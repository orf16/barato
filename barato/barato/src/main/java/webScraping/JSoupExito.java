/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package webScraping;

import org.hibernate.Session;
import org.hibernate.Transaction;

import org.jsoup.Connection;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import servicios.Funciones;

import javax.net.ssl.*;
import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.math.BigInteger;
import java.net.CookieHandler;
import java.net.CookieManager;
import java.net.URL;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;


import static javax.ws.rs.core.HttpHeaders.USER_AGENT;

/**
 * @author andres
 */
public class JSoupExito {

    ActualizarProduct it= new ActualizarProduct();
    private HttpsURLConnection conn;
    private List<String> cookies;
    private List<String> listaCodigos = new ArrayList<>();
    private final Funciones funciones = new Funciones();

    public List<String> getCookies() {
        return cookies;
    }

    public void setCookies(List<String> cookies) {
        this.cookies = cookies;
    }


    public void obtenerProductos(Integer idalmacen) {

        JSoupCertificadoSSL ssl = new JSoupCertificadoSSL();
        ssl.certificadoseguro();


        String url = "https://www.exito.com/Mercado/_/N-2akf?No=0&Nrpp=20";
        String urldom = "https://www.exito.com";
        // habilitar cookies
        CookieHandler.setDefault(new CookieManager());

        // 1. Se envia una peticion get para obtener cookies
        try {
            GetPageContent(url);
        } catch (Exception e) {
        }

        //2. Petición post n1 requerida para la Seleccionar Región
        String postParamsCiud;
        postParamsCiud = "shortName=" + ciudad(idalmacen);
        String urle = "https://www.exito.com/selectDispatchRegionAction";
        try {
            String respuestaCiud = sendPost(urle, urldom, url, postParamsCiud);
        } catch (Exception e) {
        }

        //3. Petición post n2 requerida para la Seleccionar Región
        String postParamsCiud2 = "";
        postParamsCiud2 = ciudad2(idalmacen);
        String urle2 = "https://www.exito.com/landingAction";
        try {
            String respuestaCiud2 = sendPost(urle2, urldom, url, postParamsCiud2);
        } catch (Exception e) {

        }

        //4. Petición post n3 requerida para la Seleccionar Sede
        String postParamsSede = "";
        postParamsSede = almacen(idalmacen);
        String urle3 = "https://www.exito.com/landingAction";
        try {
            String respuestaSede = sendPost(urle3, urldom, url, postParamsSede);
        } catch (Exception e) {
        }
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

        //Pollo y Pescado
        pagina = "https://www.exito.com/Mercado-Frescos-Pollo-_carne_y_pescado/_/N-2bbb?No=";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("8"));

