# Participantes:
# Angel Alcántara Valdés
# Mauricio Ayala Morales
# Hernández Sanchez Oscar Jose
# Madera Baldovinos Erika Yusset

defmodule Parte2 do
  defp reverse([],rev) do
	rev
  end
  defp reverse([h|t], rev) do
	reverse(t, [h|rev])
  end
  defp reverse(l) when is_list(l) do
	reverse(l,[])
  end

  # 1 Implementación de split/
  defp split_rec(left, [], _count) do
	{reverse(left),[]}
  end
  defp split_rec(left, right, 0) do
	{reverse(left), right}
  end
  defp split_rec(left, [r|right], count) do
	split_rec([r|left], right, count-1)
  end
  def split(l, split_ind) when is_list(l) and is_number(split_ind) do
	split_rec([], l, split_ind)
  end

  # 2 Implementación de all?/2
  def all?([], _fun) do
	true
  end
  def all?([h|t], fun) when is_function(fun) do
	if fun.(h) do
	  all?(t,fun)
	else
	  false
	end
  end

  # 3 Implementación de filter recursivo.
  defp filter_rec([], res, _test) do
	reverse(res)
  end
  defp filter_rec([h|t], res, test) do
	if test.(h) do
	  filter_rec(t, [h|res], test)
	else
	  filter_rec(t, res, test)
	end
  end
  def filter(l, test) when is_list(l) and is_function(test) do
	filter_rec(l,[],test)
  end
end
