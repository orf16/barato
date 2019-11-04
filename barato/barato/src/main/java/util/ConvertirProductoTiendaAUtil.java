/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package util;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Hashtable;
import java.util.List;
import modelos.Producto;
import modelos.ProductoTienda;
import modelos.ProductoTiendaCadena;

/**
 *
 * @author marti
 */
public class ConvertirProductoTiendaAUtil {

    public ConvertirProductoTiendaAUtil() {
    }
    
        
    public Hashtable<Integer, ProductosxTiendaUtil> convertirProductoTiendaCadena(List<ProductoTienda> listaProductoTienda,List<ProductoTiendaCadena> listaProductoTiendaCadena){
        
        Hashtable<Integer, ProductosxTiendaUtil> tiendasyProductosTiendas = new Hashtable<Integer, ProductosxTiendaUtil>();
            
            for(ProductoTienda productoTienda : listaProductoTienda){
                ProductosxTiendaUtil productosxTiendaUtilHash = tiendasyProductosTiendas.get(productoTienda.getTienda().getIdtienda());
                
                if(productosxTiendaUtilHash == null){
                    ProductosxTiendaUtil productosxTiendaUtil = new ProductosxTiendaUtil();
                    productosxTiendaUtil.setNombreTienda(productoTienda.getTienda().getNombre());
                    productosxTiendaUtil.setIdTienda(productoTienda.getTienda().getIdtienda());
                    
                    List <Producto> listProductosTemp = new ArrayList<>(); 
                    Producto productoTemp = new Producto();
                    productoTemp.setIdproducto(productoTienda.getProducto().getIdproducto());
                    productoTemp.setNombre(productoTienda.getProducto().getNombre());
                    productoTemp.setDetalle(productoTienda.getProducto().getDetalle());
                    productoTemp.setValor(productoTienda.getValor());
                    productoTemp.setDireccionImagen(productoTienda.getProducto().getDireccionImagen());
                    listProductosTemp.add(productoTemp);
                    
                    productosxTiendaUtil.setListaProductos(listProductosTemp);
                    productosxTiendaUtil.setValor(productoTienda.getValor());
                    tiendasyProductosTiendas.put(productoTienda.getTienda().getIdtienda(), productosxTiendaUtil);
                }else{
                    Producto productoTemp = new Producto();
                    productoTemp.setIdproducto(productoTienda.getProducto().getIdproducto());
                    productoTemp.setNombre(productoTienda.getProducto().getNombre());
                    productoTemp.setDetalle(productoTienda.getProducto().getDetalle());
                    productoTemp.setValor(productoTienda.getValor());
                    productoTemp.setDireccionImagen(productoTienda.getProducto().getDireccionImagen());
                    
                    productosxTiendaUtilHash.setValor(productosxTiendaUtilHash.getValor()+productoTienda.getValor());
                    productosxTiendaUtilHash.getListaProductos().add(productoTemp);
                }
            }
            /*
            for(ProductoTiendaCadena productoTiendaCadena : listaProductoTiendaCadena){
                ProductosxTiendaUtil productosxTiendaUtilHash = tiendasyProductosTiendas.get(productoTiendaCadena.getTienda().getIdtienda());
                if(productosxTiendaUtilHash == null){
                    ProductosxTiendaUtil productosxTiendaUtil = new ProductosxTiendaUtil();
                    productosxTiendaUtil.setNombreTienda(productoTiendaCadena.getTienda().getNombre());
                    productosxTiendaUtil.setIdTienda(productoTiendaCadena.getTienda().getIdtienda());
                    
                    List <Producto> listProductosTemp = new ArrayList<Producto>();
                    Producto productoTemp = new Producto();
                    productoTemp.setIdproducto(productoTiendaCadena.getProducto().getIdproducto());
                    productoTemp.setNombre(productoTiendaCadena.getProducto().getNombre());
                    productoTemp.setDetalle(productoTiendaCadena.getProducto().getDetalle());
                    productoTemp.setValor(productoTiendaCadena.getValor());
                    productoTemp.setDireccionImagen(productoTiendaCadena.getProducto().getDireccionImagen());
                    listProductosTemp.add(productoTemp);
                    
                    productosxTiendaUtil.setListaProductos(listProductosTemp);
                    productosxTiendaUtil.setValor(productoTiendaCadena.getValor());
                    tiendasyProductosTiendas.put(productoTiendaCadena.getTienda().getIdtienda(), productosxTiendaUtil);
                }else{
                    Producto productoTemp = new Producto();
                    productoTemp.setIdproducto(productoTiendaCadena.getProducto().getIdproducto());
                    productoTemp.setNombre(productoTiendaCadena.getProducto().getNombre());
                    productoTemp.setDetalle(productoTiendaCadena.getProducto().getDetalle());
                    productoTemp.setValor(productoTiendaCadena.getValor());
                    productoTemp.setDireccionImagen(productoTiendaCadena.getProducto().getDireccionImagen());
                    
                    productosxTiendaUtilHash.setValor(productosxTiendaUtilHash.getValor()+productoTiendaCadena.getValor());
                    productosxTiendaUtilHash.getListaProductos().add(productoTemp);
                }
            }
            */
        return tiendasyProductosTiendas;
    }
    
    public List<ProductosxTiendaUtil> ordenarAlista(Hashtable<Integer, ProductosxTiendaUtil> tiendasyProductosTiendas,final Integer orden,Integer maximo){
        List<ProductosxTiendaUtil> listProductosxTiendaUtil = new ArrayList<ProductosxTiendaUtil>(tiendasyProductosTiendas.values());
        Integer posicion = 1;
        
        Collections.sort(listProductosxTiendaUtil, new Comparator(){
                @Override
                public int compare(Object o1, Object o2) {
                    ProductosxTiendaUtil p1 = (ProductosxTiendaUtil)o1;
                    ProductosxTiendaUtil p2 = (ProductosxTiendaUtil)o2;
                    if(orden == 1){
                        return p1.getValor().compareTo(p2.getValor());
                    }else{
                        return p2.getValor().compareTo(p1.getValor());
                    }
                }
            }
        );
        
        if(listProductosxTiendaUtil.size()<=maximo){
            for(ProductosxTiendaUtil productosxTiendaUtil : listProductosxTiendaUtil){
                productosxTiendaUtil.setPosicion(posicion);
                posicion++;
            }
            return listProductosxTiendaUtil;
        }else{
            List<ProductosxTiendaUtil> listaTemp = new ArrayList<ProductosxTiendaUtil>();
            for(int x=0;maximo>x;x++){
                ProductosxTiendaUtil productosxTiendaUtil = listProductosxTiendaUtil.get(x);
                productosxTiendaUtil.setPosicion(posicion);
                listaTemp.add(productosxTiendaUtil);
                posicion++;
            }
            return listaTemp;
        }
        
    }

    
}
