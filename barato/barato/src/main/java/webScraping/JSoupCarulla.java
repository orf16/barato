/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package webScraping;

import java.awt.Toolkit;
import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.StringSelection;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.jsoup.Connection;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import servicios.Funciones;

import java.math.BigInteger;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 * @author andres
 */
public class JSoupCarulla {

    private final Funciones funciones = new Funciones();
    ActualizarProduct it= new ActualizarProduct();
    private List<String> listaCodigos = new ArrayList<>();
    public void obtenerProductos(Integer idalmacen) {
        JSoupCertificadoSSL ssl = new JSoupCertificadoSSL();
        ssl.certificadoseguro();


            String script = "";
            String pagina = "";
            Integer totalprodProc = 0;
            //Crea tarea tabla tareawebscraper
            Session conexion = funciones.getConexion();
            script = "SELECT nextval('tareawebscraper_idtarea_seq') AS CONSECUTIVO";
            Iterator<BigInteger> iter;
            iter = (Iterator<BigInteger>) conexion.createSQLQuery(script).list().iterator();
            Long idtareal = iter.next().longValue();
            String idtarea = idtareal.toString();

            Transaction tx = conexion.beginTransaction();
            script = "INSERT INTO public.tareawebscraper(idtarea,idalmacen) values(" + idtarea + "," + idalmacen + ")";
            conexion.createSQLQuery(script).executeUpdate();
            tx.commit();
            conexion.close();

            //Bebidas
            pagina = "https://www.carulla.com/Vinos_y_licores/_/N-2c5u?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("2"));


            Session conexionf = funciones.getConexion();
            Transaction txf2 = conexionf.beginTransaction();
            script = "UPDATE public.tareawebscraper set fechahorafin=now(),cantidadproductos=" + totalprodProc + " WHERE idtarea =" + idtarea;
            conexionf.createSQLQuery(script).executeUpdate();
            txf2.commit();
            conexionf.close();

             ActualizarProduct intProd = new ActualizarProduct();
        try {
            intProd.copiarProduct(new BigInteger(idtarea), new Integer(5));
        } catch (SQLException e) {
            e.printStackTrace();
        }

        script = "UPDATE public.tareawebscraper set productoscopiados=true WHERE idtarea=" + idtarea;
            Session conexionfc = funciones.getConexion();
            Transaction txfc = conexionfc.beginTransaction();
            conexionfc.createSQLQuery(script).executeUpdate();
            txfc.commit();
            conexionfc.close();




/*
            Session conexionfc = funciones.getConexion();
            java.sql.Connection connection= ((SessionImpl) conexionfc).connection();
            Transaction txfc = conexionfc.beginTransaction();
            try {
                connection.prepareCall("{call public.copiarproductos("+ idtarea+")}").executeQuery();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            txfc.commit();
            conexionfc.close();


            */



    }

