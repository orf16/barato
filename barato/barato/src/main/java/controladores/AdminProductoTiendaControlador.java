/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controladores;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;

import modelos.Producto;
import modelos.ProductoTienda;
import modelos.ProductoTwebscrHist;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import servicios.AdminProductoTiendaImplementacion;
import servicios.AdminProductos;
import interfaces.AdminProductoTiendaInterface;
import interfaces.ProductoInterface;
import org.springframework.web.bind.annotation.ResponseBody;
import util.ConvertirProductoTiendaAUtil;
import util.ProductosxTiendaUtil;

/**
 *
 * @author 
 */
@Controller
public class AdminProductoTiendaControlador {
    
    private final ProductoInterface adminProducts = new AdminProductos();
    private final AdminProductoTiendaInterface productoTienda = new AdminProductoTiendaImplementacion();
    private final ConvertirProductoTiendaAUtil convertirProductoTiendaAUtil = new ConvertirProductoTiendaAUtil();
    private final ObjectMapper mapper = new ObjectMapper().configure(SerializationFeature.FAIL_ON_EMPTY_BEANS, false);
    
    @RequestMapping(value = "/getProductosTiendaUtil", method =  RequestMethod.GET)
    @ResponseBody
    public String getTodosProductos(@RequestParam(required = false, value = "listProductoId") String listProductoId,
                                  @RequestParam(required = false, value = "orden") int ordenCast,
                                  @RequestParam(required = false, value = "maximo") int maximoCast) throws Exception{
      
            List<Integer> listaProductos = new ArrayList<Integer>();
            String idProductos = listProductoId;
            
            String retorno  = "false";
            
            if( listProductoId != "" && listProductoId != null){
                String[] listaProductosString = idProductos.split(",");
            
                for(String valor : listaProductosString){
                    listaProductos.add(Integer.parseInt(valor));
                }                      
                List <Producto> listProductos = adminProducts.traerProductosxIds(listaProductos);
                System.out.println("listProductos Controller = "+listProductos);

                //llama los productos de las tiendas en db
                List<ProductoTienda> listaProductoTienda = productoTienda.getProductoTienda(listProductos);
                //List<ProductoTiendaCadena> listaProductoTiendaCadena = productoTienda.getProductoTiendaCadena(listProductos);         

                //une las 2 listas en un solo objeto ordenado por tiendad
                Hashtable<Integer, ProductosxTiendaUtil> tiendasyProductosXTiendas = convertirProductoTiendaAUtil.convertirProductoTiendaCadena(listaProductoTienda, null);

                //devuelve una lista con las tiendas ordenadas por el menos valor
                List<ProductosxTiendaUtil> listaTiendasyProductos = convertirProductoTiendaAUtil.ordenarAlista(tiendasyProductosXTiendas,ordenCast,maximoCast);

                JSONObject result = new JSONObject( );
                result.put("tiendas", listaTiendasyProductos);
                return mapper.writeValueAsString( listaTiendasyProductos );  
            }
            else{
                return "";
            }                                                                 
    }



    @RequestMapping(value = "/getProductosNocreadosTareaCat", method = RequestMethod.GET)
    @ResponseBody
    public String getProductosNocreadosTareaCat( @RequestParam(name = "idtienda" , required = true) Integer idtienda,
                                         @RequestParam(name = "idcategoria" , required = true) Integer idcategoria,
                                         @RequestParam(name = "nombreprod" , required = true) String nombreprod) throws IOException, JSONException {
        List<ProductoTwebscrHist>   productoList= productoTienda.getProductosNoExistenTareaCat(idtienda,idcategoria,nombreprod);

        return mapper.writeValueAsString( productoList );
    }


    @RequestMapping(value = "/getProductosTareaCat", method = RequestMethod.GET)
    @ResponseBody
    public String getProductosTareaCat( @RequestParam(name = "idtienda" , required = true) Integer idtienda,
                                         @RequestParam(name = "idcategoria" , required = true) Integer idcategoria,
                                        @RequestParam(name = "nombreprod" , required = true) String nombreprod,
                                        @RequestParam(name = "codigotienda" , required = true) String codigotienda,
                                        @RequestParam(name = "precio" , required = true) Double precio) throws IOException, JSONException {
        List<ProductoTwebscrHist>   productoList= productoTienda.getProductosTareaCat(idtienda,idcategoria,nombreprod,codigotienda,precio);

        return mapper.writeValueAsString( productoList );
    }


}
