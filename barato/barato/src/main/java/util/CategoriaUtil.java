/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package util;

import modelos.Categoria;
import modelos.Producto;

import java.util.List;

/**
 *
 * @author marti
 */
public class CategoriaUtil {
    Categoria Categoria;
    List<Producto> listProducto;

    public CategoriaUtil(Categoria Categoria, List<Producto> listProducto) {
        this.Categoria = Categoria;
        this.listProducto = listProducto;
    }

    public Categoria getCategoria() {
        return Categoria;
    }

    public void setCategoria(Categoria Categoria) {
        this.Categoria = Categoria;
    }

    public List<Producto> getListProducto() {
        return listProducto;
    }

    public void setListProducto(List<Producto> listProducto) {
        this.listProducto = listProducto;
    }
    
    
    
}
