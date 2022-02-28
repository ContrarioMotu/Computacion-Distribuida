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
