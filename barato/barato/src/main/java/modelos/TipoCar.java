package modelos;
// Generated 25/11/2019 06:05:58 PM by Hibernate Tools 4.3.1



/**
 * TipoCar generated by hbm2java
 */
public class TipoCar  implements java.io.Serializable {


     private int idCar;
     private String caracteristica;

    public TipoCar() {
    }

    public TipoCar(int idCar, String caracteristica) {
       this.idCar = idCar;
       this.caracteristica = caracteristica;
    }
   
    public int getIdCar() {
        return this.idCar;
    }
    
    public void setIdCar(int idCar) {
        this.idCar = idCar;
    }
    public String getCaracteristica() {
        return this.caracteristica;
    }
    
    public void setCaracteristica(String caracteristica) {
        this.caracteristica = caracteristica;
    }




}


