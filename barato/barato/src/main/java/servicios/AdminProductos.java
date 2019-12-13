/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servicios;

import interfaces.ProductoInterface;
import static java.lang.String.format;
import static java.lang.String.format;

import java.math.BigInteger;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Random;
import modelos.Producto;
import modelos.Productoxcategoria;
import modelos.ProductoTwebscrHist;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Service;
import webScraping.ActualizarProduct;

/**
 * @author
 */
@Service("ProductoInterface")
public class AdminProductos implements ProductoInterface {

    private final Funciones funciones = new Funciones();
    private final ActualizarProduct integ = new ActualizarProduct();
    @Override
    public List<Producto> traerTodosProductos() {

        Session conexion = funciones.getConexion();
        List<Producto> productoList = conexion.createQuery("FROM Producto").list();
        conexion.close();
        return productoList;
    }

    @Override
    public List<Producto> traerProductosxNombre(String nombre) {

        Session conexion = funciones.getConexion();
        Query query = conexion.createQuery("FROM Producto p WHERE p.nombre like :nombreProducto");
        query.setParameter("nombreProducto", "%" + nombre + "%");
        List<Producto> productoList = query.list();
        conexion.close();
        return productoList;
    }

    @Override
    public List<Productoxcategoria> traerProductosxcategoriaxNombre(String nombre, Integer idcat) {
        try {
            String busqueda = (nombre.trim().toLowerCase());
            Session conexion = funciones.getConexion();

            String consulta = "FROM Productoxcategoria pc left join fetch pc.producto left join fetch pc.categoria ";

            consulta = consulta + " where pc.categoria.idcategoria = :idcategoria";

            if (!nombre.trim().equals(""))
                consulta = consulta + " and lower(  unaccent(pc.producto.nombre ||' '|| pc.producto.detalle)  ) like unaccent('%" + busqueda + "%')";

            consulta = consulta + " ORDER BY pc.producto.nombre ";
            Query query = conexion.createQuery(consulta);
            if (idcat != null)
                query.setParameter("idcategoria", idcat);
            List<Productoxcategoria> productoList = query.list();
            conexion.close();
            return productoList;
        } catch (Exception e) {
            System.out.println("ERROR-> traerProductosxcategoriaxNombre-> " + e);
            return null;
        }
    }

    @Override
    public List<Productoxcategoria> traerProductosxcategoriaxLimite(Integer limitCategoria) {
        try {

            Session conexion = funciones.getConexion();
            Query query = conexion.createQuery("FROM Productoxcategoria pc left join fetch pc.producto left join fetch pc.categoria where pc.producto.nombre like :nombreProducto").setMaxResults(limitCategoria);
            List<Productoxcategoria> productoList = query.list();
            conexion.close();
            return productoList;

        } catch (Exception e) {
            System.out.println("ERROR-> traerProductosxcategoriaxNombre-> " + e);
            return null;
        }
    }

    @Override
    public List<Producto> traerProductosxcategoriaxidCategoria(Integer idCategoria, Integer limiteProducto) {
        try {

            Session conexion = funciones.getConexion();
            Query query = conexion.createQuery("Select p FROM Productoxcategoria pc left join pc.producto p where pc.categoria.idcategoria = :idCategoria").setMaxResults(limiteProducto);
            query.setParameter("idCategoria", idCategoria);
            List<Producto> productoList = query.list();
            conexion.close();
            return productoList;

        } catch (Exception e) {
            System.out.println("ERROR-> traerProductosxcategoriaxNombre-> " + e);
            return new ArrayList<Producto>();
        }
    }

    @Override
    public List<Producto> traerTodosProductosxcategoria(Integer idCategoria) {
        try {

            Session conexion = funciones.getConexion();
            Query query = conexion.createQuery("Select p FROM Productoxcategoria pc inner join pc.producto p where pc.categoria.idcategoria = :idCategoria");
            query.setParameter("idCategoria", idCategoria);
            List<Producto> productoList = query.list();
            conexion.close();
            return productoList;

        } catch (Exception e) {
            System.out.println("ERROR-> traerProductosxcategoriaxNombre-> " + e);
            return new ArrayList<Producto>();
        }
    }

