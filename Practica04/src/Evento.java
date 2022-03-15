/**
 * Clase que modela un evento.
 */
public class Evento{
    
    private String nombre;

    private int inicio;

    private int fin;

    /**
     * Constructor para eventos que recibe el nombre, inicio
     * y fin del evento. El inicio y fin deben ser enteros mayores a 0
     * además de que el fin debe ser mayor que el inicio.
     */
    public Evento(String nombre, int inicio, int fin) throws Exception{

        if(fin <= inicio){
            throw new IllegalArgumentException("\n" + "El final del evento " + nombre + " no puede ser menor o igual al inicio...");
        }

        if(inicio < 1 || fin < 1){
            throw new IllegalArgumentException("\n" + "Ni el final ni el inicio del evento " + nombre + " pueden ser negativos...");
        }
        
        this.nombre = nombre;
        this.inicio = inicio;
        this.fin = fin;

    }

    /**
     * Método para obtener el nombre del evento.
     */
    public String getNombre(){
        return this.nombre;
    }

    /**
     * Método para obtener el inicio del evento.
     */
    public int getInicio(){
        return this.inicio;
    }

    /**
     * Método para obtener el fin del evento.
     */
    public int getFin(){
        return this.fin;
    }

    /**
     * Método para asignar un nuevo nombre al evento.
     */
    public void setNombre(String n){
        this.nombre = n;
    }
    
    /**
     * Método para asignar un inicio nombre al evento.
     */
    public void setInicio(int i){
        this.inicio = i;
    }

    /**
     * Método para asignar un nuevo fin al evento.
     */
    public void setFin(int f){
        this.fin = f;
    }

    /**
     * Método para comparar dos eventos mediante su final.
     */
    public int compareTo(Evento pr){
        if(this.fin == pr.fin){
            return 0;
        }

        if(this.fin > pr.fin){
            return 1;
        }

        return -1;
    }

    /**
     * Método para imprimir la información del evento.
     */
    @Override
    public String toString(){
        return this.nombre + "(" + this.inicio + ", " + this.fin + ")";
    }

}
