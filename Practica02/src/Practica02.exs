# Participantes:
# Angel Alcántara Valdés
# Mauricio Ayala Morales
# Hernández Sanchez Oscar Jose
# Madera Baldovinos Erika Yusset

defmodule Practica02 do
  #1
  def n_strings(n, str) do
    import Enum, only: [map: 2]
    map(1..n, fn _x -> str end)
  end

  #2
  def insert_into_list(list, index, value) do
    import List, only: [insert_at: 3]
    insert_at(list, index, value)
  end

  #3
  def remove_from_list(list, index) do
    import List, only: [delete_at: 2]
    delete_at(list, index)
  end

  #4
  def last_element(list) do
    import List, only: [last: 1]
    last(list)
  end

  #5
  def zip_lists(list_of_lists) do
    import List, only: [zip: 1]
    zip(list_of_lists)
  end

  #6
  def remove_from_map(map, key) do
    import Map, only: [delete: 2]
    delete(map, key)
  end

  #7
  def map_to_list(map) do
    import Map, only: [to_list: 1]
    to_list(map)
  end

  #8
  def distance(x_1, y_1, x_2, y_2) do
    x_dist = :math.pow(x_1 - x_2, 2)
    y_dist = :math.pow(y_1 - y_2, 2)
    :math.sqrt(x_dist + y_dist)
  end

  #9
  def element_into_tuple(tuple, element) do
    import Tuple, only: [append: 2]
    append(tuple, element)
  end

  #10
  def tuple_to_list(tuple) do
    import Tuple, only: [to_list: 1]
    to_list(tuple)
  end
end
