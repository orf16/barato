package modelos;
// Generated 24/11/2019 10:52:28 AM by Hibernate Tools 4.3.1



/**
 * ProductoTwebscrCar generated by hbm2java
 */
public class ProductoTwebscrCar  implements java.io.Serializable {


     private int id;
     private int idProducto;
     private int idCar;

    public ProductoTwebscrCar() {
    }

    public ProductoTwebscrCar(int id, int idProducto, int idCar) {
       this.id = id;
       this.idProducto = idProducto;
       this.idCar = idCar;
    }
   
    public int getId() {
        return this.id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    public int getIdProducto() {
        return this.idProducto;
    }
    
    public void setIdProducto(int idProducto) {
        this.idProducto = idProducto;
    }
    public int getIdCar() {
        return this.idCar;
    }
    
    public void setIdCar(int idCar) {
        this.idCar = idCar;
    }




}


