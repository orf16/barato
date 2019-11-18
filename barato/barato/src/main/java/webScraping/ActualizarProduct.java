package webScraping;

import modelos.Categoria;
import modelos.Producto;
import modelos.ProductoTienda;
import modelos.ProductoTwebscrHist;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.internal.SessionImpl;
import servicios.AdminCategoriasImplementacion;
import servicios.AdminProductoTiendaImplementacion;
import servicios.AdminProductos;
import servicios.Funciones;


import java.math.BigInteger;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;


public class ActualizarProduct {
    private final Funciones funciones = new Funciones();

    public Boolean EjecutaScript(List<String> scripts) throws SQLException {

        Boolean retorno=false;
        Boolean error=true;

        Integer cont=new Integer(0);

        while (error==true)
        {
            ++cont;

            Session conexionr = funciones.getConexion();
            java.sql.Connection connectionr = ((SessionImpl) conexionr).connection();
            Transaction txfr = conexionr.beginTransaction();
            Statement statementr = null;
            try {

                statementr = connectionr.createStatement();
                for (String scr : scripts) {
                    statementr.addBatch(scr);
                }
                statementr.executeBatch();
                txfr.commit();
                error=false;
                retorno=true;

            } catch (SQLException e) {
                error=true;
                retorno=false;

            } finally {
                statementr.close();
                connectionr.close();
                conexionr.close();
                if (cont>=10)
                {
                    error=false;

                }
            }

        }
        return retorno;


    }

    public Integer findIdproductoProductoTiendaByCodigo(String cod, Integer idtienda, List<ProductoTienda> lista) {
        for (int i = 0; i < lista.size(); i++) {
            ProductoTienda prod = lista.get(i);

            if ((prod.getCodigotienda().equals(cod)) && (prod.getTienda().getIdtienda() == idtienda)) {
                return prod.getProducto().getIdproducto();

            }
        }
        return null;
    }


    public Integer findIdproductoProductoTiendaByCodigoSimilar(String cod, Integer idtienda, List<ProductoTienda> lista) {
        for (int i = 0; i < lista.size(); i++) {
            ProductoTienda prod = lista.get(i);

            if ((idtienda == 1) || (idtienda == 5)) {
                if ((prod.getCodigotienda().equals(cod)) && ((prod.getTienda().getIdtienda()  == 1) || (prod.getTienda().getIdtienda()  == 5))) {
                    return prod.getProducto().getIdproducto();
                }
            } else {
                if ((prod.getCodigotienda().equals(cod)) && (prod.getTienda().getIdtienda()  == idtienda)) {
                    return prod.getProducto().getIdproducto();
                }
            }
        }
        return null;
    }


    public void copiarProduct(BigInteger idtarea, Integer idtienda) throws SQLException {

        List<Categoria> cattot = new ArrayList<>();
        AdminCategoriasImplementacion admCat = new AdminCategoriasImplementacion();
        cattot = admCat.getCategoriasxLimite(100);
        for (int x = 0; x < cattot.size(); x++) {
            copiarProductCat(idtarea, idtienda, cattot.get(x).getIdcategoria());
        }

    }

    public void copiarProductCat(BigInteger idtarea, Integer idtienda, Integer idcat) throws SQLException {
        String script = "";
        String seq = "";
        AdminProductos admPr = new AdminProductos();
        List<Producto> todos = admPr.traerTodosProductosxcategoria(idcat);

        AdminProductoTiendaImplementacion admPrTiend = new AdminProductoTiendaImplementacion();
        List<ProductoTienda> todosTienda = admPrTiend.getProductoTiendaCopiar();
        List<ProductoTwebscrHist> todosTarea = admPrTiend.getProductosTareaCatSingle(idtarea, idcat);
        List<String> scripts = new ArrayList<>();
        for (int x = 0; x < todosTarea.size(); x++) {
            ProductoTwebscrHist prod = todosTarea.get(x);
            Integer idprod = findIdproductoProductoTiendaByCodigoSimilar(prod.getCodigotienda(), idtienda, todosTienda);

            if (idprod != null) {
                script = " UPDATE public.producto SET direccion_imagen='" + prod.getDireccionImagen().replace("'", "''") + "' where idproducto=" + idprod + ";";
                scripts.add(script);

            }

            Integer idprodT = null;

            idprodT = findIdproductoProductoTiendaByCodigo(prod.getNombre(), idtienda, todosTienda);

            if (idprodT != null) {

                script = " UPDATE public.producto_tienda set nombre='" + prod.getNombre().replace("'", "''") + "'"+ ",valor = " + prod.getPrecio() + " , valor_unidad=" + prod.getPrecio() + ", estado = true where producto_idproducto=" + idprod + " and tienda_idtienda = " + idtienda + ";";
                scripts.add(script);

            }


        }
        if (scripts.isEmpty() == false) {


            Integer nuact = 0;
            Integer cantscripts=500;
            Integer nufin = 0;

            while (nuact <= scripts.size()) {
                List<String> scriptsloc = new ArrayList<>();
                nufin = nuact + cantscripts;
                if (nufin > scripts.size())
                    nufin = scripts.size();

                scriptsloc = scripts.subList(nuact, nufin);
                EjecutaScript(scriptsloc);
                nuact = nuact + cantscripts;
            }

        }
    }
}
