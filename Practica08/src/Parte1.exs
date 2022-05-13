# Participantes:
# Angel Alcántara Valdés
# Mauricio Ayala Morales
# Hernández Sanchez Oscar Jose
# Madera Baldovinos Erika Yusset
defmodule LeaderElection do

  # Función para "inicializar" un proceso con un estado por default.
  def inicia do
    estado = %{termino?: false}
    recibe_mensaje(estado)
  end

  # Función que permite a un proceso recibir mensajes, tanto para cambiar
  # como para imprimir su estado.
  def recibe_mensaje(estado) do
    if not estado[:termino?] do
      receive do
        mensaje -> nuevo_estado = procesa_mensaje(mensaje, estado)
          recibe_mensaje(nuevo_estado)
      end
    end
  end

  # Función para asignarle un id a un proceso.
  def procesa_mensaje({:id, id}, estado) do
    Map.put(estado, :id, id)
  end

  # Función para asignarle vecinos a un proceso.
  def procesa_mensaje({:vecinos, izquierdo, derecho}, estado) do
    estado = Map.put(estado, :derecho, derecho)
    Map.put(estado, :izquierdo, izquierdo)
  end

  # Función para inicializar el algoritmo de elección
  # del lídel desde cualquier proceso.
  def procesa_mensaje({:inicia}, estado) do
    self_id = estado[:id]
    send(estado[:izquierdo], {:compare, self_id})
    Map.put(estado, :lider, self_id)
  end

  # Función para que un proceso compare su id con un id
  # recibido.
  #   Si el id recibido es mayor al suyo, reenvía
  #   el id recibido a su vecino izquierdo, si el recibido
  #   es igual al suyo el proceso se proclama líder, en
  #   cualquier otro caso no hace nada.
  def procesa_mensaje({:compare, other_id}, estado) do
    self_id = estado[:id]
    cond do
      other_id == self_id ->
        send(estado[:izquierdo], {:lider})
        IO.puts "Soy el lider, id: #{self_id}"
        Map.put(estado, :termino?, true)
      other_id > self_id ->
        send(estado[:izquierdo], {:compare, other_id})
        Map.put(estado, :lider, other_id)
      true -> estado
    end
  end

  # Función para que un proceso se proclame líder y le avise
  # a los demás procesos.
  def procesa_mensaje({:lider}, estado) do
    IO.puts "Soy #{estado[:id]} y el lider es #{estado[:lider]}"
    send(estado[:izquierdo], {:lider})
    Map.put(estado, :termino?, true)
  end
end

a = spawn(LeaderElection, :inicia, [])
b = spawn(LeaderElection, :inicia, [])
c = spawn(LeaderElection, :inicia, [])
d = spawn(LeaderElection, :inicia, [])

send(a, {:id, 11})
send(b, {:id, 6})
send(c, {:id, 1000})
send(d, {:id, 9})

send(a, {:vecinos, d,b})
send(b, {:vecinos, a,c})
send(c, {:vecinos, b,d})
send(d, {:vecinos, c,a})

send(a, {:inicia})
send(b, {:inicia})
send(c, {:inicia})
send(d, {:inicia})
