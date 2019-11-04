/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servicios;

import org.hibernate.Hibernate;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;


/**
 * @author
 */
public class Funciones {

    SessionFactory sesionFactory;
    Session conexion;

    public Funciones() {
    }

    public Session getConexion() {
            try {

                sesionFactory = HibernateUtil.getSessionFactory();
                conexion = sesionFactory.openSession();
            } catch (Exception e) {
                sesionFactory = HibernateUtil.getSessionFactory();
                conexion = sesionFactory.openSession();
            }


        return conexion;
    }

    public Transaction getTransaccion() {
        Integer id = (int) (Math.random() * 1000000) + 1;
        Hibernate.initialize(id);
        Transaction trans = conexion.getTransaction();
        return trans;
    }

}
