/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servicios;

import interfaces.AdminListasInterface;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import modelos.Lista;
import modelos.ListaProducto;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.springframework.stereotype.Service;

import java.util.logging.Level;
import java.util.logging.Logger;
import modelos.ListaNew;
import modelos.ListaProductoNew;
import modelos.ListasCompartidas;
import modelos.ProductoTwebscrHist;
import modelos.Usuario;
import org.hibernate.Query;

/**
 *
 * @author 
 */
@Service("ProductoInterface")
public class AdminListasImplementacion implements AdminListasInterface{
    
    private final Funciones funciones = new Funciones();
    
    @Override
    public Boolean crearListas(Lista lista) {
                
        Session conexion = funciones.getConexion();       
        Transaction trans = null;
        
        try {
            Logger.getLogger(getClass().getName()).log(Level.INFO, "entra a crear la lista: {0}", lista);
            trans = conexion.getTransaction();
            trans.begin();
            conexion.save(lista);            
            trans.commit();
            return true; 
        }
        catch (Exception e) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "Error al crear la lista: {0}", e);
            if (trans!=null) trans.rollback();
            return false;
        }
        finally {
            conexion.close();            
        }
    }

    @Override
    public Boolean crearListaProducto(ListaProducto listaProducto) {
        Session conexion = funciones.getConexion();     
        Transaction trans = null;
        
        try {
            Logger.getLogger(getClass().getName()).log(Level.INFO, "entra a crear la listaProducto: {0}", listaProducto);
            trans = conexion.getTransaction();
            trans.begin();
            conexion.save(listaProducto);            
            trans.commit();
            return true; 
        }
        catch (Exception e) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "Error al crear crearListaProducto: {0}", e);
            if (trans!=null) trans.rollback();
            return false;
        }
        finally {
            conexion.close();            
        }
    }

    @Override
    public Boolean actualizarLista(Lista lista) {
        Session conexion = funciones.getConexion();        
        Transaction trans = null;
        
        try {            
            trans = conexion.getTransaction();
            trans.begin();
            conexion.update(lista);            
            trans.commit();
            return true; 
        }
        catch (Exception e) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "Error al actualizar lista", e);
            if (trans!=null) trans.rollback();
            return false;
        }
        finally {
            conexion.close();            
        }
    }

    @Override
    public Lista getLista(Integer id) {
        Session conexion = funciones.getConexion();
        Lista lista = (Lista)conexion.createQuery("FROM Lista WHERE idlista= "+id ).uniqueResult();
        conexion.close();
        return lista;
    }

    @Override
    public boolean eliminarCompartirLista( Integer idUsuario, Integer idLista, String emailUsers ) {
        Session conexion = funciones.getConexion();
        List<String> listaEmails = new ArrayList<String>();
        String[] listaUsuariosString = emailUsers.split(",");
        
        for(String valor : listaUsuariosString){
            listaEmails.add( valor );
        }        
        Query query = conexion.createQuery("DELETE FROM ListasCompartidas list WHERE list.usuario.idusuario = :idusuario AND list.lista.idlista = :idlista AND list.emailuser  IN ( :emailUsers ) "  );
        query.setParameterList("emailUsers", listaEmails );        
        query.setParameter("idlista", idLista );
        query.setParameter("idusuario", idUsuario );
        query.executeUpdate();                  
        conexion.close();
        return true;
    }
    
    @Override
    public boolean eliminarCompartirLista( Integer idLista ) {
        Session conexion = funciones.getConexion();     
        
        Transaction trans = null;
        try {            
            trans = conexion.getTransaction();
            trans.begin();
        Query query = conexion.createQuery("DELETE FROM ListasCompartidas list WHERE list.lista.idlista = :idlista "  );
        query.setParameter("idlista", idLista );        
        query.executeUpdate();            

         trans.commit();
            return true; 
        }
        catch (Exception e) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "Error al eliminar la lista", e);
            if (trans!=null) trans.rollback();
            return false;
        }
        finally {
            conexion.close();            
        }
    }
    
    @Override
    public boolean eliminarLista( Integer idLista ) {
        Session conexion = funciones.getConexion();  
        
        Transaction trans = null;
        
        try {            
            trans = conexion.getTransaction();
            trans.begin();
                                                 
            Query consulta = conexion.createQuery("FROM Lista list WHERE idlista =  "+ idLista );        
            Lista lista = (Lista)consulta.uniqueResult();                     
            
            conexion.delete(lista);            
                        
            trans.commit();
            return true; 
        }
        catch (Exception e) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "Error al eliminar la lista", e);
            if (trans!=null) trans.rollback();
            return false;
        }
        finally {
            conexion.close();            
        }
        
        /*Query query = conexion.createQuery("DELETE FROM Lista WHERE idlista = :idlista "  );               
        query.setParameter("idlista", idLista ); 
        System.out.println(" Valor lista --> " + query.executeUpdate()); 
        //query_shared.executeUpdate();    
        conexion.delete( lista );
        conexion.close();
        return true;*/
    }
        
    @Override
    public boolean compartirLista( Usuario usuario, Lista lista, String emailUsers ) {
        Session conexion = funciones.getConexion();     
        Transaction trans = null;
        
        java.sql.Timestamp timestamp = null;
        
        try {            
            trans = conexion.getTransaction();
            trans.begin();                                    
            String[] listaUsuariosString = emailUsers.split(",");
            for(String listaUsuarioEmail : listaUsuariosString){
                ListasCompartidas listaShared = new ListasCompartidas();
                listaShared.setUsuario(usuario);
                listaShared.setEmailuser(listaUsuarioEmail);
                listaShared.setLista( lista );    
                listaShared.setFechacompartido(timestamp);
                conexion.save( listaShared );  
            }                         
            trans.commit();
            return true; 
        }
        catch (Exception e) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "Error al compartir lisa ", e);
            if (trans!=null) trans.rollback();
            return false;
        }
        finally {
            conexion.close();            
        }
    }

    @Override
    public List<ListasCompartidas> getListaShared(String emailUser) {
        Session conexion = funciones.getConexion();                                                              
        Query consulta = conexion.createQuery("FROM ListasCompartidas l INNER JOIN FETCH l.lista WHERE emailUser = '"+emailUser + "' ORDER BY l.fechacompartido " );
        List<ListasCompartidas> lista = consulta.list(); 
        conexion.close();        
        return lista;      
    }
    
    @Override
    public List<ListasCompartidas> getListaShared(Integer idLista) {
        Session conexion = funciones.getConexion();                                                              
        Query consulta = conexion.createQuery("FROM ListasCompartidas l INNER JOIN FETCH l.lista WHERE l.lista.idlista = "+idLista + " ORDER BY l.fechacompartido " );
        List<ListasCompartidas> lista = consulta.list(); 
        conexion.close();        
        return lista;      
    }

    @Override
    public Boolean eliminarListaProducto(Integer idLista) {
        Session conexion = funciones.getConexion();         
        Transaction trans = null;
        
        try {            
            trans = conexion.getTransaction();
            trans.begin();
            
            Query query = conexion.createQuery("DELETE FROM ListaProducto lp WHERE lp.lista.idlista = :idlista"  );              
            query.setParameter("idlista", idLista ); 
            query.executeUpdate();                                       
            trans.commit();
            return true; 
        }
        catch (Exception e) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "Error al eliminar productos lisa ", e);
            if (trans!=null) trans.rollback();
            return false;
        }
        finally {
            conexion.close();            
        }
    }
    
    @Override
    public boolean crearListasNew(ListaNew lista) {
                
        Session conexion = funciones.getConexion();  
        
        String script = "";
        script = "SELECT nextval('lista_new_id_seq') AS CONSECUTIVO";
        Iterator<BigInteger> iter;
        iter = (Iterator<BigInteger>) conexion.createSQLQuery(script).list().iterator();
        Long idtareal = iter.next().longValue();
        lista.setId(idtareal.intValue());
        
        Transaction trans = null;
        
        try {
            Logger.getLogger(getClass().getName()).log(Level.INFO, "entra a crear la lista: {0}", lista);
            trans = conexion.getTransaction();
            trans.begin();
            conexion.save(lista);            
            trans.commit();
            return true; 
        }
        catch (Exception e) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "Error al crear la lista: {0}", e);
            if (trans!=null) trans.rollback();
            return false;
        }
        finally {
            conexion.close();            
        }
    }
