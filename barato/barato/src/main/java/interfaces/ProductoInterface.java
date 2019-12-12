/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package interfaces;

import modelos.Producto;
import modelos.Productoxcategoria;

import java.util.List;
import modelos.ProductoTwebscrHist;

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
    public List <ProductoTwebscrHist> traerProductosxID(String id);
    ////BUSQUEDA APROXIMADA GENERAL
    public List <ProductoTwebscrHist> traerProductos(String nombre, String categoria, String producto,String marca,String presentacion,String volumen, String tienda, String pi, String pf);
    public List <ProductoTwebscrHist> traerProductosAdmin(String nombre, String categoria, String producto,String marca,String presentacion,String volumen, String tienda, String pi, String pf, String nr);
    public List <ProductoTwebscrHist> traerRelacionados(String nombre);
}