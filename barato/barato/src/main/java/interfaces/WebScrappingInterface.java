/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package interfaces;


import java.math.BigInteger;

/**
 *
 * @author 
 */
public interface WebScrappingInterface {
    
    public String webScrappingCarulla(Integer idmunicipio);
    
    public String webScrappingExito(Integer idalmacen);
    
    public String webScrappingJumbo(Integer idalmacen);
    
    public String webScrappingOlimpica(Integer idalmacen);

    public String unificarproductos(BigInteger idtareaexito,BigInteger idtareacarull,BigInteger idtareaoli,BigInteger idtareajumb);
}
