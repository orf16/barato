/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controladores;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import modelos.Categoria;
import modelos.Lista;
import modelos.ListaProducto;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import servicios.AdminImplementacion;
import servicios.Buscadorimplementacion;
import interfaces.AdminInterface;
import interfaces.BuscadorInterface;
import interfaces.ProductoInterface;
import modelos.Usuario;
import org.json.JSONArray;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import servicios.AdminProductos;
import servicios.Funciones;

/**
 *
 * @author 
 */
@Controller
//@RequestMapping("/buscador.html")
@CrossOrigin(origins = "*", allowedHeaders = "*")
public class BuscadorControlador {
                
    private final BuscadorInterface buscador = new Buscadorimplementacion();
    private final ObjectMapper mapper = new ObjectMapper().configure(SerializationFeature.FAIL_ON_EMPTY_BEANS, false);
    private final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    private final SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd");
    private final Funciones funciones = new Funciones();    
    private final AdminInterface admin = new AdminImplementacion();
    private final ProductoInterface producto = new AdminProductos();
          
    
    @RequestMapping(value = "/getListasUsuario", method = RequestMethod.GET)
    @ResponseBody
     public String getListasUsuario(@RequestParam(required = false, value = "emailUser") String emailUser ) throws Exception{                
    
    Usuario usuario = admin.buscarUsuario( emailUser );
    List<Lista> listas = null ; List<ListaProducto> listaProductos = null;            
    listas = buscador.getListasUsuario( usuario.getIdusuario() ) ;
    JSONArray result = new JSONArray();
    
    if( listas != null ){                     
        for (Lista lista : listas){            
            JSONArray jsonListaProducto = null;
            listaProductos = buscador.getListaProducto( lista.getIdlista() ) ;
            
            if( listaProductos != null ){                      
                jsonListaProducto = new JSONArray( mapper.writeValueAsString(listaProductos)  );                                       
            } 

            Date fechaFormato = sdf.parse( lista.getFechacreada().toString() );
            lista.setFechacreada( fechaFormato );                
            JSONObject jsonLista = new JSONObject( mapper.writeValueAsString( lista ) );
            jsonLista.put( "productos", jsonListaProducto);
            result.put(jsonLista);
        }
    }        
    return result.toString();        
    }
    
    @RequestMapping(value = "/getCategorias", method = RequestMethod.GET )
    @ResponseBody
    public String getCategorias( ) throws Exception{
        List<Categoria> categorias = buscador.getCategorias() ; 
        return mapper.writeValueAsString(categorias);      
    }
       
   @RequestMapping(value = "/guardarProductosLista", method = RequestMethod.POST )
   @ResponseBody
   public String guardarProductosLista( @RequestBody String body ) throws Exception{
     
        ListaProducto producto = new ListaProducto();      
        Lista lista  = buscador.getLista(new Date());

        JSONObject param = new JSONObject( body );
        Integer idUsuario = param.getInt("idUsuario");    
        
        ListaProducto productoLista = mapper.readValue( param.get("producto").toString(), ListaProducto.class);
        
        if( lista == null){ //Si no existe se crea la lista para el dia de hoy            
             lista = new Lista();
             lista.setEstado( Short.valueOf("1") );
             lista.setFechacreada( new Timestamp(new Date().getTime()) );                                 
             lista.setUsuario( admin.buscarUsuario( idUsuario )); // Modificar al momento de agregar la sesion de usuario 
             lista.setUsuarioDireccion( admin.buscarDirecciones( idUsuario ).get(0)); // Modificar al momento de validar las direcciones de los aestablecimientos 
             Boolean listaGuardada =  buscador.guardarLista( lista );              
        }         
        productoLista.setLista( lista );                             
        Boolean bandera = buscador.guardarProductosLista(productoLista);                
        return mapper.writeValueAsString( bandera );   
        
   }
      
}