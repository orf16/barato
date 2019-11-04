/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servicios;

import interfaces.AdminProductoTiendaInterface;

import java.math.BigInteger;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

import modelos.Producto;
import modelos.ProductoTienda;
import modelos.ProductoTiendaCadena;
import modelos.ProductoTwebscrHist;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Service;

/**
 * @author
 */
@Service("AdmInterface")
public class AdminProductoTiendaImplementacion implements AdminProductoTiendaInterface {

    private final Funciones funciones = new Funciones();

    @Override
    public List<ProductoTienda> getProductoTienda(List<Producto> listProductos) {
        Session conexion = funciones.getConexion();
        System.out.println("entra1");
        System.out.println(listProductos);
        String consulta = "";
        Query query = conexion.createQuery("FROM ProductoTienda p left join fetch p.producto left join fetch p.tienda WHERE p.producto in (:listProductos) ");
        query.setParameterList("listProductos", listProductos);
        query.setParameterList("listProductos", listProductos);

        List<ProductoTienda> ProductoTiendaList = query.list();
        conexion.close();

        return ProductoTiendaList;
    }

    @Override
    public List<ProductoTienda> getProductoTiendaCopiar() {
        Session conexion = funciones.getConexion();
        String consulta = "";
        Query query;

        consulta = "Select pt FROM Productoxcategoria pc inner join pc.categoria c inner join pc.producto p inner join p.productoTiendas pt ";
        //         consulta = "Select pt FROM ProductoTienda pt inner join producto  p inner join fetch pt.tienda t inner join productoxcategoria c on p.idproducto=c.idproducto where c.categoria_idcategotia = :idcategoria";
        query = conexion.createQuery(consulta);
        List<ProductoTienda> ProductoTiendaList = query.list();
        conexion.close();

        return ProductoTiendaList;
    }

    @Override
    public List<ProductoTiendaCadena> getProductoTiendaCadena(List<Producto> listProductos) {
        Session conexion = funciones.getConexion();
        System.out.println("entra2");
        Query query = conexion.createQuery("FROM ProductoTiendaCadena p left join fetch p.producto left join fetch p.tienda WHERE p.producto in (:listProductos) ");
        query.setParameterList("listProductos", listProductos);

        List<ProductoTiendaCadena> ProductoTiendaCadenaList = query.list();

        conexion.close();

        return ProductoTiendaCadenaList;
    }


    @Override
    public List<ProductoTwebscrHist> getProductosTareaCatSingle(BigInteger idtarea,Integer idcategoria) {
        Session conexion = funciones.getConexion();
        String consulta="";
        consulta = "FROM ProductoTwebscrHist WHERE idtarea=:idtarea and idcategoria=:idcategoria and precio > 0 ";
        Query query = conexion.createQuery(consulta );
        query.setParameter("idtarea",idtarea);
        query.setParameter("idcategoria",idcategoria);
        List <ProductoTwebscrHist> ProductoTareaList = query.list();
        conexion.close();
        return ProductoTareaList;
    }

    @Override
    public List<ProductoTwebscrHist> getProductosTareaCat(Integer idtienda, Integer idcategoria, String nombreprod,String codigotienda,Double precio) {

        Session conexion = funciones.getConexion();

        String script = "";
        script = "select max(t.idtarea) from tareawebscraper t inner join almacen a on " +
                " t.idalmacen=a.idalmacen where a.idtienda = " + idtienda;
        Iterator<BigInteger> iter;
        iter = (Iterator<BigInteger>) conexion.createSQLQuery(script).list().iterator();
        Long idtareal = iter.next().longValue();
        String idtareastr = idtareal.toString();
        BigInteger idtarea = new BigInteger(idtareastr);

        String consulta = "";

        if (!codigotienda.trim().equals("")){
            consulta = consulta+"   Select idproducto,nombre,detalle,fecha,hora,fechahora,idtarea,direccion_imagen as direccionimagen,idcategoria,codigotienda,descripcion,precio "+
                    " FROM Producto_Twebscr_Hist WHERE codigotienda = :codigotienda and idtarea=:idtarea2  UNION ";

        }


        consulta = consulta+" Select idproducto,nombre,detalle,fecha,hora,fechahora,idtarea,direccion_imagen as direccionimagen,idcategoria,codigotienda,descripcion,precio  FROM Producto_Twebscr_Hist WHERE idtarea=:idtarea  ";

        //Productos que se repiten en varias categorias
        if ( (idcategoria==1) ||  (idcategoria==3) ||  (idcategoria==4)||  (idcategoria==5))
            consulta = consulta +" and (idcategoria=:idcategoria or idcategoria=:idcategoria2) ";
        else
            consulta = consulta +" and idcategoria=:idcategoria ";


        if (precio == new Double(0))
            consulta = consulta +" and precio > 0 ";
        else
        {
            Double precioini=precio-(precio*0.4);
            Double preciofin=(precio*0.4)+precio;
            consulta = consulta +" and precio >  "+precioini.toString()+" and precio <  "+preciofin.toString();

        }


        if (!nombreprod.trim().equals("")) {
            //String delimiter = "\\.";
            String delimiter = " ";
            String[] tempArray = nombreprod.split(delimiter);
            String nombreprodtemp = "";

            String consnombre= "";

            for (int i = 0; i < tempArray.length; i++) {
                nombreprodtemp = tempArray[i].replace("'", "''");;

                 if((nombreprodtemp.length()>2) && (!nombreprodtemp.toLowerCase().equals("marca")) && (!nombreprodtemp.toLowerCase().equals("exclusiva"))
                         && (!nombreprodtemp.toLowerCase().equals("pack"))) {
                     if (consnombre.equals(""))
                         consnombre = consnombre + "  (unaccent(nombre||' ' ||detalle)  ~* unaccent('\\m" + nombreprodtemp + "\\M'))";
                     else
                         consnombre = consnombre + " or (unaccent(nombre||' ' ||detalle) ~* unaccent('\\m" + nombreprodtemp + "\\M'))";
                 }

            }
            if (!consnombre.equals(""))
            consulta = consulta+" and ("+ consnombre + " )";

            consulta = consulta+" order by nombre";



        }

        Query query = conexion.createSQLQuery(consulta).setResultTransformer(Transformers.aliasToBean(ProductoTwebscrHist.class));;
       // Query query = conexion.createQuery(consulta);
        query.setParameter("idtarea", idtarea);
        query.setParameter("idcategoria", idcategoria);
        if (!codigotienda.trim().equals("")) {
            query.setParameter("codigotienda", codigotienda);
            query.setParameter("idtarea2", idtarea);
        }
        //Productos que se repiten en varias categorias
        if  (idcategoria==1)
            query.setParameter("idcategoria2", 3);
        else   if  (idcategoria==3)
            query.setParameter("idcategoria2", 1);
        else   if  (idcategoria==4)
            query.setParameter("idcategoria2", 5);
        else   if  (idcategoria==5)
            query.setParameter("idcategoria2", 4);



        List<ProductoTwebscrHist> ProductoTareaList = query.list();

        if (!codigotienda.trim().equals("")) {
            Integer indexprod = findIndexCodigoTienda(codigotienda, ProductoTareaList);
            if (indexprod!=null)
            Collections.swap(ProductoTareaList, 0, indexprod);
        }
        conexion.close();
        return ProductoTareaList;
    }

