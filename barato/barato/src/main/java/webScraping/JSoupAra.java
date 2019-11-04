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
public class JSoupAra {
    
    private static String pagStop = "";
    
    public static void traerPaginasYproductosAlkosto(String url){
        try{
        pagStop = url;
        String pagSiguiente = "";
        org.jsoup.nodes.Document doc = Jsoup.connect(url).get();
//            System.out.println("doc:"+doc);
        //trae los productos de la pga actual
        org.jsoup.select.Elements listProductos = doc.select("div[class=\"wpb_column vc_column_container vc_col-sm-12\"]");
//            System.out.println("listProductos:"+listProductos);
            //for encargado de recorrer el paginador y sacar la pag siguiente
            
            for (org.jsoup.nodes.Element productos: listProductos) {
                org.jsoup.select.Elements listProducto = productos.select("div[class=\"ara-product ara-rebajon-contenedor\"]");
                for (org.jsoup.nodes.Element producto: listProducto) {
                    org.jsoup.select.Elements detalle = producto.select("div[class=\"ara-rebajon-producto_detalle \"]");
                    org.jsoup.select.Elements nombre = detalle.select("p");
                    org.jsoup.select.Elements valor = producto.select("li[class=\"ara-rebajon-texto2\"]");
                    System.out.println("nombre:"+nombre.text()+"-valor:"+valor.text());
                }
            }
            
        
        }catch (SocketTimeoutException e){
            System.err.println("Pag stop por time out (reanuda en 10s):"+pagStop);
            JSoupAra.reanudarFalla();
           
        }catch(Exception e){
            e.printStackTrace();
            
        }
    }
    
    public static void buscadorDeProductoxPagina(String url){
       JSoupAra.traerPaginasYproductosAlkosto(url);
        
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
        JSoupAra.buscadorDeProductoxPagina("http://www.aratiendas.com/rebajon/");
    }
}
