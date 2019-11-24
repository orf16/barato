package modelos;
// Generated 24/11/2019 10:52:28 AM by Hibernate Tools 4.3.1



/**
 * ProductoTienda generated by hbm2java
 */
public class ProductoTienda  implements java.io.Serializable {


     private int idproductoTienda;
     private Producto producto;
     private Tienda tienda;
     private String nombre;
     private Double valor;
     private Double valorUnidad;
     private Boolean estado;
     private String codigotienda;

    public ProductoTienda() {
    }

	
    public ProductoTienda(int idproductoTienda) {
        this.idproductoTienda = idproductoTienda;
    }
    public ProductoTienda(int idproductoTienda, Producto producto, Tienda tienda, String nombre, Double valor, Double valorUnidad, Boolean estado, String codigotienda) {
       this.idproductoTienda = idproductoTienda;
       this.producto = producto;
       this.tienda = tienda;
       this.nombre = nombre;
       this.valor = valor;
       this.valorUnidad = valorUnidad;
       this.estado = estado;
       this.codigotienda = codigotienda;
    }
   
    public int getIdproductoTienda() {
        return this.idproductoTienda;
    }
    
    public void setIdproductoTienda(int idproductoTienda) {
        this.idproductoTienda = idproductoTienda;
    }
    public Producto getProducto() {
        return this.producto;
    }
    
    public void setProducto(Producto producto) {
        this.producto = producto;
    }
    public Tienda getTienda() {
        return this.tienda;
    }
    
    public void setTienda(Tienda tienda) {
        this.tienda = tienda;
    }
    public String getNombre() {
        return this.nombre;
    }
    
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
    public Double getValor() {
        return this.valor;
    }
    
    public void setValor(Double valor) {
        this.valor = valor;
    }
    public Double getValorUnidad() {
        return this.valorUnidad;
    }
    
    public void setValorUnidad(Double valorUnidad) {
        this.valorUnidad = valorUnidad;
    }
    public Boolean getEstado() {
        return this.estado;
    }
    
    public void setEstado(Boolean estado) {
        this.estado = estado;
    }
    public String getCodigotienda() {
        return this.codigotienda;
    }
    
    public void setCodigotienda(String codigotienda) {
        this.codigotienda = codigotienda;
    }




}