    public Integer findIndexCodigoTienda(String codigoTienda, List<ProductoTwebscrHist> lista) {
        for (int i = 0; i < lista.size(); i++) {
            ProductoTwebscrHist prod = lista.get(i);

            if (prod.getCodigotienda().equals(codigoTienda)) {
                return i;

            }
        }
        return null;
    }


    @Override
    public List<ProductoTwebscrHist> getProductosNoExistenTareaCat(Integer idtienda, Integer idcategoria, String nombreprod) {

        Session conexion = funciones.getConexion();

        String script = "";
        script = "select max(t.idtarea) from tareawebscraper t inner join almacen a on " +
                " t.idalmacen=a.idalmacen where a.idtienda = " + idtienda;
        Iterator<BigInteger> iter;
        iter = (Iterator<BigInteger>) conexion.createSQLQuery(script).list().iterator();
        Long idtareal = iter.next().longValue();
        String idtareastr = idtareal.toString();
        BigInteger idtarea = new BigInteger(idtareastr);

        String consulta = "";
        consulta = "FROM ProductoTwebscrHist  WHERE idtarea=:idtarea and idcategoria=:idcategoria and precio > 0 and codigotienda NOT IN (select codigotienda from ProductoTienda  where tienda.idtienda=:idtienda ) ";

        if (!nombreprod.trim().equals(""))
            consulta = consulta + " and lower( unaccent(nombre || ' '  || detalle )  ) like unaccent('%" + nombreprod.toLowerCase() + "%')";


        consulta = consulta + " order by nombre";
        Query query = conexion.createQuery(consulta);
        query.setParameter("idtarea", idtarea);
        query.setParameter("idcategoria", idcategoria);
        query.setParameter("idtienda", idtienda);



        ProductoTwebscrHist Prod= new ProductoTwebscrHist();

        List<ProductoTwebscrHist> ProductoTareaList = query.list();
        conexion.close();
        return ProductoTareaList;
    }

    @Override
    public List<ProductoTwebscrHist> getProductosTareaCatExitoCarulla(Integer idcategoria) {
        Session conexion = funciones.getConexion();
        String consulta = "";
        consulta = "FROM ProductoTwebscrHist WHERE idcategoria=:idcategoria and idtarea = :idtareaexito  and codigotienda in (" +
                " select codigotienda FROM ProductoTwebscrHist WHERE idcategoria=:idcategoria2 and idtarea in (:idtareaexito2,:idtareacarull) and precio > 0 " +
                " group by codigotienda having count(1) > 1 ) ";

        BigInteger idtareaexito = new BigInteger("1");
        BigInteger idtareacarull = new BigInteger("1");

        Query query = conexion.createQuery(consulta);
        query.setParameter("idcategoria", idcategoria);
        query.setParameter("idtareaexito", idtareaexito);
        query.setParameter("idcategoria2", idcategoria);
        query.setParameter("idtareaexito2", idtareaexito);
        query.setParameter("idtareacarull", idtareacarull);
        List<ProductoTwebscrHist> ProductoTareaList = query.list();
        conexion.close();
        return ProductoTareaList;
    }


}
