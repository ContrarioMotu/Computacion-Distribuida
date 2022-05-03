# Participantes:
# Angel Alcántara Valdés
# Mauricio Ayala Morales
# Hernández Sanchez Oscar Jose
# Madera Baldovinos Erika Yusset
defmodule Parte1 do

  # Función para "inicializar" un proceso con un estado por default.
  def initialize do
    init_state = %{:parent => nil, :leader => -1, :children => [], :unexplored => []}
    message_receive (init_state)
  end

  # Función que permite a un proceso recibir mensajes, tanto para cambiar
  # como para imprimir su estado.
  def message_receive(state) do
    receive do
      msge -> {:ok, new_state} = process_message(msge, state)
      message_receive(new_state)
    end
  end

  # Función para que un proceso imprima su estado.
  def process_message({:ask_process}, state) do
    %{:children => child, :id => id, :leader => _, :neighbours => _, :parent => parent, :unexplored => _} = state
    IO.puts("Soy #{inspect self()}, id:#{inspect id}, Hijos: #{inspect(child, charlists: false)}, Padre: #{inspect(parent, charlists: false)}")
    {:ok, state}
  end

  # Función para asignarle el id y los vecinos a un proceso.
  def process_message({:data, data}, state) do
    %{:id => id, :neighbours => ngbs} = data
    state = Map.put(state, :id, id)
    state = Map.put(state, :neighbours, ngbs)
    state = Map.put(state, :unexplored, ngbs)
    {:ok, state}
  end

  # Función para inicializar el algoritmo del árbol generador
  # desde cualquier proceso.
  def process_message({:init}, state) do
    state = Map.put(state, :leader, Map.get(state, :id))
    state = Map.put(state, :parent, self())
    data = %{:new_id => Map.get(state, :id) , :sender => self()}
    state = explore(state, data)
    {:ok, state}
  end

  # Función para que un proceso elija a su lider (raíz). El
  # proceso elige al id mayor.
  def process_message({:leader, data}, state) do
    %{:children => _, :id => id, :leader => leader, :neighbours => ngbs, :parent => _, :unexplored => unexp} = state
    %{:new_id => new_id, :sender => sender} = data
    new_data = %{:new_id => new_id, :sender => self()}
    if (leader < new_id) do
      nexp = List.delete(unexp, sender)
      new_state = %{:children => [], :id => id, :leader => new_id, :neighbours => ngbs, :parent => sender, :unexplored => nexp}
      new_state = explore(new_state, new_data)
      {:ok, new_state}
    else
      if (leader == new_id) do
        send(sender, {:already, new_data})
      end
      {:ok, state}
    end
  end

  # Función para que un proceso le indique a otro que ya tiene
  # un lider mayor al de él.
  def process_message({:already, data}, state) do
    %{:children => _, :id => _, :leader => leader, :neighbours => _, :parent => _, :unexplored => _} = state
    %{:new_id => new_id, :sender => _} = data
    new_data = %{:new_id => new_id, :sender => self()}
    if (new_id == leader) do
      new_state = explore(state, new_data)
      {:ok, new_state}
    else
      {:ok, state}
    end
  end

  # Función para que un proceso agregue a otro proceso a sus hijos
  # en caso de que lo elija como padre.
  def process_message({:parent, data}, state) do
    %{:children => child, :id => id, :leader => leader, :neighbours => ngbs, :parent => parent, :unexplored => unexp} = state
    %{:new_id => new_id, :sender => sender} = data
    new_data = %{:new_id => new_id, :sender => self()}
    if (new_id == leader) do
      new_child = [sender|child]
      new_state = %{:children => new_child, :id => id, :leader => leader, :neighbours => ngbs, :parent => parent, :unexplored => unexp}
      new_state = explore(new_state, new_data)
      {:ok, new_state}
    else
      {:ok, state}
    end
  end

  # Función para que un proceso explore a sus vecinos no explorados
  # e intente agregarlos como hijos.
  def explore(state, data) do
    %{:children => child, :id => id, :leader => leader, :neighbours => ngbs, :parent => parent, :unexplored => unexp} = state
    if (unexp != []) do
      [head|tail] = unexp
      p_k = head
      new_state = %{:children => child, :id => id, :leader => leader, :neighbours => ngbs, :parent => parent, :unexplored => tail}
      send(p_k, {:leader, data})
      new_state
    else
      if (parent != self()) do
        send(parent, {:parent, data})
      else
        IO.puts("Root: #{inspect self()}, id: #{inspect id}")
      end
      state
    end
  end

end

a = spawn(Parte1, :initialize, [])
b = spawn(Parte1, :initialize, [])
c = spawn(Parte1, :initialize, [])
d = spawn(Parte1, :initialize, [])
e = spawn(Parte1, :initialize, [])
f = spawn(Parte1, :initialize, [])

data_a = %{:id => 1, :neighbours => [b]}
send(a, {:data, data_a })
data_b = %{:id => 2, :neighbours => [a, c]}
send(b, {:data, data_b })
data_c = %{:id => 6, :neighbours => [b, e]}
send(c, {:data, data_c })
data_d = %{:id => 3, :neighbours => [b, e, f]}
send(d, {:data, data_d })
data_e = %{:id => 5, :neighbours => [c, d, f]}
send(e, {:data, data_e })
data_f = %{:id => 4, :neighbours => [d, e]}
send(f, {:data, data_f })

Process.sleep(1000)

send(a, {:init})
send(b, {:init})
send(c, {:init})
send(d, {:init})
send(e, {:init})
send(f, {:init})

Process.sleep(1000)
all = [a, b, c, d, e, f]
Process.sleep(1000)
Enum.each(all, &(send(&1, {:ask_process})))
