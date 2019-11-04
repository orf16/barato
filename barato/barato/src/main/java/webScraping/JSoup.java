/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package webScraping;

import java.io.IOException;
import javax.swing.text.Document;
import javax.ws.rs.core.Response;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;
import org.jsoup.Jsoup;
import org.w3c.dom.NodeList;

/**
 *
 * @author 
 */
public class JSoup {
    
    public static int getStatusConnectionCode(String url)  {

        Response response = null;

        try {
            response = (Response) Jsoup.connect(url).userAgent("Mozilla/5.0").timeout(100000).ignoreHttpErrors(true).execute();
        } catch (IOException ex) {
            System.out.println("Excepción al obtener el Status Code: " + ex.getMessage());
        }
        
        return response.getStatus();        
    }
    
    public static void prueba2(){
        
        try {

            Document doc = (Document) (Jsoup.connect("http://timesofindia.indiatimes.com/world/china/China-sees-red-in-Abes-WWII-shrine-visit/articleshow/27989418.cms").get());
            String exp = "//*[@id='cmtMainBox']/div/div[@class='cmtBox']/div/div[@class='box']/div[@class='cmt']/div/span";

            XPathFactory factory = XPathFactory.newInstance();
            XPath xPath = factory.newXPath();
            XPathExpression expr = xPath.compile(exp);

            NodeList node = (NodeList) expr.evaluate(doc, XPathConstants.NODE);

            for (int i = 0; i < node.getLength(); i++) {
                System.out.println(expr.evaluate(node.item(i), XPathConstants.STRING));
            }

        } catch (Exception e) {
            e.printStackTrace();
//            System.out.println(e);
        }
    }

    public static void prueba3(){
        try {
            final String url = "https://www.exito.com/browse?Ntt=jugo%20hit";

            org.jsoup.nodes.Document doc = Jsoup.connect(url).get();

            //Obtenemos todas las filas identificadas como evento deportivo
            //ya que con este atributo es como se identifican los partidos
            org.jsoup.select.Elements matches = doc.select("div[class$=\"row product-list\"]");
            System.out.println("matches" + matches.toString());
            for (org.jsoup.nodes.Element match : matches) {

                //Obtenemos los equipos de cada partido utilizando también expresiones
                org.jsoup.select.Elements teams = match.select("div[class=\"product search col-xs-12 col-sm-4 col-md-4 col-lg-3\"]");

                //obtenemos el enlace al detalle del partido
                org.jsoup.select.Elements score = match.select("p[class=\"price\"]");
                org.jsoup.select.Elements prueba = match.select("div.masthead");
                System.out.println("PRUEBAAAA:" + prueba);
                String localTeam = teams.get(0).text();
                String visitorTeam = teams.get(1).text();
                String valor = score.get(0).text();
                score.size();
                for (int x = 0; x < score.size(); x++) {
                    System.out.println("--valor--" + x + ": " + score.get(x).text());
                }
//        String statsLink = score.first().attr("href");

                System.out.println("---0---" + teams.get(0).text()
                        + "---1---" + teams.get(1).text()
                        + "---2---" + teams.get(2).text()
                        + "---3---" + teams.get(3).text());

//            System.out.println("--valor--"+score.get(0).text());
//            System.out.println("--valor--"+score.get(1).text());
//            System.out.println("localTeam: "+localTeam+" visitorTeam: "+visitorTeam+" statsLink: "+statsLink);
//        String[] goals = score.first().text().split("-");
//        int localGoals = Integer.parseInt(goals[0].trim());
//        int visitorGoals = Integer.parseInt(goals[1].trim());
//        System.out.println(localTeam + " vs " + visitorTeam + ": " + localGoals + "-" + visitorGoals + " -&gt; " + statsLink);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public static void main(String[] args){
//        JSoup.getStatusConnectionCode("https://www.exito.com/browse?Ntt=jugo");
//        JSoup.prueba2();
        JSoup.prueba3();
    }
}
