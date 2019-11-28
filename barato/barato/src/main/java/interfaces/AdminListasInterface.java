/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package interfaces;

import modelos.Lista;
import modelos.ListaProducto;
import modelos.ListasCompartidas;
import modelos.Usuario;

import java.util.List;
import modelos.ListaNew;
import modelos.ListaProductoNew;

/**
 *
 * @author 
 */
public interface AdminListasInterface {
    
    public Boolean crearListas(Lista lista);
    public Boolean crearListaProducto(ListaProducto listaProducto);
    public Boolean actualizarLista(Lista lista);
    public Boolean eliminarListaProducto(Integer idLista);
    public Lista getLista(Integer id); //Buscar por identificador de la tabla    
    public List<ListasCompartidas> getListaShared(String emailUser); //Buscar por identificador de la tabla
    public List<ListasCompartidas> getListaShared(Integer idLista); //Buscar por identificador de la tabla    
    public boolean compartirLista(Usuario usuario, Lista lista, String emailUsers); //Compartir Lista
    public boolean eliminarCompartirLista( Integer idUsuario, Integer idLista, String emailUsers); //Eliminar Lista comparti
    public boolean eliminarLista( Integer idLista ); //Eliminar Lista
    public boolean eliminarCompartirLista( Integer idLista); 
    public boolean crearListasNew(ListaNew lista);
    public ListaNew buscarUsuarioNew(String idnew);
    public boolean crearListasProductoNew(ListaProductoNew lista);
    public List<ListaProductoNew> traerListaProdNew(String lista);
    public boolean EliminarDeListasProductoNew(String usuario, Integer Producto);
}
