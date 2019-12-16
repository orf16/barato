/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servicios;

import interfaces.CaracteristicaInterface;
import interfaces.CategoriasInterface;
import java.util.ArrayList;
import java.util.List;

import modelos.Caracteristica;
import modelos.Categoria;
import modelos.ProductoTwebscrHist;
import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.stereotype.Service;
import static servicios.AdminProductos.countWordsUsingSplit;
/**
 *
 * @author orf16
 */
@Service("CaracteristicaInterface")
public class AdminCaracteristicaImplementacion implements CaracteristicaInterface{
    private final Funciones funciones = new Funciones();
    //Obtiene todas la caracteristicas
    @Override
    public List <Caracteristica> obtenerCaracteristica(Integer limite) {
        Session conexion = funciones.getConexion();  
        try {   
            Query query = conexion.createQuery("FROM Caracteristica ORDER BY caracteristica").setMaxResults(limite);
            List<Caracteristica> productoList = query.list();
            return productoList;
        } catch (Exception e) {
            System.out.println("ERROR-> traerProductosxcategoriaxNombre-> " + e);
            return null;
        }
        finally{
            conexion.close();
        }
    }
    //Categorias según busqueda
    @Override
    public List <Caracteristica> obtenerCaracteristicaPalabra(String nombre, String categoria, String producto,String marca,String presentacion,String volumen) {
        
        int words=countWordsUsingSplit(nombre);
        String precision="0.24";
        if (words==1) {
            precision="0.1";
        }
        //Long numInLong = Long.valueOf(Integer.parseInt(nombre));
        //String base="from ProductoTwebscrHist where lower(nombre) similar to '%(aguila|águila)%'";
        String base="SELECT p.idproducto, p.nombre, p.detalle, p.fecha, p.hora, p.fechahora, p.idtarea, p.direccion_imagen,p.idcategoria, p.codigotienda, p.descripcion, p.precio, p.url, p.relacion, p.activo, t.nombre as tienda_nom from producto_twebscr_hist p";
        base+=" INNER JOIN tareawebscraper d ON p.idtarea = d.idtarea ";
        base+=" INNER JOIN  almacen s on d.idalmacen = s.idalmacen ";
        base+=" INNER JOIN tienda t  ON t.idtienda = s.idtienda ";
        base+=" where p.relacion is not null and similarity(concat(p.nombre, ' ', p.detalle),:nombre) >" +precision;
        //base+=" where similarity(concat(p.nombre, ' ', p.detalle),:nombre) > "+precision;
        //String base="SELECT * from producto_twebscr_hist p INNER JOIN tareawebscraper d ON p.idtarea = d.idtarea where similarity(concat(p.nombre, ' ', p.detalle),:nombre) > 0.10";
        String order=" order by similarity(concat(p.nombre, ' ', p.detalle),:nombre) desc"; 
        String and=" and ";
        String or=" or ";
        String query_cat=" and lower(p.nombre) similar to  :categoria";
        String query_prd=" and lower(p.nombre) similar to  :producto";
        String query_mrc=" and lower(p.nombre) similar to  :marca";
        String query_pre=" and lower(p.nombre) similar to  :presentacion";
        String query_vol=" and lower(p.nombre) similar to  :volumen";
        String query_tienda="";
        int resultTienda=0;
        
        Session conexion = funciones.getConexion();
        
        if (categoria != null && !categoria.isEmpty()) {
            categoria=categoria.replace(';', '|');
            categoria="%("+categoria+")%";
            base+=query_cat;
        }
        if (producto != null && !producto.isEmpty()) {
            producto=producto.replace(';', '|');
            producto="%("+producto+")%";
            base+=query_prd;
        }
        if (marca != null && !marca.isEmpty()) {
            marca=marca.replace(';', '|');
            marca="%("+marca+")%";
            base+=query_mrc;
        }
        if (presentacion != null && !presentacion.isEmpty()) {
            presentacion=presentacion.replace(';', '|');
            presentacion="%("+presentacion+")%";
            base+=query_pre;
        }
        if (volumen != null && !volumen.isEmpty()) {
            volumen=volumen.replace(';', '|');
            volumen="%("+volumen+")%";
            base+=query_vol;
        }

        base+=order;
        Query query = conexion.createSQLQuery(base).addEntity(ProductoTwebscrHist.class);
        query.setString("nombre", nombre);
        if (categoria != null && !categoria.isEmpty()) {
            query.setString("categoria", categoria.toLowerCase());
        }
        if (producto != null && !producto.isEmpty()) {
            query.setString("producto", producto.toLowerCase());
        }
        if (marca != null && !marca.isEmpty()) {
            query.setString("marca", marca.toLowerCase());
        }
        if (presentacion != null && !presentacion.isEmpty()) {
            query.setString("presentacion", presentacion.toLowerCase());
        }
        if (volumen != null && !volumen.isEmpty()) {
            query.setString("volumen", volumen.toLowerCase());
        }

        List<ProductoTwebscrHist> productoList = query.list();
        
        
//        String base="from ProductoTwebscrHist where similarity(concat(nombre, ' ', detalle),:nombre) > 0.10";
//        String order=" order by similarity(concat(nombre, ' ', detalle),:nombre) desc";
//        String and=" and ";
//        String or=" or ";
//        String query_cat=" and lower(nombre) like :categoria";
//        String query_prd=" and lower(nombre) like :producto";
//        String query_mrc=" and lower(nombre) like :marca";
//        String query_pre=" and lower(nombre) like :presentacion";
//        String query_vol=" and lower(nombre) like :volumen";
//        Session conexion = funciones.getConexion();
//        
//        if (categoria != null && !categoria.isEmpty()) {
//            base+=query_cat;
//        }
//        if (producto != null && !producto.isEmpty()) {
//            base+=query_prd;
//        }
//        if (marca != null && !marca.isEmpty()) {
//            base+=query_mrc;
//        }
//        if (presentacion != null && !presentacion.isEmpty()) {
//            base+=query_pre;
//        }
//        if (volumen != null && !volumen.isEmpty()) {
//            base+=query_vol;
//        }
//        
//        base+=order;
//        Query query = conexion.createQuery(base);
//
//        //Query query = conexion.createQuery("from ProductoTwebscrHist").setMaxResults(10);
//        query.setParameter("nombre", nombre);
//        if (categoria != null && !categoria.isEmpty()) {
//            query.setParameter("categoria", "%"+categoria.toLowerCase()+"%");
//        }
//        if (producto != null && !producto.isEmpty()) {
//            query.setParameter("producto", "%"+producto.toLowerCase()+"%");
//        }
//        if (marca != null && !marca.isEmpty()) {
//            query.setParameter("marca", "%"+marca.toLowerCase()+"%");
//        }
//        if (presentacion != null && !presentacion.isEmpty()) {
//            query.setParameter("presentacion", "%"+presentacion.toLowerCase()+"%");
//        }
//        if (volumen != null && !volumen.isEmpty()) {
//            query.setParameter("volumen", "%"+volumen.toLowerCase()+"%");
//        }
//        List<ProductoTwebscrHist> productoList = query.list();
        conexion.close();
        
        Session conexion1 = funciones.getConexion();
        try {
            List<String> names = new ArrayList<>();
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
                            if (!ajuste.toLowerCase().contains(b.toLowerCase())) {
                                ajuste+=b;
                                names.add(b);
                            }
                        }
                        else{
                            if (!ajuste.toLowerCase().contains(b.toLowerCase())) {
                                ajuste+="|"+b;
                                names.add(b);
                            }
                        }        
                        cont++;
                    }
                }
            } 
            ajuste=ajuste.toLowerCase();
            String query_sim="SELECT distinct * FROM Caracteristica WHERE ";
            int cont1=0;
            for (String n : names) 
            {
                if (cont1==0) {
                    query_sim+=" similarity(alias,'"+ n +"') >= 0.4 ";
                }
                else{
                    query_sim+=" or similarity(alias,'"+ n +"') >= 0.4 ";
                }
                cont1++;
            }
            if (names.size() == 0) {
                return null;
            }
            //Query query1 = conexion1.createSQLQuery("SELECT distinct * FROM Caracteristica WHERE lower(alias) similar to :name").addEntity(Caracteristica.class);
            Query query1 = conexion1.createSQLQuery(query_sim).addEntity(Caracteristica.class);
            //List pusList = query1.setString("name", "%("+ajuste.toLowerCase()+")%").list();
            List pusList = query1.list();
            return pusList;
        } catch (Exception e) {
            System.out.println("ERROR-> traerProductosxcategoriaxNombre-> " + e);
            return null;
        }
        finally{
            conexion1.close();
        }
    }
    //Obtiene caracteristicas de tipo producto
    @Override
    public List <Caracteristica> obtenerCategoriasProductos() {
            Session conexion = funciones.getConexion();  
            try {
                Query query = conexion.createQuery("FROM Caracteristica where id_tipo= :idproductos and mostrar=true ORDER BY caracteristica");
                query.setParameter("idproductos", 3);
                List<Caracteristica> productoList = query.list();
                return productoList;
            } catch (Exception e) {
                System.out.println("ERROR-> traerProductosxcategoria-> " + e);
                return null;
            }
            finally{
                conexion.close();
            }
        }
    }

    

