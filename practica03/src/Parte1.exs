# Participantes:
# Angel Alcántara Valdés
# Mauricio Ayala Morales
# Hernández Sanchez Oscar Jose
# Madera Baldovinos Erika Yusset

defmodule Parte1 do
  #1
  def factorial_rec(accumulator, 0) do
    accumulator
  end
  def factorial_rec(accumulator, n) do
    factorial_rec(n*accumulator, n-1)
  end
  def factorial(n) do
    factorial_rec(1,n)
  end

  #2
  def average_rec(sum, divisor, []) do
    if divisor == 0 do
      0
    else
      sum / divisor
    end
  end
  def average_rec(sum, divisor, [h|t]) do
    average_rec(sum+h, divisor+1, t)
  end
  def average(l) when is_list(l) do
    average_rec(0,0,l)
  end

  #3
  def smallest_rec(smallest_seen, []) do
    smallest_seen
  end
  def smallest_rec(smallest_seen, [h|t]) do
    if h < smallest_seen do
      smallest_rec(h,t)
    else
      smallest_rec(smallest_seen, t)
    end
  end
  def smallest(l) when is_list(l) do
    smallest_rec(List.first(l),l)
  end

  #4
  def gauss_sum_rec(accumulator, 0) do
    accumulator
  end
  def gauss_sum_rec(accumulator, rest) do
    gauss_sum_rec(accumulator + rest, rest - 1)
  end
  def gauss_sum(n) when is_number(n) do
    gauss_sum_rec(0,n)
  end

  #5
  def print_n_times(_msg, 0) do
    :ok
  end
  def print_n_times(msg, n) do
    IO.puts msg
    print_n_times(msg, n-1)
  end
end