        //Frutas
        pagina = "https://www.exito.com/Mercado-Frescos-Frutas_y_verduras-Frutas/_/N-2bb6?No=";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("6"));

        //Pulpa Frutas
        pagina = "https://www.exito.com/Mercado-Congelados_y_refrigerados-Congelados-Fruta_y_pulpa_congelada/_/N-2avh?No=";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("6"));

        //Verduras
        pagina = "https://www.exito.com/Mercado-Frescos-Frutas_y_verduras-Verduras/_/N-2bb4?No=";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("7"));

        //Papas
        pagina = "https://www.exito.com/Mercado-Frescos-Frutas_y_verduras-Papas/_/N-2bb5?No=";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("7"));

        //Verduras Congeladas
        pagina = "https://www.exito.com/Mercado-Congelados_y_refrigerados-Congelados-Papas-_yucas_y_verduras_congeladas/_/N-2av7?No=";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("7"));

        //Despensa
        pagina = "https://www.exito.com/Mercado-Alimentos_y_bebidas-Despensa/_/N-2amt?No=";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("3"));

        //Snacks
        pagina = "https://www.exito.com/Mercado-Alimentos_y_bebidas-Galleteria-_confiteria_y_pasabocas/_/N-2ar6?No=";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("1"));

        //Bebidas
        pagina = "https://www.exito.com/Mercado-Alimentos_y_bebidas-Bebidas/_/N-2apq?No=";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("2"));

        //Congelados
        pagina = "https://www.exito.com/Mercado-Congelados_y_refrigerados-Congelados/_/N-2au4?No=";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("4"));


        //Refrigerados
        pagina = "https://www.exito.com/Mercado-Congelados_y_refrigerados-Lacteos-_huevos_y_refrigerados/_/N-2at3?No=";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("5"));


        //Mundo Vinos
        pagina = "https://www.exito.com/Mercado-Mundo_vinos/_/N-2d9g?No=";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("10"));

        //Licores
        pagina = "https://www.exito.com/Mercado-Vinos_y_licores/_/N-2aky?No=";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("10"));

        //Delicatessen
        pagina = "https://www.exito.com/Mercado-Alimentos_y_bebidas-Delicatessen/_/N-2aqd?No=";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("9"));

        //Panaderia y Reposteria
        pagina = "https://www.exito.com/Mercado-Alimentos_y_bebidas-Panaderia_y_reposteria/_/N-2aqr?No=";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("11"));

        //Aseo Hogar
        pagina = "https://www.exito.com/Mercado-Aseo_del_hogar/_/N-2avk?No=";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("12"));

        //MASCOTAS

        //alimento gatos
        pagina = "https://www.exito.com/Mercado-Mascotas-Gatos-Alimentos/_/N-2am4?No=";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("14"));

        //alimento gatos humedos
        pagina = "https://www.exito.com/Mercado-Mascotas-Gatos-Alimentos_humedos/_/N-2am2?No=";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("14"));

        //alimento seco perros
        pagina = "https://www.exito.com/Mercado-Mascotas-Perros-Alimentos_secos/_/N-2ame?No=";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("14"));


        //alimento humedo perros
        pagina = "https://www.exito.com/Mercado-Mascotas-Perros-Alimentos_humedos/_/N-2amd?No=";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("14"));


        //CUIDADO PERSONAL
        //Cuidado Femenino
        pagina = "https://www.exito.com/Salud_y_Belleza-Cuidado_femenino/_/N-2bii?No=";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("13"));

        //Cuidado Masculino
        pagina = "https://www.exito.com/Salud_y_Belleza-Cuidado_masculino/_/N-2bhw?No=";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("13"));

        //Cuidado Bucal
        pagina = "https://www.exito.com/Salud_y_Belleza-Cuidado_bucal/_/N-2bh9?No=";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("13"));

        //Cuidado Capilar
        pagina = "https://www.exito.com/Salud_y_Belleza-Cuidado_capilar/_/N-2bjn?No=";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("13"));

        //Cuidado Corporal
        pagina = "https://www.exito.com/Salud_y_Belleza-Cuidado_corporal/_/N-2bg8?No=";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("13"));

        //Cuidado Facial
        pagina = "https://www.exito.com/Salud_y_Belleza-Cuidado_facial/_/N-2bks?No=";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("13"));


        //BEBES
        //Pañales Bebes
        pagina = "https://www.exito.com/Bebes-Panales_y_Panaleras/_/N-2afz?No=";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("15"));

        //Leche Tarro
        pagina = "https://www.exito.com/Bebes-Alimentacion_del_Bebe-Leche_De_Tarro_Para_Bebes/_/N-2ado?No=";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("15"));

        //Compotas
        pagina = "https://www.exito.com/Bebes-Alimentacion_del_Bebe-Compotas/_/N-2adv?No=";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("15"));


        //Cereales Bebe
        pagina = "https://www.exito.com/Bebes-Alimentacion_del_Bebe-Cereales_Para_Bebe/_/N-2adt?No=";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("15"));

        //Jugos Bebe
        pagina = "https://www.exito.com/Bebes-Alimentacion_del_Bebe-Jugos_y_Papillas_Para_Bebes/_/N-2adu?No=";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("15"));




        //Shampoo Bebe
        pagina = "https://www.exito.com/Bebes-Higiene_Del_Bebe-Shampoo_Para_Bebe/_/N-2afn?No=";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("15"));

        //Colonias Bebe
        pagina = "https://www.exito.com/Bebes-Higiene_Del_Bebe-Colonias_Para_Bebe/_/N-2afr?No=";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("15"));

        //Acondicionadores Bebe
        pagina = "https://www.exito.com/Bebes-Higiene_Del_Bebe-Acondicionadores_Para_Bebe/_/N-2afq?No=";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("15"));

        //Aceites Bebe
        pagina = "https://www.exito.com/Bebes-Higiene_Del_Bebe-Aceites_Para_Bebe/_/N-2afo?No=";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("15"));

        //Talcos Bebe
        pagina = "https://www.exito.com/Bebes-Higiene_Del_Bebe-Talcos_Para_Bebe/_/N-2afl?No=";
        totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("15"));

        Session conexionf = funciones.getConexion();
        Transaction txf = conexionf.beginTransaction();
        script = "UPDATE public.tareawebscraper set fechahorafin=now(),cantidadproductos=" + totalprodProc + " WHERE idtarea =" + idtarea;
        conexionf.createSQLQuery(script).executeUpdate();
        txf.commit();
        conexionf.close();

        ActualizarProduct intProd = new ActualizarProduct();
        try {
            intProd.copiarProduct(new BigInteger(idtarea), new Integer(1));
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
            //inserart tags de categorias
            //insertar y clasificar 
            //Constantes
            String scriptfijo = "INSERT INTO public.producto_twebscr_hist(nombre, detalle,precio,idtarea,direccion_imagen,codigotienda,idcategoria) VALUES (";
            String idtienda = "1";
            int cantporpag = 20;
            String pageadic = "&Nrpp=" + cantporpag;
            String clasprod = "span[class=\"name\"]";
            String clasdet = "span[class=\"brand\"]";
            String clasprec = "div[class=\"col-price\"]";
            String clasprec2 = "span[class=\"money\"]";
            String clasimag = "div[class=\"image\"]";
            //  String clascodprod = "div[class=\"product grocery col-xs-12 col-sm-4 col-md-4 col-lg-3\"]";
            String clascodprod = "div[data-skuid]";

            String clascantprod = "div[class=\"plp-pagination-result col-md-4\"]";

            int timeout = 120000;
            String script = "";

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
                        reintentar = true;
                        //tiempo de espera evitar ser detectado como  robot
                        Thread.sleep(4000);
                    }
                }
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
                    ;
                    String precio = prec.html().replace(",", "");

                    org.jsoup.nodes.Element img = Imagenes.get(numprod).child(0);
                    String imagen = img.attr("src");

                    org.jsoup.nodes.Element cod = Codigos.get(numprod);
                    String codigotienda = "";
                    codigotienda = cod.attr("data-skuid");

                    if (precio.trim().equals("")) {
                        precio = "-1";
                    }

                    if (listaCodigos.contains(codigotienda)==false) {
                        script = scriptfijo + "'" + nombreprod + "','" + descriprod + "'," + precio + "," + idtarea + ",'" + imagen + "'" + ",'" + codigotienda.trim() + "'," + idcategoria + ");";
                        scripts.add(script);
                        listaCodigos.add(codigotienda);
                        ++numprod;
                        ++totalprodProc;
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
            //Bogotá
            case 1:
                retorno = "BG";
                break;
            case 2:
                retorno = "BG";
                break;
            case 3:
                retorno = "BG";
                break;
            case 4:
                retorno = "BG";
                break;
            case 5:
                retorno = "BG";
                break;
            case 6:
                retorno = "BG";
                break;
            case 7:
                retorno = "BG";
                break;
            case 9:
                retorno = "BG";
                break;
            //Medellín
            case 10:
                retorno = "ML";
                break;
            case 11:
                retorno = "ML";
                break;
            case 12:
                retorno = "ML";
                break;
            case 13:
                retorno = "ML";
                break;
            //Cali
            case 14:
                retorno = "CL";
                break;
            //Barranquilla
            case 15:
                retorno = "BQ";
                break;
            //Cartagena
            case 16:
                retorno = "CG";
                break;
            default:
                retorno = "BG";
                break;
        }
        return retorno;
    }

    public String ciudad2(Integer idalmacen) {
        String retorno;
        switch (idalmacen) {
            //Bogotá
            case 1:
                retorno = "awsservice=wsdependencies&landingcity={\"idCity\":4,\"nameCity\":\"Bogota\",\"cityCode\":\"BOGOTA-CUNDINAMARCA\",\"region\":\"BG\",\"idDepartment\":\"2\",\"nameDepartment\":null,\"departmentCode\":\"CU\",\"order\":1}";
                break;
            case 2:
                retorno = "awsservice=wsdependencies&landingcity={\"idCity\":4,\"nameCity\":\"Bogota\",\"cityCode\":\"BOGOTA-CUNDINAMARCA\",\"region\":\"BG\",\"idDepartment\":\"2\",\"nameDepartment\":null,\"departmentCode\":\"CU\",\"order\":1}";
                break;
            case 3:
                retorno = "awsservice=wsdependencies&landingcity={\"idCity\":4,\"nameCity\":\"Bogota\",\"cityCode\":\"BOGOTA-CUNDINAMARCA\",\"region\":\"BG\",\"idDepartment\":\"2\",\"nameDepartment\":null,\"departmentCode\":\"CU\",\"order\":1}";
                break;
            case 4:
                retorno = "awsservice=wsdependencies&landingcity={\"idCity\":4,\"nameCity\":\"Bogota\",\"cityCode\":\"BOGOTA-CUNDINAMARCA\",\"region\":\"BG\",\"idDepartment\":\"2\",\"nameDepartment\":null,\"departmentCode\":\"CU\",\"order\":1}";
                break;
            case 5:
                retorno = "awsservice=wsdependencies&landingcity={\"idCity\":4,\"nameCity\":\"Bogota\",\"cityCode\":\"BOGOTA-CUNDINAMARCA\",\"region\":\"BG\",\"idDepartment\":\"2\",\"nameDepartment\":null,\"departmentCode\":\"CU\",\"order\":1}";
                break;
            case 6:
                retorno = "awsservice=wsdependencies&landingcity={\"idCity\":4,\"nameCity\":\"Bogota\",\"cityCode\":\"BOGOTA-CUNDINAMARCA\",\"region\":\"BG\",\"idDepartment\":\"2\",\"nameDepartment\":null,\"departmentCode\":\"CU\",\"order\":1}";
                break;
            case 7:
                retorno = "awsservice=wsdependencies&landingcity={\"idCity\":4,\"nameCity\":\"Bogota\",\"cityCode\":\"BOGOTA-CUNDINAMARCA\",\"region\":\"BG\",\"idDepartment\":\"2\",\"nameDepartment\":null,\"departmentCode\":\"CU\",\"order\":1}";
                break;
            //Chia
            case 9:
                retorno = "awsservice=wsdependencies&landingcity={\"idCity\":104,\"nameCity\":\"Chia\",\"cityCode\":\"CHIA-CUNDINAMARCA\",\"region\":\"BG\",\"idDepartment\":\"2\",\"nameDepartment\":null,\"departmentCode\":\"CU\",\"order\":2}";
                break;
            //Medellin
            case 10:
                retorno = "awsservice=wsdependencies&landingcity={\"idCity\":1,\"nameCity\":\"Medellín\",\"cityCode\":\"MEDELLIN-ANTIOQUIA\",\"region\":\"ML\",\"idDepartment\":\"1\",\"nameDepartment\":null,\"departmentCode\":\"AN\",\"order\":3}";
                break;
            case 11:
                retorno = "awsservice=wsdependencies&landingcity={\"idCity\":1,\"nameCity\":\"Medellín\",\"cityCode\":\"MEDELLIN-ANTIOQUIA\",\"region\":\"ML\",\"idDepartment\":\"1\",\"nameDepartment\":null,\"departmentCode\":\"AN\",\"order\":3}";
                break;
            case 12:
                retorno = "awsservice=wsdependencies&landingcity={\"idCity\":1,\"nameCity\":\"Medellín\",\"cityCode\":\"MEDELLIN-ANTIOQUIA\",\"region\":\"ML\",\"idDepartment\":\"1\",\"nameDepartment\":null,\"departmentCode\":\"AN\",\"order\":3}";
                break;
            case 13:
                retorno = "awsservice=wsdependencies&landingcity={\"idCity\":1,\"nameCity\":\"Medellín\",\"cityCode\":\"MEDELLIN-ANTIOQUIA\",\"region\":\"ML\",\"idDepartment\":\"1\",\"nameDepartment\":null,\"departmentCode\":\"AN\",\"order\":3}";
                break;
            //Cali
            case 14:
                retorno = "awsservice=wsdependencies&landingcity={\"idCity\":3,\"nameCity\":\"Cali\",\"cityCode\":\"CALI-VALLE\",\"region\":\"CL\",\"idDepartment\":\"3\",\"nameDepartment\":null,\"departmentCode\":\"VC\",\"order\":8}";
                break;
            //Barranquilla
            case 15:
                retorno = "awsservice=wsdependencies&landingcity={\"idCity\":7,\"nameCity\":\"Barranquilla\",\"cityCode\":\"BARRANQUILLA-ATLANTICO\",\"region\":\"BQ\",\"idDepartment\":\"10\",\"nameDepartment\":null,\"departmentCode\":\"AT\",\"order\":10}";
                break;
            //Cartagena
            case 16:
                retorno = "awsservice=wsdependencies&landingcity={\"idCity\":10,\"nameCity\":\"Cartagena\",\"cityCode\":\"CARTAGENA-BOLIVAR\",\"region\":\"CG\",\"idDepartment\":\"11\",\"nameDepartment\":null,\"departmentCode\":\"BL\",\"order\":11}";
                break;
            default:
                retorno = "awsservice=wsdependencies&landingcity={\"idCity\":4,\"nameCity\":\"Bogota\",\"cityCode\":\"BOGOTA-CUNDINAMARCA\",\"region\":\"BG\",\"idDepartment\":\"2\",\"nameDepartment\":null,\"departmentCode\":\"CU\",\"order\":1}";
                break;
        }
        return retorno;
    }

    public String almacen(Integer idalmacen) {
        String retorno;
        switch (idalmacen) {
            case 1:
                // Éxito Americas
                retorno = "awsservice=wssummary&landingdependency=%7B%22idDependency%22%3A106%2C%22quantityUnitsExpress%22%3A0%2C%22dispatchOrder%22%3Atrue%2C%22deliveryPoint%22%3Atrue%2C%22express%22%3Afalse%2C%22dependencyCode%22%3A%22084%22%2C%22nameDependence%22%3A%22Exito+Americas%22%2C%22address%22%3A%22AC+6+%23+68+-+94%22%2C%22idChannel%22%3A%2211%22%2C%22nameChannel%22%3A%22Exito.com%22%7D&landingcity=%7B%22idCity%22%3A4%2C%22nameCity%22%3A%22Bogota%22%2C%22cityCode%22%3A%22BOGOTA-CUNDINAMARCA%22%2C%22region%22%3A%22BG%22%2C%22idDepartment%22%3A%222%22%2C%22nameDepartment%22%3Anull%2C%22departmentCode%22%3A%22CU%22%2C%22order%22%3A1%7D&typeservice=PE";
                break;
            case 2:
                // Éxito Chapinero Bogotá. 
                retorno = "awsservice=wssummary&landingdependency=%7B%22idDependency%22%3A114%2C%22quantityUnitsExpress%22%3A13%2C%22dispatchOrder%22%3Atrue%2C%22deliveryPoint%22%3Atrue%2C%22express%22%3Atrue%2C%22dependencyCode%22%3A%22094%22%2C%22nameDependence%22%3A%22Exito+Chapinero%22%2C%22address%22%3A%22Calle+52+%23+13-70%22%2C%22idChannel%22%3A%2211%22%2C%22nameChannel%22%3A%22Exito.com%22%7D&landingcity=%7B%22idCity%22%3A4%2C%22nameCity%22%3A%22Bogota%22%2C%22cityCode%22%3A%22BOGOTA-CUNDINAMARCA%22%2C%22region%22%3A%22BG%22%2C%22idDepartment%22%3A%222%22%2C%22nameDepartment%22%3Anull%2C%22departmentCode%22%3A%22CU%22%2C%22order%22%3A1%7D&typeservice=PE";
                break;
            case 3:
                // Éxito Colina
                retorno = "awsservice=wssummary&landingdependency=%7B%22idDependency%22%3A108%2C%22quantityUnitsExpress%22%3A0%2C%22dispatchOrder%22%3Atrue%2C%22deliveryPoint%22%3Atrue%2C%22express%22%3Afalse%2C%22dependencyCode%22%3A%22088%22%2C%22nameDependence%22%3A%22Exito+Colina%22%2C%22address%22%3A%22Avenida++Boyaca+++%23+146+B-+25%22%2C%22idChannel%22%3A%2211%22%2C%22nameChannel%22%3A%22Exito.com%22%7D&landingcity=%7B%22idCity%22%3A4%2C%22nameCity%22%3A%22Bogota%22%2C%22cityCode%22%3A%22BOGOTA-CUNDINAMARCA%22%2C%22region%22%3A%22BG%22%2C%22idDepartment%22%3A%222%22%2C%22nameDepartment%22%3Anull%2C%22departmentCode%22%3A%22CU%22%2C%22order%22%3A1%7D&typeservice=PE";
                break;
            case 4:
                // Éxito Country
                retorno = "awsservice=wssummary&landingdependency=%7B%22idDependency%22%3A103%2C%22quantityUnitsExpress%22%3A0%2C%22dispatchOrder%22%3Atrue%2C%22deliveryPoint%22%3Atrue%2C%22express%22%3Afalse%2C%22dependencyCode%22%3A%22081%22%2C%22nameDependence%22%3A%22Exito+Country%22%2C%22address%22%3A%22Calle+134+%23+9+-+51%22%2C%22idChannel%22%3A%2211%22%2C%22nameChannel%22%3A%22Exito.com%22%7D&landingcity=%7B%22idCity%22%3A4%2C%22nameCity%22%3A%22Bogota%22%2C%22cityCode%22%3A%22BOGOTA-CUNDINAMARCA%22%2C%22region%22%3A%22BG%22%2C%22idDepartment%22%3A%222%22%2C%22nameDepartment%22%3Anull%2C%22departmentCode%22%3A%22CU%22%2C%22order%22%3A1%7D&typeservice=PE";
                break;
            case 5:
                // Éxito Gran Estación
                retorno = "awsservice=wssummary&landingdependency=%7B%22idDependency%22%3A176%2C%22quantityUnitsExpress%22%3A0%2C%22dispatchOrder%22%3Atrue%2C%22deliveryPoint%22%3Atrue%2C%22express%22%3Afalse%2C%22dependencyCode%22%3A%22356%22%2C%22nameDependence%22%3A%22Exito+Gran+Estaci%C3%B3n%22%2C%22address%22%3A%22Carrera+66+24+a+20%22%2C%22idChannel%22%3A%2211%22%2C%22nameChannel%22%3A%22Exito.com%22%7D&landingcity=%7B%22idCity%22%3A4%2C%22nameCity%22%3A%22Bogota%22%2C%22cityCode%22%3A%22BOGOTA-CUNDINAMARCA%22%2C%22region%22%3A%22BG%22%2C%22idDepartment%22%3A%222%22%2C%22nameDepartment%22%3Anull%2C%22departmentCode%22%3A%22CU%22%2C%22order%22%3A1%7D&typeservice=PE";
                break;
            case 6:
                // Éxito Norte
                retorno = "awsservice=wssummary&landingdependency=%7B%22idDependency%22%3A112%2C%22quantityUnitsExpress%22%3A0%2C%22dispatchOrder%22%3Atrue%2C%22deliveryPoint%22%3Atrue%2C%22express%22%3Afalse%2C%22dependencyCode%22%3A%22092%22%2C%22nameDependence%22%3A%22Exito+Norte%22%2C%22address%22%3A%22Calle+175++%23+22-13%22%2C%22idChannel%22%3A%2211%22%2C%22nameChannel%22%3A%22Exito.com%22%7D&landingcity=%7B%22idCity%22%3A4%2C%22nameCity%22%3A%22Bogota%22%2C%22cityCode%22%3A%22BOGOTA-CUNDINAMARCA%22%2C%22region%22%3A%22BG%22%2C%22idDepartment%22%3A%222%22%2C%22nameDepartment%22%3Anull%2C%22departmentCode%22%3A%22CU%22%2C%22order%22%3A1%7D&typeservice=PE";
                break;
            case 7:
                // Éxito Unicentro Bogotá
                retorno = "awsservice=wssummary&landingdependency=%7B%22idDependency%22%3A153%2C%22quantityUnitsExpress%22%3A0%2C%22dispatchOrder%22%3Atrue%2C%22deliveryPoint%22%3Atrue%2C%22express%22%3Afalse%2C%22dependencyCode%22%3A%22303%22%2C%22nameDependence%22%3A%22Exito+Unicentro+Bogota%22%2C%22address%22%3A%22Cl+127+%23+14A-1%22%2C%22idChannel%22%3A%2211%22%2C%22nameChannel%22%3A%22Exito.com%22%7D&landingcity=%7B%22idCity%22%3A4%2C%22nameCity%22%3A%22Bogota%22%2C%22cityCode%22%3A%22BOGOTA-CUNDINAMARCA%22%2C%22region%22%3A%22BG%22%2C%22idDepartment%22%3A%222%22%2C%22nameDepartment%22%3Anull%2C%22departmentCode%22%3A%22CU%22%2C%22order%22%3A1%7D&typeservice=PE";
                break;
            case 8:
                // Éxito Villa Mayor
                retorno = "awsservice=wssummary&landingdependency=%7B%22idDependency%22%3A105%2C%22quantityUnitsExpress%22%3A0%2C%22dispatchOrder%22%3Atrue%2C%22deliveryPoint%22%3Atrue%2C%22express%22%3Afalse%2C%22dependencyCode%22%3A%22083%22%2C%22nameDependence%22%3A%22Exito+Villa+Mayor%22%2C%22address%22%3A%22Autopista+Sur+%23+38+A+Sur+07%22%2C%22idChannel%22%3A%2211%22%2C%22nameChannel%22%3A%22Exito.com%22%7D&landingcity=%7B%22idCity%22%3A4%2C%22nameCity%22%3A%22Bogota%22%2C%22cityCode%22%3A%22BOGOTA-CUNDINAMARCA%22%2C%22region%22%3A%22BG%22%2C%22idDepartment%22%3A%222%22%2C%22nameDepartment%22%3Anull%2C%22departmentCode%22%3A%22CU%22%2C%22order%22%3A1%7D&typeservice=PE";
                break;
            case 9:
                // Éxito Chia Fontanar
                retorno = "awsservice=wssummary&landingdependency=%7B%22idDependency%22%3A438%2C%22quantityUnitsExpress%22%3A0%2C%22dispatchOrder%22%3Atrue%2C%22deliveryPoint%22%3Atrue%2C%22express%22%3Afalse%2C%22dependencyCode%22%3A%22483%22%2C%22nameDependence%22%3A%22Exito+Chia+Fontanar%22%2C%22address%22%3A%22Km+2.5+v%C3%ADa+Chia+cajica+Centro+Comercial+Fontanar+costado+oriental%22%2C%22idChannel%22%3A%2211%22%2C%22nameChannel%22%3A%22Exito.com%22%7D&landingcity=%7B%22idCity%22%3A104%2C%22nameCity%22%3A%22Chia%22%2C%22cityCode%22%3A%22CHIA-CUNDINAMARCA%22%2C%22region%22%3A%22BG%22%2C%22idDepartment%22%3A%222%22%2C%22nameDepartment%22%3Anull%2C%22departmentCode%22%3A%22CU%22%2C%22order%22%3A2%7D&typeservice=PE";
                break;
            case 10:
                // Éxito Bello
                retorno = "awsservice=wssummary&landingdependency=%7B%22idDependency%22%3A73%2C%22quantityUnitsExpress%22%3A0%2C%22dispatchOrder%22%3Atrue%2C%22deliveryPoint%22%3Atrue%2C%22express%22%3Afalse%2C%22dependencyCode%22%3A%22030%22%2C%22nameDependence%22%3A%22Exito+Bello%22%2C%22address%22%3A%22Diagona+51l+%23+35+-+120%22%2C%22idChannel%22%3A%2211%22%2C%22nameChannel%22%3A%22Exito.com%22%7D&landingcity=%7B%22idCity%22%3A1%2C%22nameCity%22%3A%22Medell%C3%ADn%22%2C%22cityCode%22%3A%22MEDELLIN-ANTIOQUIA%22%2C%22region%22%3A%22ML%22%2C%22idDepartment%22%3A%221%22%2C%22nameDepartment%22%3Anull%2C%22departmentCode%22%3A%22AN%22%2C%22order%22%3A3%7D&typeservice=PE";
                break;
            case 11:
                // Éxito Envigado
                retorno = "awsservice=wssummary&landingdependency=%7B%22idDependency%22%3A77%2C%22quantityUnitsExpress%22%3A0%2C%22dispatchOrder%22%3Atrue%2C%22deliveryPoint%22%3Atrue%2C%22express%22%3Afalse%2C%22dependencyCode%22%3A%22035%22%2C%22nameDependence%22%3A%22Exito+Envigado%22%2C%22address%22%3A%22Carrera+48+%23+34+Sur-29%22%2C%22idChannel%22%3A%2211%22%2C%22nameChannel%22%3A%22Exito.com%22%7D&landingcity=%7B%22idCity%22%3A1%2C%22nameCity%22%3A%22Medell%C3%ADn%22%2C%22cityCode%22%3A%22MEDELLIN-ANTIOQUIA%22%2C%22region%22%3A%22ML%22%2C%22idDepartment%22%3A%221%22%2C%22nameDepartment%22%3Anull%2C%22departmentCode%22%3A%22AN%22%2C%22order%22%3A3%7D&typeservice=PE";
                break;
            case 12:
                // Éxito Poblado
                retorno = "awsservice=wssummary&landingdependency=%7B%22idDependency%22%3A75%2C%22quantityUnitsExpress%22%3A0%2C%22dispatchOrder%22%3Atrue%2C%22deliveryPoint%22%3Atrue%2C%22express%22%3Afalse%2C%22dependencyCode%22%3A%22033%22%2C%22nameDependence%22%3A%22Exito+Poblado%22%2C%22address%22%3A%22Calle+10+%23+43+E+135%22%2C%22idChannel%22%3A%2211%22%2C%22nameChannel%22%3A%22Exito.com%22%7D&landingcity=%7B%22idCity%22%3A1%2C%22nameCity%22%3A%22Medell%C3%ADn%22%2C%22cityCode%22%3A%22MEDELLIN-ANTIOQUIA%22%2C%22region%22%3A%22ML%22%2C%22idDepartment%22%3A%221%22%2C%22nameDepartment%22%3Anull%2C%22departmentCode%22%3A%22AN%22%2C%22order%22%3A3%7D&typeservice=PE";
                break;
            case 13:
                // Punto Entrega Oviedo
                retorno = "awsservice=wssummary&landingdependency=%7B%22idDependency%22%3A305%2C%22quantityUnitsExpress%22%3A13%2C%22dispatchOrder%22%3Atrue%2C%22deliveryPoint%22%3Atrue%2C%22express%22%3Atrue%2C%22dependencyCode%22%3A%22880%22%2C%22nameDependence%22%3A%22Punto+Entrega+Oviedo%22%2C%22address%22%3A%22Carrera+43+B+%23+7S+85%22%2C%22idChannel%22%3A%2211%22%2C%22nameChannel%22%3A%22Exito.com%22%7D&landingcity=%7B%22idCity%22%3A1%2C%22nameCity%22%3A%22Medell%C3%ADn%22%2C%22cityCode%22%3A%22MEDELLIN-ANTIOQUIA%22%2C%22region%22%3A%22ML%22%2C%22idDepartment%22%3A%221%22%2C%22nameDepartment%22%3Anull%2C%22departmentCode%22%3A%22AN%22%2C%22order%22%3A3%7D&typeservice=PE";
                break;
            case 14:
                // Éxito La Flora
                retorno = "awsservice=wssummary&landingdependency=%7B%22idDependency%22%3A92%2C%22quantityUnitsExpress%22%3A0%2C%22dispatchOrder%22%3Atrue%2C%22deliveryPoint%22%3Atrue%2C%22express%22%3Afalse%2C%22dependencyCode%22%3A%22054%22%2C%22nameDependence%22%3A%22Exito+La+Flora%22%2C%22address%22%3A%22Av+3+F+Norte+52+-46%22%2C%22idChannel%22%3A%2211%22%2C%22nameChannel%22%3A%22Exito.com%22%7D&landingcity=%7B%22idCity%22%3A3%2C%22nameCity%22%3A%22Cali%22%2C%22cityCode%22%3A%22CALI-VALLE%22%2C%22region%22%3A%22CL%22%2C%22idDepartment%22%3A%223%22%2C%22nameDepartment%22%3Anull%2C%22departmentCode%22%3A%22VC%22%2C%22order%22%3A8%7D&typeservice=PE";
                break;
            case 15:
                // Éxito Barranquilla
                retorno = "awsservice=wssummary&landingdependency=%7B%22idDependency%22%3A82%2C%22quantityUnitsExpress%22%3A0%2C%22dispatchOrder%22%3Atrue%2C%22deliveryPoint%22%3Atrue%2C%22express%22%3Afalse%2C%22dependencyCode%22%3A%22041%22%2C%22nameDependence%22%3A%22Exito+Barranquilla%22%2C%22address%22%3A%22Carrera+51+B+87+-+50+%22%2C%22idChannel%22%3A%2211%22%2C%22nameChannel%22%3A%22Exito.com%22%7D&landingcity=%7B%22idCity%22%3A7%2C%22nameCity%22%3A%22Barranquilla%22%2C%22cityCode%22%3A%22BARRANQUILLA-ATLANTICO%22%2C%22region%22%3A%22BQ%22%2C%22idDepartment%22%3A%2210%22%2C%22nameDepartment%22%3Anull%2C%22departmentCode%22%3A%22AT%22%2C%22order%22%3A10%7D&typeservice=PE";
                break;
            case 16:
                // Éxito San Diego 
                retorno = "awsservice=wssummary&landingdependency=%7B%22idDependency%22%3A184%2C%22quantityUnitsExpress%22%3A0%2C%22dispatchOrder%22%3Atrue%2C%22deliveryPoint%22%3Atrue%2C%22express%22%3Afalse%2C%22dependencyCode%22%3A%22367%22%2C%22nameDependence%22%3A%22Exito+San+Diego%22%2C%22address%22%3A%22Calle+38+%23+10+-+85%22%2C%22idChannel%22%3A%2211%22%2C%22nameChannel%22%3A%22Exito.com%22%7D&landingcity=%7B%22idCity%22%3A10%2C%22nameCity%22%3A%22Cartagena%22%2C%22cityCode%22%3A%22CARTAGENA-BOLIVAR%22%2C%22region%22%3A%22CG%22%2C%22idDepartment%22%3A%2211%22%2C%22nameDepartment%22%3Anull%2C%22departmentCode%22%3A%22BL%22%2C%22order%22%3A11%7D&typeservice=PE";
                break;
            default:
                retorno = "awsservice=wssummary&landingdependency=%7B%22idDependency%22%3A114%2C%22quantityUnitsExpress%22%3A13%2C%22dispatchOrder%22%3Atrue%2C%22deliveryPoint%22%3Atrue%2C%22express%22%3Atrue%2C%22dependencyCode%22%3A%22094%22%2C%22nameDependence%22%3A%22Exito+Chapinero%22%2C%22address%22%3A%22Calle+52+%23+13-70%22%2C%22idChannel%22%3A%2211%22%2C%22nameChannel%22%3A%22Exito.com%22%7D&landingcity=%7B%22idCity%22%3A4%2C%22nameCity%22%3A%22Bogota%22%2C%22cityCode%22%3A%22BOGOTA-CUNDINAMARCA%22%2C%22region%22%3A%22BG%22%2C%22idDepartment%22%3A%222%22%2C%22nameDepartment%22%3Anull%2C%22departmentCode%22%3A%22CU%22%2C%22order%22%3A1%7D&typeservice=PE";
                break;
        }
        return retorno;
    }

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
        // Almacenamos la respuesta de las cookies
        setCookies(conn.getHeaderFields().get("Set-Cookie"));
        return response.toString();
    }

    private String sendPost(String url, String Host, String urlreferer, String postParams) throws Exception {

        URL obj = new URL(url);
        conn = (HttpsURLConnection) obj.openConnection();
        conn.setUseCaches(false);
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Host", Host);
        conn.setRequestProperty("User-Agent", USER_AGENT);
        conn.setRequestProperty("Accept",
                "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8");
        conn.setRequestProperty("Accept-Language", "en-US,en;q=0.5");
        // Se añaden las cookies obtenidas en la cabecera.
        for (String cookie : this.cookies) {
            conn.addRequestProperty("Cookie", cookie.split(";", 1)[0]);
        }
        conn.setRequestProperty("Connection", "keep-alive");
        conn.setRequestProperty("Referer", urlreferer);
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
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
