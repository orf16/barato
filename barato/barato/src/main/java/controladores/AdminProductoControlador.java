/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controladores;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import java.io.IOException;
import java.util.List;

import modelos.Producto;
import modelos.Productoxcategoria;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import servicios.AdminProductos;
import interfaces.ProductoInterface;
import modelos.ProductoTwebscrHist;

/**
 *
 * @author 
 */
@Controller
public class AdminProductoControlador {

    private final ObjectMapper mapper = new ObjectMapper().configure(SerializationFeature.FAIL_ON_EMPTY_BEANS, false);
    private final ProductoInterface prod = new AdminProductos();
    
    public AdminProductoControlador() {
    }
    
    @RequestMapping(value = "/getProductoList", method = RequestMethod.GET)
    @ResponseBody
    public String getTodosProductos() throws Exception{                                        
        ProductoInterface prod = new AdminProductos();
        prod.traerTodosProductos();
        List<Producto> productoList = prod.traerTodosProductos();
        return mapper.writeValueAsString( productoList );  
    }
            
    @RequestMapping(value = "/getProductosxNombre", method = RequestMethod.GET)
    @ResponseBody
    public String getProductosxNombre( @RequestParam(name = "nombre" , required = true) String nombre ) throws IOException, JSONException{                              
        List<Producto> productoList = prod.traerProductosxNombre( nombre );
        return mapper.writeValueAsString( productoList );
    }
    
    @RequestMapping(value = "/getProductosxcategoriaxNombre", method = RequestMethod.GET )
    @ResponseBody
    public String getProductosxcategoriaxNombre( @RequestParam(required = false, value = "nombre") String nombre,@RequestParam(required = false, value = "idcat") Integer idcat) throws IOException, JSONException{
        List<Productoxcategoria> productoList = prod.traerProductosxcategoriaxNombre(nombre,idcat);
        return mapper.writeValueAsString( productoList );                               
    }


    @RequestMapping(value = "/setCrearProducto",method = RequestMethod.POST ,  headers = "Content-Type=application/json" )
    @ResponseBody
    public String setCrearProducto( @RequestBody String body ) throws Exception{

        JSONObject param = new JSONObject( body );
        //Integer idUsuario = param.getInt("idUsuario");
        String tiendprods = param.getString("tiendprods");

        Boolean result = prod.crearproductos(tiendprods);

        return mapper.writeValueAsString( result );

    }

    @RequestMapping(value = "/getProductosxID", method = RequestMethod.GET)
    @ResponseBody
    public String getProductosxID( @RequestParam(name = "id" , required = true) String id ) throws IOException, JSONException{                              
        List<ProductoTwebscrHist> productoList = prod.traerProductosxID( id );
        return mapper.writeValueAsString( productoList );
    }
}
