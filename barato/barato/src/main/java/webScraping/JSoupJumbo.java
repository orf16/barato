/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package webScraping;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.json.JSONArray;
import org.json.JSONObject;
import servicios.Funciones;

import javax.net.ssl.HttpsURLConnection;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.math.BigInteger;
import java.net.URL;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import static javax.ws.rs.core.HttpHeaders.USER_AGENT;

/**
 * @author andres
 */
public class JSoupJumbo {

    private final Funciones funciones = new Funciones();
    ActualizarProduct it= new ActualizarProduct();
    private HttpsURLConnection conn;
    private List<String> cookies;
    private List<String> listaCodigos = new ArrayList<>();
    private String GetPageContent(String url) throws Exception {
        URL obj = new URL(url);
        conn = (HttpsURLConnection) obj.openConnection();
        conn.setRequestMethod("GET");
        conn.setUseCaches(false);
        conn.setRequestProperty("User-Agent", USER_AGENT);
        conn.setRequestProperty("Accept",
                "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8");
        conn.setRequestProperty("Accept-Language", "en-US,en;q=0.5");
        if (cookies != null) {
            for (String cookie : this.cookies) {
                conn.addRequestProperty("Cookie", cookie.split(";", 1)[0]);
            }
        }
        int responseCode = conn.getResponseCode();
        BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        String inputLine;
        StringBuffer response = new StringBuffer();
        while ((inputLine = in.readLine()) != null) {
            response.append(inputLine);
        }
        in.close();

        return response.toString();
    }

    public void obtenerProductos(Integer idalmacen) {


        String script = "";
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

        String pagina = "";



        //Despensa
        pagina = "%2f2000055%2f";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer(3));


        //Pescados y Mariscos
        pagina = "%2f2000039%2f";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer(8));


        //Frutas
        pagina = "%2f2000045%2f2000048%2f";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer(6));


        //Pulpa Frutas
        pagina = "%2f2000045%2f2000221%2f";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer(6));



        // Hortalizas
        pagina = "%2f2000045%2f2000046%2f";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer(7));

        //Carne y Pollo
        pagina = "%2f2000030%2f";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer(8));


        //Bebidas
        pagina = "%2f2000098%2f";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer(2));


        //Charcuteria
        pagina = "%2f2000051%2f";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer(9));


        //Panaderia y Pasteleria
        pagina = "%2f2000083%2f";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer(11));


        //Vinos y Licores
        pagina = "%2f1000060%2f";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer(10));




        //Aseo Hogar
        pagina = "%2f2000006%2f";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer(12));

        //Cuidado Personal
        pagina = "%2f2000014%2f";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer(13));



        //Dulces y Postres
        pagina = "%2f2000052%2f";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer(1));


        //Productos congelados
        pagina = "%2f2000087%2f";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer(4));



        //Cigarrillos
        pagina = "%2f2000002%2f";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer(10));


        //Cuidado del Bebe
        pagina = "%2f2000179%2f";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer(15));

        //lacteos  refrigerados
        pagina = "%2f2000023%2f";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer(5));


        //huevos
        pagina = "%2f2000023%2f2000026%2f";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer(3));


        //Pasabocas  
        pagina = "%2f2000217%2f";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer(1));

        //Cuidado ropa y calzado
        pagina = "%2f2000231%2f";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer(12));

        //Limpieza de cocina
        pagina = "%2f2000235%2f";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer(12));

        //Mascotas    
        pagina = "%2f2000228%2f";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer(14));

        Session conexionf = funciones.getConexion();
        Transaction txf = conexionf.beginTransaction();
        script = "UPDATE public.tareawebscraper set fechahorafin=now(),cantidadproductos=" + totalprodProc + " WHERE idtarea =" + idtarea;
        conexionf.createSQLQuery(script).executeUpdate();
        txf.commit();
        conexionf.close();


        ActualizarProduct intProd = new ActualizarProduct();
        try {
            intProd.copiarProduct(new BigInteger(idtarea), new Integer(2));
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

        JSoupCertificadoSSL ssl = new JSoupCertificadoSSL();
        ssl.certificadoseguro();

        int totalprodProc = 0;
        List<String> scripts = new ArrayList<>();
        try {
            //Constantes
            int numprod = 0;
            String scriptfijo = "INSERT INTO public.producto_twebscr_hist(nombre,detalle,descripcion,precio,idtarea,direccion_imagen,codigotienda,idcategoria) VALUES (";
            String idtienda = "2";
            String page = "https://www.tiendasjumbo.co/api/catalog_system/pub/products/search/?&fq=C%3a%2f2000001";
            String clasprod = "productName";
            String clasdet = "brand";
            String clasdesc = "description";
            String clasprec = "Value";
            String clasimag = "imageUrl";
            String clascodig = "productId";

            String script = "";
            //se requiere para que entre en el while no borrar
            String retorno = "[contend]";
            Integer cant = 0;
            Integer desde = 0;
            Integer hasta = 0;

            while (!retorno.trim().equals("[]")) {

                cant = cant + 50;
                desde = cant - 50;
                hasta = cant - 1;

                Boolean reintentar = true;

                while (reintentar == true) {
                    try {

                        retorno = GetPageContent(page + pagina + "&O=OrderByNameASC&_from=" + desde + "&_to=" + hasta);
                        reintentar = false;
                    } catch (Exception e) {
                        //tiempo de espera evitar ser detectado como  robot
                        Thread.sleep(4000);
                        reintentar = true;
                    }
                }
                List<String> listascript = new ArrayList<>();
                JSONArray jsonArr = new JSONArray(retorno);

                for (int i = 0; i < jsonArr.length(); i++) {

                    JSONObject jsonObj = jsonArr.getJSONObject(i);
                    String nombreprod = jsonObj.getString(clasprod).replace("'", "''");
                    String descriprod = jsonObj.getString(clasdesc).replace("'", "''");
                    String detalleprod = jsonObj.getString(clasdet).replace("'", "''");
                    String codigotienda = jsonObj.getString(clascodig);
                    String precio = "0";
                    String imagen = "";

                    try {
                        JSONObject precObj = jsonObj.getJSONArray("items").getJSONObject(0).getJSONArray("sellers").getJSONObject(0).getJSONObject("commertialOffer").getJSONArray("Installments").getJSONObject(0);

                        Double precd = precObj.getDouble(clasprec);
                        precio = precd.toString();
                    } catch (Exception e) {
                        String error = script;
                    }

                    try {
                        JSONObject imagenObj = jsonObj.getJSONArray("items").getJSONObject(0).getJSONArray("images").getJSONObject(0);
                        imagen = imagenObj.getString(clasimag);
                    } catch (Exception e) {
                        String error = script;
                    }
                    if (listaCodigos.contains(codigotienda)==false) {
                        script = scriptfijo + "'" + nombreprod + "','" + detalleprod + "','" + descriprod + "'," + precio + "," + idtarea + ",'" + imagen + "'" + ",'" + codigotienda.trim() + "'," + idcategoria + ");" + System.getProperty("line.separator");
                        scripts.add(script);
                        listaCodigos.add(codigotienda);
                        ++totalprodProc;
                    }


                }

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

}
