package webScraping;

import modelos.Categoria;
import modelos.Producto;
import modelos.ProductoTienda;
import modelos.ProductoTwebscrHist;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.internal.SessionImpl;
import servicios.AdminCategoriasImplementacion;
import servicios.AdminProductoTiendaImplementacion;
import servicios.AdminProductos;
import servicios.Funciones;
import java.awt.Image;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import java.io.IOException;
import java.math.BigInteger;
import java.net.URL;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;


public class unificarProduct {
    private final Funciones funciones = new Funciones();





    public void EjecutaScript(List<String> scripts) throws SQLException {

        Boolean error = true;

        Integer cont = new Integer(0);

        while (error == true) {
            ++cont;

            Session conexionr = funciones.getConexion();
            java.sql.Connection connectionr = ((SessionImpl) conexionr).connection();
            Transaction txfr = conexionr.beginTransaction();
            Statement statementr = null;
            try {

                statementr = connectionr.createStatement();
                for (String scr : scripts) {
                    statementr.addBatch(scr);
                }
                statementr.executeBatch();
                txfr.commit();
                error = false;

            } catch (SQLException e) {
                error = true;

            } finally {
                statementr.close();
                connectionr.close();
                conexionr.close();
                if (cont >= 10) {
                    error = false;

                }
            }

        }


    }

    public Integer findIdproductoProductoTiendaByCodigo(String cod, Integer idtienda, List<ProductoTienda> lista) {
        for (int i = 0; i < lista.size(); i++) {
            ProductoTienda prod = lista.get(i);

            if ((prod.getCodigotienda().equals(cod)) && (prod.getTienda().getIdtienda() == idtienda)) {
                return prod.getProducto().getIdproducto();

            }
        }
        return null;
    }


    public Integer findIdproductoProductoTiendaByCodigoSimilar(String cod, Integer idtienda, List<ProductoTienda> lista) {
        for (int i = 0; i < lista.size(); i++) {
            ProductoTienda prod = lista.get(i);

            if ((idtienda == 1) || (idtienda == 5)) {
                if ((prod.getCodigotienda().equals(cod)) && ((prod.getTienda().getIdtienda() == 1) || (prod.getTienda().getIdtienda() == 5))) {
                    return prod.getProducto().getIdproducto();
                }
            } else {
                if ((prod.getCodigotienda().equals(cod)) && (prod.getTienda().getIdtienda() == idtienda)) {
                    return prod.getProducto().getIdproducto();
                }
            }
        }
        return null;
    }


    public void copiarProduct(BigInteger idtareaexito, BigInteger idtareacarull, BigInteger idtareaolimpica, BigInteger idtareajumbo)  {
        List<Categoria> cattot = new ArrayList<>();
        AdminCategoriasImplementacion admCat = new AdminCategoriasImplementacion();
        cattot = admCat.getCategoriasxLimite(1000);

        for (int x = 0; x < cattot.size(); x++) {
            copiarProductCat(idtareaexito, idtareacarull, idtareaolimpica, idtareajumbo, cattot.get(x).getIdcategoria());
        }

        //copiarProductCat(idtareaexito, idtareacarull, idtareaolimpica, idtareajumbo, 3);



    }

