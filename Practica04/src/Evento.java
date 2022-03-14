public class Evento{
    
    private String nombre;

    private int inicio;

    private int fin;

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

    public String getNombre(){
        return this.nombre;
    }

    public int getInicio(){
        return this.inicio;
    }

    public int getFin(){
        return this.fin;
    }

    public void setNombre(String n){
        this.nombre = n;
    }
    
    public void setInicio(int i){
        this.inicio = i;
    }

    public void setFin(int f){
        this.fin = f;
    }

    public int compareTo(Evento pr){
        if(this.fin == pr.fin){
            return 0;
        }

        if(this.fin > pr.fin){
            return 1;
        }

        return -1;
    }

    @Override
    public String toString(){
        return this.nombre + "(" + this.inicio + ", " + this.fin + ")";
    }

}
