package modelos;
// Generated 26/11/2019 06:43:24 PM by Hibernate Tools 4.3.1



/**
 * Caracteristica generated by hbm2java
 */
public class Caracteristica  implements java.io.Serializable {


     private int id;
     private int idTipo;
     private String caracteristica;
     private String alias;
     private Integer idpadre;
     private Boolean mostrar;
     private String imagen;

    public Caracteristica() {
    }

	
    public Caracteristica(int id, int idTipo, String caracteristica) {
        this.id = id;
        this.idTipo = idTipo;
        this.caracteristica = caracteristica;
    }
    public Caracteristica(int id, int idTipo, String caracteristica, String alias, Integer idpadre, Boolean mostrar, String imagen) {
       this.id = id;
       this.idTipo = idTipo;
       this.caracteristica = caracteristica;
       this.alias = alias;
       this.idpadre = idpadre;
       this.mostrar = mostrar;
       this.imagen = imagen;
    }
   
    public int getId() {
        return this.id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    public int getIdTipo() {
        return this.idTipo;
    }
    
    public void setIdTipo(int idTipo) {
        this.idTipo = idTipo;
    }
    public String getCaracteristica() {
        return this.caracteristica;
    }
    
    public void setCaracteristica(String caracteristica) {
        this.caracteristica = caracteristica;
    }
    public String getAlias() {
        return this.alias;
    }
    
    public void setAlias(String alias) {
        this.alias = alias;
    }
    public Integer getIdpadre() {
        return this.idpadre;
    }
    
    public void setIdpadre(Integer idpadre) {
        this.idpadre = idpadre;
    }
    public Boolean getMostrar() {
        return this.mostrar;
    }
    
    public void setMostrar(Boolean mostrar) {
        this.mostrar = mostrar;
    }
    public String getImagen() {
        return this.imagen;
    }
    
    public void setImagen(String imagen) {
        this.imagen = imagen;
    }




}


