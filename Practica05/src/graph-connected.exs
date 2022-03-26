# Participantes:
# Angel Alcántara Valdés
# Mauricio Ayala Morales
# Hernández Sanchez Oscar Jose
# Madera Baldovinos Erika Yusset

##Parte 1.2
#Lo primero que tenemos que observar es que es imposible determinar si una gráfica
#es conexa si no se tiene información del sistema.
#Si no sabemos nada acerca de la red global y no tenemos comunicación con
#nodos "disconexos" no hay forma de que un componente conexo de procesos determine
#que existen mas nodos aislados de ellos.
#
#Así tenemos 2 opciones: Dar mas información de la red global o dar un medio de comunicación
#entre procesos que son disconexos en la gráfica.
#
#Para implementar la segunda opción podríamos crear un nodo "cordinador" que
#tenga comunicación con todos los nodos. Así bastaria con que la raíz reporte cuando
#cree que ya se termino el árbol y el coordinador le pregunte a todos los nodos si estan
#conectados; Si lo estan es conexa, si no no.
#
#Aqui optamos por la primera opción ya que es mas fácil de implementar. Ademas
#de recibir la gráfica también vamos a recibir la cuenta de los vértices.
#Cuando se termina el árbol podemos contar sus vértices y determinar si estan todos los nodos.
defmodule Graphs do

  def inicia do
	estado_inicial = %{:raiz => false, :procesado => false, :cuenta => 0, :hijos => []}
    recibe_mensaje(estado_inicial)
  end

  def recibe_mensaje(estado) do
    receive do
      mensaje -> {:ok, nuevo_estado} = procesa_mensaje(mensaje, estado)
      recibe_mensaje(nuevo_estado)
    end
  end

  #Setup
  def procesa_mensaje({:id, id}, estado) do
	estado = Map.put(estado, :id, id)
    {:ok, estado}
  end

  def procesa_mensaje({:vecinos, vecinos}, estado) do
	estado = Map.put(estado, :vecinos, vecinos)
	respondieron = Enum.filter(vecinos, fn v -> v != self() end)
	estado = Map.put(estado, :respondieron, respondieron)
    {:ok, estado}
  end

  def procesa_mensaje({:raiz, c}, estado) do
	estado = Map.put(estado, :raiz, true)
	estado = Map.put(estado, :vertices, c)
    {:ok, estado}
  end

  def procesa_mensaje({:inicia}, estado) do
	estado = conexion(estado)
    {:ok, estado}
  end

  #Run
  def procesa_mensaje({:converge, cuenta_de_hijo, sender}, estado) do
	estado = converge(cuenta_de_hijo, sender, estado)
	{:ok, estado}
  end
  def procesa_mensaje({:padre, sender}, estado) do
	estado = Map.put(estado, :hijos, [sender | estado[:hijos]])
	{:ok, estado}
  end

  def procesa_mensaje({:mensaje, sender_proc, n_id}, estado) do
    estado = conexion(estado, sender_proc, n_id)
    {:ok, estado}
  end

  def converge(cuenta_de_hijo, sender, estado) do

	#Si ya se recibió mensaje de todos los hijos, mandar a padre
	#si aun no, solo anotar y seguir esperando
	#si raíz y todos hijos => decide
	
	estado = if not Map.has_key?(estado, :clones) do
	  Map.put(estado, :clones, estado[:hijos])
	else
	  estado
	end

	estado = Map.put(estado, :cuenta, estado[:cuenta] + cuenta_de_hijo)
	estado = Map.put(estado, :clones, Enum.filter(estado[:clones], fn x -> x != sender end))
	if estado[:clones] == [] do
	  if estado[:raiz] do
		if estado[:cuenta] + 1 == estado[:vertices] do
		  IO.puts "CONEXA"
		else
		  IO.puts "NO CONEXA"
		end
	  else
		send(estado[:padre], {:converge, estado[:cuenta]+1, estado[:id]})
		estado
	  end
	end
	estado
  end

  def conexion(estado, sender_proc \\nil ,n_id \\ nil) do

	if estado[:procesado] and n_id != nil do
	  respondieron = Enum.filter(estado[:respondieron], fn x -> x != sender_proc end)
	  estado = Map.put(estado, :respondieron, respondieron)

	  #Si ya respondieron todos los vecinos y ninguno es un hijo este proceso
	  #debe de ser una hoja, se dispara un converge
	  if estado[:respondieron] == [] and estado[:hijos] == [] do
		send(estado[:padre], {:converge, 1, estado[:id]})
		estado
	  else
		send(sender_proc, {:mensaje, self(), estado[:id]})##
		estado
	  end
	else
	  if estado[:raiz] do
		Enum.map(estado[:vecinos], fn vecino -> send(vecino, {:mensaje, self(), estado[:id]}) end)
		Map.put(estado, :procesado, true)
	  else
		if n_id != nil do
		  
		  send(sender_proc, {:padre, estado[:id]})
		  Enum.map(estado[:vecinos], fn vecino -> send(vecino, {:mensaje, self(), estado[:id]}) end)
		  estado = Map.put(estado, :padre, sender_proc)
		  estado = Map.put(estado, :respondieron, Enum.filter(estado[:respondieron], fn x -> x != sender_proc end))
		  Map.put(estado, :procesado, true)
		else
		  estado
		end
	  end
	end
  end

end

#Se incluye una gráfica de ejemplo (debe ser disconexa)
a = spawn(Graphs, :inicia, [])
b = spawn(Graphs, :inicia, [])
c = spawn(Graphs, :inicia, [])
d = spawn(Graphs, :inicia, [])

send(a, {:id, 1})
send(b, {:id, 2})
send(c, {:id, 3})
send(d, {:id, 4})

send(a, {:vecinos, [b]})
send(b, {:vecinos, [a]})
send(c, {:vecinos, [d]})
send(d, {:vecinos, [c]})

send(a, {:raiz, 4})

send(a, {:inicia})
send(b, {:inicia})
send(c, {:inicia})
send(d, {:inicia})
