package modelos;
// Generated 24/11/2019 10:52:28 AM by Hibernate Tools 4.3.1


import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import java.util.HashSet;
import java.util.Set;

/**
 * Municipio generated by hbm2java
 */
public class Municipio  implements java.io.Serializable {


     private int idmunicipio;
     @JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
     @JsonIgnore
     private Departamento departamento;
     private String nombremunicipio;
     private String codigomunicipio;
     private Short estado;
     private Set almacens = new HashSet(0);
     @JsonIgnore
     private Set usuarioDireccions = new HashSet(0);

    public Municipio() {
    }

	
    public Municipio(int idmunicipio) {
        this.idmunicipio = idmunicipio;
    }
    public Municipio(int idmunicipio, Departamento departamento, String nombremunicipio, String codigomunicipio, Short estado, Set almacens, Set usuarioDireccions) {
       this.idmunicipio = idmunicipio;
       this.departamento = departamento;
       this.nombremunicipio = nombremunicipio;
       this.codigomunicipio = codigomunicipio;
       this.estado = estado;
       this.almacens = almacens;
       this.usuarioDireccions = usuarioDireccions;
    }
   
    public int getIdmunicipio() {
        return this.idmunicipio;
    }
    
    public void setIdmunicipio(int idmunicipio) {
        this.idmunicipio = idmunicipio;
    }
    public Departamento getDepartamento() {
        return this.departamento;
    }
    
    public void setDepartamento(Departamento departamento) {
        this.departamento = departamento;
    }
    public String getNombremunicipio() {
        return this.nombremunicipio;
    }
    
    public void setNombremunicipio(String nombremunicipio) {
        this.nombremunicipio = nombremunicipio;
    }
    public String getCodigomunicipio() {
        return this.codigomunicipio;
    }
    
    public void setCodigomunicipio(String codigomunicipio) {
        this.codigomunicipio = codigomunicipio;
    }
    public Short getEstado() {
        return this.estado;
    }
    
    public void setEstado(Short estado) {
        this.estado = estado;
    }
    public Set getAlmacens() {
        return this.almacens;
    }
    
    public void setAlmacens(Set almacens) {
        this.almacens = almacens;
    }
    public Set getUsuarioDireccions() {
        return this.usuarioDireccions;
    }
    
    public void setUsuarioDireccions(Set usuarioDireccions) {
        this.usuarioDireccions = usuarioDireccions;
    }




}


