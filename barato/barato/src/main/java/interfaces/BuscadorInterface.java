/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package interfaces;

import java.util.Date;
import java.util.List;

import modelos.*;
import org.jsoup.nodes.Document;

/**
 *
 * @author Soporte-AITE
 */
public interface BuscadorInterface {
    int getStatusConnectionCode(String url);   
    Document getHtmlDocument(String url);    
    List<SubPagina> getPaginas();
    List<ListaProducto> getListaProducto(Integer idLista );
    List<Lista> getListasUsuario(long idUsuario );
    Boolean guardarProductosLista( ListaProducto producto );
    Lista getLista( long idlista );
    Lista getLista( Date fecha );
    List<Categoria> getCategorias( );
    List<Subcategoria> getSubcategorias(long idSubcategoria);
    Boolean guardarLista(Lista lista);
}
