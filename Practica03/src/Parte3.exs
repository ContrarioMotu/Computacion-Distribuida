defmodule Parte3 do

  # Función para leer los mensajes recibidos:
  #     (a) Si recibe una tupla con el átomo :pid deberá imprimir lo siguiente:
  #         "Hola PIDA, soy PIDB." donde PIDA es el pid que te manden, y
  #         PIDB es el PIDB del proceso. Solo recibes una tupla de la forma:
  #         {:pid, self()}.
  #     (b) Si recibe una tupla con el átomo :ok deberá imprimir el mensaje
  #         que traiga la segunda entrada de la tupla.
  #     (c) Si recibe una tupla con el átomo :nok deberá imprimir el mensaje
  #         concatenado a si mismo.
  def recibe() do
    receive do
      {:pid, str} -> if is_pid(str) do IO.puts("Hola #{inspect(str)}, soy #{inspect(self())}") end
                     recibe()
      {:ok, str} -> if is_binary(str) do IO.puts(str) end
                    recibe()
      {:nok, str} -> if is_binary(str) do IO.puts(str <> str) end
                     recibe()
    end
  end

end
