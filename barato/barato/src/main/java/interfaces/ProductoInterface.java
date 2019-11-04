/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package interfaces;

import modelos.Producto;
import modelos.Productoxcategoria;

import java.util.List;

/**
 *
 * @author 
 */
public interface ProductoInterface {
    
    public List <Producto> traerTodosProductos();
    public List <Producto> traerProductosxNombre(String nombre);
    public List <Productoxcategoria> traerProductosxcategoriaxNombre(String nombre, Integer idcat);
    public List <Productoxcategoria> traerProductosxcategoriaxLimite(Integer limitCategoria);
    public List <Producto> traerProductosxcategoriaxidCategoria(Integer idCategoria,Integer limiteProducto);
    public List <Producto> traerTodosProductosxcategoria(Integer idCategoria);
    public List <Producto> traerProductosxIds(List<Integer> idProductos);
    public Boolean crearproductos(String tiendprods);
}
