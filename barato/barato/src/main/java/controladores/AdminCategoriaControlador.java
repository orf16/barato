/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controladores;


import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import interfaces.CaracteristicaInterface;
import java.util.List;

import modelos.Categoria;
import modelos.Producto;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import servicios.AdminCategoriasImplementacion;
import servicios.AdminProductos;
import interfaces.CategoriasInterface;
import interfaces.ProductoInterface;
import java.io.IOException;
import modelos.Caracteristica;
import modelos.ProductoTwebscrHist;
import org.json.JSONException;
import org.springframework.web.bind.annotation.RequestParam;
import servicios.AdminCaracteristicaImplementacion;


/**
 *
 * @author 
 */
@Controller
public class AdminCategoriaControlador {
    
    private final ObjectMapper mapper = new ObjectMapper().configure(SerializationFeature.FAIL_ON_EMPTY_BEANS, false);

    public AdminCategoriaControlador() {
    }
            
    @RequestMapping(value = "/getCategoriasxLimite", method = RequestMethod.POST, headers = "Content-Type=application/json" )
    @ResponseBody
    public String getCategoriasxLimite( @RequestBody String body ) throws Exception {
        
        JSONObject param = new JSONObject( body );
        Integer limiteCategoria = param.getInt("limiteCategoria");
        Integer limiteProducto = param.getInt("limiteProducto");
                          
        CategoriasInterface cad = new AdminCategoriasImplementacion();
        ProductoInterface pro = new AdminProductos();

        List<Categoria> categoriaList = cad.getCategoriasxLimite( limiteCategoria );

        for(Categoria categoria : categoriaList){
            List<Producto> traerProductosxcategoriaxidCategoria = pro.traerProductosxcategoriaxidCategoria(categoria.getIdcategoria(), limiteProducto);
            categoria.setListaProducto(traerProductosxcategoriaxidCategoria);
        }        
        return mapper.writeValueAsString( categoriaList );
    }
    
    @RequestMapping(value = "/getCategoriaWS", method = RequestMethod.GET)
    @ResponseBody
    public String getCategoriaWS(Integer id) throws IOException, JSONException{   
        CaracteristicaInterface cad = new AdminCaracteristicaImplementacion();
        
        List<Caracteristica> caracteristicaList = cad.obtenerCaracteristica(id);
        return mapper.writeValueAsString( caracteristicaList );
    }
    @RequestMapping(value = "/getProductosWS", method = RequestMethod.GET)
    @ResponseBody
    public String getProductosWS() throws IOException, JSONException{   
        CaracteristicaInterface cad = new AdminCaracteristicaImplementacion();
        
        List<Caracteristica> caracteristicaList = cad.obtenerCategoriasProductos();
        return mapper.writeValueAsString( caracteristicaList );
    }
    
}
