defmodule Practica02 do
  #1 Función que dado un número n y una cadena, regresa una lista con n
  # veces la cadena.
  def n_strings(n, str) do
    import Enum, only: [map: 2]
    map(1..n, fn _x -> str end)
  end

  #2 Función que dada una lista, un índice i y un valor, regresa la lista con
  # el valor insertado en el índice i de la lista.
  def insert_into_list(list, index, value) do
    import List, only: [insert_at: 3]
    insert_at(list, index, value)
  end

  #3 Función que dada una lista y un índice i regresa la lista sin el elemento
  # en la posición i.
  def remove_from_list(list, index) do
    import List, only: [delete_at: 2]
    delete_at(list, index)
  end

  #4 Función que regresa el último elemento de una lista.
  def last_element(list) do
    import List, only: [last: 1]
    last(list)
  end

  #5 Función que dada una lista de listas encapsula en tuplas los elementos
  # correspondientes de cada lista,
  def zip_lists(list_of_lists) do
    import List, only: [zip: 1]
    zip(list_of_lists)
  end

  #6 Función que dado un map y una llave, regresa el map sin la entrada con
  # la llave.
  def remove_from_map(map, key) do
    import Map, only: [delete: 2]
    delete(map, key)
  end

  #7 Función que dado un map regresa su conversión a una lista.
  def map_to_list(map) do
    import Map, only: [to_list: 1]
    to_list(map)
  end

  #8 Función que calcula la distancia entre dos puntos.
  def distance(x_1, y_1, x_2, y_2) do
    x_dist = :math.pow(x_1 - x_2, 2)
    y_dist = :math.pow(y_1 - y_2, 2)
    :math.sqrt(x_dist + y_dist)
  end

  #9 Función que inserta un elemento en una tupla.
  def element_into_tuple(tuple, element) do
    import Tuple, only: [append: 2]
    append(tuple, element)
  end

  #10 Función que pasa de una tupla a una lista.
  def tuple_to_list(tuple) do
    import Tuple, only: [to_list: 1]
    to_list(tuple)
  end
end
