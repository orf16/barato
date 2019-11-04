package controladores;
/**
 *
 * @author 
 */

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

import modelos.Departamento;
import modelos.Municipio;
import modelos.Usuario;
import modelos.UsuarioDireccion;
import org.json.JSONObject;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import interfaces.AdminInterface;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import servicios.AdminImplementacion;
import servicios.Funciones;


@RestController
public class AdminControlador {
                 
   //@Autowired
   protected AdminInterface admin;
   private final Funciones funciones = new Funciones();
   private final ObjectMapper mapper = new ObjectMapper().configure(SerializationFeature.FAIL_ON_EMPTY_BEANS, false);

    public AdminControlador() {
        this.admin = new AdminImplementacion();
    }
   
   @RequestMapping(value = "/getLogin", method = RequestMethod.POST, headers = "Content-Type=application/json"  )   
   @ResponseBody
   //@Secured("ROLE_REGULAR_USER")   
   public String buscarUsuario( @RequestBody String body ) throws Exception {
                                   
       JSONObject param = new JSONObject( body );
       String email = param.getString("email");
       String clave = param.getString("clave");              
       Usuario usuario = admin.buscarUsuario( email, clave);
       
       return mapper.writeValueAsString(usuario);
   }
   
   @RequestMapping(value = "/getUsuarios" ,  method = RequestMethod.GET )   
   @ResponseBody
   //@Secured("ROLE_ADMIN")
   public String getUsuarios(  @RequestParam(name = "numeroDocumento" , required = false) String numeroDocumento  , @RequestParam(name = "correo", required = false) String correo ) throws Exception{
                    
     
        List<Usuario> usuarios = new ArrayList<Usuario>();        

        if(numeroDocumento == null && correo == null){            
            usuarios = admin.buscarUsuario();
        }else{                    
            if( numeroDocumento != null ){                
                Usuario auxObject = admin.buscarUsuario( 0, numeroDocumento );                        
                if( auxObject != null) usuarios.add( auxObject );
            }
            else if( correo != null ){                
                Usuario auxObject = admin.buscarUsuario( correo );
                if( auxObject != null) usuarios.add( auxObject );
            }
        }       
        return mapper.writeValueAsString(usuarios);
    }
     
    @RequestMapping(value = "/getDepartamentos", method = RequestMethod.GET, headers = "Content-Type=application/json")
    @ResponseBody
    public String getDepartamentos( ) throws Exception {        
  
        List<Departamento> departamentos = admin.buscarDepartamento();
        return mapper.writeValueAsString(departamentos);
    }
        
    @RequestMapping(value = "/getMunicipios", method = RequestMethod.GET, headers = "Content-Type=application/json")    
    @ResponseBody
    public String getMunicipios( @RequestParam(name = "idDepartamento" , required = true) long idDepartamento ) throws Exception {        
                       
        List<Municipio> municipios = admin.buscarMunicipio( idDepartamento );
        return mapper.writeValueAsString( municipios );     
    }

    @RequestMapping(value = "/setComentario", method = RequestMethod.POST , headers = "Content-Type=application/json")
    @ResponseBody
    public String setComentario( @RequestBody String body ) throws Exception {
        JSONObject param = new JSONObject(body);
        String coment=param.get("coment").toString();
        String calif=param.get("calif").toString();
        String email=param.get("email").toString();
        Boolean retorno=admin.recibircomentarios(coment,calif,email);

        return mapper.writeValueAsString( retorno );
    }


        @RequestMapping(value = "/guardarUsuario", method = RequestMethod.POST , headers = "Content-Type=application/json")
    @ResponseBody
    public String guardarUsuario( @RequestBody String body ) throws Exception {         
                            
        JSONObject param = new JSONObject( body );
        Usuario usuario = mapper.readValue( param.get("usuario").toString(), Usuario.class);  
        //System.out.println("Email usuario --> "+usuario.getEmail());
        Usuario usuarioSearch = admin.buscarUsuario( usuario.getEmail() );
        
        if( usuarioSearch == null ){ //Se crea sino existe ningun usuario con ese correo
            List<UsuarioDireccion> direcciones = new ArrayList<UsuarioDireccion>();

            JSONArray direccionesJson = new JSONArray( param.get("direcciones").toString() );
            for (Object direccionJson : direccionesJson){ 
               if ( direccionJson instanceof JSONObject ) {
                    JSONObject auxDireccion = (JSONObject)direccionJson;
                    Municipio municipio = admin.buscarMunicipio( auxDireccion.getInt("idMunicipio")); 
                    Departamento departamento = admin.buscarDepartamento( auxDireccion.getInt("idDepartamento") );
                    //System.out.println("departamento .... "+  mapper.writeValueAsString( departamento ))  ;
                    auxDireccion.put("departamento", new JSONObject( mapper.writeValueAsString( departamento ) ) );
                    auxDireccion.put("municipio", new JSONObject( mapper.writeValueAsString( municipio ) ) );
                    auxDireccion.put("usuario", new JSONObject( param.get("usuario").toString() ) );

                    auxDireccion.remove("idDepartamento");                
                    auxDireccion.remove("idMunicipio");
                    System.out.println( auxDireccion.toString() );

                    direcciones.add( mapper.readValue( auxDireccion.toString(), UsuarioDireccion.class) );
                }            
            }

            Boolean result = admin.guardarUsuario(usuario, direcciones);        
            //System.out.println(" direcciones-->"+direcciones);                
            return mapper.writeValueAsString( result ); 
        }
        else{
            return mapper.writeValueAsString( false ); 
        }
    }
                    
} 
