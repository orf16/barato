package modelos;
// Generated 26/11/2019 06:43:24 PM by Hibernate Tools 4.3.1



/**
 * Diccionario generated by hbm2java
 */
public class Diccionario  implements java.io.Serializable {


     private long id;
     private String palabra;

    public Diccionario() {
    }

    public Diccionario(long id, String palabra) {
       this.id = id;
       this.palabra = palabra;
    }
   
    public long getId() {
        return this.id;
    }
    
    public void setId(long id) {
        this.id = id;
    }
    public String getPalabra() {
        return this.palabra;
    }
    
    public void setPalabra(String palabra) {
        this.palabra = palabra;
    }




}


