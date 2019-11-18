/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controladores;


import interfaces.WebScrappingInterface;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import servicios.AdminWebScrappersImplementacion;

import java.math.BigInteger;

/**
 *
 * @author andres
 */
@Controller
public class AdminScrapingControlador {

    public AdminScrapingControlador() {
    }


    @RequestMapping(value = "/getWebScrapingTodos", method = RequestMethod.GET)
    @ResponseBody
    public String getWebScrapingTodos() throws Exception {
        Thread thread = new Thread() {
            public void run() {
                //WebScrappingInterface wse = new AdminWebScrappersImplementacion();
                //wse.webScrappingExito(new Integer(2));

                //WebScrappingInterface wsc = new AdminWebScrappersImplementacion();
                //wsc.webScrappingCarulla(new Integer(17));

                //WebScrappingInterface wso = new AdminWebScrappersImplementacion();
                //wso.webScrappingOlimpica(new Integer(22));

                WebScrappingInterface wsj = new AdminWebScrappersImplementacion();
                wsj.webScrappingJumbo(new Integer(21));

            }
        };
        thread.start();
        return "WebScrapers Iniciados Satisfactoriamente";
    }



    @RequestMapping(value = "/getWebScrapingCarulla", method = RequestMethod.GET)
    @ResponseBody
    public String getWebScrappingCarulla(@RequestParam(name = "idalmacen" , required = true) final Integer idalmacen) throws Exception {
        Thread thread = new Thread() {
            public void run() {
                WebScrappingInterface wsc = new AdminWebScrappersImplementacion();
                wsc.webScrappingCarulla(idalmacen);
            }
        };
        thread.start();
        return "WebScraper Iniciado Satisfactoriamente";
    }

    @RequestMapping(value = "/getWebScrapingExito", method = RequestMethod.GET)
    @ResponseBody
    public String getWebScrappingExito(@RequestParam(name = "idalmacen" , required = true) final Integer idalmacen) throws Exception {
        Thread thread = new Thread() {
            public void run() {
                WebScrappingInterface wse = new AdminWebScrappersImplementacion();
                wse.webScrappingExito(idalmacen);
            }
        };
        thread.start();
        return "WebScraper Iniciado Satisfactoriamente";
    }
    
    @RequestMapping(value = "/getWebScrapingJumbo", method = RequestMethod.GET)
    @ResponseBody
    public String getWebScrappingJumbo(@RequestParam(name = "idalmacen" , required = true) final Integer idalmacen) throws Exception {
        Thread thread = new Thread() {
            public void run() {
                WebScrappingInterface wsj = new AdminWebScrappersImplementacion();
                wsj.webScrappingJumbo(idalmacen);
            }
        };
        thread.start();
        return "WebScraper Iniciado Satisfactoriamente";
    }
    
    
    @RequestMapping(value = "/getWebScrapingOlimpica", method = RequestMethod.GET)
    @ResponseBody
    public String getWebScrapingOlimpica(@RequestParam(name = "idalmacen" , required = true) final Integer idalmacen) throws Exception {
        Thread thread = new Thread() {
            public void run() {
                WebScrappingInterface wso = new AdminWebScrappersImplementacion();
                wso.webScrappingOlimpica(idalmacen);
            }
        };
        thread.start();
        return "WebScraper Iniciado Satisfactoriamente";
    }


    @RequestMapping(value = "/getWebScrapingUnificarproductos", method = RequestMethod.GET)
    @ResponseBody
    public String getWebScrapingUnificarproductos(@RequestParam(name = "idtareaexito" , required = true) final BigInteger idtareaexito,@RequestParam(name = "idtareacarull" , required = true) final BigInteger idtareacarull,@RequestParam(name = "idtareaoli" , required = true) final BigInteger idtareaoli,@RequestParam(name = "idtareajumb" , required = true) final BigInteger idtareajumb) throws Exception {
        Thread thread = new Thread() {
            public void run() {
                WebScrappingInterface wsc = new AdminWebScrappersImplementacion();
                wsc.unificarproductos(idtareaexito,idtareacarull,idtareaoli,idtareajumb);
            }
        };
        thread.start();
        return "Tarea Unificar productos Iniciada Satisfactoriamente";
    }

}
