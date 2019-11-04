/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servicios;


import interfaces.WebScrappingInterface;
import org.springframework.stereotype.Service;
import webScraping.*;

import java.math.BigInteger;

/**
 *
 * @author 
 */
@Service("WebScrappingInterface")
public class AdminWebScrappersImplementacion implements WebScrappingInterface {
    
    private final Funciones funciones = new Funciones();

    @Override
    public String webScrappingCarulla(Integer idmunicipio) {
        JSoupCarulla jsc= new JSoupCarulla();
        jsc.obtenerProductos(idmunicipio);
        return ""; 
    }
    
   @Override
    public String webScrappingExito(Integer idalmacen) {
        JSoupExito jse= new JSoupExito();
        jse.obtenerProductos(idalmacen);
        return "";
    }

    @Override
    public String webScrappingJumbo(Integer idalmacen) {
        JSoupJumbo jsj= new JSoupJumbo();
        jsj.obtenerProductos(idalmacen);
        return "";
    }   
    
    @Override
    public String webScrappingOlimpica(Integer idalmacen) {
        JSoupOlimpica jso= new JSoupOlimpica();
        jso.obtenerProductos(idalmacen);
        return ""; 
    }

    @Override
    public String unificarproductos(BigInteger idtareaexito, BigInteger idtareacarull, BigInteger idtareaoli, BigInteger idtareajumb) {
        unificarProduct up = new unificarProduct();
        up.copiarProduct(idtareaexito,idtareacarull,idtareaoli,idtareajumb);
        return "";
    }


}
