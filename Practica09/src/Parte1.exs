defmodule King do

  ##hyperparameter is the amount of failures
  @failures 1

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
        receive_preferences(Enum.filter(ids, fn x -> x!=id end), [pref|preferences])
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

    Map.put(state, :majority, majority)
    |> Map.put(:multiplicity, multiplicity)

    consensus_even(state, round)
  end
  def consensus_even(state, round) do
    king_maj = if round == state[:id] do
                Enum.map(state[:neighbours], fn n -> send(n, {:maj, state[:majority]}) end)
                state[:majority]
               else
                 receive do
                   {:maj, choice} -> choice
                   _ ->  state[:majority] ## unsure about this line
                 end
               end
    state[:pref] = if state[:multiplicity] > length(state[:neighbours]) + @failures do
                     state[:majority]
                   else
                     king_maj
                   end

    if round == @failures + 1 do
      IO.puts "choose ..."
    else
      consensus_odd(state, round+1)
    end
  end
end
