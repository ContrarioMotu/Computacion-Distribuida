import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.util.LinkedList;

public class Parte3 {
    
    private LinkedList<Proceso> procesos = new LinkedList<Proceso>();

    private LinkedList<Proceso> schedule = new LinkedList<Proceso>();

    private void leerProcesos(String path){

        try{
            File archivo = new File(path);

            BufferedReader input = new BufferedReader(new FileReader(archivo));

            String line;

            while ((line = input.readLine()) != null) {
                String[] l = line.split(",");

                this.procesos.add(new Proceso(l[0], Integer.parseInt(l[1]), Integer.parseInt(l[2])));
            }
            
            input.close();

            if(procesos.isEmpty()){
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

    public void schedule(){
        LinkedList<Proceso> procesosOrdenados = new LinkedList<Proceso>(procesos);

        procesosOrdenados.sort((p, q) -> p.compareTo(q));

        Proceso pFinal = procesosOrdenados.getFirst();
        this.schedule.add(pFinal);

        for(Proceso p : procesosOrdenados){
            if(p.getInicio() >= pFinal.getfin()){

                this.schedule.add(p);

                pFinal = p;
            }
        }

        
    }

    public LinkedList<Proceso> getSchedule(){
        return this.schedule;
    }

    @Override
    public String toString(){

        int nombreMasLargo = 1;

        for(Proceso p : procesos){

            if(p.getNombre().length() > nombreMasLargo){
                nombreMasLargo = p.getNombre().length();
            }
        }

        String s = " ".repeat(nombreMasLargo + 4);

        for(int i = procesos.getFirst().getInicio();
            i <= procesos.getLast().getfin(); i++){

                s += String.format("%02d ", i);
        }
        s += "\n";

        for(Proceso p : procesos){
            s += p.getNombre() + " ".repeat(nombreMasLargo - p.getNombre().length()) + " =>  ";

            for (int j = 1; j < p.getInicio(); j++) {
                s += "   ";
            }

            s += "|";

            for (int k = p.getInicio(); k < p.getfin() - 1; k++) {
                s += "---";
            }

            s += "--|\n";
        }

        return s;
    }

    public String toStringSchedule(){

        int nombreMasLargo = 1;

        for(Proceso p : procesos){

            if(p.getNombre().length() > nombreMasLargo){
                nombreMasLargo = p.getNombre().length();
            }
        }

        int primerInicio = procesos.getFirst().getInicio();

        for (Proceso p : procesos) {
            if(p.getInicio() < primerInicio){
                primerInicio = p.getInicio();
            }
        }

        int ultimoFinal = 1;

        for (Proceso p : procesos) {
            if(p.getfin() > ultimoFinal){
                ultimoFinal = p.getfin();
            }
        }

        String s = " ".repeat(nombreMasLargo + 4);

        for(int i = primerInicio;
            i <= ultimoFinal; i++){

                s += String.format("%02d ", i);
        }
        s += "\n";

        for(Proceso p : procesos){
            s += p.getNombre() + " ".repeat(nombreMasLargo - p.getNombre().length()) + " =>  ";

            for (int j = 1; j < p.getInicio(); j++) {
                s += "   ";
            }

            s += "|";
            if(schedule.contains(p)){
                for (int k = p.getInicio(); k < p.getfin() - 1; k++) {
                    s += "~~~";
                }

                s += "~~|\n";
                continue;
            }

            for (int k = p.getInicio(); k < p.getfin() - 1; k++) {
                s += "---";
            }

            s += "--|\n";

        }

        return s;
    }

    public static void main(String[] args) {

        try{
            Parte3 p = new Parte3();

            p.leerProcesos(args[0]);

            p.schedule();

            System.out.println("\n" + "Scheadule: " + p.getSchedule().toString() + "\n");
            System.out.println(p.toStringSchedule());
        }catch(ArrayIndexOutOfBoundsException aiobe){
            System.err.println("\n" + 
                               "Ingrese el nombre del archivo con los procesos.\n" +
                               "Uso:\n" + 
                               "$ java Parte3 \"archivo.txt\"\n");
            System.exit(1);
        }
    }

}