    @Override
    public List<Producto> traerProductosxIds(List<Integer> idProductos) {
        try {

            Session conexion = funciones.getConexion();
            System.out.println("idcategoria==" + idProductos);
            System.out.println("idProductos = " + idProductos);
            Query query = conexion.createQuery("Select p FROM Producto p where p.idproducto IN (:idProductos) ");
            query.setParameterList("idProductos", idProductos);
            List<Producto> productoList = query.list();
            conexion.close();
            return productoList;

        } catch (Exception e) {
            System.out.println("ERROR-> traerProductosxIds-> " + e);
            return new ArrayList<Producto>();
        }
    }

    @Override
    public Boolean crearproductos(String tiendprods) {
        Boolean result = false;
        String script = "";
        String seq = "";
        try {

            String json = "{data:" + tiendprods + "}";
            JSONObject jsonObj = new JSONObject(json);

            JSONArray precObj = jsonObj.getJSONArray("data");

            //Se recibe el producto tienda principal es el ultimo siempre
            JSONObject tiendPr = precObj.getJSONObject(precObj.length()-1);
            Integer idtiendaPr = tiendPr.getInt("idtienda");
            String codigotiendPr = tiendPr.getString("producto");


            Session conexion = funciones.getConexion();
            seq = "SELECT nextval('producto_idproducto_seq') AS CONSECUTIVO";
            Iterator<BigInteger> iter;
            iter = (Iterator<BigInteger>) conexion.createSQLQuery(seq).list().iterator();
            Integer idprod = iter.next().intValue();

            List<String> scripts = new ArrayList<>();



            script = "select max(t.idtarea) from tareawebscraper t inner join almacen a on " +
                    " t.idalmacen=a.idalmacen where a.idtienda = " + idtiendaPr;
            Iterator<BigInteger> itert;
            itert = (Iterator<BigInteger>) conexion.createSQLQuery(script).list().iterator();
            Long idtareal = itert.next().longValue();
            String idtareastr = idtareal.toString();



            script = " INSERT INTO public.producto(idproducto,nombre,detalle,direccion_imagen) " +
                   " SELECT "+ idprod+" ,nombre,detalle,direccion_imagen from producto_twebscr_hist where codigotienda='"+codigotiendPr+"' and idtarea="+idtareastr;
            scripts.add(script);

            script = " INSERT INTO public.productoxcategoria(producto_idproducto,categoria_idcategotia,valor,valor_unidad) " +
                    " SELECT "+ idprod+",idcategoria,precio,precio from producto_twebscr_hist where codigotienda='"+codigotiendPr+"' and idtarea="+idtareastr;
            scripts.add(script);

            script = " INSERT INTO public.producto_tienda(producto_idproducto,tienda_idtienda,nombre,valor,valor_unidad,estado,codigotienda) " +
                    " SELECT "+ idprod+","+ idtiendaPr+",nombre,precio,precio,true,codigotienda from producto_twebscr_hist where codigotienda='"+codigotiendPr+"' and idtarea="+idtareastr;
            scripts.add(script);


            for (int x = 0; x < precObj.length() - 1; x++) {

                JSONObject tiend = precObj.getJSONObject(x);
                Integer idtienda = tiend.getInt("idtienda");
                String codigotiend = tiend.getString("producto");
                if (!codigotiend.trim().equals("")) {

                    script = "select max(t.idtarea) from tareawebscraper t inner join almacen a on " +
                            " t.idalmacen=a.idalmacen where a.idtienda = " + idtienda;
                    Iterator<BigInteger> itertl;
                    itertl = (Iterator<BigInteger>) conexion.createSQLQuery(script).list().iterator();
                    Long idtareasltr = itertl.next().longValue();
                    String idtarealstr = idtareasltr.toString();

                    script = " INSERT INTO public.producto_tienda(producto_idproducto,tienda_idtienda,nombre,valor,valor_unidad,estado,codigotienda) " +
                            " SELECT "+ idprod+","+ idtienda+",nombre,precio,precio,true,codigotienda from producto_twebscr_hist where codigotienda='"+codigotiend+"' and idtarea="+idtarealstr;
                    scripts.add(script);

                }

            }

            conexion.close();

            if (scripts.isEmpty() == false)
                result= integ.EjecutaScript(scripts);


            result = true;
        } catch (Exception e) {
            String error = e.getMessage();
        }

        return result;
    }

