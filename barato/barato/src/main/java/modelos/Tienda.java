package modelos;
// Generated 16/11/2019 08:26:25 PM by Hibernate Tools 4.3.1


import com.fasterxml.jackson.annotation.JsonIgnore;
import java.util.HashSet;
import java.util.Set;

/**
 * Tienda generated by hbm2java
 */
public class Tienda  implements java.io.Serializable {


     private int idtienda;
     private String nombre;
     private String detalle;
     private String lugar;
     private Double lat;
     private Double lng;
     private String placeId;
     private String imagen;
     private String urlWeb;
     @JsonIgnore
     private Set almacens = new HashSet(0);
     @JsonIgnore
     private Set productoTiendaCadenas = new HashSet(0);
     @JsonIgnore
     private Set productoTiendas = new HashSet(0);

    public Tienda() {
    }

	
    public Tienda(int idtienda) {
        this.idtienda = idtienda;
    }
    public Tienda(int idtienda, String nombre, String detalle, String lugar, Double lat, Double lng, String placeId, String imagen, String urlWeb, Set almacens, Set productoTiendaCadenas, Set productoTiendas) {
       this.idtienda = idtienda;
       this.nombre = nombre;
       this.detalle = detalle;
       this.lugar = lugar;
       this.lat = lat;
       this.lng = lng;
       this.placeId = placeId;
       this.imagen = imagen;
       this.urlWeb = urlWeb;
       this.almacens = almacens;
       this.productoTiendaCadenas = productoTiendaCadenas;
       this.productoTiendas = productoTiendas;
    }
   
    public int getIdtienda() {
        return this.idtienda;
    }
    
    public void setIdtienda(int idtienda) {
        this.idtienda = idtienda;
    }
    public String getNombre() {
        return this.nombre;
    }
    
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
    public String getDetalle() {
        return this.detalle;
    }
    
    public void setDetalle(String detalle) {
        this.detalle = detalle;
    }
    public String getLugar() {
        return this.lugar;
    }
    
    public void setLugar(String lugar) {
        this.lugar = lugar;
    }
    public Double getLat() {
        return this.lat;
    }
    
    public void setLat(Double lat) {
        this.lat = lat;
    }
    public Double getLng() {
        return this.lng;
    }
    
    public void setLng(Double lng) {
        this.lng = lng;
    }
    public String getPlaceId() {
        return this.placeId;
    }
    
    public void setPlaceId(String placeId) {
        this.placeId = placeId;
    }
    public String getImagen() {
        return this.imagen;
    }
    
    public void setImagen(String imagen) {
        this.imagen = imagen;
    }
    public String getUrlWeb() {
        return this.urlWeb;
    }
    
    public void setUrlWeb(String urlWeb) {
        this.urlWeb = urlWeb;
    }
    public Set getAlmacens() {
        return this.almacens;
    }
    
    public void setAlmacens(Set almacens) {
        this.almacens = almacens;
    }
    public Set getProductoTiendaCadenas() {
        return this.productoTiendaCadenas;
    }
    
    public void setProductoTiendaCadenas(Set productoTiendaCadenas) {
        this.productoTiendaCadenas = productoTiendaCadenas;
    }
    public Set getProductoTiendas() {
        return this.productoTiendas;
    }
    
    public void setProductoTiendas(Set productoTiendas) {
        this.productoTiendas = productoTiendas;
    }




}


