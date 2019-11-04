/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package webScraping;

import java.net.SocketTimeoutException;

import org.jsoup.Jsoup;

/**
 *
 * @author marti
 */
public class JSoupJumbo_old {
    
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
        for (org.jsoup.nodes.Element producto: Productos) {

            org.jsoup.select.Elements items = producto.select("li[class=\"item\"]");
            for (org.jsoup.nodes.Element item: items) {
                org.jsoup.select.Elements valor = item.select("span[class=\"price\"]");
                org.jsoup.select.Elements nombre = item.select("h2[class=\"product-name\"]");
                System.out.println("--> nombre:"+nombre.get(0).text()+" |--> valor:"+valor.get(0).text());
            }
        }
        return pagSiguiente;
        }catch (SocketTimeoutException e){
            System.err.println("Pag stop por time out (reanuda en 10s):"+pagStop);
            JSoupJumbo_old.reanudarFalla();
            return "";
        }catch(Exception e){
            e.printStackTrace();
            return "";
        }
    }
    
    public static void prueba3(String url){
        try{
     
        org.jsoup.nodes.Document doc = Jsoup.connect(url).get();

        //Obtenemos todas las filas identificadas como evento deportivo
        //ya que con este atributo es como se identifican los partidos
        org.jsoup.select.Elements matches = doc.select("div[class=\"product-shelf n18colunas\"]");
            System.out.println("matches"+matches.toString());
        for (org.jsoup.nodes.Element match: matches) {

            org.jsoup.select.Elements items = match.select("li[layout=\"49a31962-b0e8-431b-a189-2473c95aeeeb\"]");
            for (org.jsoup.nodes.Element item: items) {
                org.jsoup.select.Elements nombre = item.select("a[class=\"product-item__name\"]");
                org.jsoup.select.Elements valor = item.select("span[class=\"product-prices__value product-prices__value--best-price\"]");
                System.out.println("--> nombre:"+nombre.get(0).text()+" |--> valor:"+valor.get(0).text());
            }
            
        }
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
    public static void buscadorDeProductoxPagina(String url){
        String pagSiguiente = JSoupJumbo_old.traerPaginasYproductosAlkosto(url);
        if(!pagSiguiente.equals("")){
            JSoupJumbo_old.buscadorDeProductoxPagina(pagSiguiente);
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
//        JSoupJumbo_old.buscadorDeProductoxPagina("http://www.alkosto.com/mercado/todo-el-mercado");
        JSoupJumbo_old.prueba3("http://mercado.tiendasjumbo.co/supermercado/bebidas");
    }
}