    @Override
    public List<ProductoTwebscrHist> traerProductosxID(String id) {
        int hh=10;
        Long numInLong = Long.valueOf(Integer.parseInt(id));
        Session conexion = funciones.getConexion();
        //Query query = conexion.createQuery("from ProductoTwebscrHist where id= :idproductos");
        Query query = conexion.createQuery("from ProductoTwebscrHist").setMaxResults(10);
        //query.setParameter("idProductos", 1);
        //query.setParameter("idproductos", hh);
        
        
            
        List<ProductoTwebscrHist> productoList = query.list();
        conexion.close();
        return productoList;
    }
    
   
    public static int countWordsUsingSplit(String input) {
    if (input == null || input.isEmpty()) {
      return 0;
    }

    String[] words = input.split("\\s+");
    return words.length;
  }
    
    ////BUSQUEDA APROXIMADA GENERAL1
    @Override
    public List<ProductoTwebscrHist> traerProductos(String nombre, String categoria,String producto,String marca,String presentacion,String volumen, String tienda, String pi, String pf) {
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
        String query_precio=" and p.precio >= :pi and p.precio <= :pf";
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
        if (tienda != null && !tienda.isEmpty()) {
            resultTienda = Integer.parseInt(tienda);
            query_tienda=" and t.idtienda = :tienda";
            base+=query_tienda;
        }
        if (pi != null && !pi.isEmpty() && pf != null && !pf.isEmpty()) {
            base+=query_precio;
        }
        base+=order;
        Query query = conexion.createSQLQuery(base).addEntity(ProductoTwebscrHist.class);
        
        //query.setString("categoria", "%"+categoria.toLowerCase()+"%");
        
        
        
        //List pusList = query1.setString("name", "%("+ajuste.toLowerCase()+")%");

        //Query query = conexion.createQuery("from ProductoTwebscrHist").setMaxResults(10);
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
        if (tienda != null && !tienda.isEmpty()) {
            query.setInteger("tienda", resultTienda);
        }
        if (pi != null && !pi.isEmpty() && pf != null && !pf.isEmpty()) {
            double pid = Double.parseDouble(pi); 
            double pfd = Double.parseDouble(pf); 
            query.setDouble("pi", pid);
            query.setDouble("pf", pfd);
        }
        List<ProductoTwebscrHist> productoList = query.list();
        
        conexion.close();
        return productoList;
    }
    
