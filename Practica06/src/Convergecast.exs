defmodule Convergecast do

  def sumaListas(parent, children, input \\ []) do
    estado = %{:parent => parent, :children => children, :input => input}

    if (children == []) do
      send(parent, {self(), input})
    else
      recibe(estado, [], [])
    end

  end

  def recibe(estado, rC, cL) do
    %{:parent => parent, :children => children, :input => input} = estado

      receivedChildren = rC
      childrenLenghts = cL

    receive do
      {:pid, lista} -> receivedChildren|:pid
                       childrenLenghts|(length(lista)*2)
                       input++lista

      if (Enum.all?(children, fn x -> Enum.member?(receivedChildren, x) end) ) do
        input = Enum.sum(input) ++ childrenLenghts
        if(parent == nil) do
          IO.puts("#{inspect(input)}")
        else
          send(parent, {self(), input})
        end

      end

      recibeRaiz(estado, receivedChildren, childrenLenghts)
    end

  end

end

# p = [parent, children, input]

pr = spawn(Convergecast, :sumaListas, [nil, [p0, p1]])
p0 = spawn(Convergecast, :sumaListas, [pr, [p2, p3, p4]])
p1 = spawn(Convergecast, :sumaListas, [pr, [p5]])
p2 = spawn(Convergecast, :sumaListas, [p0, [], [1]])
p3 = spawn(Convergecast, :sumaListas, [p0, [], [2]])
p4 = spawn(Convergecast, :sumaListas, [p0, [], [3]])
p5 = spawn(Convergecast, :sumaListas, [p1, [], [4]])
