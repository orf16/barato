/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servicios;

import interfaces.CaracteristicaInterface;
import interfaces.CategoriasInterface;
import java.util.List;

import modelos.Caracteristica;
import modelos.Categoria;
import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.stereotype.Service;
/**
 *
 * @author orf16
 */
@Service("CaracteristicaInterface")
public class AdminCaracteristicaImplementacion implements CaracteristicaInterface{
    private final Funciones funciones = new Funciones();
    
    @Override
    public List <Caracteristica> obtenerCaracteristica(Integer limite) {
        try {
            Session conexion = funciones.getConexion();            
            Query query = conexion.createQuery("FROM Caracteristica ORDER BY caracteristica").setMaxResults(limite);
            List<Caracteristica> productoList = query.list();
            conexion.close();
            return productoList;
        } catch (Exception e) {
            System.out.println("ERROR-> traerProductosxcategoriaxNombre-> " + e);
            return null;
        }
    }
    @Override
    public List <Caracteristica> obtenerCategoriasProductos() {
        try {
            //int productos_id=4;
            Session conexion = funciones.getConexion();            
            Query query = conexion.createQuery("FROM Caracteristica where id_tipo= :idproductos and mostrar=true ORDER BY caracteristica");
            query.setParameter("idproductos", 3);
            List<Caracteristica> productoList = query.list();
            conexion.close();
            return productoList;
        } catch (Exception e) {
            System.out.println("ERROR-> traerProductosxcategoria-> " + e);
            return null;
        }
    }
    
    
}
