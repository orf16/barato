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
import modelos.Diccionario;
import modelos.ProductoTwebscrHist;
import org.hibernate.Query;

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
        BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
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



 
        //Vinos y Licores
        pagina = "%2f1000060%2f";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer(10));


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
            String scriptfijo = "INSERT INTO public.producto_twebscr_hist(nombre,detalle,descripcion,precio,idtarea,direccion_imagen,codigotienda,idcategoria, url) VALUES (";
            String scriptfijo3 = "INSERT INTO public.diccionario(palabra) VALUES (";
            String scriptfijo1 = "UPDATE public.producto_twebscr_hist SET precio=";
            String scriptfijo2 = " WHERE idproducto=";
            String scriptfijo4 = " , direccion_imagen=";
            String scriptfijo5 = " , url=";
            
            String idtienda = "2";
            String page = "https://www.tiendasjumbo.co/api/catalog_system/pub/products/search/?&fq=C%3a%2f2000001";
            String clasprod = "productName";
            String clasdet = "brand";
            String clasdesc = "description";
            String clasprec = "Value";
            String clasimag = "imageUrl";
            String clascodig = "productId";
            String claslink = "link";

            String script = "";
            String script1 = "";
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
                    String url = jsonObj.getString(claslink);
                    String precio = "0";
                    String imagen = "";
                    String[] arrOfStr = nombreprod.split(" ", 20);
                    
                        
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
                    
                    Session conexion = funciones.getConexion();
                    try {
                        Query query = conexion.createQuery("from ProductoTwebscrHist where codigotienda= :nombre").setMaxResults(1);
                        //Query query = conexion.createQuery("from ProductoTwebscrHist where nombre= :nombre and detalle= :detalle and direccion_imagen= :direccion_imagen and codigotienda= :codigotienda");
                        query.setParameter("nombre", codigotienda.trim());

                        List<ProductoTwebscrHist> productoList = query.list();
                        conexion.close();
                        if (productoList.isEmpty()) {
                            if (listaCodigos.contains(codigotienda) == false) {
                                script = scriptfijo + "'" + nombreprod + "','" + detalleprod + "','" + descriprod + "'," + precio + "," + idtarea + ",'" + imagen + "'" + ",'" + codigotienda.trim() + "'," + idcategoria + ",'" + url.trim() + "'" + ");" + System.getProperty("line.separator");
                                scripts.add(script);
                                listaCodigos.add(codigotienda);
                                ++totalprodProc;
                            }
                        } else {
                            //url="'"+url+"'";
                            //imagen="'"+imagen+"'";
                                int id=productoList.get(0).getIdproducto();
                                script = scriptfijo1+precio+scriptfijo4+"'"+imagen+"'"+scriptfijo5+"'"+url.trim()+"'"+scriptfijo2+Integer.toString(id);
                                scripts.add(script);
                                listaCodigos.add(codigotienda);
                                ++totalprodProc;
                        }
                    } catch (Exception e) {
                        conexion.close();
                    }

                    
                    //construir diccionario
                    for (String a : arrOfStr){
                        Session conexion1 = funciones.getConexion();
                        try {
                            Query query = conexion1.createQuery("from Diccionario where palabra= :palabra").setMaxResults(1);
                            //Query query = conexion.createQuery("from ProductoTwebscrHist where nombre= :nombre and detalle= :detalle and direccion_imagen= :direccion_imagen and codigotienda= :codigotienda");
                            query.setParameter("palabra", a);

                            List<Diccionario> DiccionarioList = query.list();
                            conexion1.close();
                            if (DiccionarioList.isEmpty()) {
                                script1 = scriptfijo3 + "'" + a + "');" + System.getProperty("line.separator");
                                scripts.add(script1);
                            } 
                        } catch (Exception e) {
                            conexion1.close();
                        }  
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
