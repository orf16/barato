/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servicios;

import interfaces.AdminInterface;
import java.math.BigInteger;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import modelos.Departamento;

import modelos.Municipio;
import org.springframework.stereotype.Service;
import modelos.Usuario;
import modelos.UsuarioDireccion;
import org.hibernate.Hibernate;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.NoSuchProviderException;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import modelos.Producto;
import modelos.UsuarioNew;

/**
 *
 * @author 
 */

@Service("AdmInterface")
public class AdminImplementacion implements AdminInterface{
    private final Funciones funciones = new Funciones();
    Properties emailProperties;
    javax.mail.Session mailSession;
    MimeMessage emailMessage;
        
    @Override
    public Boolean guardarUsuario(Usuario usuario, List<UsuarioDireccion> direcciones) { 
       Session conexion = funciones.getConexion();
       Transaction trans = funciones.getTransaccion();             
       Boolean result = false;
       try{                       
            trans.begin();
            conexion.save( usuario );            
            for( UsuarioDireccion direccion : direcciones ){
                direccion.setUsuario( usuario );
                conexion.save( direccion );
            }                        
            trans.commit();   
            result = true;
        }
        catch (Exception e) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "Error al crear el usuario: {0}", e);
            if (trans!=null) trans.rollback(); 
            result = false;
        }
        finally {
            conexion.close();            
        }      
        return result;      
    }
              
    @Override
    public List<Usuario> buscarUsuario() { 
        Session conexion = funciones.getConexion();
        Query consulta = conexion.createQuery("FROM Usuario" );                
        List<Usuario> usuarios = consulta.list(); 
        conexion.close();
        return usuarios;        
    }
    
    @Override
    public List<UsuarioDireccion> buscarDirecciones(long idUsuario) {
        Session conexion = funciones.getConexion();
        Query consulta = conexion.createQuery("FROM UsuarioDireccion WHERE idusuario = "+  idUsuario);                
        List<UsuarioDireccion> direccion = consulta.list();
        conexion.close(); 
        return direccion;
    }
    
    @Override
    public int actualizarUsuario(Usuario usuario) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public boolean eliminarUsuarioId(long id) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
                
    @Override
    public boolean eliminarUsuarios() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public List<Departamento> buscarDepartamento() {   
        Session conexion = funciones.getConexion();
        Query consulta = conexion.createQuery("FROM Departamento " );
        List<Departamento> departamentos = consulta.list();
        conexion.close();
        return departamentos; 
    }

    @Override
    public List<Municipio> buscarMunicipio(long idDepartamento) {    
        Session conexion = funciones.getConexion();
        Query consulta = conexion.createQuery("FROM Municipio WHERE iddepartamento="+idDepartamento+" " );
        List<Municipio> municipios = consulta.list(); 
        conexion.close();
        return municipios;                
    }

    @Override
    public Departamento buscarDepartamento(long idDepartamento) {
        Session conexion = funciones.getConexion();
        Departamento departamento = (Departamento) conexion.createQuery("FROM Departamento WHERE iddepartamento="+idDepartamento+" " ).uniqueResult();  
        conexion.close();
        return departamento; 
    }

    @Override
    public Municipio buscarMunicipio(int idMunicipio) {    
        Session conexion = funciones.getConexion();
        Municipio municipio = (Municipio) conexion.createQuery("FROM Municipio WHERE idmunicipio="+idMunicipio+" " ).uniqueResult();        
        conexion.close();
        return municipio;         
    }           

