# Participantes:
# Angel Alcántara Valdés
# Mauricio Ayala Morales
# Hernández Sanchez Oscar Jose
# Madera Baldovinos Erika Yusset

# Parte 2 de la práctica.
defmodule Generales do

  # Función para mandar mensajes y que cada proceso empiece a recibir mensajes.
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

  #Función que permite al Lider recibir mensajes de confirmación del No Lider.
  def recibe_lider(estado) do
    import Map, only: [get: 3]
    receive do
      {:ok} -> IO.puts("Comenzamos a atacar a las #{inspect(get(estado, :hora, nil))}")
      recibe_lider(estado)
    end
  end

  #Función que permite al no Lider recibir mensajes de ataque del Lider.
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
