# Participantes:
# Angel Alcántara Valdés
# Mauricio Ayala Morales
# Hernández Sanchez Oscar Jose
# Madera Baldovinos Erika Yusset

defmodule Consultas do
import Practica02, except: [distance: 4]
#atributo
@lista [1,2,3,4,5,6,7,8,9,10]
#Función que dada una cadena, un elemento, un número n y un índice
#i < n, crea una lista con la cadena repetida "n" veces, y a esta lista, le
#agrega el elemento en el índice dado.

def ejercicio2(str, e, n, index) do
n_strings(n,str) |> insert_into_list(index,e)
end
end

#definir un último modulo con las siguientes funciones:

defmodule Ultimo do
import Practica02, except: [distance: 4]

#funcion que dado un map y un índice, elimina la lista generada
#por el map, el elemento en el indice dado

def parte_A(map,index) do
map_to_list(map) |> remove_from_list(index)
end

#funcion que dada una tupla y un valor, agrega el valor a la tupla, pasa
#la tupla a lista y regresa el último elemento de esta lista

def parte_B(tupla, valor) do
element_into_tuple(tupla, valor) |> tuple_to_list() |> last_element()
end
end
