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

            //Alimento Bebé
            pagina = "https://www.carulla.com/Mercado-Mundo_del_bebe-Hora_de_Comer/_/N-2gj7?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("15"));

            //Cuidado Bebé Pañales
            pagina = "https://www.carulla.com/Mercado-Mundo_del_bebe-Hora_del_Panal/_/N-2dhs?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("15"));

            //Vinos y Licores
            pagina = "https://www.carulla.com/Vinos_y_licores/_/N-2c5u?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("10"));

            //Delicatesen
            pagina = "https://www.carulla.com/Delicatessen/_/N-2bm3?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("9"));

            //Frutas
            pagina = "https://www.carulla.com/Frutas_y_verduras-Frutas/_/N-2bmk?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("6"));

            //Verduras
            pagina = "https://www.carulla.com/Frutas_y_verduras-Verduras/_/N-2bmi?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("7"));

            // Hierbas
            pagina = "https://www.carulla.com/Frutas_y_verduras-Hierbas_y_especias_naturales/_/N-2bml?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("7"));


            //Pollo Carne y Pescado
            pagina = "https://www.carulla.com/Pollo-_carne_y_pescado/_/N-2bzs?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("8"));


            //DESPENSA
            //Cafe y chocolate
            pagina = "https://www.carulla.com/Mercado-Alimentos-Despensa-Cafe_y_chocolate/_/N-2buk?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("3"));

            //Cereales y Granolas
            pagina = "https://www.carulla.com/Mercado-Alimentos-Despensa-Cereales_y_granolas/_/N-2btt?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("3"));

            //Aceite y Vinagre
            pagina = "https://www.carulla.com/Mercado-Alimentos-Despensa-Aceite_y_vinagre/_/N-2bua?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("3"));

            //Huevos
            pagina = "https://www.carulla.com/Mercado-Congelados_y_refrigerados-Lacteos-_huevos_y_refrigerados-Huevos/_/N-2bqb?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("3"));

            //Granos y Arroz
            pagina = "https://www.carulla.com/Mercado-Alimentos-Despensa-Granos-_arroz_y_sal/_/N-2bus?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("3"));

            //Enlatados y Conservas
            pagina = "https://www.carulla.com/Mercado-Alimentos-Despensa-Enlatados_y_conservas/_/N-2bu1?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("3"));

            //Pastas Salsas y Cremas
            pagina = "https://www.carulla.com/Mercado-Alimentos-Despensa-Pastas/_/N-2bvp?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("3"));

            //Azúcar Panela y Endulzante
            pagina = "https://www.carulla.com/Mercado-Alimentos-Despensa-Azucar-_panela_y_endulzante/_/N-2bun?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("3"));

            //Para Untar
            pagina = "https://www.carulla.com/Mercado-Alimentos-Despensa-Para_untar/_/N-2bta?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("3"));

            //Harinas Avena y Soya
            pagina = "https://www.carulla.com/Mercado-Alimentos-Despensa-Soya_y_avena/_/N-2bv3?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("3"));

            //Sal Condimentos y Especias
            pagina = "https://www.carulla.com/Mercado-Alimentos-Despensa-Granos-_arroz_y_sal-Sal/_/N-2buu?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("3"));


            //SNACKS
            //Pasabocas
            pagina = "https://www.carulla.com/Mercado-Alimentos-Despensa-Granos-_arroz_y_sal-Sal/_/N-2buu?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("1"));

            //Tortas y Postres
            pagina = "https://www.carulla.com/Panaderia_y_reposteria-Postres_y_tortas/_/N-2bzq?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("1"));

            //Galleteria y Chocolates
            pagina = "https://www.carulla.com/Mercado-Alimentos-Galleteria-_confiteria_y_pasabocas-Chocolates/_/N-2bwq?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("1"));

            //Confiteria y Dulces
            pagina = "https://www.carulla.com/Mercado-Alimentos-Galleteria-_confiteria_y_pasabocas-Confiteria_y_dulces/_/N-2bwy?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("1"));


            //Lacteos y Refrigerados
            pagina = "https://www.carulla.com/Mercado-Congelados_y_refrigerados-Lacteos-_huevos_y_refrigerados/_/N-2bpt?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("5"));

            //Congelados
            pagina = "https://www.carulla.com/Mercado-Congelados_y_refrigerados-Congelados/_/N-2bqu?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("4"));

            //Panaderia
            pagina = "https://www.carulla.com/Panaderia_y_reposteria/_/N-2bzd?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("11"));

            //Bebidas
            pagina = "https://www.carulla.com/Mercado-Alimentos-Bebidas/_/N-2bsm?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("2"));

            //Aseo Hogar
            pagina = "https://www.carulla.com/Mercado-Aseo_del_hogar/_/N-2bmq?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("12"));

            //MASCOTAS

            //alimento gatos
            pagina = "https://www.carulla.com/Mercado-Mascotas-Gatos-Alimentos/_/N-2bxs?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("14"));

            //alimento gatos humedos
            pagina = "https://www.carulla.com/Mercado-Mascotas-Gatos-Alimentos_humedos/_/N-2bxp?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("14"));

            //alimento seco perros
            pagina = "https://www.carulla.com/Mercado-Mascotas-Perros-Alimentos/_/N-2by0?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("14"));


            //alimento humedo perros
            pagina = "https://www.carulla.com/Mercado-Mascotas-Perros-Alimentos_humedos/_/N-2bxz?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("14"));


            //CUIDADO PERSONAL
            //Cuidado Femenino
            pagina = "https://www.carulla.com/Salud_y_belleza-Cuidado_femenino/_/N-2c2n?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("13"));

            //Cuidado Masculino
            pagina = "https://www.carulla.com/Salud_y_belleza-Cuidado_masculino/_/N-2c4t?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("13"));

            //Cuidado Bucal
            pagina = "https://www.carulla.com/Salud_y_belleza-Cuidado_bucal/_/N-2c5f?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("13"));

            //Cuidado Capilar
            pagina = "https://www.carulla.com/Salud_y_belleza-Cuidado_capilar/_/N-2c16?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("13"));

            //Cuidado Corporal
            pagina = "https://www.carulla.com/Salud_y_belleza-Cuidado_corporal/_/N-2c44?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("13"));

            //Cuidado Facial
            pagina = "https://www.carulla.com/Salud_y_belleza-Cuidado_facial/_/N-2c2b?No=";
            totalprodProc = totalprodProc + obtenerproductcat(idalmacen, pagina, new BigInteger(idtarea), new Integer("13"));

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
            String clasprod = "h1[class=\"name plpName\"]";
            String clasdet = "h2[class=\"brand plpBrand\"]";
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
