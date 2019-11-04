/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controladores;


import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import interfaces.AdminTiendaInterface;
import interfaces.ProductoInterface;
import java.util.ArrayList;
import java.util.List;

import modelos.Tienda;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RequestParam;
import servicios.AdminProductos;
import servicios.AdminTiendaImplementacion;

/**
 *
 * @author 
 */
@Controller
public class AdminTiendaControlador {
    
    private final ObjectMapper mapper = new ObjectMapper().configure(SerializationFeature.FAIL_ON_EMPTY_BEANS, false);
    private final AdminTiendaInterface adminTienda = new AdminTiendaImplementacion();    
    private final ProductoInterface adminProducts = new AdminProductos();

    public AdminTiendaControlador() {
    }
            
    @RequestMapping(value = "/getTiendas", method = RequestMethod.GET )
    @ResponseBody
    public String getTiendas( @RequestParam(name = "listProduct" , required = false) String listProduct ) throws Exception {                       
                        
        List<Integer> listaProductos = new ArrayList<Integer>();
        if( listProduct != "" && listProduct != null){
            String[] listaProductosString = listProduct.split(",");
            for(String valor : listaProductosString){
                listaProductos.add(Integer.parseInt(valor));
            } 
        }
        
        List<Tienda> tiendaList = adminTienda.buscarTiendas(  );
        return mapper.writeValueAsString( tiendaList );
    }
    
}
