package modelos;
// Generated 21/07/2018 12:11:31 PM by Hibernate Tools 4.3.1


import com.fasterxml.jackson.annotation.JsonIgnore;
import java.util.Date;

/**
 * ListasCompartidas generated by hbm2java
 */
public class ListasCompartidas  implements java.io.Serializable {


     private int idcompartida;
     @JsonIgnore
     private Lista lista;
     @JsonIgnore
     private Usuario usuario;
     private String emailuser;
     private Date fechacompartido;

    public ListasCompartidas() {
    }

	
    public ListasCompartidas(int idcompartida) {
        this.idcompartida = idcompartida;
    }
    public ListasCompartidas(int idcompartida, Lista lista, Usuario usuario, String emailuser, Date fechacompartido) {
       this.idcompartida = idcompartida;
       this.lista = lista;
       this.usuario = usuario;
       this.emailuser = emailuser;
       this.fechacompartido = fechacompartido;
    }
   
    public int getIdcompartida() {
        return this.idcompartida;
    }
    
    public void setIdcompartida(int idcompartida) {
        this.idcompartida = idcompartida;
    }
    public Lista getLista() {
        return this.lista;
    }
    
    public void setLista(Lista lista) {
        this.lista = lista;
    }
    public Usuario getUsuario() {
        return this.usuario;
    }
    
    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }
    public String getEmailuser() {
        return this.emailuser;
    }
    
    public void setEmailuser(String emailuser) {
        this.emailuser = emailuser;
    }
    public Date getFechacompartido() {
        return this.fechacompartido;
    }
    
    public void setFechacompartido(Date fechacompartido) {
        this.fechacompartido = fechacompartido;
    }




}


