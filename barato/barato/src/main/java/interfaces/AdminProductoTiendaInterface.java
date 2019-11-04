/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package interfaces;

import modelos.Producto;
import modelos.ProductoTienda;
import modelos.ProductoTiendaCadena;
import modelos.ProductoTwebscrHist;

import java.math.BigInteger;
import java.util.List;

/**
 *
 * @author marti
 */
public interface AdminProductoTiendaInterface {
    
    public List<ProductoTienda> getProductoTienda(List <Producto> listProductos);

    public List<ProductoTienda> getProductoTiendaCopiar();

    public List<ProductoTiendaCadena> getProductoTiendaCadena(List <Producto> listProductos);

    public List<ProductoTwebscrHist> getProductosTareaCatSingle(BigInteger idtarea, Integer idcategoria);

    public List<ProductoTwebscrHist> getProductosTareaCat(Integer idtienda, Integer idcategoria, String nombreprod,String codigotienda,Double precio);

    public List<ProductoTwebscrHist> getProductosNoExistenTareaCat(Integer idtienda,Integer idcategoria,String nombreprod);

    public List<ProductoTwebscrHist> getProductosTareaCatExitoCarulla (Integer idcategoria);

    
}
