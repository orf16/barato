package modelos;
// Generated 25/11/2019 06:05:58 PM by Hibernate Tools 4.3.1


import com.fasterxml.jackson.annotation.JsonIgnore;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * Categoria generated by hbm2java
 */
public class Categoria  implements java.io.Serializable {


     private int idcategoria;
     private String nombre;
     private String abreviatura;
     private String direccionImagen;
     @JsonIgnore
     private Set productoxcategorias = new HashSet(0);
     @JsonIgnore
     private Set subcategorias = new HashSet(0);
     @JsonIgnore
     List<Producto> listaProducto;

    public Categoria() {
    }

	
    public Categoria(int idcategoria) {
        this.idcategoria = idcategoria;
    }
    public Categoria(int idcategoria, String nombre, String abreviatura, String direccionImagen, Set productoxcategorias, Set subcategorias) {
       this.idcategoria = idcategoria;
       this.nombre = nombre;
       this.abreviatura = abreviatura;
       this.direccionImagen = direccionImagen;
       this.productoxcategorias = productoxcategorias;
       this.subcategorias = subcategorias;
    }
   
    public int getIdcategoria() {
        return this.idcategoria;
    }
    
    public void setIdcategoria(int idcategoria) {
        this.idcategoria = idcategoria;
    }
    public String getNombre() {
        return this.nombre;
    }
    
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
    public String getAbreviatura() {
        return this.abreviatura;
    }
    
    public void setAbreviatura(String abreviatura) {
        this.abreviatura = abreviatura;
    }
    public String getDireccionImagen() {
        return this.direccionImagen;
    }
    
    public void setDireccionImagen(String direccionImagen) {
        this.direccionImagen = direccionImagen;
    }
    public Set getProductoxcategorias() {
        return this.productoxcategorias;
    }
    
    public void setProductoxcategorias(Set productoxcategorias) {
        this.productoxcategorias = productoxcategorias;
    }
    public Set getSubcategorias() {
        return this.subcategorias;
    }
    
    public void setSubcategorias(Set subcategorias) {
        this.subcategorias = subcategorias;
    }

 public List<Producto> getListaProducto() {
        return listaProducto;
    }

    public void setListaProducto(List<Producto> listaProducto) {
        this.listaProducto = listaProducto;
    }
}