    public Integer obtenerproductcat(Integer idalmacen, String pagina, BigInteger idtarea, Integer idcategoria) {
        int totalprodProc = 0;
        List<String> scripts = new ArrayList<>();
        try {
            //Constantes
            String scriptfijo = "INSERT INTO public.producto_twebscr_hist(nombre, detalle,precio,idtarea,direccion_imagen,codigotienda,idcategoria) VALUES (";
            String idtienda = "5";
            int cantporpag = 20;
            String pageadic = "&Nrpp=" + cantporpag;
            String clasprod = "span[class=\"name plpName\"]";
            String clasdet = "span[class=\"brand plpBrand\"]";
            String clasprec = "div[class=\"col-price\"]";
            String clasimag = "div[class=\"image\"]";
            String clascodprod = "div[data-skuid]";

            String clascantprod = "p[class=\"plpResults\"]";

            int timeout = 120000;


            //Cargamos primera pagina para obtener total productos
            String blogUrlone = pagina + "0" + pageadic;
            Connection connectionone = Jsoup.connect(blogUrlone);
            connectionone.userAgent("Mozilla");
            connectionone.timeout(timeout);
            //Cookie ciudad
            connectionone.cookie("selectedCity", ciudad(idalmacen));

            connectionone.referrer("http://google.com");
            Document docOneConn = null;
            try {
                docOneConn = connectionone.get();
            } catch (Exception e) {
            }
            //Obtenemos total productos
            org.jsoup.select.Elements numproductos = docOneConn.select(clascantprod);
            org.jsoup.nodes.Element nprod = numproductos.get(0);
            String labeltotalprod = nprod.html().replace("</strong>", "").replace("'", "''");
            int numini = labeltotalprod.indexOf("de");
            int numfin = labeltotalprod.indexOf("resultados");
            String totalprodstr = labeltotalprod.substring(numini + 3, numfin).trim();
            int totalprod = Integer.parseInt(totalprodstr);
            int numPag = 0;
            int numPagmax = 0;
            if (totalprod > cantporpag)
                numPagmax = totalprod - (totalprod % cantporpag);

            String script = "";
            while (numPag <= numPagmax) {
                String blogUrl = pagina + numPag + pageadic;
                Connection connection = Jsoup.connect(blogUrl);
                connection.userAgent("Mozilla");
                connection.timeout(timeout);
                //Cookie ciudad
                connection.cookie("selectedCity", ciudad(idalmacen));

                connection.referrer("http://google.com");
                Document docCustomConn = null;

                Boolean reintentar = true;
                while (reintentar == true) {
                    try {
                        docCustomConn = connection.get();
                        reintentar = false;
                    } catch (Exception e) {
                        //tiempo de espera evitar ser detectado como  robot
                        Thread.sleep(4000);
                        reintentar = true;
                    }
                }
                StringSelection stringSelection = new StringSelection(docCustomConn.wholeText());
Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
clipboard.setContents(stringSelection, null);
                org.jsoup.select.Elements Productos = docCustomConn.select(clasprod);
                
                org.jsoup.select.Elements Detalles = docCustomConn.select(clasdet);
                org.jsoup.select.Elements Precios = docCustomConn.select(clasprec);
                org.jsoup.select.Elements Imagenes = docCustomConn.select(clasimag);
                org.jsoup.select.Elements Codigos = docCustomConn.select(clascodprod);

                int numprod = 0;
                for (org.jsoup.nodes.Element prod : Productos) {
                    String nombreprod = prod.html().replace("'", "''");
                    org.jsoup.nodes.Element det = Detalles.get(numprod);
                    String descriprod = det.html().replace("'", "''");

                    org.jsoup.nodes.Element prec = Precios.get(numprod).child(0).child(0);
                    String precio = prec.html().replace(",", "");

                    org.jsoup.nodes.Element img = Imagenes.get(numprod).child(0);
                    ;
                    String imagen = img.attr("src");

                    org.jsoup.nodes.Element cod = Codigos.get(numprod);
                    String codigotienda = "";
                    codigotienda = cod.attr("data-skuid");

                    if (precio.trim().equals("")) {
                        precio = "-1";
                    }
                    if (listaCodigos.contains(codigotienda)==false) {
                    script =  scriptfijo + "'" + nombreprod + "','" + descriprod + "'," + precio + "," + idtarea + ",'" + imagen + "'" + ",'" + codigotienda.trim() + "'," + idcategoria + ");";
                    scripts.add(script);
                    listaCodigos.add(codigotienda);
                    ++totalprodProc;
                    ++numprod;
                    }

                }
                numPag = numPag + cantporpag;
            }

            Integer nuact=0;
            Integer cantscripts=500;
            Integer nufin=0;

            while (nuact<= scripts.size())
            {
                List<String> scriptsloc=new ArrayList<>();
                nufin=nuact+cantscripts;
                if (nufin>scripts.size())
                    nufin=scripts.size();

                scriptsloc= scripts.subList(nuact,nufin);
                it.EjecutaScript(scriptsloc);
                nuact=nuact+cantscripts;
            }


        } catch (Exception ex) {

        }

        return totalprodProc;
    }

    public String ciudad(Integer idalmacen) {
        String retorno;
        switch (idalmacen) {
            case 17:
                retorno = "BG";
                break;
            case 18:
                retorno = "CG";
                break;
            case 19:
                retorno = "CL";
                break;
            case 20:
                retorno = "ML";
                break;
            default:
                retorno = "BG";
                break;
        }
        return retorno;
    }

}