     @Override
    public List<ProductoTwebscrHist> traerProductosAdmin(String nombre, String categoria,String producto,String marca,String presentacion,String volumen, String tienda, String pi, String pf, String nr) {
        int words=countWordsUsingSplit(nombre);
        String precision="0.15";
        if (words==1) {
            precision="0.1";
        }
        
        String base="SELECT p.idproducto, p.nombre, p.detalle, p.fecha, p.hora, p.fechahora, p.idtarea, p.direccion_imagen,p.idcategoria, p.codigotienda, p.descripcion, p.precio, p.url, p.relacion, p.activo, t.nombre as tienda_nom from producto_twebscr_hist p";
        base+=" INNER JOIN tareawebscraper d ON p.idtarea = d.idtarea ";
        base+=" INNER JOIN  almacen s on d.idalmacen = s.idalmacen ";
        base+=" INNER JOIN tienda t  ON t.idtienda = s.idtienda ";
        //base+=" where p.relacion is not null and similarity(concat(p.nombre, ' ', p.detalle),:nombre) > 0.10";
        base+=" where similarity(concat(p.nombre, ' ', p.detalle),:nombre) > "+precision;
        //String base="SELECT * from producto_twebscr_hist p INNER JOIN tareawebscraper d ON p.idtarea = d.idtarea where similarity(concat(p.nombre, ' ', p.detalle),:nombre) > 0.10";
        String order=" order by similarity(concat(p.nombre, ' ', p.detalle),:nombre) desc"; 
        String and=" and ";
        String or=" or ";
        String query_cat=" and lower(p.nombre) similar to  :categoria";
        String query_prd=" and lower(p.nombre) similar to  :producto";
        String query_mrc=" and lower(p.nombre) similar to  :marca";
        String query_pre=" and lower(p.nombre) similar to  :presentacion";
        String query_vol=" and lower(p.nombre) similar to  :volumen";
        String query_precio=" and p.precio >= :pi and p.precio <= :pf";
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
        if (tienda != null && !tienda.isEmpty()) {
            resultTienda = Integer.parseInt(tienda);
            query_tienda=" and t.idtienda = :tienda";
            base+=query_tienda;
        }
        if (pi != null && !pi.isEmpty() && pf != null && !pf.isEmpty()) {
            base+=query_precio;
        }
        base+=order;
        Query query = conexion.createSQLQuery(base).addEntity(ProductoTwebscrHist.class);
        
        //query.setString("categoria", "%"+categoria.toLowerCase()+"%");
        
        
        
        //List pusList = query1.setString("name", "%("+ajuste.toLowerCase()+")%");

        //Query query = conexion.createQuery("from ProductoTwebscrHist").setMaxResults(10);
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
        if (tienda != null && !tienda.isEmpty()) {
            query.setInteger("tienda", resultTienda);
        }
        if (pi != null && !pi.isEmpty() && pf != null && !pf.isEmpty()) {
            double pid = Double.parseDouble(pi); 
            double pfd = Double.parseDouble(pf); 
            query.setDouble("pi", pid);
            query.setDouble("pf", pfd);
        }
        List<ProductoTwebscrHist> productoList = query.list();
        List<ProductoTwebscrHist> listabase = new ArrayList<ProductoTwebscrHist>();
        int nri=-1;
        conexion.close();
        for (ProductoTwebscrHist item : productoList) {
            String relacion=item.getRelacion();
            if (relacion!=null) {
                Session cnx = funciones.getConexion();
                String query_rel="SELECT p.idproducto, p.nombre, p.detalle, p.fecha, p.hora, p.fechahora, p.idtarea, p.direccion_imagen,p.idcategoria, p.codigotienda, p.descripcion, p.precio, p.url, p.relacion, p.activo from producto_twebscr_hist p where p.relacion=:relacion";
                Query qry = cnx.createSQLQuery(query_rel);
                qry.setString("relacion", relacion);
                List<ProductoTwebscrHist> relaciones = qry.list();
                if (relaciones.size()>0) {
                    item.setNum_relacion(relaciones.size());
                }
                
                try {
                   nri = Integer.parseInt(nr);
                }
                catch (NumberFormatException e)
                {
                   nri = -1;
                }
                if (nri==0) {
                    if (relaciones.size()==0) {
                        listabase.add(item);
                    }
                }
                else{
                    if (relaciones.size()>=nri) {
                        listabase.add(item);
                    }
                }
                
                cnx.close();
            }
            else{
                item.setNum_relacion(-1);
                try {
                   nri = Integer.parseInt(nr);
                }
                catch (NumberFormatException e)
                {
                   nri = -1;
                }
                if (nri==0) {
                   listabase.add(item);
                }
            }
            //listaEmails.add(valor);
            
        }
         if (nri>=0) {
             return listabase;
         }
        return productoList;
    }
    
