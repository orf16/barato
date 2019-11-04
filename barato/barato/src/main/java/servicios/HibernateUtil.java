package servicios;/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


import javax.imageio.spi.ServiceRegistry;

import modelos.Tienda;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.boot.registry.StandardServiceRegistry;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.hibernate.cfg.Configuration;
import org.hibernate.cfg.Environment;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.boot.autoconfigure.domain.EntityScanner;

import java.util.*;

/**
 * Hibernate Utility class with a convenient method to get Session Factory
 * object.
 *
 * @author rafael
 */
public class HibernateUtil {


    private static StandardServiceRegistry registry;
    private static SessionFactory sessionFactory;

    public static SessionFactory getSessionFactory() {

            try {

                if (sessionFactory == null) {



               /*     StandardServiceRegistryBuilder registryBuilder = new StandardServiceRegistryBuilder();


                    //Configuration properties
                    Map<String, Object> settings = new HashMap<>();
                    settings.put(Environment.DIALECT, "org.hibernate.dialect.PostgreSQL9Dialect");
                    settings.put(Environment.DRIVER, "org.postgresql.Driver");
                    settings.put(Environment.URL, "jdbc:postgresql://localhost:5432/metabuscador");
                    settings.put(Environment.USER, "beyodntest");
                    settings.put(Environment.PASS, "metabyd2018");
                    settings.put(Environment.HBM2DDL_AUTO, "validate");
                    settings.put(Environment.SHOW_SQL, true);

                    registryBuilder.applySettings(settings);
                    registry = registryBuilder.build();*/

                    Configuration configuration = new Configuration().configure();

                    StandardServiceRegistry serviceRegistry = new StandardServiceRegistryBuilder().applySettings(configuration.getProperties()).build();
                    // builds a session factory from the service registry
                    sessionFactory = configuration.buildSessionFactory(serviceRegistry);







                }
            } catch (Throwable th) {
                System.err.println("Enitial SessionFactory creation failed" + th);
                throw new ExceptionInInitializerError(th);
            }
            return sessionFactory;
        }


}
