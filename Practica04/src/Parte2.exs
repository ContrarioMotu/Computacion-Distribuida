# Participantes:
# Angel Alcántara Valdés
# Mauricio Ayala Morales
# Hernández Sanchez Oscar Jose
# Madera Baldovinos Erika Yusset

defmodule GetBack do

	def getBack do
		
		receive do
			{sender, figure, data} ->
        	send(sender, {figure, area(figure, data)})
        	getBack()
		end
	end

	defp area(:circle, %{:radio => radio}) do (:math.pi()*radio*radio)
  	end

  	defp area(:triangle, %{:base => base, :altura => altura}) do (base*altura)/2
  	end


  	defp area(:rectangle, %{:base => base, :altura => altura}) do (base*altura)
  	end

  	defp area(:trapezoid, %{:base1 => base1, :base2 => base2, :altura => altura}) do ((base1 + base2)*altura)/2
  	end

end

