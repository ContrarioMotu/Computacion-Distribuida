defmodule Generales do

  def generales(id, noLider \\ self(), hora \\ nil, lider \\ nil) do

    estado = %{:id => id, :noLider => noLider, :hora => hora, :lider => lider}

      if id do
        send(noLider, {self(), hora})
        recibe_lider(estado)
      else

        if (lider != nil) and (hora != nil) do
          send(lider, {:ok})
        end

        recibe_no_lider(estado)
      end
  end

  def recibe_lider(estado) do
    import Map, only: [get: 3]
    receive do
      {:ok} -> IO.puts("Comenzamos a atacar a las #{inspect(get(estado, :hora, nil))}")
      recibe_lider(estado)
    end
  end

  def recibe_no_lider(estado) do
    receive do
      {lider, hora} -> IO.puts("Recibi mensaje : Atacamos a las #{inspect(hora)}")
                       generales(false, self(), hora, lider)
      recibe_no_lider(estado)
    end

  end


end

# b = spawn(Generales, :generales, [false])
# a = spawn(Generales, :generales, [true, b, 12])
