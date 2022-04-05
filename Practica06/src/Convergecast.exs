defmodule Convergecast do

  def inicia do
    estado_inicial = %{:padre => nil, :hijos => [], :input => []}
    recibe_mensaje(estado_inicial)
  end

  def recibe_mensaje(estado) do
    receive do
      mensaje -> nuevo_estado = procesa_mensaje(mensaje, estado)
      recibe_mensaje(nuevo_estado)
    end
  end

  def procesa_mensaje({:padre, padre}, estado) do
    Map.put(estado, :padre, padre)
  end

  def procesa_mensaje({:hijos, hijos}, estado) do
    Map.put(estado, :hijos, hijos)
  end

  def procesa_mensaje({:input, input}, estado) do
    Map.put(estado, :input, input)
  end

  def procesa_mensaje({:inicia}, estado) do
    sumaListas(estado)
  end

  def procesa_mensaje({:suma, hijo, l}, estado) do
    %{:padre => padre, :hijos => hijos, :input => input} = estado

    estado = Map.put(estado, :hijos, hijos -- [hijo])
    estado = Map.put(estado, :input, [l|input])

    if (Map.get(estado, :hijos) == []) do
      longitudHijos = Enum.map(Map.get(estado,:input), fn x -> length(x) end)
      i = List.flatten(Map.get(estado,:input))
      i = Enum.sum(i)
      i = [i|longitudHijos]
      Map.put(estado, :input, i)

      if(padre == nil) do
        IO.puts("#{inspect(i)}")
      else
        send(padre, {:suma, self(), i})
      end

    end
    estado
  end

  def sumaListas(estado) do
    %{:padre => padre, :hijos => hijos, :input => input} = estado

    if (hijos == []) do
      send(padre, {:suma, self(), input})
    end

    estado
  end

end

pr = spawn(Convergecast, :inicia, [])
p0 = spawn(Convergecast, :inicia, [])
p1 = spawn(Convergecast, :inicia, [])
p2 = spawn(Convergecast, :inicia, [])
p3 = spawn(Convergecast, :inicia, [])
p4 = spawn(Convergecast, :inicia, [])
p5 = spawn(Convergecast, :inicia, [])

send(p0, {:padre, pr})
send(p1, {:padre, pr})
send(p2, {:padre, p0})
send(p3, {:padre, p0})
send(p4, {:padre, p0})
send(p5, {:padre, p1})

send(pr, {:hijos, [p0, p1]})
send(p0, {:hijos, [p2, p3, p4]})
send(p1, {:hijos, [p5]})

send(p2, {:input, [1]})
send(p3, {:input, [2]})
send(p4, {:input, [3]})
send(p5, {:input, [4]})

send(pr, {:inicia})
send(p0, {:inicia})
send(p1, {:inicia})
send(p2, {:inicia})
send(p3, {:inicia})
send(p4, {:inicia})
send(p5, {:inicia})
