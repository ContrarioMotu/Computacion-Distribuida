# Participantes:
# Angel Alcántara Valdés
# Mauricio Ayala Morales
# Hernández Sanchez Oscar Jose
# Madera Baldovinos Erika Yusset

defmodule GetBack do


	# Función para leer los mensajes recibidos. Esta regresa
  # al remitente el resultado dependiendo de la entrada.
	def getBack do

		receive do
			{sender, figure, data} ->
        	send(sender, {figure, area(figure, data)})
        	getBack()
		end
	end

	# Función privada que calcula el área de un círculo.
	defp area(:circle, %{:radio => radio}) do (:math.pi()*radio*radio)
  	end
	# Función privada que calcula el área de un triángulo.
  	defp area(:triangle, %{:base => base, :altura => altura}) do (base*altura)/2
  	end

	# Función privada que calcula el área de un rectángulo.
  	defp area(:rectangle, %{:base => base, :altura => altura}) do (base*altura)
  	end
	# Función privada que calcula el área de un trapezoide.
  	defp area(:trapezoid, %{:base1 => base1, :base2 => base2, :altura => altura}) do ((base1 + base2)*altura)/2
  	end

end
