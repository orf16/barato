/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package webScraping;

import java.net.SocketTimeoutException;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.jsoup.Jsoup;

/**
 *
 * @author marti
 */
public class JSoupMakro {
    
    private static String pagStop = "";
    
    public static String traerPaginasYproductosAlkosto(String url){
        try{
        pagStop = url;
        String pagSiguiente = "";
        org.jsoup.nodes.Document doc = Jsoup.connect(url).get();

        //trae el paginador de la pag
        org.jsoup.select.Elements paginas = doc.select("div[class=\"pages\"]");
        //trae los productos de la pga actual
        org.jsoup.select.Elements Productos = doc.select("div[class=\"category-products\"]");
        
            //for encargado de recorrer el paginador y sacar la pag siguiente
            bucle1:
            for (org.jsoup.nodes.Element pagina: paginas) {

            org.jsoup.select.Elements items = pagina.select("ol");
            System.out.println("items"+items.get(0).text());
            System.out.println(" |>> pagina actual:"+url);
            for (org.jsoup.nodes.Element item: items) {
                org.jsoup.select.Elements valores = item.select("a[class=\"next i-next\"]");
                org.jsoup.select.Elements valores2 = item.select("a[class=\"next i-next\"]").remove();
                for (org.jsoup.nodes.Element valor: valores) {
                    
                    System.out.println(" |>> pagina siguiente:"+valor.attr("href"));
                    pagSiguiente = valor.attr("href");
                }
                break bucle1;
            }
            
        }
            
        //Se engarga de buscar los productos  
//            System.out.println("Productos"+Productos);
        for (org.jsoup.nodes.Element producto: Productos) {
//            System.out.println("producto"+producto);
//            System.out.println("producto"+producto);
            org.jsoup.select.Elements items = producto.select("div[class=\"producto\"]");
//             System.out.println("items"+items);
            for (org.jsoup.nodes.Element item: items) {
//                System.out.println("item"+item);
                org.jsoup.select.Elements detalle = item.select("div[class=\"detalle_producto\"]");
                org.jsoup.select.Elements valorRegular = item.select("span[class=\"regular-price\"]");
                
                org.jsoup.select.Elements valor = valorRegular.select("span[class=\"price-number\"]");
                org.jsoup.select.Elements nombre = detalle.select("a");
                System.out.println("--> nombre:"+nombre.get(0).text()+" |--> valor:"+valor.get(0).text());
            }
        }
        return pagSiguiente;
        }catch (SocketTimeoutException e){
            System.err.println("Pag stop por time out (reanuda en 10s):"+pagStop);
            JSoupMakro.reanudarFalla();
            return "";
        }catch(Exception e){
            e.printStackTrace();
            return "";
        }
    }

    public static void buscadorDeProductoxPagina(String url){
        String pagSiguiente = JSoupMakro.traerPaginasYproductosAlkosto(url);
        if(!pagSiguiente.equals("")){
            JSoupMakro.buscadorDeProductoxPagina(pagSiguiente);
        }
    }
    
    public static void reanudarFalla(){
        try {
            int segundos = 10;
            Thread.sleep (segundos*1000);
            buscadorDeProductoxPagina(pagStop);
        } catch (InterruptedException ex) {
            ex.printStackTrace();
        }
    }
    
    public static void main(String[] args){
        JSoupMakro.buscadorDeProductoxPagina("http://www.makrovirtual.com/cumara/categorizacion-de-productos/ofertas.html/");
    }
}
