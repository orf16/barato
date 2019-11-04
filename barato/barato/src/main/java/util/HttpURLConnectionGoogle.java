/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package util;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.Iterator;
import java.util.Map;
import org.json.JSONObject;
 
import javax.net.ssl.HttpsURLConnection;
import org.json.JSONArray;
import org.json.JSONException;
 
public class HttpURLConnectionGoogle {
 
	private final String USER_AGENT = "Chrome/4.0.249.0";

	// HTTP GET request
	private StringBuffer sendGet() throws Exception {
	    
//	    String username="hitenpratap";
//        StringBuilder stringBuilder = new StringBuilder("https://www.googleapis.com/customsearch/v1?key=AIzaSyDIKXncdMMuJs7Q5Y7JMHANQwu9B_963xw&cx=018333737359568223381:bplw_xojxd8&q=jugo&num=10&start=20");
            StringBuilder stringBuilder = new StringBuilder("https://www.googleapis.com/customsearch/v1?key=AIzaSyC0rNlk8ogDWoTmwTTkB71_3L_j0X7JwzI&cx=010225874253370736786:cuvnpmshmdi&q=jugo&num=10&start=20");

//        stringBuilder.append("?q=");
//        stringBuilder.append(URLEncoder.encode(username, "UTF-8"));
        
        URL obj = new URL(stringBuilder.toString());
 
		HttpURLConnection con = (HttpURLConnection) obj.openConnection();
		con.setRequestMethod("GET");
		con.setRequestProperty("User-Agent", USER_AGENT);
 
		System.out.println("Response Code : " + con.getResponseCode());
		System.out.println("Response Message : " + con.getResponseMessage());
 
		BufferedReader in = new BufferedReader(
		        new InputStreamReader(con.getInputStream()));
		String line;
		StringBuffer response = new StringBuffer();
 
		while ((line = in.readLine()) != null) {
			response.append(line);
		}
		in.close();
                
                System.out.println(response.toString());
                return response;
	}
        
        public void converter(StringBuffer respuesta) throws JSONException{
            JSONObject jsonObj = new JSONObject(respuesta.toString());
                        
            Iterator datos = jsonObj.keys();
            while (datos.hasNext()) {
                System.out.println("J: "+datos.next());
            }
            System.out.println("valor:"+jsonObj.get("items").getClass());
            
            
            JSONArray innerArray=(JSONArray) jsonObj.get("items");
            JSONObject object = null;
            for(int n = 0; n < innerArray.length(); n++)
                {
                    object = innerArray.getJSONObject(n);
                    object.get("title");
                    System.out.println("T: "+object.get("title")+" -D: "+object.get("snippet"));
                    // do some stuff....
                }
            
            Iterator item = object.keys();
            while (item.hasNext()) {
                System.out.println("I: "+item.next());
            }
            
//            for(int i=0;i<innerArray.length();i++){
//            JSONObject innInnerObj=innerArray.getJSONObject(i);
//            Iterator<String> InnerIterator=innInnerObj.keys();
//            while(InnerIterator.hasNext()){
//                System.out.println("valor"+InnerIterator+" is :"+innInnerObj.get(InnerIterator.next()));
//             }
//            }
            
            
            JSONObject jsonItems = new JSONObject(jsonObj.get("items").toString());
            Iterator items = jsonItems.keys();
            
            while (items.hasNext()) {
                Map.Entry e = (Map.Entry)items.next();
                System.out.println("I: "+e.getKey() + " " + e.getValue());
            }
            
            while (items.hasNext()) {
                System.out.println("I: "+items.next());
            }
            System.out.println("valor:"+jsonObj.get("items"));
            }
        
        
        public static void main(String[] args) throws Exception {
 
		HttpURLConnectionGoogle http = new HttpURLConnectionGoogle();
 
		System.out.println("GET Request Using HttpURLConnection");
		http.converter(http.sendGet());
//		System.out.println("POST Request Using HttpURLConnection");
//		http.sendPost();
 
	}
}