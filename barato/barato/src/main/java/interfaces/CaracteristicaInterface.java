/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package interfaces;

import modelos.Caracteristica;

import java.util.List;
/**
 *
 * @author orf16
 */
public interface CaracteristicaInterface {
    public List <Caracteristica> obtenerCaracteristica(Integer id);
    public List <Caracteristica> obtenerCategoriasProductos();
}
