/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controladores;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import modelos.Lista;
import modelos.ListaProducto;
import modelos.Producto;
import modelos.Usuario;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import servicios.AdminImplementacion;
import interfaces.AdminInterface;
import interfaces.AdminListasInterface;
import interfaces.BuscadorInterface;
import interfaces.ProductoInterface;
import java.text.SimpleDateFormat;
import modelos.ListasCompartidas;
import org.json.JSONArray;
import org.springframework.web.bind.annotation.RequestParam;
import servicios.AdminListasImplementacion;
import servicios.AdminProductos;
import servicios.Buscadorimplementacion;

/**
 *
 * @author marti
 */
@Controller
public class AdminListasControlador {
    
    private final BuscadorInterface buscador = new Buscadorimplementacion();
    private final AdminListasInterface adminListas = new AdminListasImplementacion();
    private final AdminInterface adminUsuario = new AdminImplementacion();
    private final ProductoInterface adminProducts = new AdminProductos();
    private final ObjectMapper mapper = new ObjectMapper().configure(SerializationFeature.FAIL_ON_EMPTY_BEANS, false);
    private final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    private final SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd");
    
    public AdminListasControlador() {
    }
    
    @RequestMapping(value = "/setListasProductosxUsuario",method = RequestMethod.POST ,  headers = "Content-Type=application/json" )
    @ResponseBody
    public String setListasProductosxUsuario( @RequestBody String body ) throws Exception{
                
        JSONObject param = new JSONObject( body );
        //Integer idUsuario = param.getInt("idUsuario");
        String listProductoId = param.getString("listProductoId");
        String emailUser = param.getString("emailUser");
        String nombrelista = "default";
        
        
//        if( listProductoId.length() > 0 ){
        
            if( !param.isNull("nombreLista") ){
                nombrelista = param.getString("nombreLista");
            }
            //Usuario usuario = adminUsuario.buscarUsuario( idUsuario );
            Usuario usuario = adminUsuario.buscarUsuario( emailUser );
            List<Integer> listaProductos = new ArrayList<Integer>();
            if( listProductoId.length() > 0 ){ //Sino vienen productos solo se crea la lista
                String idProductos = listProductoId;
                String[] listaProductosString = idProductos.split(",");

                for(String valor : listaProductosString){
                    listaProductos.add(Integer.parseInt(valor));
                }                                        
            }
            Lista lista = new Lista();
            lista.setUsuario(usuario);
            lista.setFechacreada(new Date());
            lista.setEstado(Short.MAX_VALUE);
            lista.setNombrelista(nombrelista);
            Boolean result = adminListas.crearListas(lista);

            if( listProductoId.length() > 0 ){ //Sino vienen productos solo se crea la lista
                List <Producto> listProductos = adminProducts.traerProductosxIds(listaProductos);     
                for(Producto producto : listProductos){
                    ListaProducto listaProducto = new ListaProducto();
                    listaProducto.setProducto(producto);
                    listaProducto.setLista(lista);
                    listaProducto.setNombreproducto(producto.getNombre());
                    listaProducto.setProducto_idproducto( producto.getIdproducto() );
                    listaProducto.setDescripcionproducto( producto.getDetalle());
                    listaProducto.setFechaagregado( new Date());
                    listaProducto.setUrl(producto.getDireccionImagen());//Url de la imagen
                    result = adminListas.crearListaProducto(listaProducto);            
                }       
            }
            return mapper.writeValueAsString( result ); 
            
        /*}else
            return mapper.writeValueAsString( true ); */
    }
    
