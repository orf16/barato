/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controladores;

import org.json.JSONObject;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 *
 * @author 
 */
public class CargaDatosControlador {
    
    @RequestMapping(value = "/getCategoriasxLimite", method = RequestMethod.GET )
    @ResponseBody
    public String getCategoriasxLimite(@RequestParam(required = false, value = "limiteCategoria") String limiteCategoria,
                                    @RequestParam(required = false, value = "limiteProducto") String limiteProducto ) throws Exception {
        System.out.println("estra13----");
        
        JSONObject respuesta = new JSONObject( );
//            respuesta.put("listcategoria", categoriaList);
       // response.getWriter().println( respuesta );

       return "";
    }
    
}
