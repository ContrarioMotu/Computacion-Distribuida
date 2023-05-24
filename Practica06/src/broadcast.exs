defmodule Broadcast do

  def inicia do
    estado = %{}
    recibe_mensaje(estado)
  end

  def recibe_mensaje(estado) do
    receive do
      mensaje -> nuevo_estado = procesa_mensaje(mensaje, estado)
        recibe_mensaje(nuevo_estado)
    end
  end

  def procesa_mensaje({:id, id}, estado) do
    Map.put(estado, :id, id)
  end

  def procesa_mensaje({:hijos, hijos}, estado) do
    Map.put(estado, :hijos, hijos)
  end

  def procesa_mensaje({:raiz}, estado) do
    Map.put(estado, :raiz, true)
  end

  def procesa_mensaje({:mensaje, fuente, msg}, estado) do
    Enum.map(estado[:hijos], fn e -> send(e, {:mensaje, estado[:id], "alive"}) end)
      IO.puts "soy el id(#{estado[:id]}) y mi padre(#{fuente}) me pasó el mensaje <#{msg}>"
    estado
  end

  def procesa_mensaje({:inicia}, estado) do
    if estado[:raiz] do
      Enum.map(estado[:hijos], fn e -> send(e, {:mensaje, estado[:id], "alive"}) end)
    end
    estado
  end
end

p1 = spawn(Broadcast, :inicia, [])
p2 = spawn(Broadcast, :inicia, [])
p3 = spawn(Broadcast, :inicia, [])
p4 = spawn(Broadcast, :inicia, [])
p5 = spawn(Broadcast, :inicia, [])
p6 = spawn(Broadcast, :inicia, [])
p7 = spawn(Broadcast, :inicia, [])
p8 = spawn(Broadcast, :inicia, [])
p9 = spawn(Broadcast, :inicia, [])
p10 = spawn(Broadcast, :inicia, [])

procs = [p1,p2,p3,p4,p5,p6,p7,p8,p9,p10]
Enum.zip(1..10, procs) |> Enum.map(fn {id, p} -> send(p, {:id, id}) end)

send(p1, {:hijos, [p2, p3, p6]})
send(p2, {:hijos, []})
send(p3, {:hijos, [p4,p5]})
send(p4, {:hijos, []})
send(p5, {:hijos, []})
send(p6, {:hijos, [p7,p8]})
send(p7, {:hijos, []})
send(p8, {:hijos, [p9,p10]})
send(p9, {:hijos, []})
send(p10, {:hijos, []})

send(p1, {:raiz})

Enum.map(procs, fn p -> send(p, {:inicia}) end)