@Override
    public ListaNew buscarUsuarioNew(String idnew) {
        Session conexion = funciones.getConexion();
        Query query = conexion.createQuery("FROM ListaNew WHERE idusuario = :nombreProducto");
        query.setParameter("nombreProducto",  idnew );
        List<ListaNew> usuario= query.list();
        if (usuario.size()>0) {
            return usuario.get(0);
        }
        else{
            return null;
        }        
    }
    @Override
    public boolean crearListasProductoNew(ListaProductoNew lista) {
                
        Session conexion = funciones.getConexion();  
        
        String script = "";
        script = "SELECT nextval('lista_producto_new_id_seq') AS CONSECUTIVO";
        Iterator<BigInteger> iter;
        iter = (Iterator<BigInteger>) conexion.createSQLQuery(script).list().iterator();
        Long idtareal = iter.next().longValue();
        lista.setId(idtareal.intValue());
        
        Transaction trans = null;
        
        try {
            Logger.getLogger(getClass().getName()).log(Level.INFO, "entra a crear la lista: {0}", lista);
            trans = conexion.getTransaction();
            trans.begin();
            conexion.save(lista);            
            trans.commit();
            return true; 
        }
        catch (Exception e) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "Error al crear la lista: {0}", e);
            if (trans!=null) trans.rollback();
            return false;
        }
        finally {
            conexion.close();            
        }
    }
    @Override
    public List<ListaProductoNew> traerListaProdNew(String lista) {
 
        String base = "SELECT * from lista_producto_new p INNER JOIN lista_new d ON p.idlista = d.id where d.idusuario=:nombre";
        Session conexion = funciones.getConexion();
        Query query = conexion.createSQLQuery(base).addEntity(ListaProductoNew.class);
        query.setString("nombre", lista);
        List<ListaProductoNew> productoList = query.list();
        conexion.close();
        List<ListaProductoNew> productoList1 = new ArrayList<>();
        for (ListaProductoNew p : productoList) {
            boolean contiene=false;
            
            int idproducto=p.getIdproducto();
            Session conexion2 = funciones.getConexion();
            String base2 = "SELECT * from lista_producto_new p INNER JOIN lista_new d ON p.idlista = d.id where d.idusuario=:nombre2 and p.idproducto =:prod";
            Query query2 = conexion2.createSQLQuery(base2).addEntity(ListaProductoNew.class);
            query2.setString("nombre2", lista);
            query2.setInteger("prod", idproducto);
            List<ListaProductoNew> productoList2 = query2.list();
            int count=productoList2.size();
            conexion2.close();

            for (ListaProductoNew c : productoList1) {
                if (c.getIdproducto().equals(p.getIdproducto())) {
                    contiene=true;
                }
            }
            
            if (!contiene) {
                Integer id = p.getIdproducto();
                Session conexion1 = funciones.getConexion();
                String base1 = "SELECT * from producto_twebscr_hist p where p.idproducto = :nombre1";
                Query query1 = conexion1.createSQLQuery(base1).addEntity(ProductoTwebscrHist.class);
                query1.setInteger("nombre1", id);
                List<ProductoTwebscrHist> productoList_ = query1.list();
                conexion1.close();
                if (productoList_.size() > 0) {
                    p.setNombreproducto(productoList_.get(0).getNombre());
                    p.setDescripcion(productoList_.get(0).getDescripcion());
                    Double precio = productoList_.get(0).getPrecio();
                    String precioSTR = precio.toString();
                    p.setPrecioproducto(precioSTR);
                    p.setUrl(productoList_.get(0).getUrl());
                    p.setImagen(productoList_.get(0).getDireccionImagen());
                    p.setItems(count);
                    productoList1.add(p);
                }
            }
        }
        return productoList1;
    }
    
    @Override
    public boolean EliminarDeListasProductoNew(String usuario, Integer Producto) {

        Session cnx1 = funciones.getConexion();
        String base1 = "SELECT * from lista_producto_new p INNER JOIN lista_new d ON p.idlista = d.id where d.idusuario=:nombre2 and p.idproducto =:prod";
        Query query1 = cnx1.createSQLQuery(base1).addEntity(ListaProductoNew.class);
        query1.setString("nombre2", usuario);
        query1.setInteger("prod", Producto);
        //ListaProductoNew productoList1 = (ListaProductoNew)query1.list();
        List<ListaProductoNew> productoList1 = query1.list();
        cnx1.close();
        if (productoList1.size() > 0) {
            int idlistaprodnew = productoList1.get(0).getId();
            Session conexion = funciones.getConexion();
            Transaction trans = null;
            try {
                trans = conexion.getTransaction();
                trans.begin();

                Query query = conexion.createQuery("DELETE FROM ListaProductoNew lp WHERE lp.id = :idlista");
                query.setParameter("idlista", idlistaprodnew);
                query.executeUpdate();
                trans.commit();
                return true;
            } catch (Exception e) {
                Logger.getLogger(getClass().getName()).log(Level.SEVERE, "Error al eliminar productos lisa ", e);
                if (trans != null) {
                    trans.rollback();
                }
                return false;
            } finally {
                conexion.close();
            }
        } else {
            return false;
        }
        

        //return false;

    }
}
