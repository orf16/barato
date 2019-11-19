package modelos;
// Generated 16/11/2019 08:26:25 PM by Hibernate Tools 4.3.1


import java.util.Date;
import java.util.HashSet;
import java.util.Set;

/**
 * Tareawebscraper generated by hbm2java
 */
public class Tareawebscraper  implements java.io.Serializable {


     private long idtarea;
     private Almacen almacen;
     private Date fechahoraini;
     private Date fechahorafin;
     private Long cantidadproductos;
     private Boolean productoscopiados;
     private Set productoTwebscrHists = new HashSet(0);

    public Tareawebscraper() {
    }

	
    public Tareawebscraper(long idtarea, Date fechahoraini) {
        this.idtarea = idtarea;
        this.fechahoraini = fechahoraini;
    }
    public Tareawebscraper(long idtarea, Almacen almacen, Date fechahoraini, Date fechahorafin, Long cantidadproductos, Boolean productoscopiados, Set productoTwebscrHists) {
       this.idtarea = idtarea;
       this.almacen = almacen;
       this.fechahoraini = fechahoraini;
       this.fechahorafin = fechahorafin;
       this.cantidadproductos = cantidadproductos;
       this.productoscopiados = productoscopiados;
       this.productoTwebscrHists = productoTwebscrHists;
    }
   
    public long getIdtarea() {
        return this.idtarea;
    }
    
    public void setIdtarea(long idtarea) {
        this.idtarea = idtarea;
    }
    public Almacen getAlmacen() {
        return this.almacen;
    }
    
    public void setAlmacen(Almacen almacen) {
        this.almacen = almacen;
    }
    public Date getFechahoraini() {
        return this.fechahoraini;
    }
    
    public void setFechahoraini(Date fechahoraini) {
        this.fechahoraini = fechahoraini;
    }
    public Date getFechahorafin() {
        return this.fechahorafin;
    }
    
    public void setFechahorafin(Date fechahorafin) {
        this.fechahorafin = fechahorafin;
    }
    public Long getCantidadproductos() {
        return this.cantidadproductos;
    }
    
    public void setCantidadproductos(Long cantidadproductos) {
        this.cantidadproductos = cantidadproductos;
    }
    public Boolean getProductoscopiados() {
        return this.productoscopiados;
    }
    
    public void setProductoscopiados(Boolean productoscopiados) {
        this.productoscopiados = productoscopiados;
    }
    public Set getProductoTwebscrHists() {
        return this.productoTwebscrHists;
    }
    
    public void setProductoTwebscrHists(Set productoTwebscrHists) {
        this.productoTwebscrHists = productoTwebscrHists;
    }




}

