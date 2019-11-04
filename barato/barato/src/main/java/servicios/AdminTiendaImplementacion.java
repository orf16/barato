/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servicios;

import java.util.List;


import modelos.Tienda;
import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.stereotype.Service;
import interfaces.AdminTiendaInterface;



/**
 *
 * @author 
 */

@Service("TiendaInterface")
public class AdminTiendaImplementacion implements AdminTiendaInterface{
    
    private final Funciones funciones = new Funciones();


    @Override
    public List<Tienda> buscarTiendas( ) {
        Session conexion = funciones.getConexion();

        Query consulta = conexion.createQuery("FROM modelos.Tienda" );
        List <Tienda> tiendaList = consulta.list();
        conexion.close();
        return tiendaList;       
    }
}