//    @Override
//    public boolean guardarSesion(Login usuario) {      
//       Session conexion = funciones.getConexion();
//       Transaction trans = funciones.getTransaccion();  
//       Hibernate.initialize(usuario.getToken());        
//       try {            
//            trans.begin();
//            conexion.save( usuario );            
//            trans.commit();            
//            return true;      
//        }
//        catch (Exception e) {
//            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "Error al guardar sesion con token de usuario : {0}", e);
//            if (trans!=null) trans.rollback();  
//            return false;
//        }
//    }
//    
//    @Override
//    public Login capturarSesion( String token) {     
//        Session conexion = funciones.getConexion();
//        Login usuarioLogin = (Login)conexion.createQuery("FROM Login WHERE token='"+token+"'" ).uniqueResult();        
//        return usuarioLogin;        
//    }
//
//    @Override
//    public Login updateSesion() {
//        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
//    }

    @Override
    public Boolean eleminarSesion() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public Boolean recibircomentarios(String coment, String calif, String email) {

        String emailPort = "587";//gmail's smtp port

        emailProperties = System.getProperties();
        emailProperties.put("mail.smtp.port", emailPort);
        emailProperties.put("mail.smtp.auth", "true");
        emailProperties.put("mail.smtp.starttls.enable", "true");

        String[] toEmails = { "comentariosbaratoapp@gmail.com" };
        String emailSubject = "Comentario Recibido del Sitio BaratoApp";
        String emailBody = "<b>Usuario:</b>"+email+"<br>"+"<b>Comentario:</b>"+coment+"<br>" +"<b>Calificación:</b>"+calif;



        mailSession = javax.mail.Session.getDefaultInstance(emailProperties, null);
        emailMessage = new MimeMessage(mailSession);

        for (int i = 0; i < toEmails.length; i++) {
            try {
                emailMessage.addRecipient(Message.RecipientType.TO, new InternetAddress(toEmails[i]));
            } catch (MessagingException e) {
            }
        }

        try {
            emailMessage.setSubject(emailSubject);
            emailMessage.setText(emailBody, "UTF-8", "html");
            //emailMessage.setContent(emailBody, "html");
        } catch (MessagingException e) {
            e.printStackTrace();
        }

        String emailHost = "smtp.gmail.com";
        String fromUser = "baratoappservicio@gmail.com";//just the id alone without @gmail.com
        String fromUserEmailPassword = "Barato01&";

        Transport transport = null;
        try {
            transport = mailSession.getTransport("smtp");
        } catch (NoSuchProviderException e) {
            e.printStackTrace();
        }

        try {
            transport.connect(emailHost, fromUser, fromUserEmailPassword);
            transport.sendMessage(emailMessage, emailMessage.getAllRecipients());
            transport.close();
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
        }



        return false;
    }

    @Override
    public Usuario buscarUsuario(long id) {
        Session conexion = funciones.getConexion();
        Usuario usuario = (Usuario)conexion.createQuery("FROM Usuario WHERE idusuario= "+id ).uniqueResult();
        conexion.close();
        return usuario;
    }

    @Override
    public Usuario buscarUsuario(String correo) {
        Session conexion = funciones.getConexion();
        Usuario usuario = (Usuario)conexion.createQuery( "FROM Usuario WHERE email='"+correo+"'" ).uniqueResult();
        conexion.close();
        return usuario;
    }

    @Override
    public Usuario buscarUsuario(long id, String numeroDocumento) {
        Session conexion = funciones.getConexion();
        Usuario usuario = (Usuario)conexion.createQuery( "FROM Usuario WHERE documento='"+numeroDocumento+"'" ).uniqueResult();               
        conexion.close();
        return usuario;
    }

    @Override
    public Usuario buscarUsuario(String email, String clave) {
        Session conexion = funciones.getConexion();
        Usuario usuario = (Usuario)conexion.createQuery("FROM Usuario WHERE email='"+email+"'" + " " +" AND clave='"+clave+"' " ).uniqueResult();        
        conexion.close();
        return usuario;
    }    
    //IMPLEMENTACION JAVIER
    @Override
    public UsuarioNew buscarUsuarioNew(String idnew) {
        Session conexion = funciones.getConexion();
        Query query = conexion.createQuery("FROM UsuarioNew WHERE key_user = :nombreProducto");
        query.setParameter("nombreProducto",  idnew );
        List<UsuarioNew> usuario= query.list();
        if (usuario.size()>0) {
            return usuario.get(0);
        }
        else{
            return null;
        }        
        
    }
    @Override
    public Boolean guardarUsuarioNew(String usuarios) {
        
        UsuarioNew usuario = new UsuarioNew();
        usuario.setKeyUser(usuarios);

       Session conexion = funciones.getConexion();
       
       String script = "";
        script = "SELECT nextval('usuario_new_id_seq') AS CONSECUTIVO";
        Iterator<BigInteger> iter;
        iter = (Iterator<BigInteger>) conexion.createSQLQuery(script).list().iterator();
        Long idtareal = iter.next().longValue();
        usuario.setId(idtareal.intValue());
        
        
       Transaction trans = funciones.getTransaccion();             
       Boolean result = false;
       try{                       
            trans.begin();
            conexion.save( usuario );            
            trans.commit();   
            result = true;
        }
        catch (Exception e) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "Error al crear el usuario: {0}", e);
            if (trans!=null) trans.rollback(); 
            result = false;
        }
        finally {
            conexion.close();            
        }      
        return result;      
    }
}
