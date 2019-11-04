/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package util;

import modelos.Producto;

import java.util.List;

/**
 *
 * @author marti
 */
public class ProductosxTiendaUtil {
    String nombreTienda;
    Integer idTienda;
    List<Producto> listaProductos;
    Double valor;
    Integer posicion;

    public ProductosxTiendaUtil() {
    }

    public ProductosxTiendaUtil(String nombreTienda, Integer idTienda, List<Producto> listaProductos, Double valor, Integer posicion) {
        this.nombreTienda = nombreTienda;
        this.idTienda = idTienda;
        this.listaProductos = listaProductos;
        this.valor = valor;
        this.posicion = posicion;
    }

    public String getNombreTienda() {
        return nombreTienda;
    }

    public void setNombreTienda(String nombreTienda) {
        this.nombreTienda = nombreTienda;
    }

    public Integer getIdTienda() {
        return idTienda;
    }

    public void setIdTienda(Integer idTienda) {
        this.idTienda = idTienda;
    }

    public List<Producto> getListaProductos() {
        return listaProductos;
    }

    public void setListaProductos(List<Producto> listaProductos) {
        this.listaProductos = listaProductos;
    }

    public Double getValor() {
        return valor;
    }

    public void setValor(Double valor) {
        this.valor = valor;
    }

    public Integer getPosicion() {
        return posicion;
    }

    public void setPosicion(Integer posicion) {
        this.posicion = posicion;
    }

   
    
}
