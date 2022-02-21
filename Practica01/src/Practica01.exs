# Participantes:
# Angel Alcántara Valdés
#
#
#

defmodule Practica01 do

	def cuadruple(n) when is_number(n) do
		n * 4
	end

	def sucesor(n) when is_integer(n) do
		n + 1
	end

	def max(m, n) when is_number(m) and is_number(n) do
		if m > n do
			m
		else
			n
		end
	end

	def suma(m, n) when is_number(m) and is_number(n) do
		m + n
	end

	def resta(m, n) when is_number(m) and is_number(n) do
		m - n
	end

	def multiplicacion(m, n) when is_number(m) and is_number(n) do
		(resta(m, n)) * (suma(m, n))
	end

	def negacion(p) when is_boolean(p) do
		!p
	end

	def conjuncion(p , q) when is_boolean(p) and is_boolean(q) do
		p && q
	end

	def disyuncion(p, q) when is_boolean(p) and is_boolean(q) do
		p || q
	end

	def abs(n) when is_number(n) do
		if n < 0 do
			-n
		else
			n
		end
	end

	def area(r) when is_number(r) do
		:math.pi * r * r
	end

	def gaussRecursivo(n) when is_number(n) and n >=0 do
		if n == 0 do
			0
		else
			n + gaussRecursivo(n - 1)
		end
	end

	def gauss(n) when is_number(n) and n >=0 do
		trunc((n * (n + 1))/ 2)
	end

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