     @Override
    public List<ProductoTwebscrHist> traerRelacionados(String nombre) {
        
        Session cnx = funciones.getConexion();
                
        String base="SELECT p.idproducto, p.nombre, p.detalle, p.fecha, p.hora, p.fechahora, p.idtarea, p.direccion_imagen,p.idcategoria, p.codigotienda, p.descripcion, p.precio, p.url, p.relacion, p.activo, t.nombre as tienda_nom from producto_twebscr_hist p ";
        base+=" INNER JOIN tareawebscraper d ON p.idtarea = d.idtarea ";
        base+=" INNER JOIN  almacen s on d.idalmacen = s.idalmacen ";
        base+=" INNER JOIN tienda t  ON t.idtienda = s.idtienda ";
        base+=" where p.relacion=:relacion ";
        
        
        //String query_rel="SELECT p.idproducto, p.nombre, p.detalle, p.fecha, p.hora, p.fechahora, p.idtarea, p.direccion_imagen,p.idcategoria, p.codigotienda, p.descripcion, p.precio, p.url, p.relacion, p.activo, p.tienda_nom from producto_twebscr_hist p where p.relacion=:relacion";
                
                
                
                Query qry = cnx.createSQLQuery(base).addEntity(ProductoTwebscrHist.class);
                qry.setString("relacion", nombre);
                List<ProductoTwebscrHist> relaciones = qry.list();
                if (relaciones.size()>0) {
                    cnx.close();
                    return relaciones;
                }
                else{
                    cnx.close();
                    return null;
                }
    }
    @Override
    public List<ProductoTwebscrHist> traerRelacionadosID(int id) {
        
        Session cnx = funciones.getConexion();
                
        String base="SELECT p.idproducto, p.nombre, p.detalle, p.fecha, p.hora, p.fechahora, p.idtarea, p.direccion_imagen,p.idcategoria, p.codigotienda, p.descripcion, p.precio, p.url, p.relacion, p.activo, t.nombre as tienda_nom from producto_twebscr_hist p ";
        base+=" INNER JOIN tareawebscraper d ON p.idtarea = d.idtarea ";
        base+=" INNER JOIN  almacen s on d.idalmacen = s.idalmacen ";
        base+=" INNER JOIN tienda t  ON t.idtienda = s.idtienda ";
        base+=" where p.idproducto=:idproducto ";
        
        
        //String query_rel="SELECT p.idproducto, p.nombre, p.detalle, p.fecha, p.hora, p.fechahora, p.idtarea, p.direccion_imagen,p.idcategoria, p.codigotienda, p.descripcion, p.precio, p.url, p.relacion, p.activo, p.tienda_nom from producto_twebscr_hist p where p.relacion=:relacion";
                
                Query qry = cnx.createSQLQuery(base).addEntity(ProductoTwebscrHist.class);
                qry.setInteger("idproducto", id);
                List<ProductoTwebscrHist> producto = qry.list();
                cnx.close();
                if (producto.size()>0) {
                    String relacion= producto.get(0).getRelacion();
                    if (relacion!=null) {
                        String base1="SELECT p.idproducto, p.nombre, p.detalle, p.fecha, p.hora, p.fechahora, p.idtarea, p.direccion_imagen,p.idcategoria, p.codigotienda, p.descripcion, p.precio, p.url, p.relacion, p.activo, t.nombre as tienda_nom from producto_twebscr_hist p ";
                        base1+=" INNER JOIN tareawebscraper d ON p.idtarea = d.idtarea ";
                        base1+=" INNER JOIN  almacen s on d.idalmacen = s.idalmacen ";
                        base1+=" INNER JOIN tienda t  ON t.idtienda = s.idtienda ";
                        base1+=" where p.relacion=:relacion ";
                        
                        
                        Session cnx1 = funciones.getConexion();
                        Query qry1 = cnx1.createSQLQuery(base1).addEntity(ProductoTwebscrHist.class);
                        qry1.setString("relacion", relacion);
                        List<ProductoTwebscrHist> relaciones = qry1.list();
                        cnx1.close();
                        if (relaciones.size()>0) {
                            return relaciones;
                        }
                        else{
                            return null;
                        }
                    }
                    else{
                        return null;
                    }    
                    //return producto;
                }
                else{
                    return null;
                }
    }
    @Override
    public Boolean relacionarproducto(int idproducto_base, int idproducto_rel) {
        //Consultar si existe la relacion
        Boolean tiene_relacion_base=null;
        Boolean tiene_relacion_rel=null;
        String relacion_base=null;
        String relacion_rel=null;
        Session cnx1 = funciones.getConexion();
        String base1="SELECT p.idproducto, p.nombre, p.detalle, p.fecha, p.hora, p.fechahora, p.idtarea, p.direccion_imagen,p.idcategoria, p.codigotienda, p.descripcion, p.precio, p.url, p.relacion, p.activo, t.nombre as tienda_nom from producto_twebscr_hist p ";
        base1+=" INNER JOIN tareawebscraper d ON p.idtarea = d.idtarea ";
        base1+=" INNER JOIN  almacen s on d.idalmacen = s.idalmacen ";
        base1+=" INNER JOIN tienda t  ON t.idtienda = s.idtienda ";
        base1+=" where p.idproducto=:idproducto ";
                        
        Query qry1 = cnx1.createSQLQuery(base1).addEntity(ProductoTwebscrHist.class);
        qry1.setInteger("idproducto", idproducto_base);
        List<ProductoTwebscrHist> producto_base = qry1.list();      
        cnx1.close();
        if (producto_base.size()>0) {
             relacion_base= producto_base.get(0).getRelacion();
                    if (relacion_base!=null) {
                     //Existe una relacion asignada
                     tiene_relacion_base=true;
                    }
                    else{
                        //No Existe una relacion asignada
                        tiene_relacion_base=false;
                    }
        }
        
        Session cnx2 = funciones.getConexion();
        String base2="SELECT p.idproducto, p.nombre, p.detalle, p.fecha, p.hora, p.fechahora, p.idtarea, p.direccion_imagen,p.idcategoria, p.codigotienda, p.descripcion, p.precio, p.url, p.relacion, p.activo, t.nombre as tienda_nom from producto_twebscr_hist p ";
        base2+=" INNER JOIN tareawebscraper d ON p.idtarea = d.idtarea ";
        base2+=" INNER JOIN  almacen s on d.idalmacen = s.idalmacen ";
        base2+=" INNER JOIN tienda t  ON t.idtienda = s.idtienda ";
        base2+=" where p.idproducto=:idproducto ";
                        
        Query qry2 = cnx2.createSQLQuery(base2).addEntity(ProductoTwebscrHist.class);
        qry2.setInteger("idproducto", idproducto_rel);
        List<ProductoTwebscrHist> producto_rel = qry2.list();      
        cnx2.close();
        if (producto_rel.size()>0) {
             relacion_rel= producto_rel.get(0).getRelacion();
                    if (relacion_rel!=null) {
                    tiene_relacion_rel=true;
                    }
                    else{
                    tiene_relacion_rel=false;
                    }
        }
        
        if (tiene_relacion_rel && tiene_relacion_base) {
            //No se puede 
            return false;
        }
        if (!tiene_relacion_rel && tiene_relacion_base) {
            //usar relacion del base
            String code=relacion_base;
            
            Session conexionf = funciones.getConexion();
            Transaction txf2 = conexionf.beginTransaction();
            String script = "UPDATE public.producto_twebscr_hist set relacion='" + code + "' WHERE idproducto =" + idproducto_base + " or idproducto=" + idproducto_rel;
            conexionf.createSQLQuery(script).executeUpdate();
            txf2.commit();
            conexionf.close();
            return true;
            
        }
        if (tiene_relacion_rel && !tiene_relacion_base) {
           //usar relacion del rel
           String code=relacion_rel;
           
           Session conexionf = funciones.getConexion();
            Transaction txf2 = conexionf.beginTransaction();
            String script = "UPDATE public.producto_twebscr_hist set relacion='" + code + "' WHERE idproducto =" + idproducto_base + " or idproducto=" + idproducto_rel;
            conexionf.createSQLQuery(script).executeUpdate();
            txf2.commit();
            conexionf.close();
            return true;
        }
        if (!tiene_relacion_rel && !tiene_relacion_base) {
            //crear nueva relacion 
            String random_str=rand();
            Date date = Calendar.getInstance().getTime();  
            DateFormat dateFormat = new SimpleDateFormat("yyyymmddhhmmss");  
            String strDate = dateFormat.format(date); 
            String code=random_str+strDate;
            
            Session conexionf = funciones.getConexion();
            Transaction txf2 = conexionf.beginTransaction();
            String script = "UPDATE public.producto_twebscr_hist set relacion='" + code + "' WHERE idproducto =" + idproducto_base + " or idproducto=" + idproducto_rel;
            conexionf.createSQLQuery(script).executeUpdate();
            txf2.commit();
            conexionf.close();
            return true;
        }

       
        return false;
    }
    @Override
    public Boolean eliminarrelacion(int idproducto) {
                Boolean tiene_relacion_base=null;
        Boolean tiene_relacion_rel=null;
        String relacion_base=null;
        String relacion_rel=null;
        Session cnx1 = funciones.getConexion();
        String base1="SELECT p.idproducto, p.nombre, p.detalle, p.fecha, p.hora, p.fechahora, p.idtarea, p.direccion_imagen,p.idcategoria, p.codigotienda, p.descripcion, p.precio, p.url, p.relacion, p.activo, t.nombre as tienda_nom from producto_twebscr_hist p ";
        base1+=" INNER JOIN tareawebscraper d ON p.idtarea = d.idtarea ";
        base1+=" INNER JOIN  almacen s on d.idalmacen = s.idalmacen ";
        base1+=" INNER JOIN tienda t  ON t.idtienda = s.idtienda ";
        base1+=" where p.idproducto=:idproducto ";
                        
        Query qry1 = cnx1.createSQLQuery(base1).addEntity(ProductoTwebscrHist.class);
        qry1.setInteger("idproducto", idproducto);
        List<ProductoTwebscrHist> producto_base = qry1.list();      
        cnx1.close();
        if (producto_base.size()>0) {
             relacion_base= producto_base.get(0).getRelacion();
                    if (relacion_base!=null) {
                     //Existe una relacion asignada
                     tiene_relacion_base=true;
                    }
                    else{
                        //No Existe una relacion asignada
                        tiene_relacion_base=false;
                    }
        }
        if (tiene_relacion_base) {
            //usar relacion del base
            String code=relacion_base;
            
            Session conexionf = funciones.getConexion();
            Transaction txf2 = conexionf.beginTransaction();
            String script = "UPDATE public.producto_twebscr_hist set relacion=null WHERE idproducto =" + idproducto ;
            conexionf.createSQLQuery(script).executeUpdate();
            txf2.commit();
            conexionf.close();
            return true;
            
        }
        return false;
    }
     public String rand() {
        int leftLimit = 97;
        int rightLimit = 122;
        int targetStringLength = 6;
        Random random = new Random();
        StringBuilder buffer = new StringBuilder(targetStringLength);
         for (int i = 0; i < targetStringLength; i++) {
             int randomLimitedInt = leftLimit + (int)(random.nextFloat() * (rightLimit - leftLimit + 1));
             buffer.append((char) randomLimitedInt);
         }
         String generatedString = buffer.toString();
        return generatedString;
    }

}