    @RequestMapping(value = "/setActualizarListasProductosxUsuario",method = RequestMethod.POST ,  headers = "Content-Type=application/json" )
    @ResponseBody
    public String setActualizarListasProductosxUsuario( @RequestBody String body ) throws Exception {
        
        JSONObject param = new JSONObject( body );        
        String listProductoId = param.getString("listProductoId");
        Integer idLista = param.getInt("idLista"); 
        String nombrelista = param.getString("nombreLista");
        
        Lista lista = adminListas.getLista( idLista );               
        List<Integer> listaProductos = new ArrayList<Integer>();
        
        String[] listaProductosString = listProductoId.split(",");
        for(String valor : listaProductosString){
            listaProductos.add(Integer.parseInt(valor));
        }

        List <Producto> listProductos = adminProducts.traerProductosxIds(listaProductos);
                        
        lista.setFechacreada(new Date());
        lista.setEstado(Short.MAX_VALUE);
        lista.setNombrelista( nombrelista );
        
        Boolean result = false;
        Boolean resultUpdate = adminListas.actualizarLista(lista);
        if( resultUpdate ){
            //Eliminar productos de la lista para volverlos a agregar cuando se edita
            adminListas.eliminarListaProducto( idLista );
            for(Producto producto : listProductos){                        
                ListaProducto listaProducto = new ListaProducto();
                listaProducto.setProducto(producto);
                listaProducto.setLista(lista);
                listaProducto.setNombreproducto(producto.getNombre());
                listaProducto.setProducto_idproducto( producto.getIdproducto() );
                listaProducto.setDescripcionproducto( producto.getDetalle());
                listaProducto.setFechaagregado( new Date());
                listaProducto.setUrl(producto.getDireccionImagen());//Url de la imagen
                result = adminListas.crearListaProducto(listaProducto);              
            }    
        }
        return mapper.writeValueAsString( result );
    }
    
    @RequestMapping(value = "/compartirLista",method = RequestMethod.POST ,  headers = "Content-Type=application/json" )
    @ResponseBody
    public String setSharedListUser( @RequestBody String body ) throws Exception{
                
        JSONObject param = new JSONObject( body );
        String emailUser = param.getString("emailUser");
        Integer idLista = param.getInt("idLista");
        String emailsUser = param.getString("emailsUser");
                                                                                              
        Usuario usuario = adminUsuario.buscarUsuario( emailUser ); 
        Lista lista = adminListas.getLista( idLista ); 
        
        adminListas.eliminarCompartirLista(  usuario.getIdusuario() ,  idLista , emailsUser );        
        Boolean result = adminListas.compartirLista( usuario , lista , emailsUser );

        return mapper.writeValueAsString( result );         
    }
    
    //Eliminar lista
    @RequestMapping(value = "/eliminarLista",method = RequestMethod.POST ,  headers = "Content-Type=application/json" )
    @ResponseBody
    public String deleteList( @RequestBody String body ) throws Exception{
                
        JSONObject param = new JSONObject( body );
        Integer idLista = param.getInt("idLista");    
        
        
        Boolean result = adminListas.eliminarCompartirLista(idLista ); 
        if( result == true){            
            result = adminListas.eliminarListaProducto(idLista );           
            if( result == true ){
                result = adminListas.eliminarLista( idLista );  
            }        
        }
        return mapper.writeValueAsString( result );         
    }
    
    @RequestMapping(value = "/getListSharedUser", method = RequestMethod.GET)
    @ResponseBody
     public String getListSharedUser(@RequestParam(required = false, value = "emailUser") String emailUser ) throws Exception{
         
    List<ListasCompartidas> listasCompartidas = null ; List<ListaProducto> listaProductos = null;            
    listasCompartidas = adminListas.getListaShared( emailUser );
            
    JSONArray result = new JSONArray();
    
    if( listasCompartidas != null ){  
        for( ListasCompartidas listaCompartida :  listasCompartidas ){
            Lista lista = listaCompartida.getLista();
            JSONArray jsonListaProducto = null;
            listaProductos = buscador.getListaProducto( lista.getIdlista() ) ;

            if( listaProductos != null ){                      
                jsonListaProducto = new JSONArray( mapper.writeValueAsString(listaProductos)  );
            } 
            
            /*Date fechaCompartida ;
            if(  lista.getFechacreada() != null ) fechaCompartida = lista.getFechacreada();
            else fechaCompartida = new Date();

            Date fechaFormato = sdf.parse( fechaCompartida.toString() );
            lista.setFechacreada( fechaFormato );   */             
            JSONObject jsonLista = new JSONObject( mapper.writeValueAsString( lista ) );
            jsonLista.put( "productos", jsonListaProducto);
            result.put(jsonLista);            
        }
    }                        
        return result.toString(); 
    }
     
   
    
}
