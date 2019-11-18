/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package interfaces;
import java.util.List;
import modelos.Departamento;
//import modelos.Login;
import modelos.Municipio;
import modelos.Usuario;
import modelos.UsuarioDireccion;

/**
 *
 * @author 
 */

public interface AdminInterface {
         
    Usuario buscarUsuario(String login, String clave); //Buscar por login y clave      
    
    Usuario buscarUsuario(long id); //Buscar por identificador de la tabla    
    
    Usuario buscarUsuario(String correo); // Buscar solo por correo
    
    Usuario buscarUsuario(long id , String numeroDocumento ); //Buscar solo por documento             
    
    List<Usuario> buscarUsuario(); 
    
//    boolean guardarSesion( Login sesion);    
//    
//    Login capturarSesion( String token );    
//    
//    Login updateSesion( );    
    
    Boolean eleminarSesion( );

    Boolean recibircomentarios(String coment,String calif,String email);
    
    List<UsuarioDireccion> buscarDirecciones( long idUsuario );
             
    Boolean guardarUsuario(Usuario usuario, List<UsuarioDireccion> direcciones);
     
    int actualizarUsuario(Usuario usuario);
     
    boolean eliminarUsuarioId(long id);
          
    boolean eliminarUsuarios();   
    
    List<Departamento> buscarDepartamento();
    
    List<Municipio> buscarMunicipio( long idDepartamento);
    
    Municipio buscarMunicipio( int idMunicipio );
    
    Departamento buscarDepartamento( long idDepartamento );

}
