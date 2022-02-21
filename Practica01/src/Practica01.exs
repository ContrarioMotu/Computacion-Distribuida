# Participantes:
# Angel Alcántara Valdés
# Mauricio Ayala Morales
# Hernández Sanchez Oscar Jose
# Madera Baldovinos Erika Yusset

defmodule Practica01 do

	# Función que calcula el cuadruple de un número.
	def cuadruple(n) when is_number(n) do
		n * 4
	end

	# Función que calcula el sucesor de un número.
	def sucesor(n) when is_integer(n) do
		n + 1
	end

	# Función que regresa el máximo de dos números.
	def max(m, n) when is_number(m) and is_number(n) do
		if m > n do
			m
		else
			n
		end
	end

	# Función que calcula la suma de dos números.
	def suma(m, n) when is_number(m) and is_number(n) do
		m + n
	end

	# Función que calcula la resta de dos números.
	def resta(m, n) when is_number(m) and is_number(n) do
		m - n
	end

	# Función que calcula la multiplicación de la resta con la suma
	# de dos números.
	def multiplicacion(m, n) when is_number(m) and is_number(n) do
		(resta(m, n)) * (suma(m, n))
	end

	# Función que calcula la negación de un valor booleano.
	def negacion(p) when is_boolean(p) do
		!p
	end

	# Función que calcula la conjunción de dos valores booleanos.
	def conjuncion(p , q) when is_boolean(p) and is_boolean(q) do
		p && q
	end

	# Función que calcula la disyunción de dos valores booleanos.
	def disyuncion(p, q) when is_boolean(p) and is_boolean(q) do
		p || q
	end

	# Función que calcula el valor absoluto de un número.
	def abs(n) when is_number(n) do
		if n < 0 do
			-n
		else
			n
		end
	end

	# Función que calcula el área de un círculo dado su radio.
	def area(r) when is_number(r) do
		:math.pi * r * r
	end

	# Función recursiva que calcula la suma de Gauss (Caso Base).
	def gaussRecursivo(n) when is_number(n) and n == 0 do
		0
	end

	# Función recursiva que calcula la suma de Gauss (Caso recursivo).
	def gaussRecursivo(n) when is_number(n) and n > 0 do
			n + gaussRecursivo(n - 1)
	end

	# Función que calcula la suma de Gauss usando la fórmula.
	def gauss(n) when is_number(n) and n >=0 do
		trunc((n * (n + 1))/ 2)
	end

	# Función que calcula el área de un triángulo dados tres puntos.
	def area(x1, y1, x2, y2, x3, y3) when is_number(x1) and is_number(y1)
                                      and is_number(x2) and is_number(y2)
									  and is_number(x3) and is_number(y3) do
		d1 = :math.sqrt(((x2 - x1)*(x2 - x1)) + ((y2 - y1)*(y2 - y1)))
		d2 = :math.sqrt(((x3 - x2)*(x3 - x2)) + ((y3 - y2)*(y3 - y2)))
		d3 = :math.sqrt(((x1 - x3)*(x1 - x3)) + ((y1 - y3)*(y1 - y3)))

		s = (d1 + d2 + d3)/2

		:math.sqrt(s * (s - d1) * (s - d2) * (s - d3))
	end

end
