/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servicios;

import interfaces.CaracteristicaInterface;
import interfaces.CategoriasInterface;
import java.util.List;

import modelos.Caracteristica;
import modelos.Categoria;
import modelos.ProductoTwebscrHist;
import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.stereotype.Service;
/**
 *
 * @author orf16
 */
@Service("CaracteristicaInterface")
public class AdminCaracteristicaImplementacion implements CaracteristicaInterface{
    private final Funciones funciones = new Funciones();
    
    @Override
    public List <Caracteristica> obtenerCaracteristica(Integer limite) {
        try {
            Session conexion = funciones.getConexion();            
            Query query = conexion.createQuery("FROM Caracteristica ORDER BY caracteristica").setMaxResults(limite);
            List<Caracteristica> productoList = query.list();
            conexion.close();
            return productoList;
        } catch (Exception e) {
            System.out.println("ERROR-> traerProductosxcategoriaxNombre-> " + e);
            return null;
        }
    }
    @Override
    public List <Caracteristica> obtenerCaracteristicaPalabra(String nombre, String categoria, String producto,String marca,String presentacion,String volumen) {
        
        String base="from ProductoTwebscrHist where similarity(nombre,:nombre) > 0.10";
        String order=" order by similarity(nombre,:nombre) desc";
        String and=" and ";
        String or=" or ";
        String query_cat=" and lower(nombre) like :categoria";
        String query_prd=" and lower(nombre) like :producto";
        String query_mrc=" and lower(nombre) like :marca";
        String query_pre=" and lower(nombre) like :presentacion";
        String query_vol=" and lower(nombre) like :volumen";
        Session conexion = funciones.getConexion();
        
        if (categoria != null && !categoria.isEmpty()) {
            base+=query_cat;
        }
        if (producto != null && !producto.isEmpty()) {
            base+=query_prd;
        }
        if (marca != null && !marca.isEmpty()) {
            base+=query_mrc;
        }
        if (presentacion != null && !presentacion.isEmpty()) {
            base+=query_pre;
        }
        if (volumen != null && !volumen.isEmpty()) {
            base+=query_vol;
        }
        
        base+=order;
        Query query = conexion.createQuery(base);

        //Query query = conexion.createQuery("from ProductoTwebscrHist").setMaxResults(10);
        query.setParameter("nombre", nombre);
        if (categoria != null && !categoria.isEmpty()) {
            query.setParameter("categoria", "%"+categoria.toLowerCase()+"%");
        }
        if (producto != null && !producto.isEmpty()) {
            query.setParameter("producto", "%"+producto.toLowerCase()+"%");
        }
        if (marca != null && !marca.isEmpty()) {
            query.setParameter("marca", "%"+marca.toLowerCase()+"%");
        }
        if (presentacion != null && !presentacion.isEmpty()) {
            query.setParameter("presentacion", "%"+presentacion.toLowerCase()+"%");
        }
        if (volumen != null && !volumen.isEmpty()) {
            query.setParameter("volumen", "%"+volumen.toLowerCase()+"%");
        }
        List<ProductoTwebscrHist> productoList = query.list();
        conexion.close();
        
        
        try {
            Session conexion1 = funciones.getConexion();
            String[] parts = nombre.split("-");
            String ajuste="";
            int cont=0;
            for (ProductoTwebscrHist a : productoList) 
            {
                String[] parts1 = a.getNombre().split(" ");
                for (String b : parts1)
                {
                    b = b.replaceAll("[^\\dA-Za-z ]", "").replaceAll("\\s+", "+");
                    if (!b.isEmpty() && b.length()>1) 
                    {
                        if (cont==0) {
                        ajuste+=b;
                        }
                        else{
                            ajuste+="|"+b;
                        }        
                        cont++;
                    }
                }
            } 
            
            
            
            Query query1 = conexion1.createSQLQuery("SELECT distinct * FROM Caracteristica WHERE lower(alias) similar to :name").addEntity(Caracteristica.class);
            List pusList = query1.setString("name", "%("+ajuste.toLowerCase()+")%").list();

            conexion1.close();
            return pusList;
        } catch (Exception e) {
            System.out.println("ERROR-> traerProductosxcategoriaxNombre-> " + e);
            return null;
        }
    }
    @Override
    public List <Caracteristica> obtenerCategoriasProductos() {
        try {
            //int productos_id=4;
            Session conexion = funciones.getConexion();            
            Query query = conexion.createQuery("FROM Caracteristica where id_tipo= :idproductos and mostrar=true ORDER BY caracteristica");
            query.setParameter("idproductos", 3);
            List<Caracteristica> productoList = query.list();
            conexion.close();
            return productoList;
        } catch (Exception e) {
            System.out.println("ERROR-> traerProductosxcategoria-> " + e);
            return null;
        }
    }
    
    
}
