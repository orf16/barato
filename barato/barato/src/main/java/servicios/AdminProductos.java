/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servicios;

import interfaces.ProductoInterface;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import modelos.Producto;
import modelos.Productoxcategoria;
import org.hibernate.Query;
import org.hibernate.Session;
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

}
