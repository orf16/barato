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
import java.io.DataOutputStream;
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
public class JSoupOlimpica {

    private final Funciones funciones = new Funciones();
    ActualizarProduct it= new ActualizarProduct();
    private HttpsURLConnection conn;
    private List<String> cookies;
    private List<String> listaCodigos = new ArrayList<>();
    public void obtenerProductos(Integer idalmacen) {

        JSoupCertificadoSSL ssl = new JSoupCertificadoSSL();
        ssl.certificadoseguro();

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

        String params = "";



        
        //BEBIDAS



        //bebidas alcoholicas
        params = "\"codigo\":\"4,10,0,0,0,0,0\"";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, params, new BigInteger(idtarea), new Integer(10));



        Session conexionf = funciones.getConexion();
        Transaction txf = conexionf.beginTransaction();
        script = "UPDATE public.tareawebscraper set fechahorafin=now(),cantidadproductos=" + totalprodProc + " WHERE idtarea =" + idtarea;
        conexionf.createSQLQuery(script).executeUpdate();
        txf.commit();
        conexionf.close();

        ActualizarProduct intProd = new ActualizarProduct();
        try {
            intProd.copiarProduct(new BigInteger(idtarea), new Integer(3));
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

    public Integer obtenerproductcat(Integer idalmacen, String params, BigInteger idtarea, Integer idcategoria) {
        int totalprodProc = 0;
        List<String> scripts = new ArrayList<>();
        try {
            int numprod = 0;
            //Constantes
            String scriptfijo = "INSERT INTO public.producto_twebscr_hist(nombre, detalle,precio,idtarea,direccion_imagen,codigotienda,idcategoria) VALUES (";
            String page = "https://app.olimpica.com.co:8181/OlimpicaSyncDMZWS/SyncServices/ServiciosApp/consultarProductos";
            String urldom = "https://www.olimpica.com.co";
            String clasprod = "descripcion";
            String clasdet = "descripcion_general";
            String clasprec = "precio";
            String clasimag = "URLImagen";
            String clascodig = "plu";

            String script = "";
            String retorno = "[contend]";
            Integer cant = 1;
            Integer desde = 1;
            Integer hasta = 1;

            while (!retorno.trim().equals("[]")) {
                cant = cant + 10;
                desde = cant - 10;
                hasta = cant - 1;
                String paramGen = "{\"centroDespacho\":423," + params + ",\"tipoOrdenamiento\":1,\"nombreUsuario\":\"appprueba2019@gmail.com\",\"tipoPedido\":2,\"index\":null,\"ciudad\":\"11001\",";
                paramGen = paramGen + "\"rangoInicio\":" + desde;
                paramGen = paramGen + ",\"rangoFin\":" + hasta + "}";

                Boolean reintentar = true;

                while (reintentar == true) {
                    try {
                        //tiempo de espera evitar ser detectado como  robot

                        retorno = sendPost(page, urldom, urldom, paramGen);
                        reintentar = false;
                    } catch (Exception e) {
                        Thread.sleep(4000);
                        reintentar = true;
                    }
                }

                JSONArray jsonArrP = new JSONArray("[" + retorno + "]");
                JSONObject jsonObjP = jsonArrP.getJSONObject(0);
                JSONArray jsonArr = jsonObjP.getJSONArray("data");

                if (jsonArr.length() == 0) {
                    retorno = "[]";
                }

                for (int i = 0; i < jsonArr.length(); i++) {
                    JSONObject jsonObj = jsonArr.getJSONObject(i);
                    String nombreprod = jsonObj.getString(clasprod).replace("'", "''");
                    String descriprod = "";
                    //Se comenta porque olimpica tiene la misma descripcion y nombre
                    //String descriprod = jsonObj.getString(clasdet).replace("'", "''");

                    String precio = "0";
                    String imagen = "";
                    String codigotienda = "";

                    try {
                        Double precd = jsonObj.getDouble(clasprec);
                        precio = precd.toString();
                    } catch (Exception e) {
                        String error = script;
                    }

                    try {
                        BigInteger codtd = jsonObj.getBigInteger(clascodig);
                        codigotienda = codtd.toString();
                    } catch (Exception e) {
                        String error = script;
                    }


                    try {
                        imagen = jsonObj.getString(clasimag);
                    } catch (Exception e) {
                        String error = script;
                    }
                    if (listaCodigos.contains(codigotienda)==false) {
                        script = scriptfijo + "'" + nombreprod + "','" + descriprod + "'," + precio + "," + idtarea + ",'" + imagen + "'" + ",'" + codigotienda.trim() + "'," + idcategoria + ");" + System.getProperty("line.separator");
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

    private String sendPost(String url, String Host, String urlreferer, String postParams) throws Exception {
        //Parametros encabezados requeridos olimpica
        String token = "eyJhbG2342342340uY456456IsImp0aS56UFRKeTkySXciLCJpYXQiOjE1NDgwMjIyMDIsIm5iZiI6MTU0ODAyMjA45675675679iYW5lc2tpQGdtYWlsLmNvbSJ9.NBvJK52DRZq4fBv679lshsZLW_VN456456A";
        String appv = "1.7.1";
        String xplat = "Android";
        String xplatv = "7.1.2";
        String xdevmod = "X-Device-Model";
        String xdevman = "samsung";
        String xdevuuid = "3cd3c5656ae32b82c";

        URL obj = new URL(url);
        conn = (HttpsURLConnection) obj.openConnection();
        conn.setUseCaches(false);
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Host", Host);
        conn.setRequestProperty("User-Agent", USER_AGENT);
        conn.setRequestProperty("Accept",
                "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8");
        conn.setRequestProperty("Accept-Language", "en-US,en;q=0.5");

        //Se añaden Parametros encabezados requeridos olimpica
        conn.addRequestProperty("token", token);
        conn.addRequestProperty("X-App-Version", appv);
        conn.addRequestProperty("X-Platform", xplat);
        conn.addRequestProperty("X-Platform-Version", xplatv);
        conn.addRequestProperty("X-Device-Model", xdevmod);
        conn.addRequestProperty("X-Device-Manufacturer", xdevman);
        conn.addRequestProperty("X-Device-UUID", xdevuuid);

        conn.setRequestProperty("Connection", "keep-alive");
        conn.setRequestProperty("Referer", urlreferer);
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setRequestProperty("Content-Length", Integer.toString(postParams.length()));
        conn.setDoOutput(true);
        conn.setDoInput(true);

        // Se envia petición post
        DataOutputStream wr = new DataOutputStream(conn.getOutputStream());
        wr.writeBytes(postParams);
        wr.flush();
        wr.close();

        int responseCode = conn.getResponseCode();
        BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        String inputLine;
        StringBuffer response = new StringBuffer();

        while ((inputLine = in.readLine()) != null) {
            response.append(inputLine);
        }
        in.close();
        String respuesta = response.toString();
        return response.toString();
    }

}
