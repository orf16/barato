package modelos;
// Generated 16/11/2019 08:26:25 PM by Hibernate Tools 4.3.1



/**
 * SubPagina generated by hbm2java
 */
public class SubPagina  implements java.io.Serializable {


     private int idsubpagina;
     private Pagina pagina;
     private String url;
     private String descripcion;

    public SubPagina() {
    }

	
    public SubPagina(int idsubpagina) {
        this.idsubpagina = idsubpagina;
    }
    public SubPagina(int idsubpagina, Pagina pagina, String url, String descripcion) {
       this.idsubpagina = idsubpagina;
       this.pagina = pagina;
       this.url = url;
       this.descripcion = descripcion;
    }
   
    public int getIdsubpagina() {
        return this.idsubpagina;
    }
    
    public void setIdsubpagina(int idsubpagina) {
        this.idsubpagina = idsubpagina;
    }
    public Pagina getPagina() {
        return this.pagina;
    }
    
    public void setPagina(Pagina pagina) {
        this.pagina = pagina;
    }
    public String getUrl() {
        return this.url;
    }
    
    public void setUrl(String url) {
        this.url = url;
    }
    public String getDescripcion() {
        return this.descripcion;
    }
    
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }




}


