defmodule King do

  ##hyperparameter is the amount of failures
  @failures 1

  #stuff on my state
  #:id
  #:pref // believe a default is proposed in the book
  #:neighbours
  #:neighbour_ids
  #:majority <-- dont need to set it up in init
  #:multiplicity <-- dont need to set it up in init
  def init(id, pref) do
    {neighbours, neighbour_ids} = get_neighbours()
    state = %{id: id, pref: pref, neighbours: neighbours, neighbour_ids: neighbour_ids}
    wait()
    consensus_odd(state, 1)
  end

  def get_neighbours() do
    receive do
      {:neighbours, ns, ids} -> {ns,ids}
    end
  end

  def wait do
    receive do
      {:start} -> :start
    end
  end

  def chosen_preference([], count) do
    Map.to_list(count)
    |> Enum.max_by(fn x->x end, fn {_a,a_c},{_b,b_c} -> a_c >= b_c end)
  end
  def chosen_preference([h|prefs], count) do
    h_count = if Map.has_key?(count, h) do count[h] else 0 end
    new_count = Map.put(count, h, h_count+1)
    chosen_preference(prefs, new_count)
  end
  def chosen_preference(preferences) do
    chosen_preference(preferences, %{})
  end

  def receive_preferences([], preferences) do
    preferences
  end
  def receive_preferences(ids, preferences) do
    receive do
      {:pref, id, pref} ->
        receive_preferences(Enum.filter(ids, fn x -> x != id end), [pref|preferences])
      _ -> receive_preferences(ids, preferences)
    end
  end
  def receive_preferences(ids) do
    receive_preferences(ids, [])
  end

  def consensus_odd(state, round) do
    Enum.map(state[:neighbours], fn n -> send(n, {:pref, state[:id], state[:pref]}) end)
    prefs = receive_preferences(state[:neighbour_ids]) ##prefs should have the shape: [1,1,12,3,4,3,1]
    {majority, multiplicity} = chosen_preference(prefs)

    state = Map.put(state, :majority, majority)
    state = Map.put(state, :multiplicity, multiplicity)

    consensus_even(state, round)
  end
  def consensus_even(state, round) do
    king_maj = if round == state[:id] do
                IO.puts "Soy: #{state[:id]}, elegí a #{state[:pref]} en la ronda #{round}."
                Enum.map(state[:neighbours], fn n -> send(n, {:maj, state[:majority]}) end)
                state[:majority]
               else
                 receive do
                   {:maj, choice} -> choice
                   _ ->  state[:majority] # Should be unreachable
                   IO.puts "Soy: #{state[:id]}, elegí a #{state[:pref]} en la ronda #{round}."
                 end
               end
    new_preference= if state[:multiplicity] > (1+ length(state[:neighbours])) / 2 + @failures do
                      state[:majority]
                     else
                       king_maj
                     end

    state = Map.put(state, :pref, new_preference)

    if round == @failures + 1 do
      IO.puts "--> Soy: #{state[:id]}, elegí a #{state[:pref]}."
    else
      consensus_odd(state, round+1)
    end
  end
end


a = spawn(fn -> King.init(1, 1) end)
b = spawn(fn -> King.init(2, 2) end)
c = spawn(fn -> King.init(3, 1) end)
d = spawn(fn -> King.init(4, 7) end)

Process.sleep(1000)

send(a, {:neighbours, [b,c,d], [2,3,4]})
send(b, {:neighbours, [a,c,d], [1,3,4]})
send(c, {:neighbours, [a,b,d], [1,2,4]})
send(d, {:neighbours, [a,b,c], [1,2,3]})

Process.sleep(1000)

send(a, {:start})
send(b, {:start})
send(c, {:start})
send(d, {:start})
