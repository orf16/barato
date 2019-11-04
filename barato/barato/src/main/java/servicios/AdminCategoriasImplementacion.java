/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servicios;

import interfaces.CategoriasInterface;
import java.util.List;

import modelos.Categoria;
import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.stereotype.Service;

/**
 *
 * @author 
 */
@Service("ProductoInterface")
public class AdminCategoriasImplementacion implements CategoriasInterface{
    
    private final Funciones funciones = new Funciones();
    
    @Override
    public List <Categoria> getCategoriasxLimite(Integer limite) {
        try {
            Session conexion = funciones.getConexion();            
            Query query = conexion.createQuery("FROM Categoria ORDER BY idcategoria").setMaxResults(limite);

            List<Categoria> productoList = query.list();

            conexion.close();
            return productoList;
        } catch (Exception e) {
            System.out.println("ERROR-> traerProductosxcategoriaxNombre-> " + e);
            return null;
        }
    }
    
}