    private static double getDifferencePercent(BufferedImage img1, BufferedImage img2) {
        int width = img1.getWidth();
        int height = img1.getHeight();
        int width2 = img2.getWidth();
        int height2 = img2.getHeight();
        if (width != width2 || height != height2) {
            throw new IllegalArgumentException(String.format("Images must have the same dimensions: (%d,%d) vs. (%d,%d)", width, height, width2, height2));
        }

        long diff = 0;
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                diff += pixelDiff(img1.getRGB(x, y), img2.getRGB(x, y));
            }
        }
        long maxDiff = 3L * 255 * width * height;

        return 100.0 * diff / maxDiff;
    }

    private static int pixelDiff(int rgb1, int rgb2) {
        int r1 = (rgb1 >> 16) & 0xff;
        int g1 = (rgb1 >> 8) & 0xff;
        int b1 = rgb1 & 0xff;
        int r2 = (rgb2 >> 16) & 0xff;
        int g2 = (rgb2 >> 8) & 0xff;
        int b2 = rgb2 & 0xff;
        return Math.abs(r1 - r2) + Math.abs(g1 - g2) + Math.abs(b1 - b2);
    }

    public BufferedImage resizeimage(BufferedImage sourceImage) {
        Image thumbnail = sourceImage.getScaledInstance(160, -1, Image.SCALE_SMOOTH);
        BufferedImage bufferedThumbnail = new BufferedImage(thumbnail.getWidth(null),
                thumbnail.getHeight(null),
                BufferedImage.TYPE_INT_RGB);

        bufferedThumbnail.getGraphics().drawImage(thumbnail, 0, 0, null);

        //  ImageIO.write(bufferedThumbnail, "jpeg", outputStream);
        return bufferedThumbnail;
    }


    public void copiarProductCat(BigInteger idtareaexito, BigInteger idtareacarull, BigInteger idtareaolimpica, BigInteger idtareajumbo, Integer idcat)  {
        String script = "";
        String seq = "";
        AdminProductos admPr = new AdminProductos();
        List<Producto> todos = admPr.traerTodosProductosxcategoria(idcat);

        AdminProductoTiendaImplementacion admPrTiend = new AdminProductoTiendaImplementacion();
        List<ProductoTienda> todosTienda = admPrTiend.getProductoTiendaCopiar();

        List<ProductoTwebscrHist> todosExitoCarulla = admPrTiend.getProductosTareaCatExitoCarulla(idcat);
        List<ProductoTwebscrHist> todosOlimpica = admPrTiend.getProductosTareaCatSingle(idtareaolimpica, idcat);
        List<ProductoTwebscrHist> todosJumbo = admPrTiend.getProductosTareaCatSingle(idtareajumbo, idcat);

        List<String> scripts = new ArrayList<>();
        BufferedImage imageexit = null;
        BufferedImage imageolim = null;
        BufferedImage imagejumb = null;
        for (int x = 0; x < todosExitoCarulla.size(); x++) {
            ProductoTwebscrHist prod = todosExitoCarulla.get(x);

            try {
                URL urlex = new URL(prod.getDireccionImagen());
                imageexit = ImageIO.read(urlex);
                imageexit = resizeimage(imageexit);
                //ImageIO.write(imageexit, "jpg", new File("/tmp/imageexito.jpg"));
            } catch (IOException e) {
            }

            String nombreex = prod.getNombre();
            for (int y = 0; y < todosOlimpica.size(); y++) {
                ProductoTwebscrHist prodol = todosOlimpica.get(x);


                try {
                    URL urlol = new URL(prodol.getDireccionImagen());
                    imageolim = ImageIO.read(urlol);
                    imageolim = resizeimage(imageolim);
                    //ImageIO.write(imageolim, "jpg", new File("/tmp/imageolimp.jpg"));
                    Double dif=getDifferencePercent(imageexit, imageolim);
                    imageolim.flush();
                    if (dif <= 7) {
                        String nombreol = prodol.getNombre();
                        String nombreol2 = prodol.getNombre();
                    }

                } catch (IOException e) {
                }


            }
            for (int z = 0; z < todosJumbo.size(); z++) {
                ProductoTwebscrHist prodjum = todosJumbo.get(x);

                try {
                    URL urlju = new URL(prodjum.getDireccionImagen());
                    imagejumb = ImageIO.read(urlju);
                    imagejumb = resizeimage(imagejumb);
                    //ImageIO.write(imagejumb, "jpg", new File("/tmp/imagejumb.jpg"));
                    Double dif=getDifferencePercent(imageexit, imagejumb);
                    imagejumb.flush();
                    if (dif <= 7) {
                        String nombreju = prodjum.getNombre();
                        String nombreju2 = prodjum.getNombre();
                    }
                } catch (IOException e) {
                }

            }
            imageexit.flush();


           /*

            Integer idprod = findIdproductoProductoTiendaByCodigoSimilar(prod.getCodigotienda(), idtienda, todosTienda);

            if (idprod != null) {
                script = " UPDATE public.producto SET direccion_imagen='" + prod.getDireccionImagen().replace("'", "''") + "' where idproducto=" + idprod + ";";
                scripts.add(script);
                script = " UPDATE public.productoxcategoria SET valor=" + prod.getPrecio() + ", valor_unidad=" + prod.getPrecio() + ",categoria_idcategotia=" + prod.getIdcategoria() + " where producto_idproducto=" + idprod + ";";
                scripts.add(script);

            } else {
                Session conexion = funciones.getConexion();
                seq = "SELECT nextval('producto_idproducto_seq') AS CONSECUTIVO";
                Iterator<BigInteger> iter;
                iter = (Iterator<BigInteger>) conexion.createSQLQuery(seq).list().iterator();
                idprod = iter.next().intValue();
                conexion.close();

                String imagen = prod.getDireccionImagen();

                script = " INSERT INTO public.producto(idproducto,nombre,detalle,direccion_imagen) " +
                        " values (" + idprod + ",'" + prod.getNombre().replace("'", "''") + "','" + prod.getDetalle().replace("'", "''") + "','" + prod.getDireccionImagen().replace("'", "''") + "'" + ");";
                scripts.add(script);

                script = " INSERT INTO public.productoxcategoria(producto_idproducto,categoria_idcategotia,valor,valor_unidad) " +
                        " values (" + idprod + "," + prod.getIdcategoria() + "," + prod.getPrecio() + "," + prod.getPrecio() + ");";
                scripts.add(script);

            }
            Integer idprodT = null;

            idprodT = findIdproductoProductoTiendaByCodigo(prod.getNombre(), idtienda, todosTienda);

            if (idprodT == null) {
                script = " INSERT INTO public.producto_tienda(producto_idproducto,tienda_idtienda,nombre,valor,valor_unidad,estado,codigotienda)" +
                        " values (" + idprod + "," + idtienda + ",'" + prod.getNombre().replace("'", "''") + "'," + prod.getPrecio() + "," + prod.getPrecio() + ",true,'" + prod.getCodigotienda().replace("'", "''") + "');";
                scripts.add(script);
            } else {
                script = " UPDATE public.producto_tienda set nombre='" + prod.getNombre().replace("'", "''") + "',codigotienda ='" + prod.getCodigotienda().replace("'", "''") + "',valor = " + prod.getPrecio() + " , valor_unidad=" + prod.getPrecio() + ", estado = true where producto_idproducto=" + idprod + " and tienda_idtienda = " + idtienda + ";";
                scripts.add(script);

            }*/


        }
    /*    if (scripts.isEmpty() == false) {


            Integer nuact = 0;
            Integer cantscripts = 500;
            Integer nufin = 0;

            while (nuact <= scripts.size()) {
                List<String> scriptsloc = new ArrayList<>();
                nufin = nuact + cantscripts;
                if (nufin > scripts.size())
                    nufin = scripts.size();

                scriptsloc = scripts.subList(nuact, nufin);
                EjecutaScript(scriptsloc);
                nuact = nuact + cantscripts;
            }

        }*/

    }
}
