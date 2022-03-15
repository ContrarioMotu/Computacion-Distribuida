import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.util.LinkedList;

public class Parte3 {
    
    private LinkedList<Evento> eventos = new LinkedList<Evento>();

    private LinkedList<Evento> schedule = new LinkedList<Evento>();

    /**
     * Método para leer los eventos de un archivo.
     */
    private void leerEventos(String path){

        try{
            File archivo = new File(path);

            BufferedReader input = new BufferedReader(new FileReader(archivo));

            String line;

            while ((line = input.readLine()) != null) {
                String[] l = line.split(",");

                this.eventos.add(new Evento(l[0], Integer.parseInt(l[1]), Integer.parseInt(l[2])));
            }
            
            input.close();

            if(eventos.isEmpty()){
                throw new Exception("\n" + "Archivo vacío...");
            }

        }catch(FileNotFoundException iae){
            System.err.println("\n" + "Archivo no encontrado...");
            System.exit(1);

        }catch(Exception e){
            System.err.println(e.getMessage());
            System.err.println("Error al leer el archivo...");
            System.exit(1);
        }
    }

    /**
     * Método greedy para encontrar la secuencia de eventos compatibles más larga.
     */
    public void schedule(){
        LinkedList<Evento> eventosOrdenados = new LinkedList<Evento>(eventos);

        //Ordenando los eventos mediante su final.
        eventosOrdenados.sort((p, q) -> p.compareTo(q));

        Evento pFinal = eventosOrdenados.getFirst();
        this.schedule.add(pFinal);

        //Agregando los eventos compatibles.
        for(Evento p : eventosOrdenados){
            if(p.getInicio() >= pFinal.getFin()){

                this.schedule.add(p);

                pFinal = p;
            }
        }

        
    }

    /**
     * Método para obtener la secuencia de eventos compatibles más larga.
     */
    public LinkedList<Evento> getSchedule(){
        return this.schedule;
    }

    /**
     * Método para la representación "gráfica" (jejeje) de los eventos junto con su
     * inicio y fin.
     */
    @Override
    public String toString(){

        int nombreMasLargo = 1;

        for(Evento p : eventos){

            if(p.getNombre().length() > nombreMasLargo){
                nombreMasLargo = p.getNombre().length();
            }
        }

        String s = " ".repeat(nombreMasLargo + 4);

        for(int i = eventos.getFirst().getInicio();
            i <= eventos.getLast().getFin(); i++){

                s += String.format("%02d ", i);
        }
        s += "\n";

        for(Evento p : eventos){
            s += p.getNombre() + " ".repeat(nombreMasLargo - p.getNombre().length()) + " =>  ";

            for (int j = 1; j < p.getInicio(); j++) {
                s += "   ";
            }

            s += "|";

            for (int k = p.getInicio(); k < p.getFin() - 1; k++) {
                s += "---";
            }

            s += "--|\n";
        }

        return s;
    }

    /**
     * Método para la representación "gráfica" (jejeje) de la secuencia de eventos
     * compatibles más larga, así como su inicio y fin.
     */
    public String toStringSchedule(){

        int nombreMasLargo = 1;

        for(Evento p : eventos){

            if(p.getNombre().length() > nombreMasLargo){
                nombreMasLargo = p.getNombre().length();
            }
        }

        int primerInicio = eventos.getFirst().getInicio();

        for (Evento p : eventos) {
            if(p.getInicio() < primerInicio){
                primerInicio = p.getInicio();
            }
        }

        int ultimoFinal = 1;

        for (Evento p : eventos) {
            if(p.getFin() > ultimoFinal){
                ultimoFinal = p.getFin();
            }
        }

        String s = " ".repeat(nombreMasLargo + 4);

        for(int i = primerInicio;
            i <= ultimoFinal; i++){

                s += String.format("%02d ", i);
        }
        s += "\n";

        for(Evento p : eventos){
            s += p.getNombre() + " ".repeat(nombreMasLargo - p.getNombre().length()) + " =>  ";

            for (int j = 1; j < p.getInicio(); j++) {
                s += "   ";
            }

            s += "|";
            if(schedule.contains(p)){
                for (int k = p.getInicio(); k < p.getFin() - 1; k++) {
                    s += "~~~";
                }

                s += "~~|\n";
                continue;
            }

            for (int k = p.getInicio(); k < p.getFin() - 1; k++) {
                s += "---";
            }

            s += "--|\n";

        }

        return s;
    }

    public static void main(String[] args) {

        try{
            Parte3 p = new Parte3();

            p.leerEventos(args[0]);

            p.schedule();

            System.out.println("\n" + "Scheadule: " + p.getSchedule().toString() + "\n");
            System.out.println(p.toStringSchedule());
        }catch(ArrayIndexOutOfBoundsException aiobe){
            System.err.println("\n" + 
                               "Ingrese el nombre del archivo con los eventos.\n" +
                               "Uso:\n" + 
                               "$ java Parte3 \"archivo.txt\"\n");
            System.exit(1);
        }
    }

}
