defmodule LeaderElection do
  def inicia do
    estado = %{termino?: false}
    recibe_mensaje(estado)
  end

  def recibe_mensaje(estado) do
    if not estado[:termino?] do
      receive do
        mensaje -> nuevo_estado = procesa_mensaje(mensaje, estado)
          recibe_mensaje(nuevo_estado)
      end
    end
  end

  ##Setup
  def procesa_mensaje({:id, id}, estado) do
    Map.put(estado, :id, id)
  end
  def procesa_mensaje({:vecinos, izquierdo, derecho}, estado) do
    estado = Map.put(estado, :derecho, derecho)
    Map.put(estado, :izquierdo, izquierdo)
  end

  ##Run
  def procesa_mensaje({:inicia}, estado) do
    self_id = estado[:id]
    send(estado[:izquierdo], {:compare, self_id})
    Map.put(estado, :lider, self_id)
  end

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
