# Parte 1 de la práctica

defmodule Graphs do

  def inicia do
    estado_inicial = %{:procesado => false, :raiz => false}
    recibe_mensaje(estado_inicial)
  end

  def recibe_mensaje(estado) do
    receive do
      mensaje -> {:ok, nuevo_estado} = procesa_mensaje(mensaje, estado)
      recibe_mensaje(nuevo_estado)
    end
  end

  def procesa_mensaje({:id, id}, estado) do
    estado = Map.put(estado, :id, id)
    {:ok, estado}
  end

  def procesa_mensaje({:vecinos, vecinos}, estado) do
    estado = Map.put(estado, :vecinos, vecinos)
    {:ok, estado}
  end

  def procesa_mensaje({:inicia}, estado) do
    estado = conexion(estado)
    {:ok, estado}
  end

  def procesa_mensaje({:raiz}, estado) do
    estado = Map.put(estado, :raiz, true)
    {:ok, estado}
  end

  def procesa_mensaje({:mensaje, n_id}, estado) do
    estado = conexion(estado, n_id)
    {:ok, estado}
  end

  def conexion(estado, n_id \\ nil) do
    %{:id => id, :vecinos => vecinos, :procesado => procesado, :raiz => raiz} = estado
    if raiz and (not procesado) do
      IO.puts "Soy el proceso inicial(#{id}) y mi papá es #{n_id}"
      Enum.map(vecinos, fn vecino -> send vecino, {:mensaje, id} end)
      Map.put(estado, :procesado, true)
    else
      if n_id != nil and (not procesado) do
        IO.puts "Soy el proceso #{id} y mi papá es #{(n_id)}"
        Enum.map(vecinos, fn vecino -> send vecino, {:mensaje, id} end)
        Map.put(estado, :procesado, true)
      else
        estado
      end
    end
  end

end

a = spawn(Graphs, :inicia, [])
b = spawn(Graphs, :inicia, [])
c = spawn(Graphs, :inicia, [])
d = spawn(Graphs, :inicia, [])
e = spawn(Graphs, :inicia, [])
f = spawn(Graphs, :inicia, [])

send(a, {:id, 1})
send(b, {:id, 2})
send(c, {:id, 3})
send(d, {:id, 4})
send(e, {:id, 5})
send(f, {:id, 6})

send(a, {:vecinos, [b,c,f]})
send(b, {:vecinos, [a,c,e]})
send(c, {:vecinos, [a,b,d]})
send(d, {:vecinos, [c,e,f]})
send(e, {:vecinos, [b,d,f]})
send(f, {:vecinos, [a,d,e]})

send(a, {:raiz})

send(a, {:inicia})
send(b, {:inicia})
send(c, {:inicia})
send(d, {:inicia})
send(e, {:inicia})
send(f, {:inicia})

#Creamos una gráfica con al menos diez vertices
a = spawn(Graphs, :inicia, [])
b = spawn(Graphs, :inicia, [])
c = spawn(Graphs, :inicia, [])
d = spawn(Graphs, :inicia, [])
e = spawn(Graphs, :inicia, [])
f = spawn(Graphs, :inicia, [])
g = spawn(Graphs, :inicia, [])
h = spawn(Graphs, :inicia, [])
i = spawn(Graphs, :inicia, [])
j = spawn(Graphs, :inicia, [])

send(a, {:id, 1})
send(b, {:id, 2})
send(c, {:id, 3})
send(d, {:id, 4})
send(e, {:id, 5})
send(f, {:id, 6})
send(g, {:id, 7})
send(h, {:id, 8})
send(i, {:id, 9})
send(j, {:id, 10})

send(a, {:vecinos, [b,c,f,g]})
send(b, {:vecinos, [a,d]})
send(c, {:vecinos, [a]})
send(d, {:vecinos, [b,g]})
send(e, {:vecinos, []})
send(f, {:vecinos, [a,g]})
send(g, {:vecinos, [a,d,f]})
send(h, {:vecinos, [g,i]})
send(i, {:vecinos, [h]})
send(j, {:vecinos, []})

send(a, {:raiz})

send(a, {:inicia})
send(b, {:inicia})
send(c, {:inicia})
send(d, {:inicia})
send(e, {:inicia})
send(f, {:inicia})
send(g, {:inicia})
send(h, {:inicia})
send(i, {:inicia})
send(j, {:inicia})
