package modelos;
// Generated 25/11/2019 06:05:58 PM by Hibernate Tools 4.3.1



/**
 * Subcategoria generated by hbm2java
 */
public class Subcategoria  implements java.io.Serializable {


     private int idsubcategoria;
     private Categoria categoria;
     private String nombreItem;

    public Subcategoria() {
    }

	
    public Subcategoria(int idsubcategoria) {
        this.idsubcategoria = idsubcategoria;
    }
    public Subcategoria(int idsubcategoria, Categoria categoria, String nombreItem) {
       this.idsubcategoria = idsubcategoria;
       this.categoria = categoria;
       this.nombreItem = nombreItem;
    }
   
    public int getIdsubcategoria() {
        return this.idsubcategoria;
    }
    
    public void setIdsubcategoria(int idsubcategoria) {
        this.idsubcategoria = idsubcategoria;
    }
    public Categoria getCategoria() {
        return this.categoria;
    }
    
    public void setCategoria(Categoria categoria) {
        this.categoria = categoria;
    }
    public String getNombreItem() {
        return this.nombreItem;
    }
    
    public void setNombreItem(String nombreItem) {
        this.nombreItem = nombreItem;
    }




}


