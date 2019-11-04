/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servicios;

import interfaces.BuscadorInterface;
import java.io.IOException;
import java.util.Date;
import java.util.List;

import modelos.*;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.jsoup.Connection.Response;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;

/**
 *
 * @author 
 */
public class Buscadorimplementacion implements BuscadorInterface{
    
    private final Funciones funciones = new Funciones();
      /********************SCRAPING JAVA*****************************************/
    /**
     * Con esta método compruebo el Status code de la respuesta que recibo al hacer la petición
     * EJM:
     * 		200 OK			300 Multiple Choices
     * 		301 Moved Permanently	305 Use Proxy
     * 		400 Bad Request		403 Forbidden
     * 		404 Not Found		500 Internal Server Error
     * 		502 Bad Gateway		503 Service Unavailable
     * @param url
     * @return Status Code
     */
    public int getStatusConnectionCode(String url) {

        Response response = null;

        try {
            response = Jsoup.connect(url).userAgent("Mozilla/5.0").timeout(100000).ignoreHttpErrors(true).execute();
        } catch (IOException ex) {
            System.out.println("Excepción al obtener el Status Code: " + ex.getMessage());
        }
        
        //return response.getStatus();
        return response.statusCode();
    }
    
    /**
    * Con este método devuelvo un objeto de la clase Document con el contenido del
    * HTML de la web que me permitirá parsearlo con los métodos de la librelia JSoup
    * @param url
    * @return Documento con el HTML
    */
   @Override
   public Document getHtmlDocument(String url) {

       Document doc = null;
       try {         
            doc = Jsoup.connect(url).userAgent("Mozilla/5.0").timeout(100000).get();
       }catch (IOException ex) {            
            System.out.println("Excepción al obtener el Status Code: " + ex.getMessage());
       }
       return doc;
   }         

    @Override
    public List<SubPagina> getPaginas() {
        
        Session conexion = funciones.getConexion();                              
        Query consulta = conexion.createQuery("FROM SubPagina  " );                
        List<SubPagina> paginas = consulta.list(); 
        conexion.close();
        return paginas;         
    }

    @Override
    public List<ListaProducto> getListaProducto(Integer idLista) {
        Session conexion = funciones.getConexion();                                                              
        Query consulta = conexion.createQuery("FROM ListaProducto WHERE lista.idlista ="+idLista);                        
        List<ListaProducto> listaProducto = consulta.list(); 
        conexion.close();        
        return listaProducto;
    }   

    @Override
    public List<Lista> getListasUsuario(long idUsuario) {
        //System.out.println( "<--> SQL...  Identificador de la Lsitas por producto:  ***** ");
        Session conexion = funciones.getConexion();                                                              
        Query consulta = conexion.createQuery("FROM Lista WHERE idusuario = "+idUsuario + " ORDER BY idlista" );        
        List<Lista> lista = consulta.list(); 
        conexion.close();        
        return lista;
    }

    @Override
    public Boolean guardarProductosLista( ListaProducto producto) {
        
        Session conexion = funciones.getConexion();       
        Transaction trans = null;
        
        try {
            trans = conexion.getTransaction();
            trans.begin();
            conexion.save( producto );            
            trans.commit();
            return true; 
        }
        catch (Exception e) {
            if (trans!=null) trans.rollback();
            return false;
        }
        finally {
            conexion.close();            
        }  
    }

    @Override
    public Lista getLista(Date fecha ) {
        
        Session conexion = funciones.getConexion();       
        Lista lista = (Lista)conexion.createQuery("FROM Lista WHERE fechacreada BETWEEN '"+ fecha.toString()+" 00:00:00' AND '"+fecha.toString()+" 23:59:59' " ).uniqueResult();
        conexion.close();        
        return lista;        
    }
    
    @Override
    public Lista getLista(long idlista ) {
        
        Session conexion = funciones.getConexion();               
        Lista lista = (Lista)conexion.createQuery("FROM Lista WHERE idlista = "+idlista ).uniqueResult();      
        conexion.close();        
        return lista;        
    }

    @Override
    public List<Categoria> getCategorias() {
        
        Session conexion = funciones.getConexion();                                                             
        Query consulta = conexion.createQuery("FROM Categoria ORDER BY idcategoria" );
        List<Categoria> categorias = consulta.list(); 
        conexion.close();        
        return categorias;        
    }

    @Override
    public List<Subcategoria> getSubcategorias(long idSubcategoria ) {
        
        Session conexion = funciones.getConexion();                                                             
        Query consulta = conexion.createQuery("FROM Subcategoria "  );        
        List<Subcategoria> subcategorias = consulta.list(); 
        conexion.close();        
        return subcategorias;
    }

    @Override
    public Boolean guardarLista( Lista lista ) {
        
        Session conexion = funciones.getConexion();     
        Transaction trans = null;
        
        try {
            trans = conexion.getTransaction();
            trans.begin();
            conexion.save( lista );            
            trans.commit();
            
        }
        catch (Exception e) {
            if (trans!=null) trans.rollback();
            return false;
        }
        finally {
            conexion.close();            
        }
        return true;
    }

    
}
