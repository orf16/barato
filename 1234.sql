PGDMP     8    *            
    w            metabuscador    10.8    10.8 �    a           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            b           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            c           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false            d           1262    24961    metabuscador    DATABASE     �   CREATE DATABASE metabuscador WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Spanish_Spain.1252' LC_CTYPE = 'Spanish_Spain.1252';
    DROP DATABASE metabuscador;
             postgres    false            e           0    0    DATABASE metabuscador    COMMENT     n   COMMENT ON DATABASE metabuscador IS 'Base de datos inicial del metabuscador que sera usado en la aplicacion';
                  postgres    false    3172                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             postgres    false            f           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  postgres    false    6                        3079    12924    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false            g           0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1                        3079    41419    fuzzystrmatch 	   EXTENSION     A   CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;
    DROP EXTENSION fuzzystrmatch;
                  false    6            h           0    0    EXTENSION fuzzystrmatch    COMMENT     ]   COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';
                       false    2                        3079    41354    pg_trgm 	   EXTENSION     ;   CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;
    DROP EXTENSION pg_trgm;
                  false    6            i           0    0    EXTENSION pg_trgm    COMMENT     e   COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';
                       false    3                        3079    24962    unaccent 	   EXTENSION     <   CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;
    DROP EXTENSION unaccent;
                  false    6            j           0    0    EXTENSION unaccent    COMMENT     P   COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';
                       false    4            #           1255    24969    copiarproductos(bigint)    FUNCTION     �
  CREATE FUNCTION public.copiarproductos(id_tarea bigint) RETURNS void
    LANGUAGE plpgsql
    AS $$declare
idProdl BIGINT;
cantidad integer;
idtienda integer;
nombrel character varying(255); 
idMaxproducto BIGINT;
reg          RECORD;
cur_productos CURSOR FOR SELECT * FROM producto_twebscr_hist
				where "idtarea"=ID_Tarea and "precio" > 0 order by "nombre";
begin
	/*	

idtienda:=(select a."idtienda" as id from "almacen" a
where a.idalmacen = (select idalmacen from tareawebscraper where "idtarea"=ID_Tarea));

UPDATE producto_tienda set estado=false
 where tienda_idtienda = idtienda;					 

 FOR reg IN cur_productos LOOP
 
 nombrel:=reg.nombre; 
idProdl:=NULL;

	idProdl:=(select p."producto_idproducto" as id from "producto_tienda" p
	where p."codigotienda" = reg.codigotienda and p."tienda_idtienda"= idtienda);	
						 
	IF idProdl IS NULL THEN					 
		IF (idtienda = 1) THEN
			idProdl:=(select p."producto_idproducto" as id from "producto_tienda" p
			where p."codigotienda" = reg.codigotienda and p."tienda_idtienda"= 5);
		END IF;	
		IF (idtienda = 5) THEN
			idProdl:=(select p."producto_idproducto" as id from "producto_tienda" p
			where p."codigotienda" = reg.codigotienda and p."tienda_idtienda"= 1);
		END IF;	
	END IF;
					 

					 
						   
								   

IF idProdl IS NULL THEN
								   
idProdl:=(SELECT nextval('producto_idproducto_seq'));
INSERT INTO producto(idproducto,nombre,detalle,direccion_imagen)
values (idProdl,reg.nombre,reg.detalle,reg.direccion_imagen);

INSERT INTO productoxcategoria(producto_idproducto,categoria_idcategotia,valor,valor_unidad)
values(idProdl,reg.idcategoria,reg.precio,reg.precio);
						 
ELSE
						 
/*UPDATE producto SET nombre=reg.nombre,direccion_imagen=reg.direccion_imagen where idproducto=idProdl;*/
UPDATE producto SET direccion_imagen=reg.direccion_imagen where idproducto=idProdl;							 
UPDATE productoxcategoria SET valor=reg.precio, valor_unidad=reg.precio,categoria_idcategotia=reg.idcategoria where producto_idproducto=idProdl;
					 
END IF;
						 
				 
 cantidad:=(select count(1) from "producto_tienda" t
where t.producto_idproducto = idProdl and tienda_idtienda = idtienda );

IF cantidad > 0  THEN
						 
UPDATE producto_tienda set nombre=reg.nombre,codigotienda = reg.codigotienda,valor = reg.precio , valor_unidad=reg.precio, estado = true
where producto_idproducto = idProdl and tienda_idtienda = idtienda;					 

ELSE

INSERT INTO producto_tienda(producto_idproducto,tienda_idtienda,nombre,valor,valor_unidad,estado,codigotienda)
VALUES(idProdl,idtienda,reg.nombre,reg.precio,reg.precio,true,reg.codigotienda);						 
END IF;	
						 
				 
					 
END LOOP;
						 
UPDATE public.tareawebscraper set productoscopiados=true WHERE "idtarea"=ID_Tarea;
	
*/						 
end
$$;
 7   DROP FUNCTION public.copiarproductos(id_tarea bigint);
       public    
   beyodntest    false    6    1            $           1255    24970    sp_tr_insert_detail()    FUNCTION     �  CREATE FUNCTION public.sp_tr_insert_detail() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
Declare
	fechacreada timestamp :=current_timestamp;
	chrly CURSOR for SELECT idproducto, nombre, detalle, direccion_imagen, lista_predeterminada FROM producto WHERE lista_predeterminada= 1;
begin

IF NEW.nombrelista = 'Lista Predeterminada' then
    FOR chrly_rec IN chrly
    LOOP
    insert into lista_producto (idlista, nombreproducto, descripcionproducto, url, fechaagregado, producto_idproducto)
    values (new.idlista ,chrly_rec.nombre, chrly_rec.detalle, chrly_rec.direccion_imagen,fechacreada,chrly_rec.idproducto);  
    END LOOP;
END IF;
return NEW;
End
$$;
 ,   DROP FUNCTION public.sp_tr_insert_detail();
       public    
   beyodntest    false    1    6            %           1255    24971    sp_tr_insert_user()    FUNCTION     n  CREATE FUNCTION public.sp_tr_insert_user() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
Declare

	fechacreada timestamp :=current_timestamp;
	estado integer :=32767;
	nombrelista varchar :='Lista Predeterminada';

begin

Insert into lista(fechacreada, estado, idusuario, nombrelista) values (fechacreada, estado, new.idusuario, nombrelista);
 return new;

End
$$;
 *   DROP FUNCTION public.sp_tr_insert_user();
       public    
   beyodntest    false    6    1            �            1259    24972    almacen    TABLE     �   CREATE TABLE public.almacen (
    idalmacen integer NOT NULL,
    idtienda integer NOT NULL,
    nombre character varying(255) NOT NULL,
    idmunicipio integer
);
    DROP TABLE public.almacen;
       public      
   beyodntest    false    6            �            1259    24975    almacen_idalmacen_seq    SEQUENCE     �   CREATE SEQUENCE public.almacen_idalmacen_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.almacen_idalmacen_seq;
       public    
   beyodntest    false    6    199            k           0    0    almacen_idalmacen_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.almacen_idalmacen_seq OWNED BY public.almacen.idalmacen;
            public    
   beyodntest    false    200            �            1259    25305    caracteristica    TABLE     �   CREATE TABLE public.caracteristica (
    id integer NOT NULL,
    id_tipo integer NOT NULL,
    caracteristica text NOT NULL,
    alias text,
    idpadre integer,
    mostrar boolean,
    imagen character varying(500)
);
 "   DROP TABLE public.caracteristica;
       public         postgres    false    6            �            1259    24977    sidcategoria    SEQUENCE     u   CREATE SEQUENCE public.sidcategoria
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.sidcategoria;
       public    
   beyodntest    false    6            �            1259    24979 	   categoria    TABLE     �   CREATE TABLE public.categoria (
    idcategoria integer DEFAULT nextval('public.sidcategoria'::regclass) NOT NULL,
    nombre text,
    abreviatura text,
    direccion_imagen character varying(255)
);
    DROP TABLE public.categoria;
       public      
   beyodntest    false    201    6            �            1259    24986    siddepartamento    SEQUENCE     x   CREATE SEQUENCE public.siddepartamento
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.siddepartamento;
       public    
   beyodntest    false    6            �            1259    24988    departamento    TABLE     �   CREATE TABLE public.departamento (
    iddepartamento integer DEFAULT nextval('public.siddepartamento'::regclass) NOT NULL,
    indicativo smallint,
    estado smallint,
    nombredepartamento text
);
     DROP TABLE public.departamento;
       public      
   beyodntest    false    203    6            l           0    0    TABLE departamento    COMMENT     E   COMMENT ON TABLE public.departamento IS 'Departamentos de colombia';
            public    
   beyodntest    false    204            m           0    0 "   COLUMN departamento.iddepartamento    COMMENT     U   COMMENT ON COLUMN public.departamento.iddepartamento IS 'Identificador del sistema';
            public    
   beyodntest    false    204            n           0    0    COLUMN departamento.indicativo    COMMENT     S   COMMENT ON COLUMN public.departamento.indicativo IS 'Indicativo del departamento';
            public    
   beyodntest    false    204            o           0    0    COLUMN departamento.estado    COMMENT     K   COMMENT ON COLUMN public.departamento.estado IS 'Estado del departamento';
            public    
   beyodntest    false    204            p           0    0 &   COLUMN departamento.nombredepartamento    COMMENT     W   COMMENT ON COLUMN public.departamento.nombredepartamento IS 'Nombre del departamento';
            public    
   beyodntest    false    204            �            1259    33130    diccionario    TABLE     W   CREATE TABLE public.diccionario (
    id bigint NOT NULL,
    palabra text NOT NULL
);
    DROP TABLE public.diccionario;
       public         postgres    false    6            �            1259    33128    diccionario_id_seq    SEQUENCE     {   CREATE SEQUENCE public.diccionario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.diccionario_id_seq;
       public       postgres    false    240    6            q           0    0    diccionario_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.diccionario_id_seq OWNED BY public.diccionario.id;
            public       postgres    false    239            �            1259    24995    sidlista    SEQUENCE     q   CREATE SEQUENCE public.sidlista
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
    DROP SEQUENCE public.sidlista;
       public    
   beyodntest    false    6            �            1259    24997    lista    TABLE     6  CREATE TABLE public.lista (
    idlista integer DEFAULT nextval('public.sidlista'::regclass) NOT NULL,
    idusuariodireccion integer,
    fechacreada timestamp without time zone DEFAULT now(),
    estado smallint,
    idusuario integer,
    nombrelista character varying(20),
    key character varying(20)
);
    DROP TABLE public.lista;
       public      
   beyodntest    false    205    6            r           0    0    COLUMN lista.estado    COMMENT     P   COMMENT ON COLUMN public.lista.estado IS '1=Pendiente,2=Comprada,3=Recomprada';
            public    
   beyodntest    false    206            �            1259    42794 	   lista_new    TABLE     �   CREATE TABLE public.lista_new (
    id integer NOT NULL,
    fechacreada timestamp without time zone,
    idusuario character varying(50),
    nombrelista character varying(20)
);
    DROP TABLE public.lista_new;
       public         postgres    false    6            �            1259    42792    lista_new_id_seq    SEQUENCE     �   CREATE SEQUENCE public.lista_new_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.lista_new_id_seq;
       public       postgres    false    6    244            s           0    0    lista_new_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.lista_new_id_seq OWNED BY public.lista_new.id;
            public       postgres    false    243            �            1259    25002    sidlistaproducto    SEQUENCE     y   CREATE SEQUENCE public.sidlistaproducto
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.sidlistaproducto;
       public    
   beyodntest    false    6            �            1259    25004    lista_producto    TABLE     {  CREATE TABLE public.lista_producto (
    idlistaproducto integer DEFAULT nextval('public.sidlistaproducto'::regclass) NOT NULL,
    idlista integer,
    nombreproducto text,
    descripcionproducto text,
    precioproducto double precision,
    url text,
    direccionproducto text,
    fechaagregado timestamp without time zone DEFAULT now(),
    producto_idproducto integer
);
 "   DROP TABLE public.lista_producto;
       public      
   beyodntest    false    207    6            t           0    0 #   COLUMN lista_producto.fechaagregado    COMMENT     _   COMMENT ON COLUMN public.lista_producto.fechaagregado IS 'Fecha en que se agrega el producto';
            public    
   beyodntest    false    208            �            1259    42802    lista_producto_new    TABLE     �   CREATE TABLE public.lista_producto_new (
    id integer NOT NULL,
    idlista integer,
    idproducto integer,
    nombreproducto text,
    descripcion text,
    precioproducto text,
    url text,
    items integer,
    imagen text
);
 &   DROP TABLE public.lista_producto_new;
       public         postgres    false    6            �            1259    42800    lista_producto_new_id_seq    SEQUENCE     �   CREATE SEQUENCE public.lista_producto_new_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.lista_producto_new_id_seq;
       public       postgres    false    246    6            u           0    0    lista_producto_new_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.lista_producto_new_id_seq OWNED BY public.lista_producto_new.id;
            public       postgres    false    245            �            1259    25012    listas_compartidas    TABLE     �   CREATE TABLE public.listas_compartidas (
    idcompartida integer NOT NULL,
    idusuario integer,
    fechacompartido timestamp with time zone DEFAULT now(),
    idlista integer,
    emailuser character varying(255)
);
 &   DROP TABLE public.listas_compartidas;
       public      
   beyodntest    false    6            �            1259    25016    sidmunicipio    SEQUENCE     u   CREATE SEQUENCE public.sidmunicipio
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.sidmunicipio;
       public    
   beyodntest    false    6            �            1259    25018 	   municipio    TABLE     �   CREATE TABLE public.municipio (
    idmunicipio integer DEFAULT nextval('public.sidmunicipio'::regclass) NOT NULL,
    iddepartamento integer,
    nombremunicipio text,
    codigomunicipio text,
    estado smallint
);
    DROP TABLE public.municipio;
       public      
   beyodntest    false    210    6            v           0    0    TABLE municipio    COMMENT     @   COMMENT ON TABLE public.municipio IS 'Municipios de colombia	';
            public    
   beyodntest    false    211            w           0    0    COLUMN municipio.idmunicipio    COMMENT     O   COMMENT ON COLUMN public.municipio.idmunicipio IS 'Identificador de la tabla';
            public    
   beyodntest    false    211            x           0    0    COLUMN municipio.iddepartamento    COMMENT     v   COMMENT ON COLUMN public.municipio.iddepartamento IS 'Identificador del departamento al cual pertenece el municipio';
            public    
   beyodntest    false    211            y           0    0     COLUMN municipio.nombremunicipio    COMMENT     N   COMMENT ON COLUMN public.municipio.nombremunicipio IS 'Nombre del municipio';
            public    
   beyodntest    false    211            z           0    0     COLUMN municipio.codigomunicipio    COMMENT     _   COMMENT ON COLUMN public.municipio.codigomunicipio IS 'Codigo a nivel nacional del municipio';
            public    
   beyodntest    false    211            {           0    0    COLUMN municipio.estado    COMMENT     I   COMMENT ON COLUMN public.municipio.estado IS '1 = Activo, 2 = Inactivo';
            public    
   beyodntest    false    211            �            1259    25025 	   sidpagina    SEQUENCE     r   CREATE SEQUENCE public.sidpagina
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
     DROP SEQUENCE public.sidpagina;
       public    
   beyodntest    false    6            �            1259    25027    pagina    TABLE     �   CREATE TABLE public.pagina (
    idpagina integer DEFAULT nextval('public.sidpagina'::regclass) NOT NULL,
    nombreestablecimiento text,
    descripcion text
);
    DROP TABLE public.pagina;
       public      
   beyodntest    false    212    6            �            1259    25034    producto    TABLE     �   CREATE TABLE public.producto (
    idproducto integer NOT NULL,
    nombre character varying(255),
    detalle character varying(255),
    direccion_imagen character varying(255),
    lista_predeterminada integer
);
    DROP TABLE public.producto;
       public      
   beyodntest    false    6            �            1259    25040    producto_idproducto_seq    SEQUENCE     �   CREATE SEQUENCE public.producto_idproducto_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.producto_idproducto_seq;
       public    
   beyodntest    false    214    6            |           0    0    producto_idproducto_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.producto_idproducto_seq OWNED BY public.producto.idproducto;
            public    
   beyodntest    false    215            �            1259    25042    producto_tienda    TABLE     ,  CREATE TABLE public.producto_tienda (
    idproducto_tienda integer NOT NULL,
    producto_idproducto integer,
    tienda_idtienda integer,
    nombre character varying(255),
    valor double precision,
    valor_unidad double precision,
    estado boolean,
    codigotienda character varying(30)
);
 #   DROP TABLE public.producto_tienda;
       public      
   beyodntest    false    6            �            1259    25045    producto_tienda_cadena    TABLE       CREATE TABLE public.producto_tienda_cadena (
    idproducto_tienda_cadena integer NOT NULL,
    producto_idproducto integer,
    tienda_idtienda integer,
    nombre character varying(255),
    valor double precision,
    valor_unidad double precision,
    estado boolean
);
 *   DROP TABLE public.producto_tienda_cadena;
       public      
   beyodntest    false    6            �            1259    25048 3   producto_tienda_cadena_idproducto_tienda_cadena_seq    SEQUENCE     �   CREATE SEQUENCE public.producto_tienda_cadena_idproducto_tienda_cadena_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 J   DROP SEQUENCE public.producto_tienda_cadena_idproducto_tienda_cadena_seq;
       public    
   beyodntest    false    6    217            }           0    0 3   producto_tienda_cadena_idproducto_tienda_cadena_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public.producto_tienda_cadena_idproducto_tienda_cadena_seq OWNED BY public.producto_tienda_cadena.idproducto_tienda_cadena;
            public    
   beyodntest    false    218            �            1259    25050 %   producto_tienda_idproducto_tienda_seq    SEQUENCE     �   CREATE SEQUENCE public.producto_tienda_idproducto_tienda_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 <   DROP SEQUENCE public.producto_tienda_idproducto_tienda_seq;
       public    
   beyodntest    false    216    6            ~           0    0 %   producto_tienda_idproducto_tienda_seq    SEQUENCE OWNED BY     o   ALTER SEQUENCE public.producto_tienda_idproducto_tienda_seq OWNED BY public.producto_tienda.idproducto_tienda;
            public    
   beyodntest    false    219            �            1259    25300    producto_twebscr_car    TABLE     �   CREATE TABLE public.producto_twebscr_car (
    id integer NOT NULL,
    id_producto integer NOT NULL,
    id_car integer NOT NULL
);
 (   DROP TABLE public.producto_twebscr_car;
       public         postgres    false    6            �            1259    25052    producto_twebscr_hist    TABLE     '  CREATE TABLE public.producto_twebscr_hist (
    idproducto integer NOT NULL,
    nombre character varying(255),
    detalle character varying(255),
    fecha date DEFAULT now() NOT NULL,
    hora time without time zone DEFAULT now() NOT NULL,
    fechahora timestamp without time zone DEFAULT now(),
    idtarea bigint,
    direccion_imagen character varying(500),
    idcategoria integer,
    codigotienda character varying(30),
    descripcion text,
    precio double precision,
    url character varying(500),
    relacion character varying(20)
);
 )   DROP TABLE public.producto_twebscr_hist;
       public      
   beyodntest    false    6            �            1259    25061 $   producto_twebscr_hist_idproducto_seq    SEQUENCE     �   CREATE SEQUENCE public.producto_twebscr_hist_idproducto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ;   DROP SEQUENCE public.producto_twebscr_hist_idproducto_seq;
       public    
   beyodntest    false    220    6                       0    0 $   producto_twebscr_hist_idproducto_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE public.producto_twebscr_hist_idproducto_seq OWNED BY public.producto_twebscr_hist.idproducto;
            public    
   beyodntest    false    221            �            1259    25063    productoxcategoria    TABLE     �   CREATE TABLE public.productoxcategoria (
    producto_idproducto integer NOT NULL,
    categoria_idcategotia integer NOT NULL,
    valor double precision,
    valor_unidad double precision
);
 &   DROP TABLE public.productoxcategoria;
       public      
   beyodntest    false    6            �            1259    25066    sidlistacompartida    SEQUENCE     {   CREATE SEQUENCE public.sidlistacompartida
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.sidlistacompartida;
       public    
   beyodntest    false    6            �            1259    25068    sidsubcategoria    SEQUENCE     x   CREATE SEQUENCE public.sidsubcategoria
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.sidsubcategoria;
       public    
   beyodntest    false    6            �            1259    25070    sidsubpagina    SEQUENCE     u   CREATE SEQUENCE public.sidsubpagina
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.sidsubpagina;
       public    
   beyodntest    false    6            �            1259    25072 
   sidusuario    SEQUENCE     �   CREATE SEQUENCE public.sidusuario
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999999999999999
    CACHE 1;
 !   DROP SEQUENCE public.sidusuario;
       public    
   beyodntest    false    6            �            1259    25074    sidusuariodireccion    SEQUENCE     |   CREATE SEQUENCE public.sidusuariodireccion
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.sidusuariodireccion;
       public    
   beyodntest    false    6            �            1259    25076 
   sub_pagina    TABLE     �   CREATE TABLE public.sub_pagina (
    idsubpagina integer DEFAULT nextval('public.sidsubpagina'::regclass) NOT NULL,
    url text,
    idpagina integer,
    descripcion text
);
    DROP TABLE public.sub_pagina;
       public      
   beyodntest    false    225    6            �            1259    25083    subcategoria    TABLE     �   CREATE TABLE public.subcategoria (
    idsubcategoria integer DEFAULT nextval('public.sidsubcategoria'::regclass) NOT NULL,
    "nombreItem" text,
    idcategoria integer
);
     DROP TABLE public.subcategoria;
       public      
   beyodntest    false    224    6            �            1259    25090    tareawebscraper    TABLE       CREATE TABLE public.tareawebscraper (
    idtarea bigint NOT NULL,
    fechahoraini timestamp(4) without time zone DEFAULT now() NOT NULL,
    fechahorafin timestamp without time zone,
    cantidadproductos bigint,
    idalmacen integer,
    productoscopiados boolean DEFAULT false
);
 #   DROP TABLE public.tareawebscraper;
       public      
   beyodntest    false    6            �            1259    25095    tareawebscraper_idtarea_seq    SEQUENCE     �   CREATE SEQUENCE public.tareawebscraper_idtarea_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.tareawebscraper_idtarea_seq;
       public    
   beyodntest    false    230    6            �           0    0    tareawebscraper_idtarea_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.tareawebscraper_idtarea_seq OWNED BY public.tareawebscraper.idtarea;
            public    
   beyodntest    false    231            �            1259    25097    tienda    TABLE     V  CREATE TABLE public.tienda (
    idtienda integer NOT NULL,
    nombre character varying(255),
    detalle character varying(255),
    lugar character varying(255),
    lat double precision,
    lng double precision,
    place_id character varying,
    imagen character varying(255),
    url_web character varying(255),
    scr_id integer
);
    DROP TABLE public.tienda;
       public      
   beyodntest    false    6            �            1259    25103    tienda_idtienda_seq    SEQUENCE     |   CREATE SEQUENCE public.tienda_idtienda_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.tienda_idtienda_seq;
       public    
   beyodntest    false    232    6            �           0    0    tienda_idtienda_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.tienda_idtienda_seq OWNED BY public.tienda.idtienda;
            public    
   beyodntest    false    233            �            1259    25313    tipo_car    TABLE     `   CREATE TABLE public.tipo_car (
    id_car integer NOT NULL,
    caracteristica text NOT NULL
);
    DROP TABLE public.tipo_car;
       public         postgres    false    6            �            1259    25105    usuario    TABLE     �  CREATE TABLE public.usuario (
    idusuario integer DEFAULT nextval('public.sidusuario'::regclass) NOT NULL,
    nombre text NOT NULL,
    apellido text NOT NULL,
    email text NOT NULL,
    clave text,
    idtipodocumento integer,
    documento text,
    sexo smallint,
    estadocivil smallint,
    fechanacimiento date,
    telefono text NOT NULL,
    tipousuario smallint NOT NULL
);
    DROP TABLE public.usuario;
       public      
   beyodntest    false    226    6            �           0    0    TABLE usuario    COMMENT     @   COMMENT ON TABLE public.usuario IS 'Usuarios de la plataforma';
            public    
   beyodntest    false    234            �           0    0    COLUMN usuario.nombre    COMMENT     B   COMMENT ON COLUMN public.usuario.nombre IS 'Nombres del usuario';
            public    
   beyodntest    false    234            �           0    0    COLUMN usuario.apellido    COMMENT     F   COMMENT ON COLUMN public.usuario.apellido IS 'Apellidos del usuario';
            public    
   beyodntest    false    234            �           0    0    COLUMN usuario.email    COMMENT     L   COMMENT ON COLUMN public.usuario.email IS 'Correo electronico del usuario';
            public    
   beyodntest    false    234            �           0    0    COLUMN usuario.clave    COMMENT     M   COMMENT ON COLUMN public.usuario.clave IS 'Clave de acceso a la plataforma';
            public    
   beyodntest    false    234            �           0    0    COLUMN usuario.idtipodocumento    COMMENT     �   COMMENT ON COLUMN public.usuario.idtipodocumento IS '1=Cedula de Ciudadania,
2=Cedula de Extranjeria,
3=Registro civil de nacimiento,
4=Tarjeta de identidad,
5=NIT,
6=Otro';
            public    
   beyodntest    false    234            �           0    0    COLUMN usuario.documento    COMMENT     F   COMMENT ON COLUMN public.usuario.documento IS 'Numero del documento';
            public    
   beyodntest    false    234            �           0    0    COLUMN usuario.sexo    COMMENT     R   COMMENT ON COLUMN public.usuario.sexo IS '1 = Masculino, 2 = femenino, 3 = Otro';
            public    
   beyodntest    false    234            �           0    0    COLUMN usuario.estadocivil    COMMENT     e   COMMENT ON COLUMN public.usuario.estadocivil IS '1 = soltero, 2 = casado, 3 = divorciado, 4 = otro';
            public    
   beyodntest    false    234            �           0    0    COLUMN usuario.fechanacimiento    COMMENT     K   COMMENT ON COLUMN public.usuario.fechanacimiento IS 'fecha de nacimiento';
            public    
   beyodntest    false    234            �           0    0    COLUMN usuario.tipousuario    COMMENT     E   COMMENT ON COLUMN public.usuario.tipousuario IS '1=admin,2=cliente';
            public    
   beyodntest    false    234            �            1259    25112    usuario_direccion    TABLE     x  CREATE TABLE public.usuario_direccion (
    idusuariodireccion integer DEFAULT nextval('public.sidusuariodireccion'::regclass) NOT NULL,
    iddepartamento integer NOT NULL,
    idmunicipio integer NOT NULL,
    direccion text NOT NULL,
    nombredireccion text NOT NULL,
    idusuario integer NOT NULL,
    lat double precision NOT NULL,
    lng double precision NOT NULL
);
 %   DROP TABLE public.usuario_direccion;
       public      
   beyodntest    false    227    6            �           0    0    TABLE usuario_direccion    COMMENT     V   COMMENT ON TABLE public.usuario_direccion IS 'almacenar las direcciones del usuario';
            public    
   beyodntest    false    235            �           0    0 +   COLUMN usuario_direccion.idusuariodireccion    COMMENT     ^   COMMENT ON COLUMN public.usuario_direccion.idusuariodireccion IS 'identificador de la tabla';
            public    
   beyodntest    false    235            �           0    0 '   COLUMN usuario_direccion.iddepartamento    COMMENT     o   COMMENT ON COLUMN public.usuario_direccion.iddepartamento IS 'identificador del departamento de la direccion';
            public    
   beyodntest    false    235            �           0    0 $   COLUMN usuario_direccion.idmunicipio    COMMENT     Y   COMMENT ON COLUMN public.usuario_direccion.idmunicipio IS 'identificador del municipio';
            public    
   beyodntest    false    235            �           0    0 "   COLUMN usuario_direccion.direccion    COMMENT     X   COMMENT ON COLUMN public.usuario_direccion.direccion IS 'direccion exacta del usuario';
            public    
   beyodntest    false    235            �           0    0 (   COLUMN usuario_direccion.nombredireccion    COMMENT     t   COMMENT ON COLUMN public.usuario_direccion.nombredireccion IS 'nombre de la direccion, casa, apartamento, trabajo';
            public    
   beyodntest    false    235            �           0    0 "   COLUMN usuario_direccion.idusuario    COMMENT     x   COMMENT ON COLUMN public.usuario_direccion.idusuario IS 'Identificador del usuario al cual pertenecen las direcciones';
            public    
   beyodntest    false    235            �           0    0    COLUMN usuario_direccion.lat    COMMENT     Y   COMMENT ON COLUMN public.usuario_direccion.lat IS 'latitud de la direccion del usuario';
            public    
   beyodntest    false    235            �           0    0    COLUMN usuario_direccion.lng    COMMENT     i   COMMENT ON COLUMN public.usuario_direccion.lng IS 'Longitud de la ubicacion en el mapa de la direccion';
            public    
   beyodntest    false    235            �            1259    42786    usuario_new    TABLE     j   CREATE TABLE public.usuario_new (
    id integer NOT NULL,
    key_user character varying(50) NOT NULL
);
    DROP TABLE public.usuario_new;
       public         postgres    false    6            �            1259    42784    usuario_new_id_seq    SEQUENCE     �   CREATE SEQUENCE public.usuario_new_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.usuario_new_id_seq;
       public       postgres    false    6    242            �           0    0    usuario_new_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.usuario_new_id_seq OWNED BY public.usuario_new.id;
            public       postgres    false    241            H           2604    25119    almacen idalmacen    DEFAULT     v   ALTER TABLE ONLY public.almacen ALTER COLUMN idalmacen SET DEFAULT nextval('public.almacen_idalmacen_seq'::regclass);
 @   ALTER TABLE public.almacen ALTER COLUMN idalmacen DROP DEFAULT;
       public    
   beyodntest    false    200    199            a           2604    33133    diccionario id    DEFAULT     p   ALTER TABLE ONLY public.diccionario ALTER COLUMN id SET DEFAULT nextval('public.diccionario_id_seq'::regclass);
 =   ALTER TABLE public.diccionario ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    239    240    240            c           2604    42797    lista_new id    DEFAULT     l   ALTER TABLE ONLY public.lista_new ALTER COLUMN id SET DEFAULT nextval('public.lista_new_id_seq'::regclass);
 ;   ALTER TABLE public.lista_new ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    243    244    244            d           2604    42805    lista_producto_new id    DEFAULT     ~   ALTER TABLE ONLY public.lista_producto_new ALTER COLUMN id SET DEFAULT nextval('public.lista_producto_new_id_seq'::regclass);
 D   ALTER TABLE public.lista_producto_new ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    246    245    246            R           2604    25120    producto idproducto    DEFAULT     z   ALTER TABLE ONLY public.producto ALTER COLUMN idproducto SET DEFAULT nextval('public.producto_idproducto_seq'::regclass);
 B   ALTER TABLE public.producto ALTER COLUMN idproducto DROP DEFAULT;
       public    
   beyodntest    false    215    214            S           2604    25121 !   producto_tienda idproducto_tienda    DEFAULT     �   ALTER TABLE ONLY public.producto_tienda ALTER COLUMN idproducto_tienda SET DEFAULT nextval('public.producto_tienda_idproducto_tienda_seq'::regclass);
 P   ALTER TABLE public.producto_tienda ALTER COLUMN idproducto_tienda DROP DEFAULT;
       public    
   beyodntest    false    219    216            T           2604    25122 /   producto_tienda_cadena idproducto_tienda_cadena    DEFAULT     �   ALTER TABLE ONLY public.producto_tienda_cadena ALTER COLUMN idproducto_tienda_cadena SET DEFAULT nextval('public.producto_tienda_cadena_idproducto_tienda_cadena_seq'::regclass);
 ^   ALTER TABLE public.producto_tienda_cadena ALTER COLUMN idproducto_tienda_cadena DROP DEFAULT;
       public    
   beyodntest    false    218    217            X           2604    25123     producto_twebscr_hist idproducto    DEFAULT     �   ALTER TABLE ONLY public.producto_twebscr_hist ALTER COLUMN idproducto SET DEFAULT nextval('public.producto_twebscr_hist_idproducto_seq'::regclass);
 O   ALTER TABLE public.producto_twebscr_hist ALTER COLUMN idproducto DROP DEFAULT;
       public    
   beyodntest    false    221    220            ]           2604    25124    tareawebscraper idtarea    DEFAULT     �   ALTER TABLE ONLY public.tareawebscraper ALTER COLUMN idtarea SET DEFAULT nextval('public.tareawebscraper_idtarea_seq'::regclass);
 F   ALTER TABLE public.tareawebscraper ALTER COLUMN idtarea DROP DEFAULT;
       public    
   beyodntest    false    231    230            ^           2604    25125    tienda idtienda    DEFAULT     r   ALTER TABLE ONLY public.tienda ALTER COLUMN idtienda SET DEFAULT nextval('public.tienda_idtienda_seq'::regclass);
 >   ALTER TABLE public.tienda ALTER COLUMN idtienda DROP DEFAULT;
       public    
   beyodntest    false    233    232            b           2604    42789    usuario_new id    DEFAULT     p   ALTER TABLE ONLY public.usuario_new ALTER COLUMN id SET DEFAULT nextval('public.usuario_new_id_seq'::regclass);
 =   ALTER TABLE public.usuario_new ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    241    242    242            /          0    24972    almacen 
   TABLE DATA               K   COPY public.almacen (idalmacen, idtienda, nombre, idmunicipio) FROM stdin;
    public    
   beyodntest    false    199         U          0    25305    caracteristica 
   TABLE DATA               f   COPY public.caracteristica (id, id_tipo, caracteristica, alias, idpadre, mostrar, imagen) FROM stdin;
    public       postgres    false    237   P      2          0    24979 	   categoria 
   TABLE DATA               W   COPY public.categoria (idcategoria, nombre, abreviatura, direccion_imagen) FROM stdin;
    public    
   beyodntest    false    202   j      4          0    24988    departamento 
   TABLE DATA               ^   COPY public.departamento (iddepartamento, indicativo, estado, nombredepartamento) FROM stdin;
    public    
   beyodntest    false    204   �      X          0    33130    diccionario 
   TABLE DATA               2   COPY public.diccionario (id, palabra) FROM stdin;
    public       postgres    false    240   �      6          0    24997    lista 
   TABLE DATA               n   COPY public.lista (idlista, idusuariodireccion, fechacreada, estado, idusuario, nombrelista, key) FROM stdin;
    public    
   beyodntest    false    206   ��      \          0    42794 	   lista_new 
   TABLE DATA               L   COPY public.lista_new (id, fechacreada, idusuario, nombrelista) FROM stdin;
    public       postgres    false    244   ��      8          0    25004    lista_producto 
   TABLE DATA               �   COPY public.lista_producto (idlistaproducto, idlista, nombreproducto, descripcionproducto, precioproducto, url, direccionproducto, fechaagregado, producto_idproducto) FROM stdin;
    public    
   beyodntest    false    208   M�      ^          0    42802    lista_producto_new 
   TABLE DATA               �   COPY public.lista_producto_new (id, idlista, idproducto, nombreproducto, descripcion, precioproducto, url, items, imagen) FROM stdin;
    public       postgres    false    246   "�      9          0    25012    listas_compartidas 
   TABLE DATA               j   COPY public.listas_compartidas (idcompartida, idusuario, fechacompartido, idlista, emailuser) FROM stdin;
    public    
   beyodntest    false    209   ��      ;          0    25018 	   municipio 
   TABLE DATA               j   COPY public.municipio (idmunicipio, iddepartamento, nombremunicipio, codigomunicipio, estado) FROM stdin;
    public    
   beyodntest    false    211   �      =          0    25027    pagina 
   TABLE DATA               N   COPY public.pagina (idpagina, nombreestablecimiento, descripcion) FROM stdin;
    public    
   beyodntest    false    213   t�      >          0    25034    producto 
   TABLE DATA               g   COPY public.producto (idproducto, nombre, detalle, direccion_imagen, lista_predeterminada) FROM stdin;
    public    
   beyodntest    false    214   ��      @          0    25042    producto_tienda 
   TABLE DATA               �   COPY public.producto_tienda (idproducto_tienda, producto_idproducto, tienda_idtienda, nombre, valor, valor_unidad, estado, codigotienda) FROM stdin;
    public    
   beyodntest    false    216   �      A          0    25045    producto_tienda_cadena 
   TABLE DATA               �   COPY public.producto_tienda_cadena (idproducto_tienda_cadena, producto_idproducto, tienda_idtienda, nombre, valor, valor_unidad, estado) FROM stdin;
    public    
   beyodntest    false    217   -�      T          0    25300    producto_twebscr_car 
   TABLE DATA               G   COPY public.producto_twebscr_car (id, id_producto, id_car) FROM stdin;
    public       postgres    false    236   J�      D          0    25052    producto_twebscr_hist 
   TABLE DATA               �   COPY public.producto_twebscr_hist (idproducto, nombre, detalle, fecha, hora, fechahora, idtarea, direccion_imagen, idcategoria, codigotienda, descripcion, precio, url, relacion) FROM stdin;
    public    
   beyodntest    false    220   g�      F          0    25063    productoxcategoria 
   TABLE DATA               m   COPY public.productoxcategoria (producto_idproducto, categoria_idcategotia, valor, valor_unidad) FROM stdin;
    public    
   beyodntest    false    222   ��      L          0    25076 
   sub_pagina 
   TABLE DATA               M   COPY public.sub_pagina (idsubpagina, url, idpagina, descripcion) FROM stdin;
    public    
   beyodntest    false    228   ��      M          0    25083    subcategoria 
   TABLE DATA               Q   COPY public.subcategoria (idsubcategoria, "nombreItem", idcategoria) FROM stdin;
    public    
   beyodntest    false    229    �      N          0    25090    tareawebscraper 
   TABLE DATA                  COPY public.tareawebscraper (idtarea, fechahoraini, fechahorafin, cantidadproductos, idalmacen, productoscopiados) FROM stdin;
    public    
   beyodntest    false    230   =�      P          0    25097    tienda 
   TABLE DATA               o   COPY public.tienda (idtienda, nombre, detalle, lugar, lat, lng, place_id, imagen, url_web, scr_id) FROM stdin;
    public    
   beyodntest    false    232   ˽      V          0    25313    tipo_car 
   TABLE DATA               :   COPY public.tipo_car (id_car, caracteristica) FROM stdin;
    public       postgres    false    238   O�      R          0    25105    usuario 
   TABLE DATA               �   COPY public.usuario (idusuario, nombre, apellido, email, clave, idtipodocumento, documento, sexo, estadocivil, fechanacimiento, telefono, tipousuario) FROM stdin;
    public    
   beyodntest    false    234   ��      S          0    25112    usuario_direccion 
   TABLE DATA               �   COPY public.usuario_direccion (idusuariodireccion, iddepartamento, idmunicipio, direccion, nombredireccion, idusuario, lat, lng) FROM stdin;
    public    
   beyodntest    false    235   ��      Z          0    42786    usuario_new 
   TABLE DATA               3   COPY public.usuario_new (id, key_user) FROM stdin;
    public       postgres    false    242   8�      �           0    0    almacen_idalmacen_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.almacen_idalmacen_seq', 22, true);
            public    
   beyodntest    false    200            �           0    0    diccionario_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.diccionario_id_seq', 7174, true);
            public       postgres    false    239            �           0    0    lista_new_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.lista_new_id_seq', 16, true);
            public       postgres    false    243            �           0    0    lista_producto_new_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.lista_producto_new_id_seq', 19, true);
            public       postgres    false    245            �           0    0    producto_idproducto_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.producto_idproducto_seq', 5296, true);
            public    
   beyodntest    false    215            �           0    0 3   producto_tienda_cadena_idproducto_tienda_cadena_seq    SEQUENCE SET     b   SELECT pg_catalog.setval('public.producto_tienda_cadena_idproducto_tienda_cadena_seq', 1, false);
            public    
   beyodntest    false    218            �           0    0 %   producto_tienda_idproducto_tienda_seq    SEQUENCE SET     V   SELECT pg_catalog.setval('public.producto_tienda_idproducto_tienda_seq', 7955, true);
            public    
   beyodntest    false    219            �           0    0 $   producto_twebscr_hist_idproducto_seq    SEQUENCE SET     W   SELECT pg_catalog.setval('public.producto_twebscr_hist_idproducto_seq', 105626, true);
            public    
   beyodntest    false    221            �           0    0    sidcategoria    SEQUENCE SET     :   SELECT pg_catalog.setval('public.sidcategoria', 9, true);
            public    
   beyodntest    false    201            �           0    0    siddepartamento    SEQUENCE SET     >   SELECT pg_catalog.setval('public.siddepartamento', 1, false);
            public    
   beyodntest    false    203            �           0    0    sidlista    SEQUENCE SET     7   SELECT pg_catalog.setval('public.sidlista', 70, true);
            public    
   beyodntest    false    205            �           0    0    sidlistacompartida    SEQUENCE SET     @   SELECT pg_catalog.setval('public.sidlistacompartida', 4, true);
            public    
   beyodntest    false    223            �           0    0    sidlistaproducto    SEQUENCE SET     @   SELECT pg_catalog.setval('public.sidlistaproducto', 511, true);
            public    
   beyodntest    false    207            �           0    0    sidmunicipio    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.sidmunicipio', 1, false);
            public    
   beyodntest    false    210            �           0    0 	   sidpagina    SEQUENCE SET     7   SELECT pg_catalog.setval('public.sidpagina', 1, true);
            public    
   beyodntest    false    212            �           0    0    sidsubcategoria    SEQUENCE SET     >   SELECT pg_catalog.setval('public.sidsubcategoria', 25, true);
            public    
   beyodntest    false    224            �           0    0    sidsubpagina    SEQUENCE SET     :   SELECT pg_catalog.setval('public.sidsubpagina', 1, true);
            public    
   beyodntest    false    225            �           0    0 
   sidusuario    SEQUENCE SET     9   SELECT pg_catalog.setval('public.sidusuario', 41, true);
            public    
   beyodntest    false    226            �           0    0    sidusuariodireccion    SEQUENCE SET     B   SELECT pg_catalog.setval('public.sidusuariodireccion', 53, true);
            public    
   beyodntest    false    227            �           0    0    tareawebscraper_idtarea_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.tareawebscraper_idtarea_seq', 50, true);
            public    
   beyodntest    false    231            �           0    0    tienda_idtienda_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.tienda_idtienda_seq', 5, true);
            public    
   beyodntest    false    233            �           0    0    usuario_new_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.usuario_new_id_seq', 2, true);
            public       postgres    false    241            �           2606    25312 "   caracteristica caracteristica_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.caracteristica
    ADD CONSTRAINT caracteristica_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.caracteristica DROP CONSTRAINT caracteristica_pkey;
       public         postgres    false    237            �           2606    33138    diccionario diccionario_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.diccionario
    ADD CONSTRAINT diccionario_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.diccionario DROP CONSTRAINT diccionario_pkey;
       public         postgres    false    240            �           2606    42799    lista_new lista_new_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.lista_new
    ADD CONSTRAINT lista_new_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.lista_new DROP CONSTRAINT lista_new_pkey;
       public         postgres    false    244            �           2606    42810 *   lista_producto_new lista_producto_new_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.lista_producto_new
    ADD CONSTRAINT lista_producto_new_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.lista_producto_new DROP CONSTRAINT lista_producto_new_pkey;
       public         postgres    false    246            q           2606    25127 *   listas_compartidas listas_compartidas_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.listas_compartidas
    ADD CONSTRAINT listas_compartidas_pkey PRIMARY KEY (idcompartida);
 T   ALTER TABLE ONLY public.listas_compartidas DROP CONSTRAINT listas_compartidas_pkey;
       public      
   beyodntest    false    209            j           2606    25129    departamento pk_idDepartamento 
   CONSTRAINT     j   ALTER TABLE ONLY public.departamento
    ADD CONSTRAINT "pk_idDepartamento" PRIMARY KEY (iddepartamento);
 J   ALTER TABLE ONLY public.departamento DROP CONSTRAINT "pk_idDepartamento";
       public      
   beyodntest    false    204            h           2606    25131    categoria pk_idcategoria 
   CONSTRAINT     _   ALTER TABLE ONLY public.categoria
    ADD CONSTRAINT pk_idcategoria PRIMARY KEY (idcategoria);
 B   ALTER TABLE ONLY public.categoria DROP CONSTRAINT pk_idcategoria;
       public      
   beyodntest    false    202            �           2606    25133    subcategoria pk_iditem 
   CONSTRAINT     `   ALTER TABLE ONLY public.subcategoria
    ADD CONSTRAINT pk_iditem PRIMARY KEY (idsubcategoria);
 @   ALTER TABLE ONLY public.subcategoria DROP CONSTRAINT pk_iditem;
       public      
   beyodntest    false    229            l           2606    25135    lista pk_idlista 
   CONSTRAINT     S   ALTER TABLE ONLY public.lista
    ADD CONSTRAINT pk_idlista PRIMARY KEY (idlista);
 :   ALTER TABLE ONLY public.lista DROP CONSTRAINT pk_idlista;
       public      
   beyodntest    false    206            s           2606    25137    municipio pk_idmunicipio 
   CONSTRAINT     _   ALTER TABLE ONLY public.municipio
    ADD CONSTRAINT pk_idmunicipio PRIMARY KEY (idmunicipio);
 B   ALTER TABLE ONLY public.municipio DROP CONSTRAINT pk_idmunicipio;
       public      
   beyodntest    false    211            u           2606    25139    pagina pk_idpagina 
   CONSTRAINT     V   ALTER TABLE ONLY public.pagina
    ADD CONSTRAINT pk_idpagina PRIMARY KEY (idpagina);
 <   ALTER TABLE ONLY public.pagina DROP CONSTRAINT pk_idpagina;
       public      
   beyodntest    false    213            �           2606    25141    sub_pagina pk_idsubpagina 
   CONSTRAINT     `   ALTER TABLE ONLY public.sub_pagina
    ADD CONSTRAINT pk_idsubpagina PRIMARY KEY (idsubpagina);
 C   ALTER TABLE ONLY public.sub_pagina DROP CONSTRAINT pk_idsubpagina;
       public      
   beyodntest    false    228            n           2606    25143 #   lista_producto pk_idusuarioproducto 
   CONSTRAINT     n   ALTER TABLE ONLY public.lista_producto
    ADD CONSTRAINT pk_idusuarioproducto PRIMARY KEY (idlistaproducto);
 M   ALTER TABLE ONLY public.lista_producto DROP CONSTRAINT pk_idusuarioproducto;
       public      
   beyodntest    false    208            �           2606    25145 #   usuario_direccion pk_llave_primaria 
   CONSTRAINT     q   ALTER TABLE ONLY public.usuario_direccion
    ADD CONSTRAINT pk_llave_primaria PRIMARY KEY (idusuariodireccion);
 M   ALTER TABLE ONLY public.usuario_direccion DROP CONSTRAINT pk_llave_primaria;
       public      
   beyodntest    false    235            w           2606    25147    producto procuto_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.producto
    ADD CONSTRAINT procuto_pkey PRIMARY KEY (idproducto);
 ?   ALTER TABLE ONLY public.producto DROP CONSTRAINT procuto_pkey;
       public      
   beyodntest    false    214            �           2606    25149 (   producto_twebscr_hist producto_temp_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.producto_twebscr_hist
    ADD CONSTRAINT producto_temp_pkey PRIMARY KEY (idproducto);
 R   ALTER TABLE ONLY public.producto_twebscr_hist DROP CONSTRAINT producto_temp_pkey;
       public      
   beyodntest    false    220            }           2606    25151 2   producto_tienda_cadena producto_tienda_cadena_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.producto_tienda_cadena
    ADD CONSTRAINT producto_tienda_cadena_pkey PRIMARY KEY (idproducto_tienda_cadena);
 \   ALTER TABLE ONLY public.producto_tienda_cadena DROP CONSTRAINT producto_tienda_cadena_pkey;
       public      
   beyodntest    false    217                       2606    25153 0   producto_tienda_cadena producto_tienda_cadena_uk 
   CONSTRAINT     �   ALTER TABLE ONLY public.producto_tienda_cadena
    ADD CONSTRAINT producto_tienda_cadena_uk UNIQUE (producto_idproducto, tienda_idtienda);
 Z   ALTER TABLE ONLY public.producto_tienda_cadena DROP CONSTRAINT producto_tienda_cadena_uk;
       public      
   beyodntest    false    217    217            y           2606    25155 $   producto_tienda producto_tienda_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public.producto_tienda
    ADD CONSTRAINT producto_tienda_pkey PRIMARY KEY (idproducto_tienda);
 N   ALTER TABLE ONLY public.producto_tienda DROP CONSTRAINT producto_tienda_pkey;
       public      
   beyodntest    false    216            {           2606    25157 "   producto_tienda producto_tienda_uk 
   CONSTRAINT     }   ALTER TABLE ONLY public.producto_tienda
    ADD CONSTRAINT producto_tienda_uk UNIQUE (producto_idproducto, tienda_idtienda);
 L   ALTER TABLE ONLY public.producto_tienda DROP CONSTRAINT producto_tienda_uk;
       public      
   beyodntest    false    216    216            �           2606    25304 .   producto_twebscr_car producto_twebscr_car_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.producto_twebscr_car
    ADD CONSTRAINT producto_twebscr_car_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.producto_twebscr_car DROP CONSTRAINT producto_twebscr_car_pkey;
       public         postgres    false    236            �           2606    25159 *   productoxcategoria productoxcategoria_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.productoxcategoria
    ADD CONSTRAINT productoxcategoria_pkey PRIMARY KEY (producto_idproducto, categoria_idcategotia);
 T   ALTER TABLE ONLY public.productoxcategoria DROP CONSTRAINT productoxcategoria_pkey;
       public      
   beyodntest    false    222    222            f           2606    25161    almacen sede_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.almacen
    ADD CONSTRAINT sede_pkey PRIMARY KEY (idalmacen);
 ;   ALTER TABLE ONLY public.almacen DROP CONSTRAINT sede_pkey;
       public      
   beyodntest    false    199            �           2606    25163 %   tareawebscraper tareawebscrapper_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.tareawebscraper
    ADD CONSTRAINT tareawebscrapper_pkey PRIMARY KEY (idtarea);
 O   ALTER TABLE ONLY public.tareawebscraper DROP CONSTRAINT tareawebscrapper_pkey;
       public      
   beyodntest    false    230            �           2606    25165    tienda tienda_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.tienda
    ADD CONSTRAINT tienda_pkey PRIMARY KEY (idtienda);
 <   ALTER TABLE ONLY public.tienda DROP CONSTRAINT tienda_pkey;
       public      
   beyodntest    false    232            �           2606    25320    tipo_car tipo_car_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.tipo_car
    ADD CONSTRAINT tipo_car_pkey PRIMARY KEY (id_car);
 @   ALTER TABLE ONLY public.tipo_car DROP CONSTRAINT tipo_car_pkey;
       public         postgres    false    238            �           2606    42791    usuario_new usuario_new_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.usuario_new
    ADD CONSTRAINT usuario_new_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.usuario_new DROP CONSTRAINT usuario_new_pkey;
       public         postgres    false    242            �           2606    25167    usuario usuario_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (idusuario);
 >   ALTER TABLE ONLY public.usuario DROP CONSTRAINT usuario_pkey;
       public      
   beyodntest    false    234            o           1259    25168    idx_idusuario    INDEX     Q   CREATE INDEX idx_idusuario ON public.listas_compartidas USING btree (idusuario);
 !   DROP INDEX public.idx_idusuario;
       public      
   beyodntest    false    209            �           2620    25169    usuario tr_insert_lista    TRIGGER     y   CREATE TRIGGER tr_insert_lista AFTER INSERT ON public.usuario FOR EACH ROW EXECUTE PROCEDURE public.sp_tr_insert_user();
 0   DROP TRIGGER tr_insert_lista ON public.usuario;
       public    
   beyodntest    false    293    234            �           2620    25170    lista tr_insert_lista_detalle    TRIGGER     �   CREATE TRIGGER tr_insert_lista_detalle AFTER INSERT ON public.lista FOR EACH ROW EXECUTE PROCEDURE public.sp_tr_insert_detail();
 6   DROP TRIGGER tr_insert_lista_detalle ON public.lista;
       public    
   beyodntest    false    206    292            �           2606    25171    almacen almacen_municipio    FK CONSTRAINT     �   ALTER TABLE ONLY public.almacen
    ADD CONSTRAINT almacen_municipio FOREIGN KEY (idmunicipio) REFERENCES public.municipio(idmunicipio);
 C   ALTER TABLE ONLY public.almacen DROP CONSTRAINT almacen_municipio;
       public    
   beyodntest    false    2931    199    211            �           2606    25176    almacen almacen_tienda    FK CONSTRAINT     }   ALTER TABLE ONLY public.almacen
    ADD CONSTRAINT almacen_tienda FOREIGN KEY (idtienda) REFERENCES public.tienda(idtienda);
 @   ALTER TABLE ONLY public.almacen DROP CONSTRAINT almacen_tienda;
       public    
   beyodntest    false    232    199    2955            �           2606    25181 !   usuario_direccion fk_departamento    FK CONSTRAINT     �   ALTER TABLE ONLY public.usuario_direccion
    ADD CONSTRAINT fk_departamento FOREIGN KEY (iddepartamento) REFERENCES public.departamento(iddepartamento);
 K   ALTER TABLE ONLY public.usuario_direccion DROP CONSTRAINT fk_departamento;
       public    
   beyodntest    false    204    235    2922            �           2606    25186    subcategoria fk_idcategoria    FK CONSTRAINT     �   ALTER TABLE ONLY public.subcategoria
    ADD CONSTRAINT fk_idcategoria FOREIGN KEY (idcategoria) REFERENCES public.categoria(idcategoria);
 E   ALTER TABLE ONLY public.subcategoria DROP CONSTRAINT fk_idcategoria;
       public    
   beyodntest    false    202    229    2920            �           2606    25191    municipio fk_iddepartamento    FK CONSTRAINT     �   ALTER TABLE ONLY public.municipio
    ADD CONSTRAINT fk_iddepartamento FOREIGN KEY (iddepartamento) REFERENCES public.departamento(iddepartamento);
 E   ALTER TABLE ONLY public.municipio DROP CONSTRAINT fk_iddepartamento;
       public    
   beyodntest    false    204    211    2922            �           2606    25196    lista_producto fk_idlista    FK CONSTRAINT     }   ALTER TABLE ONLY public.lista_producto
    ADD CONSTRAINT fk_idlista FOREIGN KEY (idlista) REFERENCES public.lista(idlista);
 C   ALTER TABLE ONLY public.lista_producto DROP CONSTRAINT fk_idlista;
       public    
   beyodntest    false    206    208    2924            �           2606    25201    sub_pagina fk_idpagina    FK CONSTRAINT     }   ALTER TABLE ONLY public.sub_pagina
    ADD CONSTRAINT fk_idpagina FOREIGN KEY (idpagina) REFERENCES public.pagina(idpagina);
 @   ALTER TABLE ONLY public.sub_pagina DROP CONSTRAINT fk_idpagina;
       public    
   beyodntest    false    228    2933    213            �           2606    25206    lista fk_idusuario    FK CONSTRAINT     |   ALTER TABLE ONLY public.lista
    ADD CONSTRAINT fk_idusuario FOREIGN KEY (idusuario) REFERENCES public.usuario(idusuario);
 <   ALTER TABLE ONLY public.lista DROP CONSTRAINT fk_idusuario;
       public    
   beyodntest    false    2957    234    206            �           2606    25211    lista fk_idususariodireccion    FK CONSTRAINT     �   ALTER TABLE ONLY public.lista
    ADD CONSTRAINT fk_idususariodireccion FOREIGN KEY (idusuariodireccion) REFERENCES public.usuario_direccion(idusuariodireccion);
 F   ALTER TABLE ONLY public.lista DROP CONSTRAINT fk_idususariodireccion;
       public    
   beyodntest    false    235    206    2959            �           2606    25216    usuario_direccion fk_municipio    FK CONSTRAINT     �   ALTER TABLE ONLY public.usuario_direccion
    ADD CONSTRAINT fk_municipio FOREIGN KEY (idmunicipio) REFERENCES public.municipio(idmunicipio);
 H   ALTER TABLE ONLY public.usuario_direccion DROP CONSTRAINT fk_municipio;
       public    
   beyodntest    false    2931    235    211            �           2606    25221    usuario_direccion fk_usuario    FK CONSTRAINT     �   ALTER TABLE ONLY public.usuario_direccion
    ADD CONSTRAINT fk_usuario FOREIGN KEY (idusuario) REFERENCES public.usuario(idusuario);
 F   ALTER TABLE ONLY public.usuario_direccion DROP CONSTRAINT fk_usuario;
       public    
   beyodntest    false    2957    234    235            �           2606    25226 )   lista_producto lista_producto_producto_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.lista_producto
    ADD CONSTRAINT lista_producto_producto_fk FOREIGN KEY (producto_idproducto) REFERENCES public.producto(idproducto);
 S   ALTER TABLE ONLY public.lista_producto DROP CONSTRAINT lista_producto_producto_fk;
       public    
   beyodntest    false    208    214    2935            �           2606    25231 2   listas_compartidas listas_compartidas_idLista_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.listas_compartidas
    ADD CONSTRAINT "listas_compartidas_idLista_fkey" FOREIGN KEY (idlista) REFERENCES public.lista(idlista);
 ^   ALTER TABLE ONLY public.listas_compartidas DROP CONSTRAINT "listas_compartidas_idLista_fkey";
       public    
   beyodntest    false    209    2924    206            �           2606    25236 4   listas_compartidas listas_compartidas_idUsuario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.listas_compartidas
    ADD CONSTRAINT "listas_compartidas_idUsuario_fkey" FOREIGN KEY (idusuario) REFERENCES public.usuario(idusuario);
 `   ALTER TABLE ONLY public.listas_compartidas DROP CONSTRAINT "listas_compartidas_idUsuario_fkey";
       public    
   beyodntest    false    2957    209    234            �           2606    25241 ?   productoxcategoria procutoxcategoria_categoria_idcategotia_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.productoxcategoria
    ADD CONSTRAINT procutoxcategoria_categoria_idcategotia_fkey FOREIGN KEY (categoria_idcategotia) REFERENCES public.categoria(idcategoria);
 i   ALTER TABLE ONLY public.productoxcategoria DROP CONSTRAINT procutoxcategoria_categoria_idcategotia_fkey;
       public    
   beyodntest    false    202    222    2920            �           2606    25246 =   productoxcategoria procutoxcategoria_producto_idproducto_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.productoxcategoria
    ADD CONSTRAINT procutoxcategoria_producto_idproducto_fkey FOREIGN KEY (producto_idproducto) REFERENCES public.producto(idproducto);
 g   ALTER TABLE ONLY public.productoxcategoria DROP CONSTRAINT procutoxcategoria_producto_idproducto_fkey;
       public    
   beyodntest    false    2935    214    222            �           2606    25251 F   producto_tienda_cadena producto_tienda_cadena_producto_idproducto_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.producto_tienda_cadena
    ADD CONSTRAINT producto_tienda_cadena_producto_idproducto_fkey FOREIGN KEY (producto_idproducto) REFERENCES public.producto(idproducto);
 p   ALTER TABLE ONLY public.producto_tienda_cadena DROP CONSTRAINT producto_tienda_cadena_producto_idproducto_fkey;
       public    
   beyodntest    false    214    217    2935            �           2606    25256 B   producto_tienda_cadena producto_tienda_cadena_tienda_idtienda_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.producto_tienda_cadena
    ADD CONSTRAINT producto_tienda_cadena_tienda_idtienda_fkey FOREIGN KEY (tienda_idtienda) REFERENCES public.tienda(idtienda);
 l   ALTER TABLE ONLY public.producto_tienda_cadena DROP CONSTRAINT producto_tienda_cadena_tienda_idtienda_fkey;
       public    
   beyodntest    false    2955    232    217            �           2606    25261 8   producto_tienda producto_tienda_producto_idproducto_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.producto_tienda
    ADD CONSTRAINT producto_tienda_producto_idproducto_fkey FOREIGN KEY (producto_idproducto) REFERENCES public.producto(idproducto);
 b   ALTER TABLE ONLY public.producto_tienda DROP CONSTRAINT producto_tienda_producto_idproducto_fkey;
       public    
   beyodntest    false    216    214    2935            �           2606    25266 4   producto_tienda producto_tienda_tienda_idtienda_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.producto_tienda
    ADD CONSTRAINT producto_tienda_tienda_idtienda_fkey FOREIGN KEY (tienda_idtienda) REFERENCES public.tienda(idtienda);
 ^   ALTER TABLE ONLY public.producto_tienda DROP CONSTRAINT producto_tienda_tienda_idtienda_fkey;
       public    
   beyodntest    false    216    232    2955            �           2606    25271 (   producto_twebscr_hist produtwbhist_tarea    FK CONSTRAINT     �   ALTER TABLE ONLY public.producto_twebscr_hist
    ADD CONSTRAINT produtwbhist_tarea FOREIGN KEY (idtarea) REFERENCES public.tareawebscraper(idtarea);
 R   ALTER TABLE ONLY public.producto_twebscr_hist DROP CONSTRAINT produtwbhist_tarea;
       public    
   beyodntest    false    220    2953    230            �           2606    25276    tareawebscraper tarea_almacen    FK CONSTRAINT     �   ALTER TABLE ONLY public.tareawebscraper
    ADD CONSTRAINT tarea_almacen FOREIGN KEY (idalmacen) REFERENCES public.almacen(idalmacen);
 G   ALTER TABLE ONLY public.tareawebscraper DROP CONSTRAINT tarea_almacen;
       public    
   beyodntest    false    2918    230    199            /   /  x�]�AN�0E��)r�q�.I)H��JV�LS+����u*z���+����6�,�g[�X��F�dWm�i��=�"�"���HKk�%�(��8�[�:�����`�h�u2���4�R;k��4��aC�F �n�v�Ѳq	|�3)���Ɔs�4a�=y�T�0�"��5�8�~e6�L��W��a����ly yrI�>�2����$�Wh}9����(9$%<�ڮI6C���d�����V`��:ldxf�G):%y�r�g￴-�	v׵���ק����RQ����[_p� Z�f      U   
  x�}W�r�6=�_�[o�H��989rǝL�f,7����e�����or̡�\z�U?����43־�#	�A8�峤ſw���$��4_�Z�z��Y��� eA��+R�rIʊ�)+��HY�2Ge����HJ�#+Pf>����J�#+KT�8)�̏3�qf�8�PIO�(2�􌞞�O�@�$�(��wiI.-c��JK��$-��$iK���RQ�Pc��X���E�%Iˉ�T�X)�ҏ������b���փ@@5aM�s��^�{}���O�EK�����5A���%�"	�$ޔd�
0�s� �0��O7��˘��zi�o��N�.|�B�B���"�z,hU�����b�c$łf4r�"���h�Y<�4#)-Ӝ�i�iN�4��i��[��>���|{Э �_|�5jZ�Q��+�3�����NrV��ꅬ�k��V�nj����V֏!2�x��v �R���4�tQƊ��G�;墌KP�����/�|%�Fv�'l��7X���d��V9���-7��q'_������, sh�=l�+���F�Y-Q-V��+f��VQΪʫ���^�&���zَ�,���_H�U�~=k(�)|�K���3�X�K�����:;�B*���B\�������$g���٪���+m�#��1a� �9���2V��/�N6֍�,z�������la����,F�_ɍjC�O�ʚƚ�C������I�qǯݘ�&�	y�����S���*��J5�m��Ď2]���5 s��u�4jDfKb�Z��ǘ0��^�'�`m�l�,��)X�߷��&_�ֽtª�&���k�z(A ���?�f�0�m#��0��S��9t��{=�&��^n����3V��7���5�T#���)JRl������F�"31�w; �����Go��@��̤��0�y���Ѕ��+ѣ�N;c��8a}Z�ǿ]�6
_�I�u�ۭu���C��4�;��Q�
t���6���)k�f��p�7��=uWнR�I}�#��ȷ��{| �3K������K�w��y�>Зu��̀��/~���$EK]�����k���q*�y�!�D��qj'C�	[��`�З�r��O6�F:�a�H��I�����xcO�3�a-��V��w��F
������<~��	�m�����z����ۀbc{��b��S�U�������c����4�S�b�����(E�?����RU��@ܪ�I�`�D��wwI	���ڀ�}	����#Ftt�S� >0��^�{p�n�H��i<�Q��bV�n��m�U�����s	�@p%ۍ���
�ߺ�ag��?S._S#��4% ��|�g;+R��)��(�$�O�	�'�\k�"2��!F�����U�=�&��Ϟ������>���Iβt��h�w�}��4��|-Ozk`��C��Ʈ�"�������4؈$K�~�&��$E��)C�(t�N��_����G�m%���nu�Br�7ۓw�'''�O�$      2   Q  x�}RKN1]gN1�:��g	��"U uՍ��C �G������̇eX���؎<w��
��WPi��=ș�
�lۀ㷲Hf��D˰��iT�Z<('����0��N���*?S��]�.r�PħiT'{<h���:8ߦO����k����~�>�wh�b�-�h�%9�Q�pNC��?,jF�+��{c��D���B�!�L��$���P9�Yv��u*n)Uh�G�#�}�'�f������A�B�d��˖������:�$*ݷh����5��ў?���by�����9]��6T���F��x� ߹Q,�7�$I~ �X�      4   !  x�M�An� E��)|�*�8N��*	K�z����gh�.�f����Yi�+��ul�O��F57�\-�QMJhs�h���w�t�5���:,�ҳL,?�+L�_�8rv���Z�ҺB���{�-=vHyIW,6 ָ����}<��V�GD�'q�}����ݞ�^}��"�+�.2��L��hI����+�1�IL��aq�Q8..��G-u�6���DJ�$�=׊!�+�`� ;�?����,��j���

_�kzq;��r��W8jYڹ> M'o�oD�N!db      X      x�d�˒\G���v�G����.j�%03'��Đlfv����ᄇ{�/ �]?�<A-SFJ�Kz��,�X믪vq���a�瘙�1S�Lͭ6�����n{Z��������"�~<�X���__��-��"���/�����t��.�e�������/��i}��>�O�����~�~�Kp~2�p"\���hq�FJFѲʴ�pE�rSԻ�ׇ����u��ߎ/�_�����(�<I�t[&ߖ)+__���xܿ��WVƅ��)�M�V�Nۧ���E���w�������Y�^��w��u(��Po���FXt����1huǈ��n˦۲y��>���lAٺ�(K���C��CPX���)��v�D�������T%I����O�՟�L�Lq������Є�IR;Xn��y��u�٣�r���Q�8K+��Vη���J�]RYz�����t�r�E�H+I��<���e{a*u���|xQ�'��n^T���_T������U��5��/�m5��j�� ��2*�-�4������N���pK�Bf1��J��M;6X�U�Yb�����ڍ��>�v�'\����=��/�ױ����5~��v^�ש�/�ر��e�~���f�ي��8)۝����l�Rl���~/�g�����⯊��*6.��n�˱�v�l�V'l���1�`��vl�"�|!�!lÿ�d#�[d���HRA�^ΑV}QA4U[�Ȫ*����J��v���z��f��vs��O����_���l���I�͖o��em��E��6a9Z�˝��;�҉r�*�ډ�����I+ޤum���4 ���Y��/_�?�oVV��� bͮZU{v��`����j#�VQC�h������v[C~�5�ٮ��_HJ&uS~�Z�|Q�?�gk֒��lΞ��S����[4�B����}��'�!{gm��-��k��6�l�ͯz}���R���_��}���t�	or��>���ٞ��쿰iF��I�ɤ=^�x )��(ZFQS'�l�r�A����8�FS'�l��v�:���C���?���@���v���E��H�I��r_衡�M���oq����4:�g?�qw�qS$}�A�OIU��y{�]v�7:�^.��N�x��Jl����P|�W�g0�e��29�q8c�և�|-�05xv� �o�w��a{�/����r�����'�;��ևK/����$Na*SWZ?lOO[��x�:ƶ��i�gȨ�*�ӳ[�ʳsx�>�Λ��/��'�AZ]?�l��,"��q��K`�0d�?�.kf�g�����?��F���\�柊fT�P�cl������p��a��3�߸-���ox�9{�W��_����O�ʡ�v �N�I`��j��؅l��[��\#R���_��[����#����{~\�|Ԯ��*�G�Ɏ�ˬ"�=���8��1`����C�!v`W��O4��&�@�G�M ��g�|��6����"�ރ��;�Wۻ������n�z��q���_�՛����e]��t���dbt�@�b���H�X`�Ĳhb��Xv�O�˚o�t������#�9i�/��`��������4�.���i����f�:^Q{l��O�S�Yk�4dѐMCVl�����Y�����v�3_�����u������߳���g+�U�Y*��R��ٺ�m�O��%�{*0�P��ؤ�?�s5ǭ�>[��O[nq���F��x��D���g1A��W'̖٘�F����J�l��~Ĥϭ~��=�X���|V<�ݞ�������n����#1�E}�G6ZW!��?xָ@��k��V��U޳(�HL*�$߯�v������i�Q�EG���qs�?��+�).�؜?a�Q��R��ʥ�\^�yr|�n��X�*3ۥΊ�I�$�V�;�?�

�&@5G�K������(�݉/�>G���eĘ�k��_�2�#�~8ힹ;G�M\n񇉭���?sO�oy)�j�Mv(<_tN�\�L��Æ��=�4����t�m�KiL����6&[�(]�4��fs���#&	�9Jɤ� ��^���Ǩ�/�hx6���y�٭��R�l�"B�1OU¦Ⱥ����~�=�Èl����	���(Fa�"��^Ģ�Q��`{d�l��Y"[��^޵����u��B,��"⋈��'�ܗ�2�p�NG���x�nϗ���x#�*U_��V}���M4��wڍ8��т6�%��EL��$?L�Zq���D�)��ފ���_��܈���N[�\Ԉ�hab[ei.!�i�W&��p���[�V&�ݢ2�-�g�e�b��p6]m{�EdH����kώ�tȆ�?�[�l�b���aU$3j
jU�3j��#QDG�xۑ���I��#Q�bVQ�V�u$�ڑ�FG"BG"��H�x��tٱ�!��.�F���؎�I|=��H�
6������싉-Y.�*N����Il��IO*��&�m���/�ec�+�ؔ'�9NA<�Y퀲��2	���o�����;Hbb�按<�ە��ؐ�TZ��{�!)� ��g��؈1����[��e+���"�\�����Ո�w��V�]ܯ������MXʤӌĶ��M��`�蝉��[��q���M]Z�T@b�;D,���/���ݯ�+�-���^Ll����d�ɥ!'���=<^�����.:�������xځ��� >vyl�&��X��,�J�Wa�/_�0�f�ض�`S>��Kl�[�o�!R@�Il�\ol����y���z��0�Ll�0�4p�d�pς�2���Bb�e�l��&��{5YjLi�ׄ8��b�UYKl�,�-tܜ�hb�y(�%��b���&D��?���Gĉ-���-.Er���O�s$[�iF���O���2�06ж<��Dի��D2'���B�����S��͓�2K.x�s`�����#yy$�ɿ��	7Y���T�N��j���>�5e��[���ĝ��jy��Wr�l�֤ѭ4�bb[|��|`�l����Y0�Gf;ĳeyf�?�m3bYܶy���_��~�����;�d��_x�}���73�,����3� �'�)�ᚲ�&Ҥ��uHÔ�,7�"�
�⧲�8���]�'TLfC|s��`5�./���<�2{m��Jm��
'il��v�3_`B}:����>�	f�9��FH���d\EHiB긑(��������l�����bȈ���J�z�L/!���)�ga�D��j��9[����#�08�e�&��3�P�����	��pN�#���e~:��V$K�����ކ�2[�܆�r��QΓ����#_�<�9ۻ-g�3Y�.Y�yg��׏����u(6����U�Vz�>=�6�R�{�VzL�S�ǔ�B0����XO럯�2�H`[�O��̶*�����<I*�Ϙ��ǧ;�6�7�FT��V^"E̶,�^"e���T&�-����D�1�,��E,�`iIe��v�nt�;�x�v�l���.��x��;��/Ӝ��4���)21��2=�L�� SޝEߝ�)a�2�7��"��u�a�U9l�Zl���d1�m���%�.l�*/�.4N��v۫Qޠ%j+��t�2O�
&s�.����7�ߙ���m��1n,b��m��.�͖i�Z`�(�H]IҾ2�-IW<��Hր��9[*,����
���O���G,�����HIc^_�pK�g����ox�K-l���$o�-�'`��]�S=�������q�/u������Y̪�=��X�,E���o�OqͥL�v<��1c�<�e]�����E�ǥ��h���
[��&��Y?�v<�(�L�`�ƶǭ�pI�M���.�.^��,j�.�{		<~ ��'	e��-�N?���e�|Q�.ss����)��h��v=�8���H��R��e���=뫦:�U?��MA~�F��4��iT�j��$ ��$��]y��zX�s���������b#{=l!������a�?3����Ѭ5��qz��.���cC��v��!VY9�1�<]8��L�*��?�.\��q��q%	���J��U6�(�gP��S��/jZ�^��[�$F�� �&�    ��`����'ؗO�zl��oY�>����FCU�f����o������Ϣ��gQ��EU�W5[�hH���M�k��9�?�[ɕ�U���n6w�߻�D�j�ZU�Z�)jU+�6`�|�V�=�|�������fL���X����ۻ��w)�K�R���K�r��.6�WQ@&�/��)_%��k��Y�j��Jո�Ʃ7Ը���jܤ���۝ *l�&X�W����/JX���!�_�{���%
����$�Lf�_��u<���l��x�
$��ӝhcc���@�KQ���#�L3b��o䳹O��l��E[<w���ע,�ʢ*�M�2��ѭ2�Q�.��C�D���/Id[��/�ɮ�l� ���f��>!��Wa��o$2���̟s�`O�n}e?"7Ǝ`L���`����do�:���	���2�`�>t
��1��.˞@�l��F/M��넿�͛�2MO� ��U���4�se��G�W����7��M@��?{����Yiff�E���ǹEɮ�i���خ)D怐}ߘMv_�.��ש�e82�$
@�����5s:�rn��;0c�_>�O�m�����ڞ���W��2�s6�w ��������i|� �}!�}�ׇ���w:�rn+8�e��>��K�����4{�=�W;�Q��E�ή����ڛJ���%���2����y��� �kf"M��0گ֡�iĹ	���(���d� {�$8�i�vN��4y;g����p����4���s2�p �HEe5?֩5����ٳ)�L�y}De8�j�Am~�\�ے̝ż�K�mS�;�+�/q��٭Č�ӕj��\o�Q�8v*��p53b k�.�Aػ��bRf�BY�~��#I�[~�g�j�K�"��.un�#C �d/��. ׬���G0k&����W�[��<t�n�����^�z�%7ٓD|h�ӁZ����Υ:Ko��������_>\���}�=_���ڋ^p ZK�H�N�SPk�|�O�Ʃ��"|��F��ڠP�J�2��E21y.]V�׏[����^&�s� ֤�d���m��ՁXӞ^Mc(�}�N8�Y�	���h3
L�ɦ�Z�R;�ӊ���ါMB�ھb��oB��
�bm<�0k�AkΨ5秨��v�g`�y\?#HĊ�l�ZCo!{'��wi�%��4�OC~��Fv����+�#��Z��Ud���sE�87���=x�7����os���9��gWqs�� c�x�ڽ��5k��#l��y]ks~Zls��&A��7ǰ�_�.��?�VS��*�ΕX�,�=�4��6�W��5g<��k'���5����[��'���T �5��ZXy��/��i-7;�DA�� J��ډ�Fs�Ѵ���<�v��	��0�:��	W� ̈́�k�k �ք�k�A*4�Wl�"X�NQajjMT�tJ��6�����B�K1��޳�i��ַj��8E�iC!�������� �ڸ{7HM���9pjCI��g�"�=�n>�/��Xk�"0k�5Hy{�V%qpa
98k���.c:`kq. ה�O�y7rm+?�:��`/�ZʋՒN- �٨"������q���~�$6�wl&l:|3�)��B�]K��9�k�4Գ�#��@��|8跠/X<I�NV�1S,[`�{�B+����Q���Jf��m�gl��'(�u�h�cdF��k��տ�>��ki�������mˢ����$ �ۏ[P^.
о��|�W�&�����+�,؛����b�˶�Ĳ��X�*��h��t�K&t��Q����i��ǵw��# �S�ց�Ӣ B��1@Ƚ�;�U҂�4�w@����˳sh�$��A碬:�r*	̍H
i4?P90��kp��xw�/�ɉK�{Y{��	3�>�������p�˸��=�r�_/�M-�G��n 5�Ų���iw:߿�7�}��h�����F��~n��7rJ�SW�-l,������M�e��S���9��t��t�*��E�^�����5��ɀ(��A�:����CE�eEe]��S!����q�[ܣ��_w���:������og|�^ڱhÔ�0��LS��t�B�[Dnv���=����;~|�=5��cU����:�i7d�]���np�ԝnrb�х��&�ޙp�wM8	������|;�x*�]ǐ�� xM2!�d�f`�/$c��LM����3u��������d�dɲ��9�����T����ۄ�iPs�L�����o���-�?n<�>��okCw�-3X��HH��(��ǣ3�eZ�|��;�A����(���K���u4�R:�z�+m������@��xذ=郱��=�0f��z�1\�W���I�mW���{�[|�/�����0�Pa�<�|�%�ծk&(�� �<��<�T�* |�������c��O�]!�"�l��H&�=l�pd�Lp{M �X�@v߯?O���c^�(>d�����1��k�]�@�����Z���I�`�t� >�(�	)A����B
MB�]���}��.��5�-D{�.��I��(@�i�؈BP�&#��2��������e���������aw�Ҷ'.�?�}���q ���Ԉ�}Q�D8������2��eX��3]��si���<_/5D߫�q}��Z���h����xY�	�u��vK�2䒭m��kr���\��O�c��C�}�k�%8 �3w�����I���6mp �OI��HZ>�ge���r�<B;�����P`�5�l�rr2�� '��������������bK���� �X�����Z�r����-I ���H5�� t@ �&m�  p�%�j���&��|�'v�I)�[�����Rl�����Um?��k�Y[�զsp��+��<��˳c�7��<�xܝP��l���?ɟL�䤓�d�.�d��P���e��
9�j�(;� Ne��d���g�}־\��J{$�:�#����K�CHm�a8�O8��=��n��J!����6��6� Z�K�0|{<`7�c3>I6�Á.����_�w��e̎��L�e���]L�o:O��˺�	�PoF�}�pHf�����ʸv�AJ#8|���:F q��N���f������|��� !��A�����a�.₱l�<�=O��	��ڠ����@�ud�:l����p����2EѲ�L ��q��vf��g�p� ��rpٶȹ���}8��w����B������E����g�>�-�
��X夢UE`�~�eH/�)p��y��[?�7�}�	Wl�<3�:#p_��e�7	�I�s/��������k�Kʖ�bS/�����W���:j���~@ ����R��_�@\ʦ�_2� � X�X�D���_7�#� ����������#�`z�	�F����d��e������/�Fs`���<UVGe!��(J�6r�Jv�y(Ŋ�z��i����?����#����6��HS�n�z+߼u��Ӿ
�s3�l��7ދe�Tx1�C0}��x6��gY�z���$K���ag�^[�w��._����gd�5/Bj�e��qQ��u�` ��aw����~���*6��vou�����i���J0&�>Iy v�]F2�����R� �T�� <9>�w�H�z�*�8���z/b�̑1������!ع_y�xƵ_ab�Uw���"�:�T����Iw:���K�^�t��]:;�[�^\/�TMG����ӡ�1�۝�<�x�X������n���B�e$1r@V�8v����2`��A�0�::�)��Y���^��=^q]�u;8/���a�Y8-�c��U����a}x:����b�ST��+��2�o51�ެ�\ч�R�����Ȥ��@��8���ե��=<����\߿��oNo�L�.3��K�R�"S�YnD�����{ye*����T�9�"۷�=�N���    0\���E&8���{���(]���H��z,�+���u,��c�RlPt
XZĨ�������=dFAK�z�4>ʊ��lt�����6�;����ށf��{|�_ޯw$�ToCEUg� Zu�[mJ�U��`Y��)
�Ug< YG8(k �YxV��bHֿ�d����}(�;ށg�ϪE�T��"���>[��z���} Z{)D��?�����4��I`�ʜPCQ Z����9��д���V_!6�i�H
��@Y�)&���Y������GdZ8s������ʯǻ����u�ga���︢!��kH�c�������C7�	�"��4����̀�&��{=��o�فy��=V�����;H�^�)~X?�.���}�gU���IՒ&ym��T�笯h]��bk��\��^ʎ��@�b�~/��Vs��<�u��V(�|�� N��ާE��j�⧒���=I�����Wy=zՒ��,s�:JV�s��P��]����K�'�?B-c3��*��U�WK��h=ya]M�_$��x �&�+���E�=�WRf!U������{Ю������/J���5�t����:����r'~݃x�v�ԫ_te	�Mf��0d�V3�I��&��G���+�=���q/9�i��/AՄ�&���� $l�$����<8�?����o@BB~�!!�U20.���&�M�ƻp�kMn���v��h�݃q}��bmX���d�كvշ�몲�Կ�?��y�m�������[{UM��_d�كs�T>�ƅ<�V������7�|����g|+<]����P�&%l�\	lkϮ�$M���sL��a��E�FJ��wQl�:U�K�d`9I>A�d��oR�,���(as�7=���b� �h0ȃiU9l�*�����]<pր��HTP������ͲR�fUi�fi5����5|�^�5��eG`���Ԝ�P�=;ˡ�U� j�� kmZ��"��ҵ��-5�VQoD�e��lj�- {0�Z���Rc��$^� Z-��+zۈKi�si�Z��ճW(����wK��|n"˭��〫v�h�G��j�)+E�������3�dq�������c��Qn�0C�g֝�H���H|�#V��)�B�k)�W�$"�C��P!뵤�#{�Emb0K�]R1��t��&SBI��H�~�U�A�>���dK�y�u���S��4n>���iM���|ҥ]�4�]3z'q������bs����b�x+��)[7:�2�JW�ZN4�N=�S�[�#{���^6wTJ)]mQ뫚bӻj��L���������;I+�=��֒SNqS�T﬚5T���MPӹ0p�3��=�/��|���x�+A�S�TT{����*7��uCp�Y��T���Y*C��`Ƨ�v/]��
�����Bm� �*G��z@�*j�+?X����>�o���|{$����3�.��xp�O@"/�~Z� R�7�o� ��*��4	ӈT�����z���2˫C^4����G@T	��+����$�b����v=p�����<��P����
<0TUF��)D�#������lM)� 
5kR�d�s+j�� �uzhv}R����*�P%���T!I�����0�@QU!ptS�'�uR�>�)�� ���/��#k�ȭ{d��u���n���n���G����y�t�� ��E�K94�SZ�/X���/�- �4"�gH�D��,��~T����ˌ@���-bf��L
<��v�Y�;59 O!'Ȥ@� :Ez`�̩�=�)^k�M	��vAU�Jo��;< �i�� �Խ�5�T��shR\2)y�R�5洷6�S����Z��))��d�>h��'I�j�4�M�ϪA��������yZ��_�A_��������`N�_߭e8�?�9��t{>h6�_]tm��D<����pW+uO(����_p������5I��g\N��&��=;x����ï��߱�>�7SNH��޽D���ˏ�\<���x�!ת���d�>�+~0D�!~�I�I���;|��[|��۟P� O��U�� �j�@P7���>("��k�E�<H�!9��[��������,��<�!�-_���7!-k�\�jB�	)����?d����i��%��G�|��,�� OE[���f�r��!�6�p�=�?"��lm� O[�^dKm�@������$_ck�E�R-z˵�A�N��My���Q'��D:j&�tgW����+�Ѩ����n�eVl:J�+��$�o��r�AQv�b�r:�&�#�N}�N}���ӡFR���x_:e��G["�Q�==�ө|���L���"ɶRBF�Q�q���������r�p��*j[��V��*�m��`/M����E������b�0�O�-E�Ƣ�Xd����B��6`S��8V}�T� NU��Rh:�)��������<�=O��]��!��C��Ǔ�w��;t���@�6O �����UM~���=�����8�@���%�e�ռ��_���(Ͼ�'5��1`���H��T��T9jVe�p��@�6a N�V34eW�������ؠN'i�O'8 8�
��|*I����4�IC��B�d�D��?��$�2�ǯ�֛���ᝥ�qz^_?��%F��3I���)���i^/����ݠNA�x�N}�N�A���z'�0�c
<0S#<(�M�Z=`ӯ��:�=k���� N�زJ߼�W��8`�g�C�'������O�dK)?�^����]g��q���/TRW������Q�*v���r<��<y�_u^͢���#!s$ OM,��5��� P5/�򧞚���I*]V�v� �?��ף�������n:��O�D�C�>=a�3�dU���l�1��c�1�YAص�g_��M�#�JǃDU�Lǃ@5�46�E6g (;��A5UK[ ���a����%j�q�I�=p�a�uj�z�} "UłFmb��N���U��R��bg-��S�2�-���o��#R��h&�
�O�遥�Y41�,�S�L��tl�\�)H��8���$ꏻ�^�����j�.y��� G���� �6��Ɇd��>�ay�'��ܟ3�V��6R�m$�m�D5�8���-��n��Q߶��GU����$�(��5u�e2�x���%�IO���|��� (ԯ�~�/�����$i@<�w�3��=pԦ�}�i���^�S�L��	_4�4�(�RW�fe�1��O��&�7�PZ�'|�9\������̐�h �����Wve;m�~0�������<w�<ŁRֺ+}�$������������;� �4l��+RW$W�Bm�$Y�E�����í�pE
g����N7�M,S�8C���'�M��L���Z����"�Φ`��6$�T;�b�^�`R�\j2fY|�����\����i}}��7��Q]}��������+4����q'?��z�S��x���&  S_��QO������y�$��s%�Q�w1.��r[�̶D	B�4`��i`g�f�ϼzw}�Ke�[WN������zVHh���vZH� T�t�z�'(������H��<|�JԴ<t�Id_�%"8��=�e#gЩ7R���٘K�u���jR��Ie���E�`T��P��p�^�o�[\��η��G�yЪ���,�r�,���R��~�s�p=��i�L�Qo7Y�H]��Z�%��|���N��)?����P�~�K;֥�'���EbNC�@L�u5���mbY5}�C�jNe/��E�]|o�)K�RL���1���1�F����l�{����dl�~l#��2����[A�	�]��"�@��ۃ\Nq��#��F�F��$$���^
���8~���Vq���6�(6�(}(!�6���+ �o�{�A���hO-Y7�c�ě��*����� [܆�!^0�]��Ƞ��?N�2K�����dʐ3������\�Z�$�Jm�m�6�ҧJ66Iع'r�#�[*��KP��KP��d�_����� {����    S�6�(6�(}LQt��I.#fkRmDs[H s��N,
�!@G�I�E\r]\�q�[�ԟMO��ri��7��G���TC��ɲ=Y�O�CG�<�����c��d��c��>� �ȥ.��������I5!]�3�m��Z�XK��4�^�1���Fʀ���	׷]Ê�TB4y�����'`_�`��x1��� x�����$���M���jF����T�dC�wq>X�7xa u�S��������p��7�:驲��W�I��bz\������Ǎ�4x�����zt�Q[<�Z<����]�oz�����F�@�������j��v� ��FI�3h	� {|8a�Y���k��~U6��j����	{=hG��;�yk��-	�x��**�Q����6p��t��"����rl*�PAK7�Jz����rP�6R�o�� ��uO��h�A<@����{ �� ���¤����;ʋ�vW��`G��kGwe�W�
� Q�=RU���z����,j�u�+�Uψ�YQ��"�����X���NP�CN髶uJ��$jHTHԶ�	��fE�XQ9�ե���TUܬ���w`�ӊz�'$@#����iE�$����Hjd/ ��堰,��? ����Hx3���#�]		��Ptd[Q $����JHXt7=.�0��D�H]� $�C`�=x�Jj�����ܻEW���V!a���$Z+,�{",� �G6�>O
}����pd������*�b���h�",�C�Ev�Ɋz $�+������%Zʧ�D������I���" ������&�K^����� H�C
��� @����EH������<�&��br���+�a��� Gjρo��5}�.Hb�̓�"+�A�� "����E@�M��Qa|T )>!����N��r�6�Qa<*,���/�����
��La����"vM_U�C�Eq� ���� eE= ���`�=q�uE=,v� HYQ� eE=���� �x�d������"����+$d[ !ۊz �Wԃ��� ��@Bʏ�T�-�Vԃs��M.�����}HH[QΫ�z�~��c,��� @�& i6rZQ�΢zLt �^5 ����
m1<��l��>P�7x �B�,����t!X��1[pz\$HHb�E�B���p�m9�����E}�M��� rȡ�r���r��ZT �+���\"8=�]��IXZ�� >��V3I*��J�Pi~(�"9�϶���$��b���(ή`�;�W�F��?�����@���EW�@I[��$��c 19��4RNF
��H!8)p�C2sيx >95X������I��<@�^�݃��p��������P0�]8ʶ� R���$< ����'Q��T:ͥ��^�joi5�״�(Ͼa���0���;�o��z;.�Tz���j�r�t{
�Ho��5"@N9�&9>u97���y|{�`�3���C��UIH�۞L��o���w�w�c}3���q�l+���{��=xs~v�#Ǌz #9:�e��E�+���(O�@L6c 09�H^���>��4asc��he��<����������*����di��� 'ŧ��4�
vrz���Y����v𬷓g�Mʊz 5y���N��a B�+�%V�(�yE=���+�<����SbE=x���o>÷�� ������M�0ʾ�@R~�o+��H�R�Xv��|�^%?ͺ�|-_��yn R�%ATZ ��Ԓa����KR/ٖ��V�|Q��tK[� -�cl9V�C��K|Gҏ�n�N�lb�$���^ o)�5A�|�МHK�o�C{j�|���wX�k9V�C��E��6 Z����'A�;l���"B�PD�!����O��$��,'� �xB�d<!h2� β	�CHѐy:�mPlP�?�'@�r'�6��F�,{+�"���!4�! �d�g)�$����1��&)	>'�(� K!���9�{:�Y�}���`,M7v]5�9�9κ�_̺�\<�N�n�?C;����(�v�w��k�������V�K�֥�u�һt)}�7H�O��
 /�"�Q���� �rn��ݢ�nQ�[��-j�4ԛE�dVhI?�%� /�8��^�%�7xK[��.O׭�����I�*����[�2��2���P�]��9�&�-�g��/; �l��$[1E�wCN�T���p%��Q�c �&�[�|��H��6@��?��f{}�,��@X⌃ ��o��F�c��1�Yp���h���|���㧺�7gI�C��t��~!6��/��b��5 �r�n���Ac�xeoC��*b!�K�"uEt�Ȃ�fEi(J�e�r(J�(5E���(�(J�(͊�P�� Y=Y��'�����=����Q@K�  �lJ�F�ACl��h����,5�����~-% �ܭO���WA���� \ir��a�^I~����~�\ }Sn ]�e ,[�ڋdi��(m{��Qځ�>ܣ>` \�vw�� ��w�Ã�"ϋ���;P�r�M9 X�(�Sox� qI�+�W����q2�k���\u� ���ohe��7�����VWNn�d�F o-�R��b`*'�e���	�@�@
Bj D U9䀭�rB2�- ��- �ToCa�QT=�ǿ:QHvj4��y����� r��Z���z�v V������TTH�L~�����	�$����܃��Y�Qo1B��ۖ�6p�oQ�����"�oPM��&�Q���'�F$��1��>0�ۖH1���L"Te����hR�y���3X:� ��4����Q��@�� *��B^�T�k�<J�Ρ�(q�`'�#[���&�d�\�%� (M;�.�N�H��]��,�g�>\ A9���6\H�ƀzLw F)��� xR��l��P�gH�D���Gir���>X @���\p����0�#@�g4�Fnmڬ�l��(U�����(m���y����R��hʡC�m��OT:T��Q��=����T�R9�HS��f}�H-.�,.���!�K������q0NHc�d�b������g|�Z��(I����I>ֿ��u��4x0�)�C c�愉�Ch9�g����]R"�w{�{B)�B���IG�IG�p���#O�|A��aZ���3�ԗKR\ ��Ŕ6pL���z��������];|��O�Y�R�h�Ã$�
�/[�g훹��l}3���n�^�]ˬCYs���3X�� β�M7eg�# ��U�4��Z3Y352" �|w:"�Q g��� �R*���	?�X�Y5�Ky�!v��=�Kx�,�=i<�����e m�NL��o�����_������iw����iKE g9�W֕�l{���>�Z�Gmbڲ?��=F����*H�ٷ�Ȳ	&����`V����Cr�!�+���LR؋X�@����4XАC�����l#	e+Cc+������le+&�BcYrY�*��JV�FV#+C'+��6OY����f�rn5$�A&1�<����"7W��U��*���S|"��'�m|��Б��R{�dϗ����(K����A�iH��J�6�}��4�_�1 �-F �rf�Z����"7_��W��+�X���?2 ���պG��CF�x�U]`�m���by�^J
I|4�-��\�e�
�ǅ�B�"T��5�dh$C�Q|e�Wfy��S��ܡ����4wdh�#��@+M��'� +# Q9b +��@VJ� h���a�bi#C�1���,K���E��i��1��# [�;kQ�P�_������%��
��<�K�g@�p��J�[k�gE���R����:�V��x�(��8+�C-=FPhVD���"2E�э"2E4+��(�QY��6��5@U��k�>���]O2=����Sj����Dɳ&�k�6�(6�(}����� t�ٻ�cE'�M8�M8J�pH�H���l�|`�s� pe���_9��Q��)���     W�a���D�=F ��b�*��r��q����й� �r��V�^	��bU]Cm���k��5����XP�}
�r�U���[��I#Tۤ�n��m�U��&��Yp��*�u�_���u���+�9�����b�+5FP}{�W?v񄪋5��+ K���A�#FpCY���JY�FY�,C�,�����<�di1�:�5j���b�Z,�CN�# e�Q$�J��q��&�`��Jmt����Kd1p�cn	�Rc@*[T�1E*CC*�e��� *�D�j�Y��5FPuM��5�jk�O/@Tv�`�D����*�u�959��.�9eD�ijQu�P�p��p���P�!&�1�Z:D��,j�YT�Y�>� 7�՛g�c��*QQ���m�K"F�JZ� ����AK�A\&�**3����`&��6�@&��DВS� .rr����^2jz���KFK/����LvmSd6�-&�#�xr��g}^���ϛ>�����E��S��q	-����AO�I|�s�w��	��Er��A�R��q�RK�%�#��)M|t�x�=FVJ� 
YلN)��"���ؤ#.:�K��]D���E�L��".BY�A\d�#.{5��E\9��6p��{2.=�L\R8�',F9���"`�#�@.[�'훩��d}3���n�����&ڨ���Ũ��(5�[ZY}8��7�D0�#�K�ǲM]q�M]qi��"pK�D�-F�\�1���^�e̪�Rr��EVE�)�x��Rcq��`�=X����0��A|�b �#��0'���~ɨg�GgA�hg�Gׂ� �>�_��������$_]t��.:�W]%"̹<v�������o^�� #:`D�$�Mq{�G���Z�����s.��zb���#��N2�X�hb�"���4:]�ND�����n�rFw��2��:�����N�yE��yEp�?�����\I���(�@�E��g�>+�c�f���Fg+���Jitm�4μ��*���i��@5�S�[s��5oR���w����Y#:�v�������[Jᦢ��mju��nS���Eݦ:�.�f\�'�J{gn�3[�̽w�4h�x�t�I~^��yg��uo�d����QNU?�%�vt%��V�<���M�+Zm�U[�j����8�7k�?"X��Q�M��&�a��&���fl�f4Z3�>��_�����ڭ~X���jB�i�[#pM�B#¼������5�wǍ���j�m��O)��;z�%������@5ekd��9n�q3�l#�}ٯq�~��eѾM�o��`ӄb��	���W��-��9ߝH�5�׿�d,�ha��zVZ����eߢ��$'��A��rj�����i�m�4J6�.'�'���@kv1���c�X��9�dG1��PS&�K#��l���$���=��u�P��LC�|Q44�I���V2; �ѧ�T�iiY���l�,ǬDL�n���N~�Ud�7�z�C貲5�{���6UM�}���	�"����yu��o��w��G� ���~�w�q���,�Ƴ�4���|�7ỏ ���LD��g��ٟ�7q��D5�|�z�����e�I��^1�
���|9�L�Dsr�AVCb�Րt5$��Af6�@3�`�u���Ҫ"HJ|�
���V���l$]����D��]>{�?�/r�Wނi��2+>�j���>.8f��v�����i�]��4�������*/ߊ��ĥ���gF�3c�3#��.�}F�`3���4S#H��o�z�����`+#1��Hme$�����m��B����B��ُ}Tf'��;��Ψ:c�I���N�tҬ�f�t΋ 8�R�B�tjZ�KB�%!Y�vW���{�qrXF���n�ʸv+s�&ՙ��l:sי'��Rޭ/��J��7O3m�Js�FsF�9c�9#h�.��Q���W���([�P4���n%4�̭��V��V��TE�+�Ӡ(�\Cm��yR[��T�/`9�(���#0�s�Z���V�noj�sNj�����o�v~{�4g��Ż�T�s�����r>����o����TQVUct���=Uw ��j���n<<�U�S���'���4cK�-�f�-)^��xg?c/�ԓ" O=c/F�� ���1��%���!�f��s���_�_	���Jޤ�y�yF@�]�L[���s4.�-S�d��%ӌ�L3�>��c�u�����gT���@bw qr  =o�)�8s1���3cLs�H� ����g�o�s`?���` ��W��A���>�����G����U�IUqi�/�ϳ�	�_���r�w�\���ڌ�k3Ɩ+���J�2�3��"�F��w�-yR:�T�R��jZj�R�P���`>'+�5����#Yn�H6o�>o�A�G�3���Ϗk��Y�R �ܬ��^��И�x���$�,!�!�������?��u�A�� I���Ñ4�M���
#�O]�� ?[ף>����aÙ�yD�����6�Amt��8���d��R������jbA����XP\�<���v�q���?��C<�O�I&�&d��& @?��D#Л�!�%?>��-�y�,�I.&�Y0�.���$9�[�"��I�F=@��T�h�G�Q �wGЯ��u��x~��������{�My$��PnF��r7�9�^:�/{�o���5��/�М$N$˃I��D*�d{�Q��ZK��7F�.��\��n�d�^[E�3�E�L{��һi��x�,47�eZ�
 R�����΅���iD:	����H]0�ރ��1&`R�v�J��T�p#���O4�I��ⳬ6�h�3�*�eǊ�Ha�@H�;� �Z�����?k�="��YH6!Bv"e�=#>&�cR�<}^?\Q�=�����>�O�
*��$�Ɠ�2TU�����߸�1�>֘�� E�Fv��n�i�E4��D75��h�?,��]�
�k��G �n���ERK���uo`$z+J�A�$��t����q�Q��(��֔ZH���һ�0`C��~+_r~�mAԤӤS�s� /��##�B7{y�l]������λ-��h�����ڿt�a?���o�+���^��W
�P{��q�1��r���H�Z���
]�.��D{���Õ7RMCN�nU�p@@�$N�"���Vz��� /�� �J]��$�E�p Ay�%2���'Q�,�Kb��%1�撘�撘e�>C{~p�߮��^�yJ��$Ɗ�c�lK+�/�d�|�M.Ve[��gK�|֌O�Xv�>kV���a��vu��Ow��_	�q�N�?#����D�>���T[".��E�#��� �$�h��H?��׳^�Id�nVv��L=���@(v��/ᦃH�����Ϙ�П곕�'�� ڋ��S��"��V�Ӷ��-s�Գ�������9�v�׭�q^=��'�0@?�6�+�����u%6���l+���Ă��ѽZ��"�
Z> ��C�6廴�{`��# �|���1kꛘ�8��#w�|�D�QSkƖZ3Zj��SkF���lv-�_��#�O�ebVG ��ts�w�>� �9$�|�S��ξ��#��AK����9��#&�Ǥ@~ڭ���[---
Z,
Z����$�������]��d��ج��Y��I��]j�tѤ�E�b�&�{A?�$d͛%��Π�gl�g4�3v�3��%�Ez��E�)jQ�ԏX�ԏX�ԏX�W �9ɉqȉ���(�Q�Q�(}� �s���zqу�#��S�ŀ?_i����Z#�5�F7�6M+�}~}��"�x<vW|�M���bQ0�40��Q�� ��*�ޖ{Ӱ?0����O�zII��(�(=$�sR�����Wv���1��i7!;�c�����8�zF����*��q�I�Wylp!3�b̢.r�֐�s���Sp��|����ޮk�I��A��!��,'�����.K9͙���؎�v\x�}�t�$���Y�+X�    7�ǣ����O�����5�#l1��^5��ɛ&�5� �!���L��O�%�W(���Ne���n=�f��#Y�U y�ò+`�u/�# ��q���+B&��n�|UDj�:��Sq��S4�G0fPg�y�i���zZ���Be��n��J7�Ҫ��������,'ݖ�-S�d�������r�zz|�6��	m}� �sҖn�0�@i�U���˼C��烬��i�Crib:!��(�z��K���**rا� �V��d^�zxx��K���v'޳���� �u�cT�� }:	�T��j�� {��]Hc�@����^*��B�>[�������x==m�oz�A�hYZߣN}�$����w��Y-����)ii�������K�Q���{�,2�r-W�b�7-����o���3>E�/-��{������9�$������(,kw�~��ov�-����?�|<���<�g��>��E�-�/P�:	P'�6.��	,gs��M��޴(�MKý	�~,��"�+�	�!������.4څz����5���u}9�3_�$�S�xh!m���|���$	���4IX��d�@`7G��L��-iڦH 8�� a8�S��!����\	�yz��l��,"k��S�Ƚg�_���@tڔ���J�:��)-`MK�f뇉���Y`�=�H����^�b{�k�/j�pι��;��-5v-�H�:5�O@:��V���rm����Z g��9G���X�k�%ה�sm�	ϩ���fS�FH�f�)��@�K�n��]��fO���:iAu�C�M�tvA��.,g�M#�v�i-g<89�����0X�5�95��h#9�6��h#��,�n>� �y�]A��` �_���4@s�+q2� gsr:� ��x������ʁ s���@s�P�\�ܭ�$z|EV��=G���k���l�f�i�))�I�$�6�c�l�����y�BG����M{O	�=�N:ȵI	��vW�M��@m�d�۴�$�ݼ���۲k
����������G,��|B9�	��N(';��\�}I�$Л� N���f����u�jV{�!���/��K`7�nOH�L 7������{<;��E	��ܑ�pb!�%.� �>��)�	7��8��<��o>�eS�9�PN�6r=�a�e����A�-ZI 9���'/�;�+	8'VC4��u{:�:
�^8O����k�L'�6�����ax�q�>��g6��v��B�ٟ�e�'���ɷI	�iM�|{��쇌�7��~�y�oF������f��~3�i���k� O����@����d�'o���k6�T'y٘��{���eL2	dg� ��Rg���$�-�?yM�E�z+�����2�!9�\�G#��Nw��!!�	I�/r_I+0�!�?_��� �d;�+���z_�b���XAw��C�)[�g���*1[%����lJ�2�o�����E��6��׍h����4a��#����~+�T�����+��^3gxN��hN���\F�8aK�a ���$o���)���(Fa:���������J��&�����#]��}�6�����=���%5r��ܤNn��.���VnM��bgRP_�/�B��5�|K�X������ن���GhS��b�^>�F�IN/o��IB�,L�+�l����X�����f��R���V.A�˙26�1�H4��&�%����u
�F�D�6O��'\�K��d�&u^��kN��f����~e� ����y�ET�c60� i��W\��N��iv��}����Ah��HH���01��i�)�1a(7���-�{K�8o�/�'�k��O3�I�bRC1�PL�(&��?�A}���C���8	�S�$ɢ`I�(h�,
�W����"3$И��'�co��Y;�O��U��j��`���}��VK���?ޱ@��mo�n�:|���AQW3(���=�.EY�4��|�(�Ŝ�J��1)j�bb���&��,w:˃ bNJ\�U"�"6W�U��*b����H`0��4�t$@��������	MM05��	CM�Ӷ;��a�ƮX���j	4�l۱;��O!%И��7���0��F�1�w�����K|�����־)��̮�ި��T���*h�5�&�6|�̛s�����@az|������(�v')�3���$)7ͽG1D�tCQ3�P�.)vށ ]����#�T���?n�.Q=�={	��&s��<�*�/�8"��o�G���3����cK����ĤXLa�
�P���&HN5�ub�#ͭgV��ڬ�����P�&�f=M��[6\�@\�/��H���S"�bJ�C� ,M�o�w�5.y�{8�o��i��ӫB�kRˮI�]�zvMaل�w���z��/کgҲ�
DB@Y="ͣG�(a�D�O����.��_����[��Ց@[N^�44A-4���ȱ�²)`�ж��L閰$��bD���HS��T����-�؛�R�ԨJ2��:UIGC�#��4S֜��rj��Ԥ�S�@S6)Բnh���_�wEZw��Na�CX�.o�I&��]��|m�+��9�ܺ���A�d%u���Q65iVc��G��P�m��;�zZM?٤�9x�4/�!����,X$�5[M����l�@}� ^�)A�]�Ϊ�-sd��ܳd]��6��Q[� �M��[�t�%�! ��ѝ Hz��ݯ�Qs�a�j���?]q�^`$M8 �1�#y3�J�đl:%݅N��B' �MRs_ָ��0�${�H�G$I�K��R���Z^J=���lT�lT%��?��K6���M�!��.{$ߞ�۳��la<;��_���~$ۜ�?@'���2A9*%�1�T�A�9����O�I;��P~���7�`Q�=�.���u
���읠�%�K���i(�JY�$�R���n4��T�5Iڒ��.���4|Pʦ/��CJ=��4����yR�ӖK	he���?f��f�DO<�v�9ى����A +=>�l\e�G�1� Xٴ�eh�ld� F��Df�IryS�\ޔ4�7�����ɕ�HMnrٓ���$�l5�����ױ����2��B@V� `��i��I�*=�r_� Xi���nx��.�WJ�x������e7e�FYw�Qv]�j�P���8�E�,��ۛ�G��yd�y�6��6��}����eӍ3�T7��>^��&���SΓ�����&�&�O>�| �l�B���n9=W�}�i�)uI�3�3rf�1� p�T��T�|�z>�� ]ΪI���@^w)ڨk����6���VvnX_κz�S��d��c�@.��4j1�Z�_��	xK	��r>��@\���㝙HA�.�������U5����P�7��o[-�ӕ�tŞ���+���x�ҟ���+yV[�:,��Um����1s��UGk��Z��;��i���8�>��]Ne�!��qEE�+*}��)}iʀ^�2p�8xQ.g�]n�G���F_�ї��K}�4���uMnhrc�#C��|S�M���P�"����ϊB?c��̛��%5�2!R>R,%͇�o�����p����u#��������'��N�|i�t����k\���w���z��h;��[� �+�˾Ä�9��L^�&�ͻ�:ɒ~�9׿�~�$��=w�W����=j:����C�G�7]�"�~����(��¦��*L�!!��g&9�J�#���[�'&D��r��y.]��N�SЩpB����k�iw:߿�7�t�q�$���%��̣d�)Y�� ~	At����_B����i�D��3�Ώ�������������")��k�L~�Í�`�Ð����C�U���R�&?�Y�����4^MAP��MA�ބ�x+����ʭ~���v'�)L�H�S[�E���Q���y�;칟c���0�r���6,6,}:X�t��ʍ�{9��1��o꓋�dY{�G�`�&R�	�ϸ5������{�ߤ���    �Բ��e=�����ȁ��1��������T�_��pX�yO	,l��@�����*�I���Wjw�u�h ��Vٖ����*�R�R�_��_ۤ HԤ��O�������j���Eu����f*��J� �>����<!��fB��о�XH�&��d6����2��a�(���� �J� ����j�:�Ё�[�����a�J���LS��� yjȓ O� y��4���fǎۈ�k�=� ^;ݧȥ�86� �d�����D�;��HvvY�Q��D/��#�6���ͮf?����}�Ma';�5��)OwOy�g�ӝ$l(s���I������AXW���e<���O���ۼ��N"6�6m�7�wjRGE �2����JVT/zJ���Zw��˸rqeұ�a�c����0{'{w͓���;�ج�Y%-�|�>߲Ϸ��Xl	�
�b���zU�]�?�x������	Â0lT�D��#�n {�[�L�#,�A�gP�bԱ�r�)�81H�	����́
�@���
�pK�@>6���%  )YM@�E��gm7����X��	���ww�Hv>,J�`qJ�Q*X�R����u+q�Y�@<�Cf%YK�B�g��\��\��\��\� u�E��A4֦�A<6/ؾ��}<O�[�DK��@*vN���7(C�X0�`<�n>zNT,�q ����ö���ف�Xv $��ٍ��Hj
r�n�a(,�剷�d���f�L`�,����0N���[�f���z�M ��2���'Ҧ�k�~>˄�f��,��e	Xc�8�³\�	Kd�Hd
Od�Ld���L ��s� ��s� �:^B���KX_C)闔�jBɩ&{}��A ��(�~<>�)�E�r[�R�h<���M �:�vsp��A�F�6�N��T�* �RD��������S^%y$b�!��C���LS�n�����a(�0�UR`�7 ?�-��F�3k���IYX����>�~������#ӗBX��"�n�����s��ښ�ųw�X��=o
����HY�˔�P�5���(��N�"�W��U@�u�D�keIKIK�IK�IKQr�	$_��G�[A�u�RiWZ����zU�j>���?�L�2��f�8q�,�)<��=�Ih~�t{qӇ'krg_�]�yb���k���x�4T(#?!�e:���4����&;�]g��a�{E���X�'���$֘���Y��Y�̳� ���;��ǖ���EJ]�fPV_�����c��� ;�p����1���#���^�:�8�2f �p�+�$�4V뱺+��E!;k2��QcA��V�je=�N�D,H��
�3��rx����=+�=źe�v���I��A:V}��ǫ���勖�jwNr�d����F� ��1�X8��cA<�W˧ұO̧��q9���d�l,26�ǚc��_�myC@8�u�5K
O��-�(�ұ��$dߌo���O�EYVExVE}FD�4�q��y7�r�
�@n�o?�>�� Y��������x�=��ￌ�������=�Ǔ��?ܟ���c'ϬR|C�_��'.eQ��FU8�?�߱A>���$����v���Cx��t��%z(ŀ0�j�^|�[����Z�ͿpE ����cӬ���i�!:3�C��lޒmt����[����{Ѝ944���w׷ʪ�x��!����_����G��ݣx<��m�	6߄�mB�}C�^�p���_z[��}6��} ڗ���wc8��ʋE7�w@�/�w+8_�(n>��{Ua���@�o�eq�tХh�ty2��c����x�zY��|��虐�����?��Q鋦< ���9��ӆζ��VL����M��m~7�t7��2�e���˞g����
-�"��t�n)�y4��3�p	۔��K�KQ%m��R�_H��$��8iYN4Qkʠ͠�Cc|[%e����j��~:^uu�h�����z,�����������[�����f�W�l�:���j���&����@|߭����>(�?���ŷ!gwU��5�km�k�0\�tQ����� �&³&���i�:�����s�-�[6O����|_�ȋ��X��v���a�K�bw�IonO���6y��eu��e���f� �7���B�z>�������>�9�� �V`kA�/+X5���F�D߷]������=�J_��0��C�|p�D�R� &���\�گ��b�m�!��e�n�����xI�.��%M[d�p>8�grâ���x{ó>��{~˳U�>���m�C�O+�Oݢ�֓�o��Z7on�7�p�:��%@��n(�s5D{&vL��Ӟc�=����|H��}�}�O�8ߏ�?���E8�8޽��'է�@��um �}2��&�:�h�;���p�[��jwխ�]Y������!�DJV�uHZ�hn^��ݢMݢ��!�ADHr���Y��8%gƮ둱{rf��3�@_ȓ�Kyb}!O�����)> �Y��7����y>`]�D�Ф��n)�3��0<F�d'|{*�';���:k���MD�<�%�GKJ��?a>J��ڒ�S�u��{Cz���ϩ����_p�MxO��������`5��	l�h���l�٦G��L(��ANO�$l� ���`d��M���5�a���3���,ɼ����x��H��g�s�^s��� �0���ߩ�7���&�����KU�����w x����w x�J��7%n.eJb�i�w�d�/�bTo�:�~�M����L�����P/ u74�2����4��F0Q�0����㭄�R����$ﺧ�L^�������Hݩ�;ʐ�"wo�'q���C��i;����{s����33���ݛ�F���+�k+Sm�5�K�}*����(O��*�e�e��<8�2xY����$�����x⟻�Rx�N�d+���w�v�&��&��3����ڇ)VH�����Ȕ�	مX����a�6bwY� >Z�w�ʓ�{��{6���A�� �7�j�n�wܼ�>{�T�b��ީM����K�=�fd�\��h7V@�
��;w# � o�=]�N:<!t��=f[��v��nn.��b�V��ܝ��v�td�t������8�
��TS]t��e���Oz��<��.&�<�I�.��2���	y�Y^��)�,�E�.K�qC�>|u�d����4����JP�-q��ݧ�vw�'p�����g���:�u�X�
�w�ߞO:�A��O��~�i��\y�e4t�g���%˸?�w��N/|v����5|�k���%�N"x�����_��#yg&�:E�.u��Hº���ud����ZJ�K�n'R�ۉ�9�'ļ�!3ma�j��L{�=��d-��4��VR����봁-�f4���e4B����>��>dٽ��^'��,��^'��i�gg���g����}h�cI����Y�ۇ�ٙ�0}vf=��C~r��p\��5��B���^���~�r�}�rR�}�C
u����+��_�?���1S}��W���+�n%8� ��:vG��zg�L��K�n 8
 ��d����u$�5�+W�̗6M�[j6qK�K�\�[�^!D��R�З�-�_wz�)bM�O�Y\�̗U�C�6!|��N�K}v_��>{��q�!_��|��W�w�^w��	��	�������t�J7���}��MH.�"�h��1��q �e>;�/��I}��n�m�֦��/�	}���W�섿�g'�>��AD��9�Ѧ��/��b���-�!�|�}$��e'�@�+.d�b�B��� �/��{��M���א����m)��=���+x��P�MF��א���
I�<sI�~!n^�x���[H�%���t���ĽB�NF��
4_�f+|@�+�����-��ѯަ$ZLIxD�iJ����l�g%�e>;y��ى|��R�{QS�5d����
M!��B��|v!��-�����   /�RӲ85-�QӲ������0����B��X���ŗ�b��	!�5�2�M]5� �t4!��d�Y�X�,#� ����.Y����&]�dW��^qv��$�"5�,j�g�y_k�}���ۄ����x��H�tj�T�:�B��译@�B����
����&���5���I�[J��>!ҵ���D]C��R�]	Ŕ������C��>����+�Tj4/�ȒJ�]|gjՐ��uw7��e���6�e�:ek$1gN�6�S��>�,�����B�����V\S�]��-!�5d���B|+|vY�u$[�e�����y	�p���?�浵��V/K�[�r�g��{�^w�\SAB]SA�O��ܣ�_�\���$��Dmq.o�2��R�M�\�v��)�Mr\��_��X	���مLרCg�<��a��R��3 |���'��Z�w6�,W����5�@W���L�t�.:�B����mA�!-f�a��R�R,�(eD�lk�r�Y�V D���Ŭ �-�s7e2����.�����ls�R�ܣ�ۺ�b��� W��B�����>������Bx�.^�����-���gb[�pK��\+��g�"ӝu#��%�d-�-�Kp�}���z����8��      6   �  x�}�In�@E��)t�8k:C�h�:!�3 v 'i�o߬Rd��켨g~����5���7�7�[t	B�`�w�w���ܾ||v���������"n	Qb0.���O�p���4�&�2�7#X��}N(����H��D�1�K6��Oь�Y���oJ,���>S��Zg�c1/)WQ�P�$&fc�H鏁�}����rz9w�C�x�seZ�\K���ePq5EԢM"I��4V����h5�=�� ��P������||z�V����Ϝ�iza���#���8�S6��{h*�[!��C1���&��'�>R�'�$N2"�6����Ъu�G���S�����a�@k�My�LB�k2;�C�Du�!Y1`y?��!QAժ�D�B��tq��
3e�bȄ�=D?*��ʞ��e��fSs6̻�(<��-��b������ Ru-�l7ØQ�џ�s�VY�U��!n���o�`n��2H�#�wW2�5Ŕ��ݧpI�KU"�X������=���.d��<^(*u�Ѐ��N1̘�u�Z��W`���}"�������u�SM!�}��P�z'S^�Z9}�S��8c޷t��?�K\�lz]P��~�����C��M���](YR�g��uco,z�o���4���'.n@1{��.�`I�:˫�0QvA�I���ѐ�1�^ӏ���)X��ω��q�ǯs��Z�V{R.���z�����<�V�s������0�      \   �   x�m̻�0 й�
~����һih�|DqAI .@"~�N���h�\b ��Q���ǲ̮I*��m/�41*3��[Rܬ6?�"���g��ph`2�Q!Q��[Ki��IG�`CJ[���F����m��qqo�]���ܾ���R>J�J�      8   �  x�՛�nG���O�w�X������h�kJT(ɉ� �ŕ�&9�t�y��>B^lOuSk�BۤXt ;b;����:u��i�Ϭ�ڣ���Y�XV�$kw.�1��,{�X��[��o�ӛrTN��M���,o��ߊ�]sTN�7�a^�_��aq;?�X!���p˅��@��Łͷ�w���UV����(N���'�<(�xhqޒ�)��D��ax �N��r<����U1�s֩��9��	��]���]�O�ÇG�����Q^-'����i~7��W��r��Zc�B+#��^��s�����?sz�O�J��y��ٰρ�M��)�>S.;ʫ*�ST;o�(_�r�:y�OǓ����aˮf����u�~l_�b!cD���ϝ�-%��nC�ՁTL���-śN�L	����fؤl@+��DX4��1�Rg*|#Բi�M�&�2����"���9h�w�xξ�}��O�����ewx�{}���&&���K��-�.�sr�>��`�o��4�f�ʆ�6P��`��.��pΰ����;|1���A��%m�\*g~)[[��k-�6Glµ�m)���bD���;�
j:�NW�����d�$%<������!�M��LQF6�(�i�w�e��٠�f���i�;d���u��"_�y����b7�Z��z���J�wN!�k�@(Ƒd��lS�LX�@{�d�aS�	#b�Fo
Tr6l���9�DL!���[[P�#�ėQ,�ɛ��6e�^��GY��mQ�)ĭ��=[��������):�n%}�G�c��2;o����^���{�w�����:ll3��[F��l�@�é���*٣�mɺ3v�=��Eu����3U�W��*-�PI�k�+�ٜ�A�I�l��l(�0n������b�:Z�`R|�ͮr��Ճ�� ������*
�,8�����>K!����]c��nX�Ɗݾ[�#���C(��XΣ�JgyZH��Q����B�|���}=�^@�D[M����p��vU�_Y�k$6	�#��o��&qjv4$�9�g���QC�UFqv���5$by��#���P2j��D��a}��*�g�"�&i��΅}�Ӓ��M��`�]CVdQC`����OCkl�� �X�WCVX�4$��u5d��h/h��#Rʭ�a�bQ��3�YL;���:i�BXTm�Q�9��sl#X
���[��[��@�G���C�/��],�Eq[f��>{����;�)�L	�������>��Pj����0��R�g�'�Y��}�ZQ��\�iN}]�VE�y{TL��lQ�AU܍g8�٤����U�Q8�ڝ��죢lӐ�1�)�
��`a2����1�<��9��'�|\�rSV첬��[�"r%�Cv9�����1#���a��-�wc���:�� 6�w��֪UA٘'��xv;J>���|��g��v�`�]��ȭ�iX[�8%6�>ƣzW�sq�����dR���d�6��A�����ԅ�EPL�gm��n�"��D%�<��h�Mm���6�j}�'l�3����ؖ�M�$�����۟Z ��a#�����������I���"�Ջa�r��;�l�!�[��:ϣkU��Y�2L�ϭ�o�<Z
(�	Mp���&m��ȤiXpR��:~���Qނ� ~]K���і���I��BH���5�zh%��)��������|y?�F�!��)��]z+��<=���8t��|��@|��>�;+��gCGn��:γ��U���}�\�}1�_�Nˊ��No�����Yo'K�m� R(/8���-8��[XJOo�o�z���y�}�J�Y�5�g��54�^��u�}�|�Z�Χ��su���6T�ը�b�2�p1+S۷�	9�a�{>g����1:_��.;���v�'��r���l�G��\_[@�1�m�y� �I���BSj�䬁g��}jp�}1q?���>^�A��h]�;l�)55�p�Z�ڂ�x��2�W��ef��3D���� n$�c����B=ʔ2@B:wh�)�*On�|��:�����L�T�N��6i!}6hx(�O�V��-)���<�L{�K6��$]���tfO��k��veE;��әL�E���F�N��C��	�B��[[P��6۬��7<a���N��
�a�;`�u��Q���g?3)�{�Q���Y �A`8���M@G����%;��WS�_���?:|��N�P�I�pW忓t���{�'���s�U�)$L�'�D%��6d����)�x�ީF���ѩt�#�^���v^��GeR2�[ƴ�0�H'@&#��ބ|�-��MCه�RQ���C3eh�B���tF��l��C��0�B���e2�0tI��H��F+-��Q�@8���<�ή.��W��]fA�nOE���uZH�����O�� 麜Ĝ�18Q>�,S��i�1t�d��~Zإ�iP���=��/:Dx�A����#<�����0vO��i��J�M���� �V����|ad��"�	�kY����&���X����"h��� b��6�N�i��;��sB?�J����R)��4����ZZ4�W�����RsH���(�I~[,h>{���U�r߬*�'�\nVZ���5��E�E��t������gIO|{^�&͌���\ze]�5���#4���Pau�@#��&�,���w;��,�t=�~�;��$�ߪ��Y��'���y���. /z?�g�z�G38UO��w��O�Q�T�4�e�&�뼄u��<�ӫ�e�{y������G�>�h�i#⃓���� g,�f[���!E�W�� �M��|RYc������CS9�E~K_o����M1z��l�C���yI��ɭķ�?wϮv�*&�z:Н���f��czI�i#=)خ���ӌ���&$�я���~�ŭ�o�I�"8�� �X��?q2X�_�3�_��F��      ^   r   x�}��	CAеSL��M���!�`.�;*b�T)z�?���5�\+�3��kg��d	`	��	#�����i��
ՠz�����A��ƥg������;,2�~^k�5�q�      9   d   x�}�A
� @��xa2(w����Rp���O��V�_>>��'@8W���<S�2�gaս�QْF;Z��x����b�U9���V=�pë�R���1      ;      x�]}Mv��ص
�n�R�>��K�~m��L/��m�3"@�Փ��DB "$�ܿ��r���:\����J��/�_�Ž\��8��K�yÆ�����0u���4�gW�``8���b�5$��ᝈ��B�7�֣Pt���V����r_�Ix2��$X�Ǿ���'���3�3�#��k%K��'�۷|�'���>��B4%�����C�hiO>�5LuF�%��:�X��	5l3A�:��uR�8�N�̯�q=���j�� 'po߮ �X+��a5�WW��u�y���^�f��t���1�QA߳0:�q%��Ay.�
��ށ�+�ˠ� �*��}0��e���������/k�������y�@��-�5��䃍c/x/x���_/���tZ48�����V��?� ��҆�6	e+I��dM\D4�1$:m�q]���*Hu9/��hL ��v��	5�]�w~�u�V ��>����Z\�	��hӉ U���^��c���'Ap�I9��A�� ~��z��(Y�~Y�u�H�%V]�N��.�� ��Z�kԹ��Ŏ�b3�Ʋ���mϬ��ut\/;�w�v��u�~�σ=���}5M\b<F�{����H#!&��M+���
��Dp�c���hx��r��ަ���X��1�Ӑ��V���+C�f�>���A	�>�U��Z��h^�ff�%E��f1�~)Ip�l�Ki)�oR�#^3��u��.к��eAN���b�>8B2h]���Ԅ�d�}�
7�dȬ�|��[���f�ʦ�fp��6-8�۟��?�X!(-����"�T�;,&��V��g	�t��x�m��#�Zz	���z� ������4���c���D�Z�om	�TI\�J$��օTV�Ͼw߅r�P�8�g[!@49�R�Hu&�y���N��hkG���E��8q�־�f�f5.�gu�Id��I�U�&�j�*	�V�!Y��F��5��5�l����'��������9q�����x�b8Qj����������6�3�̵�PǺhD�̕�;��i�hJ��wM!��K��U6i���Sff}@;�M�,r-�bll\��韪>��afA-U5��ߗOZ�ܜ*b�m(��0ja��6*Ӭ��?l�ܨ�\�Tz9k=ݔ�&��1P�V:3tr����	��t�=�>�u�.�@�3��D�KIO/�z�:qd�Htrvs�X2�$(}���Ĵp���l��0�eEt��|�@����|�fT��@o��	�2��a~�SK����@S8�{z=_ú_���6���Z��*��ݞ�E�TU	������*.U�� ��f�9����9�m&SdN&�,>�P�?K�H�u�6q/���y�f���4s�Y���nv~Mq�*3(���ܣ}b%�՛p��}�$��R=�P��@�%x�3�����=xf[�6�Y$�H�6�|��H��0���m?)P7�J��v+�����6�zf7�sT7p6On��S=8�M8�"/��?E͞������y�H*����Ц�c��i*I#&���)1\�"�z�QC�m	���e:J�T~ ��<��F)�|,�������b�VC�|��܊іjw�s> "}sB��Ƒ��brn�ग़|�jf����!�XTy�����c�$I�l곆�r�e2Mh�![�l`j�dV���F��z���k�鼟	r��'26_W5˩���g[Qo�$Ýp�6�?>|�P��$4����`���`��c��������V0����nˇM)5��3[b�rx�J��
ch�4�;�f�f�*��Io�T�u�hX��ʎ3��Z�=As��a͋�wzk,�&_�u|�.�%��m���g�rÓ�fP�����8^��v.Mf�y��<����6��h����C_�&����!	;����p�rw�2�p�e�E����ۂ�����[!S��/~uasJh�Éð� %
7p6'�{=�ђ�B�(��6{�W`�j���4kH�h���)]zȚ����f$M���P�c��d�.�`����Td��?P)2t�?��n
İ���Y}�G�+[j�H�Zn�-��mj2s�Q�A����)�`����b���?�oQg�,!D1�b�v@�id9����/�����j�8�_L���"�0nbOۙ��~b�#��n��s�*� D�)�N�ܫl�
�hT�6+���ռ?�����l��Vm��A�,��h�0p�M��V����K���e�����������-jK��shũ�D�6ͩ"J�=yb�eY'%�$j��
���92d$�':�Z�#���?
��kkh%4б͎�l���9~Α�~t�sԄ�O%Q�Ϋ����*rǫ��	 Ӳ��/�A����페p�`�f�a�E+��˃�m G���`aB����<�Q��*�gJ�{���o��6�Ы��]>I�շީ)Y���+��щ�KO,�9�������Yo0�z���-������Z�0��B3�wz�}H@���걬�E�${����X�B�v�_��3�z5��}i�	�U�z� QYDE�KpA+a�5����� Y�W.:��1!CbEO�qL�Ώ�zݿ�38\��r�XL1����ti)P@n����ةp�O��F������5!2v�RG|�&�ZSOh��[��8&a�p�����Q,�����^�ľ)�}��X/7-.��}�8��'��}��!�.�U��F<j�e0�~�k:�yq��\�G�5��#~��\��o�/�;.���	RI�(94�rJ��D��v�@U�L�\�ˎ(%$I_+MrDE��-��rmb< 6�AO��*\�Z���x�\�]��|S��t���qX\+@�Ӳ����TH�x�x�7h�
�a�J�-�%>%G���݈�?ʨY�Yf[�گU�T�x[����JyJ�4�����Yd�2=gW��E$3��*ձ��r�W'��0곒�bFX�t�:n ��aAs�8���p�dYK:C�}�W9�	�=d����mP�Y ��X���8���;�c�����æJtj@��Y���=&9{69tb��g5Xߊ�ͧ;U��l~����]zzC�EE{�[�V�^�Vb���Da�z�@�L�1��̡ܛ��~���1o��ֶB���y쪀����$J���pYt�tz>Ϳ�/t�*>���|N�1uCɪ̾ǟ.U�/�[<���v�i4�����<o������<�h;�r@�z~�u�d#>�����sց��SM O�ޢ�=���l>�<���<��Ilk,�6A6k	��	���y���H}�h��ڸz'��z�Y�m���2�=(a�|/�n���p�	Ʒ��̡]3:63��Td1�X6J�>4�?����=���m�?���
�{�8��qvf���/���Kq5D7D*T�I�#|r����9'̆p��;[��������%	�gF$��^��TCU<���
v��!��m�Nb^:��z�
�S�c��GKG�3T~H�\��1�gڿVd_'g
vM@{C���@�Itfj�%�|L3p�iq
V^~ 8#K�-1��O6J�" #�U��a��	�-��>�������$6�Uai�X~%����m�����qVGPM��9ᬮ�Gۆ^Ǩ�^��:B�ͱ}[���1����1���9>Yo.D�����#x��w*�	ێu�^�����k�����t����\����w�x^D5�͙��@���1Zܡ��	.ueR�5@�������w��`�g2�^�z��<��^>��#���;�Ch��uey�}.M����bC���M���A�+��gvR�
�y!M�h������3�VK�,��Eۚ�LS	������/Q�c^���9��\k\!]���W]Y�h�A��F��=���[������*��J���@!i�UƔ�̯7[�j�Q�]sMO�P8���:,,ŖT�,��_5k�W�����Z�	xJ�>Ŷ|%���djMA-�!�3���f]%��t�h.��    �Z�(����)�f��m����f6�P&*td��J��f�p��c�����|q�fu�;�s�ז���	�B�v�2|O{��8��8����V�q�<o�/ėMy�So${xWt��zZ
�U�V�o�JzJvh��$�;�����/�^�o�ݼE�J����+֊�]�w��}���6\��'a���̵��L�>7�`�Y_Ѳ�N���=�v
���m������Gf �N[Hb��p�Ui	&˒�:B�8�]!�ɯ�ɦ���ȟ�����x�>�0M�E��Ct��w
ZC�!` ��
j; ��효��i�+�O�c��޿Oc��=��L�p�آ�IF34��0?���PE$��y���*�� �JF�f���*�+n�CA�b�a��#��ǣ�[BEґ'_��)Ա�
�^���F�:i�y��	��m�h���G�I?dA=��ph��������ȅ�>�?��"�&S��d0�#&�e�H���_rk����*�*`Ψ��JUl淡
!�P���0��<1p�܂��Q�ƍ$���NbL����E�5��H��� �C�)�ߨ���ypm�9�d���z�O��K�p��1���YB��<Л�N�y�a��PG��
7���-Q���ÊM�Q���l�|b�G��0��{�D�N^�)ʦ`������C��n`��������;}1�Æ�O�Z^!�� 0#���<a�1��G����r�L�Z
n�Ns6��'�Ugװ;�������`�B>�{'NbY�.>�ie�]X�ɒfq�϶�g�*�2�rٙ�w[�M�U/�&�A��<�d �8���D!˷aR��!agr}[�U�Nְx��ĉh!ѷ��-�U�@����$	���m�; �ZȖ��Y0�U���p��dK=$������	�
c�+y���{ͲJ�G������dIEU�Ѐ�e��4z��,��(!��P@���j~�7C����_���E�5���W�O �|�)�����3��d���S����	D�H�c�WK�ț'��N$b��:n��Ǳ�f�
p�c�|D�p}37�{�?L�f��w�Z:��	_�AW��w�/�t���̬QQ��䉴��P��'����HT;���3�ҵ4�ؓ�m�"�	TU��m����,���*G�_<0x90�/bOz-����'fК���L1��]��	>�MSt���:�םh+)@���ux���B$�� �n�Pr$��ݖ���AtI(���qЁX�.Y[�J"���UO�iL��T�i���_�Fu���Ŏ���9[�!�R ��6)��G{��5������e�2��y�Br?e\������r���}:�G2�f��$�1����?��<��������詝�0U�>�Nh�g�B/�:�7�l�b�e�Ǵ]����D�V�vJ`�1��>j�d�� ƶ�>�r���7a��2W�	�h0�&��~����jT�ֳdU�9�=ƛ0~*��}�� ����y�-}�*�V�[�X�P��ꓢLvyX�����*�%��Fqj��j)��^(eFT�����jQ�ɳ�o��LOv�C�O�����@
a�,yU���EG�|*�˙�IV-�)1[�P�v�C"S[��R/�x�W�5ؾ�_U�ɗ��P}yR�t�&�\݅��`N������Siذ�L<�S�^O�n������>���S"˙��`��1!�}x��PƠj>ޫ�_M��{�E��_��F��P�����p쓵�dQ��tL�[h~R�\V�KĬ�uq��[�F�šP[g�����$����i!eŚc�4>�Z�
��?bsʰ��B��%j�0�ﲮX�Bu}쫔�\�B�3w�9hm*�S�_�}���X�U
�V����~Z�H#Wg+�|���J���V;��
� �[Ֆ��U�(�K��9�0\������,GgEi���F���٭d���������`�sѝ��:-7[ ��Q�:0Lp�
�}�7-�5�M+6E�Od��=8i����u�&��#1�L��ws;V�dM���,�c�8��A�\�/��	�YQ������a9���2�.^%�h8��U%q/���F��F�I�}z�N�`�* ɟH&�F�]V^�,'��0�l'���:�$9m�e#��d����>�xDz/�}m2ݏ2��
�7�sd�*_�a��b�����ӫ����͔�@r^茄7�tْ����aK�,�|��+��\z�ס�i8����H�ռ�RxPwYN3��!��*W%��*K	��&y&4�H��<	o��Td���!03�tM�t���Y�Vsf�F� {�G��>�k������x�T�)W5d�RB��l�b+��R��J'L�?t�BhS.VzL㜰|�#KC7�) +�\�ӎ�uC+;�͌�6� @b����Љ�i����GԤ7cr�E�Bh��V�6�4�f�B��H�2�������M��p�����ۇ��ú	�)�8E�`ǹ ڧ�'��t����ל~�ƚ�Q=�(ן������������8+Ϟ�*���8���	���p*�V,��V��/���b�W�9΄5j��zes������hh�,������Gm�M�Ո߹�4\�J���ɕH�m��
KV�$%�F�=�{��3�*�ކ�#t���9[��rq:������>}�=�~
�ŹS�O�C|�	�d��TY�VPW��&�3���1�s��r�u��l���(���2-���ߦ6b�Gn��~�(7�)�����g�\~�	8|s��+i�*yjk�4�
��M�阅m�g
X�>�V�7�S)D�PE��C�bX���冏�l��R�ۦ���6쌰��ۡnɘ6X9���c��K�����5��K�8�>�_Ê�z�/��|{��nVv<�Ɏ돝ҋq{y�T$�@��v�d'o�6�+[ަ.A6�F�.AvJ���b��JU��-�G#&�+U��c�����hs(��RW������**�:n���24���μ�5����`G�Y8��eu�N�rG���V������_�w&lǎ�-��_2���Ngչ��e�m�p�~	y"���=jb�-�;p]��5�sj��I[,�'�jqW�2��ox
�ب��] ND������ �8�w�����G��g�W$qP�[;� y�aX�Z���ut�ɸ"i��l��WS2Q�q!Uo��^�N����[��.V&��#�㤐Ɉ�i�e\������m���\��8�n/�����@V�r�� �.l�mG��}������-��ӹ@vI�BT��ʫx5���􀰥��O�JkZIR;��&h��!��}��9H�s����.pq�8ap)A� w[
G�|�d�x�~&7�-� ԘT�k�(7�m���ړ�4�~��yٓ�t�HN�dmg7eI(��q��>�OpF����䘿�����$���䱨嚩!6� �`�:s+�g%TY�~��F�فH�Y�@�f�)��sm2��I�$aF`z�9��3Pn��P$�#P�+l{$Y�$�I��߈X$_�_�I�V}mPOF�C36�����i�<��W�,"�@WsM.:<�Hd��Q�j&5u��]� �.��'���H`v�p��mjTz��]�|G�0�@$	n����L��?i���tȘ�-{+�Cto�J9H9���ίTE���N���uBvG��6�_�%��_T�|#�S0�So�J���^�&�2��0��E��9G��yv���!��_�Y=ܤX!�r�d���(fwۿ!����#��P*�V���� �������i�&Y�^��;L°�Gw�8~w�Q��z�/W8b���|�tN7Ԏ�ܖ"�-c��3����l�_P�Q����\�C��ಯܰ��J2~����Cһ�s�p釽X����"�����}�j?/�A�B�&�7i�HN���gT�z�%Wr����I*暄���Tn�Ի57ٝ)I�ӯ�w�R B  te���J��4xA�6ǷR̶`*D_�ЪҤ{����4�V����U2N����aYK��<�y�ǭ��� ��8��a�:�I��,��<�o�?A�)�[��*����d�=�З�0"��l��m驀m��D�$����"�.(NYz�L�X/���+��ZI���3wA���p�q�>�� �X\x>ӕZ�V�o~'f%���THp5~=��v �ZR��UxO�9U�݂�E
�q�vaq���l����%�;�(Vlۉb�O^�
����)�;c��2���1 TȮ8����	��p���H'�؀&�Z�k|��0̋�}�X|��3,�	�X˂64uD�Ҏ]���AL�\��ŗWy�n&SL��#��W�LI;+n����̪�����?��}b_&m�p�����w��qF��:1��/����Ǹ�II��%�9��2E�p�/��?oW�5�يpS�"z,>G����g�h�
������'�7Px���G���k���Uun0�NW	h����\�+��&.��R��3�a�_-?s�Sѳr8'4�H�2�	v���mYEBQ��$��1	m6�����p���<�@e�b��$`&i�UZU�nuP�
�Q��zB*u�93`�M�w ���@�$���7���"�o��	�)4#oh?�yI������Jd�NP������NǦ����2k�LM�ɔ�e8�Ⓕ�[���H���(6�n�&���$���aCe�sx����	�~W_�Ru�I�.����d�>Q/J���00�(#�k�i�	4}J���+g�����C�ɱ8��}�/r�C�Q䀔B��o��DI�|���;(�VH/��IB� $�=Kr��xV�z���������8��f='N`����7� ���go0��cRI�q&偙��d�N�y��As�z�:J�p%�+���V/L"�:�ڥ�J�f�tq�p�i%�O��C��*�߅�%��NBuz�{�z-�HW�jծW�3e�vd{���x�� ����Z�%2���z{�v�|Wx��i��&�jIlb��d!�ի]�%��i>��֘7`R���t\*:2����5Vde�wzL�vU���p&�Y�}wHN�M�Q[��C�>̈́�w��M�u���G��Zǵ���p�ufJ��\��E�WDS4���}j�~mmq��]��#�G�2N��KA�U�Ã~#�<G�nW'�0l�s�:i��W RMN��W�s���x,l�\��H�7N^�WM�>I|��aa w7�%���s�����$X�,�o���%��Ί�ǭ>���E�+����y�-0_���k~��|���c������
��o�kT�1��$���W#q��������i�S���p��@2`�]��#�p��I��M�쮁D�-���`2�H�:���������(�T��6�����j��Sa2�l[��]�O�!	>&ݫM�Ū,�#�}8X��4q5��Mn-��d�-o+4��(����T������d���D"�\$y�S통aÁ�}�����x=+��R�/�3���A�g-xc�%۱�e�;f8bƈ����Y�CV��2(��$�$�,�s����#_�_(����
<�1P�
�YE:?���Cm��7��2��=s�ze�W8i(`�w��b=����wS�v�&j�0� {��ה�~1��`�O��8}�*�$�,z��`�!�L�|چ�	nͤ��v��f2~��L�d򵡳��6n�j&I=���rZj&�?��9ղ�I��U����@��RQ&9��K��Lr킏�tyqi(�&�<�z���ud*0P~��ߵ�r6XF����b�g%��B�x��h�q+�hS�L�i�94[��D��6��R�+�N\î��o�KH��#�6��ᛈ�\��k�}˂A�����m������Z�dx�(ITr�p�x���5��@���P������
՚n��dC~�(k�x%�v�3��nV���u��e�'@k�>m	��~j�zv�s�;��L��p���p啮|<n�G�=/<�Mh���V��ښ�I��o����G(�$�Vs*(��:U7ah�%
�o$��Xs���e�t���-ĹКw���!�ò�
�	���-����� C+C�|`���z����u��R4!��K�|Q�Dz԰�D
��-=P�S�D�I�2��<O�qPC���$�I�uXd�����}8DE��D��At��� p=Ӊ?`���OԤr�z��N{���]���m�}GҮ�=�K҈!�Mis�#[W�-B�tC�� uG�ˉ� ܞ�u$N߀�m/��)���WPO�Ɠ�� �'b�������6���h|���PJm4x����dO���d����'qޢ�I+y�)p���R�'esN8:�^^��T0t��D�:O���5��Jc��s�h��E ݯ�;-����~�8�*��D���hj��/4x��d9XE R���V�x��m�����һ�[6�˛��lh{!�������J���Mf|�ƌ�G���|��^Dp�U$/�xy/�V���w�z �e�)��`��,Pe���p�K��=ܞ�7�ҥ	����ʧn�I���v/y� �C�H]CZ�"��V���V��v�@�=1'���^�XT���N�k�FA�u<�6� �g���~��6�M�)P��Ц�_~�-���f�?l�omN�͇���cr�LZ��bh*O`����x����\�����Xi����0�E>�(�E^����@�w�;�a��h3��7xaϡ5�yo���X���#;_�3�
�/����$^s�0��p���ҡ���������uʡU[(��#<�,��c��� ���t�c=���O�@����9 (�Zu�{"L�.�=�l�~�4���vG.���~�L>~m��c\�&�˯'��4P��z��x�mp9���c�D>H�s�p�9���ϧ��s�®�s�����صa
K��kX�u��v[l����||��<q�x����H��
d�y��7#���8��N��Y]���ռ	fi�[�H[������sxH��ÛN�S�����������      =      x�3�t��,�������� $�      >      x�ս�rI�&��~��7}��c��~����$�(��@�T6fc)2�B�d�R��[��0�Y���ٝm������UH�EMW�Zt�ɿ���K�������![m󸗮�<�N�i����|O�O�&��~�e���m�����`���˸w5�{�a�}�o�^���o/o��n�L_����}�y����v���+��+��VRA5�ZKj�����J_��xѿP) t�s|��m�e<ۭ���<:��7�p�?�5W9q����*�	�gK�������/�D��D�!_�D��l����<ʘ1�����ja����� jd������mk�fq�^��8�]<,�JM֋�l��nByKB��u�\����h�Io0���ɡ0-��$F%��APV��LF
���&� xXFg ��`�D�՗J�iE-�B7y���e
�#�����q��t��aFr%�j�4�"�ɚ���ӛ��.�ˎ�l�r�8��T�AH��M��s��8Y�Y4K���~��M2<��2�S�*5���\X���I���~�%f�ZQ*,qH��r"�j�i���J�%_�Yi��1��\-k���h��̚��Ɯ�/��O����PΚy-&ZJi�!AƘ�ɹЭ�Z��ď�8�Q�Q�o4𗲩�\4��oso���d�]��b��y�����ϖ��k�@G�m� �v~ ����/����b29?x�g�5�0��j5B�,K�-�Y|����}�:�M>s��w;�� �=��rr3���)DO$Ȁi� I�M��m	�q��Gr��zFԀ�Ѫ�n����
�νd<&�ppq���^� t*��aC� ��]E��-���Y<�n?d���]���.�����^�`30PæÍz�-�{���k�&�MzIܛnbeᾴb`Q���F��MN)��h\�f�aj��ᰳ��"��SJx˼
�Zd�}��,5Jjp��e!A�� M��&n�\���x�b�-ָ��>�o����f������5��3APC�FOT����-�ޱ��i�Θ6����O�?s
�Gٖl���|�S�\���Y�;�!�8�.
e��ǯoF�����Nկ�`V � �R�]E"���Ϳޮ3��d�x�`/���qA6QT�B���g�?W��J��}����e���T\��-���-%n�#�� ��v��J���y~���m�q�p�x^�_�J׿���W�;��\sm�+�	lzp�������� �`8x	��9��ɂE,[��*K��ه|����H;�_3X�Q��~J�/�X���͇��1�q�j]�~�ﳃu�z�������3C��PSZ"��Ƌk�\<��b�E�eI--�	oI�PJkiI�<�/��#Ee GQ�a�#��L���>�L�/�L:P&-IK<�����W&�s�����|����8���������n���
���eQ�CxN��BA�$�q���އ��*L2(�'�0�|�0�L(��Ŋ���
����A� i²mX���U�� ���2��\���y5��j��&����e|�/���cz	��b�!Q���49?�$K�,Kii�iD����F7�{�:w�ד�|r6��0�����<�h�#����x� m���Cv*�"1��[�W�v��?z�]%��M�=B�C�}�����^��4��a�=8�v��E<�y��O1T�2 %�khog��H!��sUYD-� ��`�R����!]��������~�x�\k��������`�ZKS5�^ ��,���٧�	�˭:�#�\u i�z��n�h�� %�H�d_Z'M�����NR)+��m4�A�6�~��~�Tmլw����u�Uf`&�[S&��U 6H�%�=Q	Ȑh����0�|�.!P��z�!>��?���c�0�i��v����T� ��Ŵ1��z��o��OgW/^��L����o_ ��<�G
Kom���������G��z�_ ��$ /����3��k��F8�N�Q��������)��2N���U%��A�(HK��:g
��	�Y�n2Ym #�g:�a��W?<�頛Pq�	�3Q ��P%��j����(�wOÂƚ�
C�b����WS�����q�>GL�%���Q:��J0�*ܧ:jȈy�E��k����9��?�Pha`:�{�ޤs�*���6VpFׂ��VP�����-{! �`pkt[B��4J��x>�4��*�J�JIaL�	���`�jP��?�9,�F�
Y
H[u��,�8,����ޤ~	Qn<���)U�4C
[�}[� ?,V^	��l2���k���)I|������>����`|�rA��ʸ�FIZK����1Un����VV����rgޭ��(���Rl�$��aa1'�f�AD���; ��?�&�l����Q��
VY�E�7�%B�n�� �O�^���D)��ǿ�������Zt�Z�"z�(�a�R6uր��e�#�����~����OQ�>�|QWZ�'�Pz����6��2V�J�x�;����pr������o�x�
�z)iW5�+�v-!X1��E���<,��˥��ԇ���,{� ���!t�X�����[�?�������x�L�nz����t��Z���I�BЬ5*'�Q�%�,�,~3���Y�ٺ�u���~.Vq������_������?�wπ� �i�h���,�L97��@t�ԧ�[���e��X�!]�盭��j��+<l���Ӓ!��O%�դ6<-(�<Xw�Y�>e[���
R"ez)F]R["].�� ���#���O'�����k �/�jd���=е))�=2�}��w��, �'�i��xD]�B މ� M#�T�2�u�a�J�j���/�m��yį�2)�Ro`ۤŶ)0�!�4���fA�	Q��"ZXW��@u���j����W��w�'Ar&^NȰ?q��� �tTG�=���k,�YcTt�GX�Sg ]{�R*�$�L��		\Al�ZuFDV;��;�>��ݟU�&.��?���b.�v��2XV�Z�a�w�ت�pU���U5$��D��D�yd�z#�����:d��p�䩐�h2з��7���o�S����7|3�F+�ᾢ��&W�D� ����%셖�J[�'�SL��ޟ2<��ӃE����ڙ��R��r1gMC+�e�/Q��9��n|q$n��oR'F�GO���C��{����6V����K�(Kj��U.
���X����r�_��_ų�u�{L�J��dt�q�{Lc)!��l i�?�� 6����/���eQ�`��V�����R!����Ԋc�m@�xN����Da?ۦ���۟7���_���/�C�)Iу�� H�@�a�sb���Qr�z�iY�L�&��p��i/��o{Û����՚�W��5�	�����m	ND�O�����~��n\.�_��W������T_i^_���h�4�zZ\���*ֹ�o@��^��&�֪Ua����0���DUz�,*~@��\�ۛ��9(_r��T-�xnH��꺩�Pl2�Oz�pp(SB�Q�p���AVs�u��m1�/҇�rQ׌Y,�HQ�d-�p��AC�
9\��m��n��m+,�#E��Ii rg�A �MI;j�Z�?�»a�EM4��ɱ�> (j����#ە��TGiPVTg�3� � X%5�h�2���k�Dq*�<	?D=YY�[�S5��B� {���!M�E�$�,G�a�l���v�2�X�qq�ÿ���K�9�h�W��fP��3��t͒q�:@?H�� �۬]L@�^�.l~���9*
�.]�]�Q5��[`p�R@�Y�*� D�*�X�e������R��E�up-� �+W�mm��$x�b�7�%ǹ_�}���@Pmi�`�"�ԭ�>��[�t��jF�qHҭBT� ��X�p��?ze�+'0�XX� �	�\��    ��__���Ϳ��݌��J'���l�L��x�'x�?�����= P��/�ա[�|�Vw���h6�>R���x�`�)$I�A�<�l�X뎨��=�&����%�6�8�5%C�:��ݙd�U}N�^�:�G�;L$�"���������wBP��n��@Ƕ6�U��A�ĝ�[�3��R�C|���ݠJ����-4Ɨ�\.V�ٺU�sKm�z,5��?[{�b��im�ёo?D�����|�Ea�~�4u+�[O��5H|� ����u�����y�����c����0!2�\��
�֓'F��#��Uءi�S�s/M�Mi��̓jｓC'|( �ƶ�� ��7bo�:����_g����ppyux�[HH4J���	����;RҮrrީ|v�v�E��XL� @�J�.���}����@��C�fAЖnР-X/�y�]GW�C�_9����`�X�A�s1ۂ��^>f���t<t'
6�����ó��+�B���n�)mAP���D��u�wμ���$���8���8��f�in�z��>F<as�z/�9n\m[���C�?�U��	�D��- �A,��}k���z�t�j��em-Mf� `�:�d���/�Bd!Ac6MIYe�!���M�s����:�M��d:w����N@K ���*�h�F���w��r���:�Ʈ'�w�(��}��ƀ�c��H�W��WKU�A��g\�r�� _ K�T�����|A�~�l��'1�/w���]��/�^S,>��\H0�0V��p]g��EC�����GmB�� ���4�J�ed��\qve�d0_�G8�WJ��%� Ȁ�'��d�D�6g���-���:-��,��������b2}���.�F(����v[!���h0pv���̟�b�-�k9��Y��l�Bb��f���×[��4�����6ߥ�n��%�kW��������G��ҟ���
�7���o=atYtC���q�m��������	^����]�c����C�������O�?�"B<�Z�G�C�OP{[k�rj4��m��,7����8�/���zl� !���bn[̻|���⪇`�ϣZMH �"J�+hyy7�ϧ�����sdQ��V�����P���K�&M \9˗��K�; c�;~i���7�A��AX���t��1_�i��̿��\�^�+ �[�-!��ͮ�q,ڂX��$���ϐ�)iZ��4O0���\���������3o/��r_Nj��}9��ϼu4�H�*\�w<�W����8>�fx� PF[���������}�-2��&��տĽu����Fa�~�o����^`�+��hX��b(U��n�P����n?d�`�����B�#����J0���)���w�m<[�g�D���l6|w��uq�fHc?��` �l�e��9���kLn1�w����_v�6s� UX�Z�S+HliS��" ��`�d��M4_���r��:��=<��=_?l��t2<�"��� ��!2��A�b����4:���� ��f]T�1����DH�=)��4�h���݃?���&���{sp��pωH�#��A����b��'��My$
*�L'�I�R����`Pr,~�LK���K�©����TaC.,J�	�@F`��1Q��i�qO���L���!#	�C`��9����l\�nՙȵ%���l�6c��n�����'[Z6E0�(5k,w'+�6a$��#��m��/� P�%��`�?�a�P��Ö'� h����Ve��0J7�ŭ�2J?�g&a˘���{+^��[�Z!an@1!lm5��:���[X�)�v[�������|r���,�Pb���Y	�� ꅨ�g|�ȶ����G<�uv����??T3��bVdl{�A�*�6�� �u��~��?�}Ի[y6�'��j�b��&l"I� !�m� {Qo�׋�]��^��P��ɲ�� F�{Y�v'B�C`�u��"�U������#M��B�G��	XCI��	[���Eݿ�����c{�)[��
�hD�Z���4\�q~_hd4�\^l�xQ%$�oҲALZb`�6����n��I٩��3�N�N���u-3�X�gc���,[�	���e��D����߉ƒ,qCH�`���uAGBI8e�wB
�Q����g��y�#t�1��w?-�� T(z�-�G��(pM�v�	�,���k"�Ī�ai�K�Fx6�^�J�u吱,�5��UG3_�T"�-�8�c鿏a�<�+<���l8x�3�5��$b;�c�A��i�A�!�u�3��ʴ�؄��yv�p-�����E�����]w�k��������`>9|U)��Z
��B��	�n٧�!4���z�*G�6�GF���B�"%�����F�h%⒘�� WG���	�ȚY��l�����G]��S�1����;��W�2C��6�b{�mt�ޡ��_۔o���v�� R�*��i(Y򦡓�<gZr->���8�eh+�SY�I8�Ak֪U�\D����L� T&��z��` �a��m�G��pL �hz��0ݪ�_���f��o�*�b>�
X/gZg�n!���{���B���2_c�SN[s�I�^ �Ǔ��@Ek�$���&]}�:
�π���'���,���j�a��*�:[�K�1�I�v@p�|n�O�+��	�
�������Ϗ��+v�:�5��ˆ��[�e�3�x��]��x�ǿϙ֜����l����f
I���P�8h<&�p���hZd�TcO�.͑֌�y4Jכ�r����v���x��C��೩�c3�CIl�!�M{[A�Ԣ����y˚�t�>���[�?�a+�����p��å]�<׋�U���1R�N��;<W����Op˿(�GђCBm��is�|f����
<�W�mx�WZ{�	�IG�Aj�������i]II�_
c���ig�o��B�EZy�Ga�Ap-EZ��
�i��:�ʎ�&хq7���AJ���j�-H4��n�-6�y�!�8�d	�
W�u�`� �u����'_o��dlT�	^H�3g�'�����*c@�j/j,�Ő�AP�q�z�����S6�<����AX�
�P� f���yP��yS��>Y8w�5{\� �"i�$P�,�zC2K�靋�0\���W��6�8Sc��!G=;��Z��QN�P�A��D1!Zh�7��F��;0bulaq���I�L�f����0�n'M��/��w��G�%��l��������I�)�8�����[L�&D8V�bO�?
�c�`k*
0!�`|R�ƠUa0C�f2��,�%�����-d-��.���^w��w�1Ӻڸ�7ɻ��u2Ee-�_�	^���Z��=Xâ��H ��c��4.T@���ަ-{�>d�&�4w�)4㥅��b
*��d��yU_+U��j�Z�:��;�d��zS����?�d�����B	�ƭ�PV��ˡ������(ǫ=	�h�5�q��jD��Rp���� JQ� C>�q0�	�ϴ����K�*E ���TiX�,�0�H� ���%���~��_lPhr���� ��-�P����M���&p,��z�L���}����̢ɬ??��|�A!1�1>R`m��k��J�LM�^/�[��ͫU^������s�m�'���/]�����2:[�'����*l�'i� �����.����*-�?l9�ɰ��ҺA�X�z�h�yv�Fp���as³�������;H���J���C�T���R$5�X(-�Qa85+ ��0�z�d�α����>���e�w����|2=�H�8Wa�G@��<�X.��X;�KOߧ>v�2(oz(61�G+�A�'^�A�Dt��!JV    .���Qh^b"~�
H_Y�K�s��`��[��32�����l���7��G��6�/�*z4(���TH�Xo�j�b�l#p�S|�삕Y�q������H�X4��G�u@�V��D�]5�,���������@��\���a��8p����5[��|C��}!��o��G�+�D=NT�A`�M+�1�_� .v���E�4p.V�g���|�!�pu��eQ i�a7�J�kIKjy`����>r{��q<��o�#����dC�cH�x*�z7lI-�Q����L��1JF7��@�#�qN�anqM��Y�k7!۪XU�^;����;�\���!W�'8��|����E���O��c� (��[������Ȋ1�����5��e�θ��������cA��	DW�iH`ĵghZU�p��K���(������H��Ka?� ��J���e9���� �b�5�d
2M|&b˧��-:�)p;�F�A`tT+��B�h�Wj��/�����N��AN�[�k�
b�#|}q�����ԟ�����f8<���z5"�/i��		�V��BF�Yd�ƻ�����8���^jZ�����jrx��.ߛ�30�p���.���:o��T`���/��ɴ��t^�8�ks�mH��C�$��A2OC�f�=���}:�!�		�M[�۬�Oc�-w��ƽ;������8�AaO��5P�¾����2d�����KkRY<�\zHp.ݴ0�@;F�n�q�L��2<�7/�w�W2�5�c*�<��7��������)N�<}=��I�|�%6�쌂�M�����t�F�ј�9Cd���x��b��*���6�Fyxs�&�#�m��%��j��cm��o��V�� ��/�j�=d��� Z&��r.�HH�z�:2��5W��M�
�t�y1e��[J�^��A��m曀�+���urrr��n�8����W�7K،���$����>�����X8��A�a!A�GQo��0d͕:�4䤶�~0t[�a����w�/o|��k��	lH�O朙6 ���|��!u�y��������E�rOU���[W��[�I�W�N�˳D�a�XeA���ƨc�c"0�>��)��
	�	���F&�uyt�<��A����ɢE�w��µ�	�!�������P��Q����c�[2��:MeS�S|����A�7g�z�̅c�g���.�fq�JƳ�d8���K��I\[)�%�n�&J8���1�b����D�翗o�%��G�-�0Za�A��w�UÂ����U�3���wL��2��"��!4&qv�?*4�u���	�7��T�[�C����n�w"e�ng����/�8>
��6i7��J}0tF�$kW̐��uQ�/�)F��jB��f�zF��ڀ���sMI��A���rOU5������.�Y�H8�A�T��0�:�>�.�1`�������	��詅���h�������{� �x���A:�X����K�8��`�ђnO�!,�N�Ż��,~H��ǧ�1]�<��uY-N�r7D�eߋ���j%�y<8�����-p,&($�D���/��@�!p��iP���󐮶�/;��z�y��QȢX���+���N��,A��ʖ]�FA��~����?<����ұ}��ٚ�øq�VKű�Z��e�8���t�c�3O�6]����1 7fD�|V�H;�w�վ5P��o_׹��i]�k�|Y�+/�^&`�W)��"0�Ua!�c�6�ѬN�C�\��(����؇�	�:�Z�S@���� ��D�o�,@�nH��ǢBϷ��&n�l`�^]��}\KO�?�-�Z�#1&����hoޟ`�w7�y|?��!���Mk¹��Pߞ��ɣ������ɦi;�Q��Cp�����A�+*�z.@̷�0���o�v��of��MՎ$|�	�BC�-t��}%��q��[�0��H׋���붉u��ݢ�X��'��q�e[4�Hܤ��:��LX�L����~O�û=��bˊ��5���? �}~���Ox���c�x�F�Y�9,!�`CĽ���1�(�ۭ��	�1<E�=�?ՐZ7��Ӷ���-�BU߁��2l�p�0x��2�0v�Ԭ�/X��!R��N�pG����⾻�>88*�c).,�Q����bo����
��%�g�@������֯�\���<�=�4��i�$�cS� PL����.��Ap|+��-�#ج�٦8�:�������`�n�A e��J������R���.D���5N�d\5F
!Z�U(vjx+�8��!��Uւ��v��m������l8Mf���ǽ����/qp�%t�8x+��]��a2��bl�5��L�o���{8Kp�@ǐ�:��v��GI<�����=���׸���I�eWFؑ��Ut~3���W-���V�4���K���n"��Jk,��B����dϒ��4��i2���ɸ?����_�!������r��fG�xNU����ڟ߉�&���T�n0N���c.'�a|�w�b<8O�Au�ItVI���YB�ߛ@���P�d�T� ;��|8TI��8�B'{���>�ss���i2�oc���C7�qr"�kj��_kS˯�����o��0�4T�#H��e�xٖ�1�A\�xpW	]��8��`M4�OG�ar��r�&�h2!aH�͢�D�����+�6_p%\���	q7�qH�����Osr�?�͓qo�zyF���]X¨�g�C\]���L�ڴ��h�l2�����i<F4��2
h -4��9�f7�cX�Â���^�/+���	|r���h�zr���t�;`;E,`li�MF��4�d����1�a{��?���hp�Lc��� =t'Ru��A/57��E5�l,d���J�6��^]=����8���!�E_���ݸ[�,դϢ��Z����_ƒ�����X�Y2���L/�����>���y���R���PO���o�i��fa�nzs_%?�	�L��r�﨤���%7�9D�#����\����/Kq�D��|��d:�����.PPn�*;���d8�	��(�PE��k� !��''��8�,"^{�=��u���W��M6�d�ˮn���l�3,g�W�=�%��c������]s�Yd�KN�6ޡ8Ō����5�W����l!�%W�!�ϟ;���ǚ���|�>��!s �4+�>���OWǩ�E2I��נbA�J^<�ǣ��x6�=u��I��T�(��Y"�1d�ste�>���u�F 0�O��I-U��$���sa$�￞ƗCǈ���k�ë��	�
�	v
"�I��?���H�8'�*T�ϩ~�򳄅ۦ`6J ��v���r��`��K�}_�c�ZF��v�F���	�o�/�i���&xx�H�󻗿n����{����U��e����ŝ{c�({E4V.�Jf_0���;���?Ǟ BJE$w�@Ŧ�_i�HY0��v�U�.��&e�r�����@�]Ψ�C� m�'�x1atI��-�Ņ��MfsL&��5�����5f�⮯��=�:P4��(#L�р��*�Ts!?��p?^�\����KK��1���Յ���5$f���� �� Q�۪EQb�ޭn?�����n�a����1�JK(��µS8���k��� �� I�y�RW�p]p��x8W9h�P$���?6�*D�S��o��v�3�rXS�s��=$�������J�Y��h�#V��/w�%*v�.|M�1�(��%q��[���ற�2��H�b����r��Z��u�r�o�P5����?�y�!f-������zz���+I����2js"kYr�<�uﲱ���z������?Ƃy��k�.�8�ң�H�dM�j���	́@Y(�ۺoW�}���-�K��58��	p�R�'�w�    ���p'�;7���4*B�*}:A��Uи��Cx4UAS�E�l���J�;7 s��~]��n&�Ǣ#�&����pH���r��E�4���j�+x ��Є�]e�Z?��!�i���o��n!\�Kg��wB���+C�we8�����?�;XRa�ap2��,]�������!��.7�cq�Q�ZvEiq�
/"��� M�����=�fJ5`n_���qn��:wu��ɠ89n6y�/&7��~$�˸ŧ��6�����#TH5.>��{ݐ�#�e��DIԄQ���Q������ �$��K�ӆO�0gYb�n�Z�^��*_ ��A�՟e0"pgڊo"�j�ζ�:~s���L@/�����k����J^��������8�����A6�-����Մ���r{`]��s����\��1�4$��[�z��TG��}����t�vfO|�b�P8�F4RJ��-�ͳ��6�.B;�-9����e��+0��U9�;����ih�K�^e����p��f���:��Zk�``m�!AL�Zs�-w�O1����^����Y��(��kɃ+7�*�AC4���z��UGWh�s`���=>[翭Y���x�خ��zr=�@R������V(�����lX�,6 ��}�]����_vY|	n�!�`�������`�Y��Qe��y	��`א���|u��~?�I�W�#uٵ�U�/&�AW�Ϝ�,<>v�5Դt
�l Wb������,<n?L��x}���Â�bH�;_�	�T�ZQ��]��[�����G��}�޻ ����4��s�T�8�h��0h^
�4���y6J�*T���6���C��=Q�����WNs� ����*>5t���	�$���7�KR�*����*R�k�q^߷�3���&���u���`�l�yǋ���)8%��p �{�|B�*�F	z{�q��t	#knl_�%�Hر�%��wX�q��/+�؂���B��D�e�_�=6��_ӆ⾞f׃xt3��#��1U��R�� ���5t�}^�?��|}J��	��M�el��/8��_��Q}BI�6VK��?�fv3�����;�u��u�%���e��e��|2>�U P���O0<�y���_@�5�,����m�J�:%35C�/�i��?����gof�5��U��w���䱀�hξ�z:�����l�Wj+��R�&�?�;�Ǧ�Jv���8@6�j.�M��� ��Kl��̮� ����A,�9a�wʒxc]���h�F	9��ا�Ʊ,:��I��c��]��������n7Yrs+�����@��X��]��þ��j݋�9��-��j�F�f%'�)N��*ȥ����e����TpH��6�n��PAKՑ�-��x����(�k:�}���>C��cOl��� ���������P��R}m？U�%�[�y]��� ��_��E&�;E�"�^���m�O�P�����ʚ/��K����)]�;J܍���2�i4�WP�	���`�(�9�n%��R�b�;�Yh��y�1��VA���e�K�$���_\u�"����_1 PD=�,�����3����-vee���F�+�w���dO��*P�/��J��W��D��S�b��=�W���~>�u��:�?����9SQ#*w�w��4d��Ѱ�>a�E0�9</-����@iÙ<%�RI�Ϙ��gH��?1AV�U������%6�*�+H�%�.7!��p�E.�A�\��;'ֹ��<8��w����Z�g�ΐ�����P,�{�?x��������sX�����8>���x�|��Cc��pը�b|tyj>�9x�MY�C빟�-�����@��z�ݥ��b�nr.>\��Oit6�Z�Sb([YJ´+�l6"h� ++��nbح����+��u"��p�� ��x�*al�a��.rЬ�������*�7(��?�V*M���p�؏/)�n�N
ޓ�pA��?� ?����'�ٟL���eh��g?���U��~��PB�ms�������{gcH!hr1e��fh�bIA�%X�Z�4!_�U(�2F�"��A��Ŀ'pz�
���[�m�c4������~@gtT�P��93i!�dʪ�Ā�oZ\{!��b�c�ٛ`���=ö��&>H3��CA�aH�Vl!r�&�(E�hM1�d�R�/+Ґ9F����v?��瞵���5Z���-ԙ�K��>��	\��4\��Pl�A����Y�F�Z(c�a���Եk,W�d�$�qb�U�dTV��ź�S�Q���h��m�5ֶ P���I]�a�G��W���[��I]�g��!
	��i��*���z����Kd������)*+�R��$���@��b�Q~�^#TB�����>�E�%-p�LH��''��b_u_iC
~g7��t��Ez���^׸�Ν�I�ݳv�`�Kfؓ��
�N肊�*(R3�����.;o*X�}D�}�T���n��(yq��Re��
n[�c�Ȁ�4����:e�F�7����ie�G�¹،����Pm�*�Ǳ��v9N�����4���5���U�&��E�_�	���_Y�Q�W�(�+�Tn����ד�rr��Gݹ�	����|�֕�ڦ�	k��pp�#/:�	����Qt�a��&]ۇ�eM=�:�Ɂ�{�Q��R
��!A
�a�}�����U<O��4g�tu��ʿ;ꂁR?y�R&	�ӵ$��Ƙ��S8�2�)��{pc��Ȅc��� �]���pf�z�X.]�������?�����6�Ga����/�-�$�z0��A�@3\���L.�ԨN� �s�QLaC>�>B����=��N}��֏��vC���f��(ʽ�K�n$X�`%������G�
%�ĕ?�Z)(XF� ��K�T��p\�_gk�0�N[	b���u���G@&m� �ւV^��p)&k�J���c���95�w�*T��A2\�6V)(�A��4f܆vwv3ÎG?�.�K�PP]y���mKd�[�m�8���rБ ^1�i
�q އ��������ӵ]�).j���E��:���3lB8M��T�N�o��
����]�~|�[}�e�Ϲ�?N��@������*��Ƌ�x�N8�A�e��?�c��T�ZfB&X��-��T�x�W �#i;^OSHB�$�
�E%{U��{E.6�	fF ;�u٩?a�Ej��d<P��6C�g���dyʀ����$Gn7�'��NVD>u���O�}�u�20��6Y�5�'!���9��ݧq(IYP�dU�C������n-PYRB�!���J\੤g1\1T��5��4��O�v�dw9�aO��A�u��?3����k�-E�'LT��رF@eAY�ۺ9��ՠ`���B�*��q�C�'��=���Br��|,�050�|vOu��������=�4���$�FnJ��Mq�\�^M���TN��>����Y�����sŷ����W��S&�i�Z[��*�(T�z�_UEL�)�]9C,\��W���R)K	�?���cWMwqr%�b,D$�w��k�s�5�	=����N����aon�J��4O���\�%����鯶Ϩ�����.a�5yI�O��M�w+�4���:w�Z��ޗ����-��܊ x���}�^q�G�N��Q�b]X�d��n�%�IGw�����'��s��|r�?+}��"X�c�j��f�s5l���h�T�+�,��S�Q��As#���gd�E�l�?�V�[?�w��?�%�
�l�`P�����<���.�y����SS"��TaC�w�i]XKbD4�-�x�-���9��_�"�n��bڍ��Ԙ
�fly4JW��U�����,]�e?�k�.O��F�
F���[3�%��*w�j�W�
>:$p\h�fJI4N��
�u����_بB�����TzAM�0���ݯ��o/} $  Lo?�x�]����Vn���Z�@%�n �`��w��O�|��,�|Ժ��WŰ����{���������ob��*췡����)%'���v�����m��s����f>��z��J����&������t�nܶ1��Xe�m��f��S_c���1߭��԰u�{��|�w(p��"S����Aq��z�x�ǃe���c|�ccH��m\c:������*6�3��7�%��m�hZ��w�ܘ���5ԩ�q��r��������ac)ic�|�=�6���M'��z�w�wiQQ��c.�~8$�e�#X�� h-�i�L��!lӻ�Ϳ��,o?,n?�m��_��%���í�Z:�R�o`M���5�A��U���(���,X����ll2]�n��<���+)5�R��m��V�-:��7�u���n���A��U�vlL����J�&�����]^Ut�⛩;��� JH�Z��6^�t��.�_v���H�R��>��q��<o�@됌n��L��].����<f��t��l��|0!|e'N[j4G˼L�����cIMՂ:� �"��h~���)�-�0:z\�����0�҅����2�H�n�����óܶ!�H�Q�`(���c�b�^�i���^[/6�X����H`m��8%�pQ�E���ڠ�	;	�V���f���b�̼����Sgt�Kߓ��ex�m����n���0$H�XC��Ű  x ��}�M����g�A�� @h��m�v�ޮ�t�)~+a�.Vy
���ߢ�d}�N��O� e�
�ʀ�gJ�&m<A��n�S$@$G6t��^%4��2�B�����Q������h��N���+R_领 �S�`8��mX�k
�@�
�����X�8�/0��S��{~�g
pUjQZy����)�`��Z7Lb���,��K]r������d8�l�4��{
��1�yb@�"�,����t}���.����6]s�v8�,��������pS�����`�0�l��Ҷ�f�e|��� ]�V�&^T�� �ΥR��
�#-_FW�����p� �h� �U�k&+�E��Ȥw�1AT3x1{\F��d:y{pr`�>��1��:��YB.�����ɗ�m�&��ٍ>(��l6�t�	�G��8��3s�E��_i�Fl�zN���i�n�*P��˛���V��b��ܭ90���M=�H����b���1~Kcw�R(�l4��'�C)�����"+)�� ���X�\���/����RVS�      @      x����r[I�6���l����)ى{���7�((A��*e� 
��	, �R����^��̦mv�Ջ�q�8 %�e��ѿww�����z�֫y&^�l��m�۞��<6�����'���I�2�tRk�:Et�wڟ'�~6�Ќ�����M���H��η��+����א�f��iud���������~�]o�������y�>��v��N��Ğ��z�2A�#�������t 8P����b�?�^���Ɠ�$����O��l�Ӂz�ͮ'�<Xc�h���כ��"��Ͽ�xX���b����"jn�sm�p諦׿^,w��t��o׫���5��������4z�m��*q�E��T��`8�f���h8�NG��l2�QRġ��.���S�q���n�ǲ���v��d7��f�	�u�]���1i�$��P=6W����n��w˻uv1�̳�ǇՎFl:�s��.X|�/���Lf����4c�Ml#�p�AȺ�5�#��g����2�����$�N���dr��L���O��ٴ�K�����)�y���fX�`�?�n1�E�ѹ��f��N�7����ٜ��m���O���5<+&�����6�p4�����D2���mvu�qۣ�1���`�t����M�'Jq�V�<Omm Z����{��jDaܿ�c��a1Y��g�ֺt6�#I�F��r��aI�a�Y�,��lq��Й/ԙ�������K˘�Uv����Hk�:��g1���$ih��,�����[_���"��g���i]J�K���ţ�Q���E���F����rt���/��p�f���=����{"@��#�{[Ňi���&]�_�o��n^����q$ep�H�9�)��Я�^ov4|���n�qMB��7�6!��J��� 5�H�c�E�@*{�ŧ�b{M�w����W�E�)�l#L�����d�˓�5��̆UN�#:uh-��y���yM�$��bA���[^�މ@;�V���H���NZo��M%����f��f�EϿH;Lr,�7�K���l�Gz�H���P�t��-V���-?n���|~�$�	0�%O��|�{�����8�lzR@~S�4���V#锔=�~?�-m?n���Ӡ`^k���O|����ȴPtHoy�4��<����汉�X'�A�:2d$bO����tD:�lt���A2��!g��!��N�����N�]�>ڤb�\�N6�x�/��w����)<Iq����#������dr�e�Vұn~�ѿ���mv���?Ж���{|J���$M��T��Q6Gqأ屉�T���V}d��Ab�Hq�E�A���l��/�����.6�kZ��=�:_�h����H"
udI�2��]�_�P������V(M�ˑ� 1-:���t�������M��h<f}4��~v�'�\t"5��2�<��9M��������lx����C���a��5�i6�y��&�!7*׆V���1W 4�H��S�	�X*m��g��OZ��jzF;$jmJk�����ZI�5�-�����v����r����i8�l��5���q^VcCZ�I��X3�M��Š<����܁���O�<����%׃�9l��gh��(qn�cg�D���8N_�R}���0%ô�}3�/Z2a*Y�s���!��f4Q���nBb16�&PS�&M�m���(��� ml��u.!h"��p�G���h�I�����dk�%����I2�.<�
�� 1��66]��v�f���rtFj����>2�.�Ф�J'�+t�����]V�����R��5,d0G�6�l��7�#� �]ei�L�\Ji5uҁ� ���qn�H=Hd!��}-?����kđ�EX����^��ԌC뼣�#�  �s� �06]  ��X��5�<�c�֤nw~x����{lx�ZH�n�����((���A$֨Lk���bbq���' a+��i��qW���(��8��%�e7d�R��g�d�$r��SO8EF���k-a�� 6�s(��$ ��x����L}���b�ؐ-�zؑ�x�^���2��ʐ��p9uGBЙ�<H�d	�ʕ%�0d3
C�%QP?r���Nj	��Y0��W|�x��Dۂ��d���g2��sAJ�ބ�{Z�1/��а���|.�� AiPP������ƶ�ڂ������%�G�Hq��A[s�Z�>���כ�rS�ʠ�ų�*�������]H8��p*Nl;��JN�ؑ�q���X�}q��v[�'�����M�@�,Tl�*ZK�NH]��Ȩ�ν&��Th����8Oc�Hm��@����T���v�J�V��}������}���F�e���<a>N����-������_i�������|���ٸ�oWie������$�th���T���D4@,w�	��o'�o'�'?�N��ǖ���[�ڒ�#�߱��,zG�C�4;�t<��|�4T�/|j~خ7�d]d��sR0�w;�P��"�n ǚ�IB��G�Ħ7%I����L��a����vZD9[|\>�f��f<������	�&�Bni����]�����xH�]�8/'����KR~��S=���9s2��I�dlqT�~q�0��^�j�Zރ�,D^�@W��NBe@,z���y"��J�˱!���INg��]h�jmA�#����#Tl����S.P�H��d�d��5�IlN��qv����3��'�w�>jÑTp
�x�N^RO������cg���k�.�\�gղ�����d&�X��_�,�����h��ll;���^�gÓ���ޒ8Gc��<E�����lp�Zm��z������w� ��'-�lh�H��3JzK˅�mξ���j�.(/7�{b�}����4q�@:Tl��7�0�<�B@��b4O������b�}�����Ř��`0"Sf����?���z5$�/�S��syj�'N{��V�+������]������j~w�S��r�{�1d'��
O1�%]��
᚞�Y#w"{���f������6�=�_��=��-~兠�'�}�y~{�^Cm�ae�F���(��d�	2a���LoVP-�K�N�8�m���d���)���n�  {ܻ�����1����/�l���D���3t}�q�y�K��9����wٿgW�!ݚ�=����RZ����i�J���~�{2����8O'�'#����d��49�e4��)KB��0�P|��t���[	�h]�+����FC�'��#�ϴ�N�]��l-�"k�!��y w0���X3�� �m�������}�K�Y�7�Ib[�=m���:�E�d5'�k�Ѹ󭲁��ة�� I\,�=n;�h�X�Kk��h�}�>,�|	�Gv]")���X��L�:�7d�����AƆ�`}K&)�ί�+ܶ�P1���Oi���F�ɹW �I���t�8����*��?�7t����m��hZ�����\���4���=n%}��Ժ"�ج�&Gz��Ф��`Ҧ��$&} �i��Q�.�N�Q����d5��@u��F�&�� @W�6\����Z��k|�z�Zo��s����e�Ǝ�&^�G�4I��{��˯�I?��\�]�o7����������|�}�B���C��t����`L�x�a��av��ph����pC��&.L���L�@�,��7B�^ZI�-�b�M�rv��ښ7;�?������-�\�M�"�挎 :�B ��F�o(�-5��pbix
x-�'}�f�~�BF��Ĵ~L{`x��I��~X�)?��o���D+��
�$D	D(��jP��J�)%�j$Ѥ� W �q3 ]��xB:M��?e�����x2=A:�ҧ�l[��^�X��?�4�t<���"  ���g�eQ����dyF�!M]A�!$$�mH�)o!9 �	����/���#��s"�u�ZcC�B�����Wן�'�:F& �62S���lm��(T��a9@ē ��h����cJ2tƛ`�����[�    1���5�����,��c�G�!$LVqa4��D��cQߩ.��uJ�&��L��w8��.n:)(To6�E���߆ĊJ���k���|߃�Y�B�0��������N��/���]S���qt�H�`z'хIϡ��:'+J�ؤ�Z����D��A+�Z\{[�nZ��r�����c�J��p�aBS�<���'#�)�O�����:�oZ d��r�9�U���&�a����ֿͳ3�,���󮌊(�4��{R�`m�!��4D�@�
�@�}�fc׋5�2�4Z�ݔ�;�6��y��?��!tX)�-S^�Hx-$���F����S����HK�l�����!b��f�p���_��|���Rw�m�+XG>6�u���t�JA����r�&�AI�RF�ߍ������F��fղj�#�#���X�"�c�h��-.|����q�&D�B�+FYs��������5�D�-n�:h���x�@�Mg��uv����G��$<I#B���� l|����By[LvPK��:]�UW��	���E��iS�],�"�2��i8^��x�N�tw|�?�_����ߗ��u��:�t����H��-�˸@�� �}���!�	#=�V�^ZʑfE+���u��_��I����B�2�d�������_��X�&��.#Sh�S��?�(|lRw�'s����hЉ�v@����iNR0hB�~wd��6��Ʒ˻Fw6��HG��f�0M�U]2o!�@1Q	��q%���w����B���C<�a4�O�tb�+/�k�s��w�·�p*�=�2z�	�$�By���1~�
��k���u[n��v��U�X�:_��K���0�V�q~�`�Ŧ�-��4~���EZ���l4+�	��8�u1_j�U<BbH��W���?a���7�`���B$]�]���齑�ϵ��|`�ݖ�!c�1�{A���$km �x�A�u���h���G��3R������̥2EM�  ]�N�.h���@�;7)�IRT�����x
D�yum�Q Is9�O��_``�@��}�\��/cD�U�����f{���:f�>���i�	4��C������(=9b�׊�'��foT�a$��>�z|�U�����Ve��[\���p�&�S(�t�p�֫���~��r��J/_�V��zSP��'}���/,,l�NR[��HY��y�H�Od�������!���ן����N��`S�X4�O�Ȯ�dٍ#ڔ�4mM�*n �d0�`6����$�e��V�E��N���/�;����0[�e�?����|e���m[��|����^"E�&]��c����A���17!���^�n�4L�Yt!�h��%T���#��>.��zǹ )��� �P�$� ����t
w� 7���nɦ���#��(%S�J-?kPbd\�-vj�غ��ݬ����|#4c�2h�Hv�`����@�P�v�Qb+�G؈���o�6F�h���}���CaTsuħl��|$�n6*:��P��Z��H6��O���\W'�N��Qr�|�d�r���T�pN4�X�&'�lu�RL%��8���V{T�H��q�.�}�/6�T!��#)Qޭ�r�mW��=�2K��f�{���O"%A�]���]�Dl�X"��NLKN�D���U�[��j �a��Ub���D�6�xN�3��m��E��)zU�4��e4��S"�^�e>A��B(h�P��N}�fg���"�O`u*�FYk���O�����+}��%���
��JAV��X�o��]O�(�8��9�w s�_E�sh-��`�I�TW�d��f������$ܸ��I� �B�=��>�9;Dݜ�=j���>U�e���yI�ȶ�v���do�M�`Z,�6JAj,ڦ��^�f��I�۠�|�m��2Y�6��K��p+�cEH�SEt�'�aW{����>��Hd"P�暋eA�!7���8�:����2�8Lޱ�j�ɫ)+b�G��J� ǃ� ��*M���E��
L_�\ZJ�2���&.0�b�Q��?��>��ي���Ǧ���"����R��DH6��u��"IŎ(��
�6������`5)��v�2 ����	���1��\p��7��f�������򩖦�t.��21w\���F�a)M��5��&��e6l������dp*�ƞfO�g���Y҈h�9��
Y�J+�F�AG�,'����$�c�MO��Y?
6��S�#Ɇ<⩔��ظ�DgZQ��-��2i��t�Gb�����s�����~B]��5��Nt4�Q�8��}�?�2@p[G�@�'��'Q����FQ^�]�A�,S"0�fV5�9cJ]_�����`��`*���I�A��x�X�6	,t�ʬ�w��|�����m��|#�p��e��$+^ E0�a��]��ƛM�J���)��d���>`�Z'Wc����]6�����h��[<+�e8'c!�V�Z ��@�i ����LdlYv�56R�忟�f[FB����;\�Ɩ�GMcni̕��h{?��_�US>���C[��ʑ� �FZV�۸�2$xrcr���T������1HN��3�?Sʦ�x�nxyْO	�-��v��Γ�F{�X��R&M4:ԒJ�v�s��Ju�'�K��E�w��|IH��ܻ�,.��c�:�8�@�
ZX��j)/��;:��ri	��$np�����!�)�ƪ�UQ\vEU�W��!�9@'�N��({��G�5��+������7I�����s}��|��*���|��}�8�'�);^p����q���4���}�0��F��70�c�Z�NB��eM#`��5�?=�=y�H��Q��X݃=0��d�'�{˰��Ƶ��l�����Ub_��<6�L�`p�z"
�zBWI'X��R������Z�k����@�c!�),+�4�5�<���2O�̕�\I�J"��HĚ'��1��#|�yj;q4㔲�H;O���Ό��E�Z�X��'Rä���˴Q�%�0u��iڌ��6L��&x��j�J��y��*��7"��Zim��hǅ�1%��dtȡ��a�ab�c�R�/��𢼌�/9J�ȧ������c[�Ҽ,M�%cNÿ�	_ߊ'��pۉ�4hX�1u�G�4h�f�X��*
W.U���`���#�wıNf�
YE����Z-�(�8�ߒBs��N���ҿ���
�^1�m,����3�ި�E	�G���W
2%4�i��R���gq�j^����ay�(By#[����Y;e9�`���� �[�щ.�Ǩ�`k"�L�0�a�A���EA�wO�by��瑾�,���cY��9�C�ꭅ��`/��P��w x8���I�A��#h'���'8��HG��r:��4TTn��Dj�w^x��N0�ا3�6e�J�N2ݏG�hx]g��3�
�pȢ�>�R�2�*��%!�h-ӊnZ��B�ݴ�iU4P㶠���`#��PU�iǫ����id��b]�5�P�@�(mp�ah�"F�q�����gv@���e�.HZd��:K���<=:E�ē��4�f����KYg���λ'x�hB��t��PS�����g8�4f����"nC�X2qs·��I��q�u�=׉�~8��[7c��u�?�c�;t_�1���u���]ܗ�|��wrB��/�����z����_]����g�W4�\����ᶸ����tD�'"h?:�:&ݤM�ۤ�I���$-��xK�t�}!4I2��i1�/?/6H��8�"��s0Hs&�����Y<�K�dQ<��v`������MB |rw�CSHu�:�%��̮Ϋ���Gimvӳ��X����
݆�k:��V@w��R(�V�MgǋЧ�Ea[Vg�է�Q���a�z����X�Ñ��j�<�����#��eMKސ�ULO���t|��0�x�a��ꆤ`�,����OH��[YQ�X�    �"���ڲ#6�9�%��5U����f�_�����:
�\�0аT����!yT!�y���vbƨ�t�Ҟ:.�#��m?j����as,��%�@Ï�]�7������i���Q�A�a�1<u Ϻ�/�6�e ՛_O���$�<�.�tWΛLG���8]���/O��GG/�����v���N�%"g[//3��!��}ĵC��?�en-$�#)��_����T��$�=#n��^+FX"7�tyw���$k�j5� 7�A:Z�$�$�A��ɤ�!�$�w6�e��y��S2|�Ħt�Z�P��L*.�8��Hr��f�\-�ޮUP�[���+�99�2�HJRF��]·O1k���+���L��TAf�n�z*-�$�y!|�,If���b�QLE�\kI�&���_\�a����sB�6��N���y3"qsI��0����6�	����d��	��<=��S��Gm��p�w��ǂ��S���
2��fL�uPݘ�f��5(a��g��x��Њ�~d8�:L;1y����(��>��)Pp��9Ҹh��g��� ���\����|�Z�o�4�����W�Gr3yL�4SU?Ŏl�[�v�j-P q$!�$�I�J�Ω��7#��5�2t�/9���.@�E�@{U#��}��$��!�R/�-��%#���xt��2�]��(���EY��;��؋�,���7��P���Ʉ�"Ź(=��)��6�HJ!%���ĥzVa�F�!7��!j�0��:R�.½A�(�h)��
���r�7$��͊���L'7�f���$�*�v1�`�V���͑yU���G�r�۰W/6���$�*�kE<�"8��@q�Rc,��hf�`�a���D宬�ދu��▨Gm'4�9"�qOg�"{\6��TTAQW)�y��`T��7p�F.k7����K���"���H�*t�������e��$��=��jfk�Q�#�zSD����A!}?���!L!�KV�}�v�W�+J��i���A�}��B�.כ5�)T�b���c�C�].a�@����<Dε�lU�E�P�׫�唴��tr��/�?��@2IQK���Y�n���7n�ސ���G=���Ru�*u,�T��8�P.�x���"�����v�,��ԎV�`:��6W��Fy�=8���V��C�ρV3�9@������n����ݚi7�$�Q����w��}�op�
��ܰ�$�w�����cw�]a{�~��_�w���a� o[4���v7����_��_��%�ɘy^8��\	\-�G1e�=1���rQ�>��e��0v�wl�
\2�c��)v��7x�9�VY�Ѳ���'��
��~lc��.�b=�E��iFߊ�hl:��Uq�y1�E�G9��\q��H�\����Xߡ��j7��0˲N26E���NY���' � � DWƦ@2��]L���_F_�(B���: S)�����Q�����MtQ��7 j��"�wr����:o
��)E'%rVE��ڢ�L){�_��zWK.��!/E�3׷�T�s�u���T�4]��������COrU6Y�͆�B�<�XȈo�ç�g �*��1	�˻	�Xj��9�g?����^,���ZC��T�:I<hҾU�^�`:�A�,�֦�L�.hV%:�b�G�'^��q��\প��/֛9�m��O�B��,��^�7��0eHs�>0��M>-64�o��Z����QuE-V�lO������#�*��u��w���z|�r݆����J[G��)$�IR�#p�4��c�	dH@��j�i��[�3��.�Lo�0�p9�E?�񲃥��TI���M�v9fUzmM-:��~<�BR(�N��8%3i�b�K'KJD(�qt����b�\���n���^�B&�I2�&��h�Ә���u�[Tޑ��M'�d�J�f��x��_�⧮�T#���4B�@qa�Է�����ۢ0�_��Ŕr�giG���f��%Q�N�(]K�,^9�;��sC+�����cSD�j%�d�ȃ�:MHBn:I<��ΊEƉ��i*�Ւ,�����K�������������U�;$q�k)�G�E���3��Uu��D(_E���Qz���]���/�P:u4�H�)�AT�F���P�a.�8GO�ĝb�"�Lܵv
��b��<V�&�Q���Р�V��t�zk$�9�%Ӌ���CW�+-z��e��c=M���y�����{]�^�����Q�jw�{�WT��:eR��{`ѓ"�/r�����*ER�Xz�jq��������%�	K#B+��X��j|��v�?�8_��H%b#B�$?����gd{5C�������C+��qa��#��(�c��ڀ3��.FGmU
j�jF�X��l0��Q�2G�����`�S���N���]�Q��uV-)�����Z��b�;.��l��^O��*8��dΩ�D�aq��lZ|d���$2���XxB��M��ۣ�L۹�*u��R�wC�e��.�<||h��s?����e���<�:�(�=���?,b$���G��T����x�O0큱�������M�F��f��V 
�q��V�y����[�C#+U�q<�?�7&!����0ͼ�6�a�zt�Ր8����@ӥ�^����Ņ<Wԗ�e�t��b��r���������-O��\CT�1ee\R�-uA�X`0�`\�����s�]&[o�&��F�ٿ���Y�f8���<�S�|� 1i*;�n�X��_��xnT0��=�)�å�(���;z�L���7�[�K��n�-Ƕ!M�I����p�{����q�cSH6��i�S��b �@��j@3�� > ��|�Wr�� �2�W0�9��D�0�^��v�fw����26E�
��^��CD��D�H��Z^i&����-i����v��#K4��-v�T9�E$�~4Wp��C����v�����/��u�WB>�����;8����o��*��\��&��B�Vտ�!�a����uc��)Z�pkq ��f�Z-���a��>�����m�����b�V�4�(��0�erq�\!Ă�Nr��w:9�g���x<�f��iv:ͮ��~��6��a?K�S��^�5���ir���`zLn���lѓ��?�(�0�W��i&���*,��o?�o�����`OW��Fh�Kc����Ggq��ZBJ��0��'�_��<k(j����!г��UR�̍�c��"tL(:��\UA�E�P��'gxT���,���:ӆC8ḳ�"��DH;0���X�-�Eh�-q��0B��!C�/_,߿O�a����"LZ�����rR��t�޴�-e ��A��]����:@��i�p�#�)��q��Q�݋�6).�G�˼��=��3�����]OK:p�Y�q����G��{���)�� J�E	\1���` >&�\4��P~���+�����m�l�Y��+H�Iw�u��V�
�}}u��F����h��8�m�X�j�:Oz�'4�h�����]�\_�������ox�'�}�X,���ͫfm<\�y����%���
�����Ȉ�:6qڠ��R���$ݸ���ڛm����ͤ2�i̾�Ѓ=nz8���>�ow�k~��l�%;&c5�el�4��w2Q��0�0g�?�Ѯ���!{��	�X�$�[()u�rD��_o�;Z�S�A�ͷ_�(GA����2x����3�x
7� �Aj��_�}���a�U"����L�Ė'�6vO��ʪ�jv�\��H��/�{���jB
�B�%UU[��E�	�0��^�Z�Pˠ��X��3B��5M�G�"�G#�������E�)�c����JS�Gx�;GP� �c�Im��&Yf1C��l��8h��3y]��?%�qCѭ*P��åC,;���uS���M<��uSW�:t�����J&����� Ê)��z<GǨ���$�	�t��J�l�I��KٟF�'�i�z8����̄�T�!}��QЎT��혾�㖟��    ��#J|��m-R���*+�"�0�	��T��@&0��%�(�n��.W������giN��j���Cg�<�m� d3��t*<K葿�MpG2���<h0�1��a
ܓ���1j��=������l���07��d<�C�C^n�+e�&,8z�\o�뛛$	��c�lK��rZih�]`bq��!��UUh��>gb�j#4�H�%����(M�Gcz�d���]�@R�x��c��{�0��U�V=?@k�����!-���mv�k���.����MO����e"�hޤ�A<���i_�8�z:*����1���8t�uX�C�[��9��s����#j�ND0H��
�@�Lv����I7�|I�C��ֲ9)�G���&�M���R7P-� �� UiuUq�`���I�o���yoÍ���]��(���;H��vu��>��ï��-� B������x��u$��
U��= �@M��`z�v�	A��{DI笯�8/����\�4���|��>�蛞���MeRX���Aq�Q^Ʀ@��{Y�Bp�8g�V�-��H\�������H�R���	�^T?�5fB����y�?���]�������v\�Op4� EJ����i��o��������f�y���W��-�3E	,��@��@TM'�>�f��έ�w�Z�'� �k� a��q����=��6ltnb��cT�E��,>.��2]\?|X.6�}�Zx��MFv�)_�I�I�J�h��GI�#N��v@�������x<��X:qZ�ppu<B8=���� :xӝLe	HS�!�]H'�����p���V_�3+�ʯ$d��_XK>��l��5%*�qM�	�/5x�Fk��|��#���<���h\&�P�K�]	�NJ�P�&�T�
���gI¾�f��(&�s���B�l�w)�yR�p**��)I�����|zM�F	>��"d�����,"�8Y(pt@�q��3�ld��xؠ���i�䠽��m�i���|r��d�Y�=���xa��lqf�a�U�]�ɓ�d��ј,�����[�7-���A��X&p�z�٠8�tM��p�:G�
NHEAӜz@�t��w~�y��.$�#E�6�h�W����tš4�-S�C�����S����x0��ޟ�R��+gp�5��k\o��c�;������I=Y���e�(��Zg��ǈ�r�{��S�����+{h4�`��^gl�"�5Ѓ8�:��-��K��R8�M�<�����\ʚ3���P�n:�t�8�/|�E�d}:5H�1�e�}�o�_����zT�V7(%��&�1��ߔ�,C��v�^j<�j���@MT�nQ��]�T��
��8A>E�B�)��po`i���]����aO�Ê��uygڮf�l��D�.�a�$�U.�M7�e���b<��i$�Q���vNGd�E��-��\|�ω�V��.��ZF5�ũF�R�K :�تK��0ݢ�K�x��a1g�Q��VoA��Wc��a;�;��`Ԕ�Z�0���>��8��:��kp��u�L(�Q����^�i����F1]��a���K�)w��T��DqU:�Q�D�30��C<��,��tcx�P�7W�w�l�!;�L/�*�Rf�_��~�MY�������HL݉��l���sz�����k��#P��%���#ά4�󌡁��!?�hh�����������1�G�f�=49�e��a�ǆf�=45��:4�C# �ꑡ�9{�62--�"S�aC	`V ��خ{:�>6?�?��A-�Z�F�x]�oSK�~t4�KGB��[�/��p�\��tx��<  E�r�8,�vK␔��M�gd��>�t(�k�T���)J%)-��=O����$������e1�M7)�6��%9���-�3��͉w�8+�K���5�nx��p�H���0U��6�g:\o��"�T���_�Y_��Gv�����.;^���`��ؠ��U<oi�n��pȂ�N�V�-��cw����� e-Om7�`�Z�w�Ւ���B�/H�z� ]��]�B�tTx7�py�=B�St^U?oZ&�{��@�A|����n���Ņ'����	���	���0M@�O4Xo��^�밥�,���'��E>��zB3u�MY�= 29�HG�v	W�|F�-C<��!������;�gZ�d��ݿ���
#k�����h�o�����H�ײgh�z���
��ny���V�]�4�%�?Ba���b��+:F6K��W��i���,96&a���w�=]m��]R�ś�նa!����_�í�H�[�G�7ggz��t
{g��� P��e[�������LQ�>M����|Rz����:�O��i\��W&;E%?���oR�! \��ڮ)�F����^�enb�-�!IRˁ8��ə�xu��;z~u7���%MJ�b;C��7p�E�����CĎ��^TDzSs^��R8�bETJe�4^Լ�1�x�����%�u?qz`�XVLqɩ���ud!���z���B��ty�u���z� �-*̑�	��8;YC!�_|3����h�,غc�T���w0�r#��x$5����-9����L��6�`�G�-�U��$�׺����ͦCSK"]i:tJ8�q�ym���lG3�#̖��9��#4_��Z2�6��W�셀�肴Z�z�)H%��M���L��Y<�x�w�G��g��.'�U�l��݀8�q2a�(ă�l�;�"�:v6�[�����݋aD1�G%Z���i�{��0c8	��f�DCx�����|2�~@z��8�PY�5���e��'�l@�{GGÈN���4:�+�F/��$y +����}�X�~��'�A���՞�d ���p���Z��_��o6�?���)1�͂X�r�2ڐ��7I-��1'�ָ�`��?�Y2u޿��]���U{��;9;�.�v��U4�Q���A������k���Z�o��ZW�\����$��r��BSAl���"�u�l��ճ�
}d��0�w��Bi<=��[�[���K[z�n8�����D��"�	E���.״I��w������ߧ�-r�22�8��vq=�T�QF�
�]�
��ӫ��}Z���lpu������ՠO�����'�Ԍ��O�6����?��C��{>N��iU\���,��hМ<P<�Ȏ1�jM*�\�D)��h�[��jL`��is�%F'٘f�_F�#�)���n%�i\T��!���V�`i���Xl��f�-�A|hP��ށ�i���f��4R����t�
M����e�Ag�7��a��&�z�r/�5��E{;�C��u�H_�S���YID�9j��f[ŉE�U�TY����%I��\����q�Y���S�ٸ�3� 
�bu� �o�/��r�c��������ʆK֋��Ǉð����� ϓ��ɆG�77���=J1y�`
�و\�o��)m�s~����!!��]DiI[D���yF�e�`��od�,(:��~n1���E ���^~䥋]�S��Q�8�h��'�e�9���qV�Vc�6���R5 eX9�4�` +���P��9�����sӊq����� �	���%�֚L×d�Z�x"� 0�'G�W&s2sT�Y�K������^/Y*�h!�8��8�����c���z���-�$��P�=6*�1��1��qM�H��ы&��p��h=���A��7qZ��yE�<�v2�yF�2\���T�����)I���;�ϲ�q�)P��	x=_d�F"It�)��b�|=
j���!���h����Q�+���#x�� � ��⚷���:V�Ej^&a��x���c%0ď�B'���Y����9FD�]��J��?hgR��B~!����!$6q�`u����d�Tasx?{6���@����18H�K+N�:Q��Q��eU��E�������/r��w�bL�n�H�JH��8�o-V4
�q�$I���I:�    ᐁ���T�Љ���j�
��Y�=$x��w	��1K���Z;�2v����%�*ⱜ,�Ȥ�������Cb�ĦHݧ��4c(��Zx%[7�@�<��%�4C��{.>�Rq���oZ�ĳ�n�`�\	�9�X�xNC�'$�
^�����^�:���cSĽˡ)�)�)1E�b���(C���S�'��9,�N<�z���<�
x��sI���V����b[��� 	Eg:�K�+��b��7Ҭ��Z*�3^2�7M���i�)F{��jCu�y��:xD�'�X7(���O1��R�֡ІFY[:,q���: �ˇ�4��S���&�����/>~���q�U�Q[�O��/	tʖG,�,�'�٢:Yߵ�r�㱥$x�W4��x~N��Uxei&6��hW�$���ظ��%��`�����؁X/�UR��K�H��1̀�pڽ"��#��������!�:�H��d��M�����*,���*P���8�����:ϖH�m��wO&}�x{Li6�P��s��32�#Y�|Q�4͐��PR<�W�!k`{�}�=G��v�k`酈xsZ2J�S�X�]2�`�����q��^��f��B �L�U@U�Z�7u�w��c3�
�/�8��e�څB�&��:��� �i�l�e7o�P:�J�
�6m��5EN�щ��i�:Z�(�*�eꚾ��.5�t~�8[(���߂��[����
v������+.VK�|d��2�=�4$�%���(��,p�G����m���s���t]I�=��39�}�����rw��r�`�;�-�7X������� 2_����3�vISg�it�~��n��׌�Z���WthM����9�F�Z�Wwx�o�+���KY"��w���w�'p���@�ڦ�Bv�Kؐ$7���⌫q��a�$H,�H����Ǜ�s���
7ɮ��1��9�L���7���[t8ҁ}�d�e���a�}��f�}�Q<��e}�;�c�w_"�[�n{
%�U�C��һ\p��קrt�[�Tj�J��P��lr�$zp�+"x��؛�Ǘ��lt~9<�2r29i�O���&��/���)HU�,�ɐ7�jѯ_����&�%��Q�Q/�.��i<��>�xm��ɯ���+�9i��1���+�N�g�*<�]]b��ʬ���t
��ie��-!"�m� ���O�����jrDa�],�߇��ޱg'�Aб1U�#,�z#,r�xz=�]�����"��`��
�K'R��K��b��-g51�=!͈�i:��&���G�r�-L�P���ֻ�����[5����TO�m�Uv��٫=�hg"�2��>����v��4\�����t�H�V��`jB�d��)��x� W윯+�tN:��y%�~������Xc�����5�.�UC�Z9]�c2�9�I��h�^LD�6������h>X_�`��4�3q�:�
o�ZX/!��O}k� �t�� �E)�I򏧞4����/��a�|��8s��s�9�d�-+��ʣ�-��pJ�n�M��"V0�d��AFb��ThZ��l�#�ѽQL[��F�	_a���D1:QiS�15�R�d�D� ��Hm��܊�t_HBX�8aR��iimi�d����f�q�E�|�x�f/���[���(BBj�'3ճ w9���sG�˯���(����>�"S�Fx�xT,b�g�,D�z'���q3b��zs��>���%�"��be,R�p�����B�� �_�wKPiT��l��?��(v-"�"�.'�-x$G �1T�*�]~����,mҺ%��Mg�~�g¶A����I�%��Q���]�l�$��K����XSԢܭ-��<�P9��x��#��pK����VP��2͓���#�*�Z]�\Wpj�Pha�I�Ϳ�+����J3�q���*�~����va�ʖ*.k5b��nr'[��: 
� )�6��x);�Xi�����C��V7�WU��� �ڣH�B
��b;(j�|6�:� ��]��s��4S�:Ο��i�P�e��3��q��;m�{;���:�9خ�*��-,c鼀[� �'�bU�r�U�p&�F;�_�\'ۆ�4Z����"Q�+�j���a�C&��t9���|��$鏊q��U��l���.�2�P��+5#���{�rT���,�JF���&W��՜#�m����=���C��C��M1����ǲ�S����-F^�7è/śe���MӚ��7]��8LV����N%�[�93U,>\�(p�x�@�(����-�R�a޲J�zZ�(���U;��a���\v��� :�煰f}�t�+Ѱ�����!�B��z4�2����Ȉ��t���I���N�=�w�3�B��; �$5S���j$k�Z��`в�_9u�?�BSg�E�΀�S�������C6[_/�t+=n�Q�1��Ʀ�#ע:9�0c��ٍ����d0"�J��p�����.(��P� 5��7�Aѭ��n[TaDU����3�3�
��|�j�	�J2��'�_ǨJ�m�t�npe��\"
y`�������4�fq��o���$\6#y��1Ke G�,�6$�#ג(q���
a��|^L�y/6b�/����05��6Պ�2W�/*)��^{��P{�j�����~6�OO'1��G|h� �"�ll��OZZ}�*��n5���W��g��ܠy
<O�J�\�xLG��b0�*�hv^�Աʠ`.߳*~�@$U� R�y�z;X8ޡп�i�{]�|���\��X3�����,�;���Ycճ�:�$'-T�������t8�E�K���ttr:,\����\�#Fh�YO d�Ǜ�Ǜ�����&�<�ǆ���GR�Jo�)������f�q�f~�"�5�t^d��P��ΐ���p�[P:��/�|{y9aw
�6B�=�����a�Uv�=��p��ذ��"H�8��F���Z�u��#+P�
􊗳�X{+�]��qa�jL�6�������4\�e7:�^�bo���5�",������9,�1��Ty��[r�a��[�<�`W:X0�20"L�)*@h%�$A�=�M�o���<��I.m���SBcM������yӛ�/o�׵fO��*��%��i���6����\&=s�Q��+������i a�U����x�@�Dgkĩ�Sx:y;I Mˆ'BTGI�\��@E�C'��O@/�9F���O63�ukQF�]�*���ZD���z�g��W���@��H��p8��b�y������qz��5�M�ic%x:�\adՓ/�=��.�!/B�8 ��N��9-TT�O;���Gg�"�/��Z�b0,d<7� "��(�%��r�Q\��C�%i��5��k���� ?�k���1��^��O�3EQ	�|O�]�"._�Y�i�`��>���<S$'��Ő�9~� �J��{�޸�'6b��x�-����nc�5-���-�k��=w�x��n�$
,,8k�˕�(��*D����ߌ�n�����Fx�R"��T
bl����j�k�	D�8V�����*�x�3���r�4���V(�&#������t��Zupg1R���IF�z���ܤ \E*�Bk͓%#����S�=��l\��p0�g� ��-�
�"�\^gi���w����0Ć�Q���-f���'�u?��q�} �"H���ivڬ�9hTg��M�(��EZ#��ݺZd�1�
q`�1p�+���A|���Y9�\v3�V�tp2�/ME,$Ĝ��'_b�����-|�����>^�U����VK�Rd�!�5�U����jj�i��t�z��(�)e��VpP�YǤd���hR�MϙH�_!m,�V�p<�u�-�����FgIh�j����z05�EiQ.������Vs|��f�Ħ����A�p�R�����#��t|�nxM�ևd��Y)vc��pg^!$�M��AYlָ9Xċ1����    oe�6�}9:n=��u�"
�1�e0����`8��2��q	[D2+V�9{r�'���߫��P���q)����9EG�RhA_����.�T
��-(�(yr��ެ�w�ʺ�EY`�F�!���$�A��B�/���c�'g#�#��?��F$���_��*�x�� �'ylvH?R��I6u�n��w�hU=ˇ
�↣kc��#,�Q���bVu.��[|���w���`���݇���^$�D)� oZ��h%2���s�WZԗÿ^�%}�Ap��Z��-"�$����{wV��a����ت?�����R0]�U�������M�� ?8�HoT2.�EL��o0Pd��>�^@[�E�S�t�.B����x�Od�)&����YN��[/hS"���M�c,��-�e�7N���y6/��o��-��1��N��Y/�!s^%��"�z^V�X�wH0���,Kߕ�1�ʨ@��4:$m��F�Z��Ÿ���w�)��D������p�J�0t^A[Q�����/V_���3~U�0Y�����8������!&�t|4�%��E؆w/���bl����W�1�".��rLE��cP{G�"#�JY��b�f�M-C�F�h8^4��H��qQFBĸ�����?ŗM��.�M �4ъ,����f��2��Lެ�Bk�J�bh8M��O�~�!�P(I℣#N}�C5j��Q��g��D�v��Y�ԗ�M}v�'���2g���5���E��(�K��j��6g�b2O�ivp&���J9��ٹ�z��wg��dV"P^�<a�`�񸚒�������SʠŽ�t�]�nDuP�UH�<ÃX��B�@'-`���|�=��^Of�'�	+��Ḋ�e�9gP���B+ث��ֳ�b���cD�Y��y��K��E�}v�Q�K�I��6�[� ݾy:cTlRȧ"K08㬄L��H��C:|�ἇ��n�qk��6�t�sA�~%_q���Xu��8��sHw��6p�([J���n;�f�������o��B%Be
Q��Iy<�紑�r��͆�� �{���O���E1w�X�`O �GȂ�m�{��{9�1�\m���1&���)/Kn�x�`���d�:���}�E�MQ<QH%=����(H���R`��(ypi�p����4Ce#�����}��sڨ��-r� "xk���������;b%V C�Vf�5�>�C<9�EV�_���ve�P���ӎ
�[����	u���t:��^��HF�X��p�-EF���Z�C�&>�Xf\9E�7lc�b�uZ�*�����f]+XpF��u\�:C�1�G���� ��L��Y��
���=M�0����W<ި��@5�t:�]�9��!QU8��ȗ���q,����'��	Y�"�sd��ϓ5���Sʚ�m]$}������<>d��biH�M�����3�a��kѡ�����\�ji�\N��RqNS+����*� �1��i��ŇD�Pk
�E�kÑ�!�XG�2z�� �Jq4]���(6v�8�/L�1ThP5i��wݔ���4S�s:��G�=��.�j�c*"�ƞm:3S��*��� ǯ�e���Ř2����G�b���9&u�z�c�D�:&-�P�Ky?*KMx�,��9�԰B��ɗ6��(;����' I�r���d��>���7��)��'OB����O���WٲwSz�������.�:�e,�`_�eq_�e�^�e�5g�כ��󊐏T�BY}�������&���Q�CD 8�9 �U؈����[��-� ���P�:ǽ��&�G�k�V�5�Ɵ���䱉�hx4��M<���~�-��M�hِ�`i���I��L_�b�n�MWj��5�{"���"�a"F]��jD(��"
%����W~�"/������TWB�n��ne_�{3�B��'������g�g7d��#��c�~�L�/EJ)��L`)LFCQ0�"*Ȧ� Z��x� #k�;p��0MvW�k1��KE�g��w↔�ěF/:g}�8>�t�N��4�����~��l0�9DdY�p���,'�Vդ�n^oʩ���g�P��1d��0��p���2����W(������W�sL������sC�m�.jyI\q�xï��jΟ\�3�^^�!*�~�N�X�
��)ҭ-ŋ+p�D,���i+���w���̝i�"m�7Ҝ���`H-�����K���ڧ4���I=��4��HtfS{<%���aN=k���������v$;3�8@�η)� ��J�� ��tx��ί.�p����/t���>����2^g�iF��#����@�x���5���"F8�(���۴���	RH�a�[��.h#l�����z����Le�4*�zB��:%��l���ӕ�R�ě�I�%�H��m��sʷN�8?\x�. ��^�8w��e!�q�|x�]d&ƪ�m��
����(�j��h#�M�"�^ �(����פ��-v���>]Tݕ�(1O��7���X����_�*B��B���" ���3��8�^�6���Bp̠(X���c!59����&�]9^}!��L��şw���]$��<����Ҹ"�\��� �  �8�S��Y���n��D��pչ�D��p���m".j9
�^ ��(٥��{!ZT������E�Z<9N=��@�C���{2S$��-koek<lJ̑����F�Ï�e"�Vq��G�K�� ��5���}K�r:��K-�t�	�0cRa&�D
80m��͇�_[��؊(�4�*{	9�ѩ�P�6	j90�,1�Ҕ5�����2� �uˮ��dp����^]�gMU�nAN$��
w���Id�1����d8J��{)����m��F�i���/���=�� �Bţ�_���l�0��	xv���(R� %��yC�#Ə�� �
!�1��_����ר�ˏ��I&���1>5�}z�F9-#DN�u>��%��
K�8�pt�B�5x�
MQ �Z�LR8]����{q�dn:p��9��O>-��ݏ!{`��ez������8{~�ـJF*Ѣ�z��Fe@�����^��P|6:�O�������,c��,!9�(����0H86���<[�0���v�!/���e�
c�f-�A�6�."�&���x�ݡ��ԃwKN�hu�>@�Б��[/��j>�rǡ���֐� 1��2"U����S �ǫ�,59(��8�4��mc5 \@�N�#���4,c��/R5�����Ģ�X��⶛<DrY)�)ּ�xq7VP*Ak">r6����<��d���Xĺ��]TƋ��9��,��<���mr\�� Į�uU�g��D�`YFt:!%GZ��x�[��W�]x2��:�}�H����ﮗ�����J��3��1bEu�i�,�s��9�9,o׸�"� �1F���V�f^9!��5��qS$��f�:���Ȉ&���!W�F�F�
�Bt0w1���ϳ���鰑��7�=6'�� ElM�.ǋ�#^PYvJZ#H�	� CF�����w����f��IK�x��P$P1C���Ih�Ǖc�,�U�v]dG��˙;��S�fɛƫ�ܤ�朩ay�mD�kئԑ�."<6:%⣣�#�e����qʢM��<NY�A����s����H
I����$�1xH�f�g3I��!�zĂ��ڐ�&<D(2��QO(ᬝ���u%�~�w��ܻ���0� �R20~��d0a>ϟ#�)�TSh���E�B�M�d����(�L�*R�	�*g��Y���!@M���)�U�x?@3��0efWq�r~T-S���.�EA;U��.�|T�9�,�I<E�E;��E����k|$��/�z �cS��x����cB$ȝ�	�Ja�"�S�3皫!6�v���(`C1D��|7׸G �r���~��ZG��q�>���Uh�����8E�jZLa�e,��8�O����>��7���&�N����gT~pH�J 7�)�����V�g���n����;����%+c!�<)    �X�h��`��=p�b��:����]�)�Osض�)�ӫ��&D��et�?,~�oQ�CǦH�����)'�{���t�t��~��nQ&�ӂV)��?�J�X��s�����6'�*��϶1C���՘����ӫ��M��8��%�H�����i�k�%^��P���y�������M��:�,���+|R�"V-1�u��F� DBBhT�VM���r= ·FE�/�r����ٛ����}�v�����OR��_�kv:;g�6���/j	c��EOĺ�-�0@P [ �����3j�П8�	5��Ϣo?9;8����(�ޮX5.����C�}KM{ʢ0��Z\p$�Z�}�g��k�7p5s�����5��CK!')��}b��q��4�1���%�%:���[���t�P[����o��IK1Ӯ�XM�c��=gЦ�h�v��l]�S�u��mZ���4ܩ��&(��KS+��K��K��X�B��;Z���p5囇岺��:�
�	��䇥iG"pIц5�GzS�V���B�7�X��Q�)���_3����~�jU�C�!��
�`p�"��ԩ�+�dzڌ�T�j_:yO��J�]��K��E���.>�U�Mdٟn&{�}�0�i�&�Wul�=�ݢ�̰�K_���7
ۼ�e���D�����g�Ch�$I)Rѹ��_UU��r�,x����w�\/ݑȔ��y_�J9�#+����<�}�azݔd��Ѥ���L����F�!�љn+�M�/���A~.��Q���_����.��\�xא��4\M,��榟���P�5���߶m&4>{-��5�6xCFӂ-�������x��͞&���=b��ܺ�Ѭ�:g���G���/o��]�]%�X���P�l0 �{Y�)t������d���m��A6x�Z���y�ګ��=�J���i��dok�v��x�`Y�/�W��fTLDˑ� �xr�~���]/+��BJ��U΃Se����?��_�]��ϵ�]9�5w=���e�V�D&��/k�h��~��A*��L%��NT�.�[��(�]��māCUǒ`m7L���0����r�	���Li���K�������F��O���r�a�{���h���>�؆�d��V�w��u��RQ�7t[I|w�V�Xv�v�ǝxd$�k�Y�/
���Q�G�"�n�+���ΖHI���x`�UbK�Xׄ�
u�d��g�5�qg�c�= %��ؼ����RI�A�-#�(~����(`w���`�$=b{S[�B������V����u����?A	 �oy����|�={�����
��OY�*�g�Q�U�q�6������A��u��ߜ���|e.��|��<x�P���Hc�e��UzP��Q*�}�Ǖ0�^&�ƨ�e����I�f��6^�����7�t�������r��Zd�;^��5�ťۋ�[\�ޠ9�菃>
5s����p^eH�"k-�+)�-�^�4إ1��rj�����ef��au3	^s,���;�Y`�c��A��`w۷eXR ��(=ҁ`��+ն-����{lV��4�-���b�ʳ�o�D�W"m�^�Q�P���c����B��e�:���uAQ��Y��Ь{d����]񶆜y1�
7r�>xnI
,�U�!��A(D�`-N"���3�@���T CN@���R�Zt�����srz�Ӳ:��[1�Y�qU�h^���J,��⺟�/����^�u��o�i��5{�l/D�܊Uw������M.�"�@�?X��'��D�OC��Fg֥������UBŒV�K�����:�.�񰇲�*`\���-.�� ��O^�[�EE��feF�Ց5rf뺽 _�����w�:���%��'�+��R��������u��ҁ�]�N�p�ß�iT��Q���F5����4)$�Ye�չ�1�t��������T�5�02��"����s��"c���Ow%��p���D�)�^֡3�UJ�!c#�iK@Q���	;B�g���B��~V����σ�9�K�~C��V�"G���Ks���Ƀ="���\��-!D ԏ~���+gEx�+�F�t����ڞ��Llq9$A��Cgm%��	�0���u�6焦�5hT/m^j� vj�3�n�Μ�U��RxW��GX�A�۵��K��L��꼶��Չ5�.�.>�^������R2�#h�bj#�%�2] rP�^˷�]P(ӌY�t%��+��%h�}q������ȝ-SH�v!�t�>�v�H�7F�L���`����b��Xb������+��:��$T���6c�$���?��0!G���B���sb���zvE��T6�;r����Et�X��2�D'_�zHǳ����5�*���;�
:�G�C�Ր�u맢\��D
��	�#f����1��?��Ҽ|�٥z`���+�Hf��P3�u`�|�W(^Q�m/�Y������67�1b���fx%W����cu0>��W��o��15G�kV7��'���k?�|y�8�����wȆ:^�ѥ\:_����g�R*@y�j��fj*
�Z|U�Ů�!ʳFg+:ܬ�77���G���N�?c��-_KĪ� �q5/��Hnx jX��y0���n]/M������o��k�&Ҥ���_�uN��r�&Ɋ)�F����I�SzӠp�<��<KpO4���0&�d�1_�aq��]�i��0��6�� %*g@d>�/
��GP�W����H�#�#�Idz#�UtH�焴���
3�?>DE��vOW��d_T��U��;��Yޭ�&+�K��|:��I��K��͐�7��q���O�(�f&.g>g���C�(��c�����ju5��Aԕ�e\����/"5�B=WjX�<��H�d�|�.�:r�]f�]���ڹw�S�ޅ^Q_z��uz9�� n*#�U�e$�}�x�9���������������ͪ<գ�W븵5�n��|��u)�u���6���e�kݠXMð����%c�+�����0l,~��xyBظG }_�F���(�~$���GVbǇ���K� ��/="�/�N��J������s��#/6�Y���w���l�?	P6ڻ�!ajy������]���O���D�/��%�\�(�p��8������"��#R����2�SD�"B��/Χ��
8�I��+GGE�MX��O����ۣ�#�&糋�S4rB\�n�Q����0��8�2���m�~\�q����F�R^��}Ֆ@�#��m���ǻ+Y�m$}���kB���1��@�4P�q�$G�V�T �������3�^��xv�=���݃���Cܴb����L��3�{~�+W:�lt��_9�I��=�v.尖l�����l����˿��J���� �8EHW	4:�
�e�E�����e�Z�l��a�����J�P,�z���	
� 	
�h!�#�����R�iY5���X�*�5���6�G/�q+������36�9�q*��qK�(�=WÂ5��G�O7������|VJ}�`�/����<� ��aې �7��e����ϲ7�ρ��0Na��0�r��sm�aH?�6�RP�M�T+̆S
X`F�S�M��������?�f�7b�^*R��M� :l�����f�8�g��@�Ê�4���J@A:b>�Q�+�y:tT
�X���ª͗Z�Z��2D�~�e#̠ێ���H}>>����B���?sg��<|B�:<t��6Öj�P�+��(R�,X88��J�o��'�F;9����������l�8᪾p/��4r�|�tv�������)��Ow�u[��_��ʸ�vL}`I�&��\6��843�_�o�[����<c0M'zCݪz�M�(sM0Fa� fr�	u-��%�� `��/��q4�ϳ�ӝ���&�yA(
�W�؉vS�nr} �i~w9�A��Y�^7��W_�k�˝�K�ۿ钒*o�����    �����W�Y��A6��E�BĢ&�y�Ҁ�Ō_EA'-��-)p֯��i��i/��=K��[�Ļx25�t��6�pA�&HNi1e�~���?0�lq�Q=���5��
p��\��h!T��T9��rN�'�wA�4�r2p������>@cU��Ä)���Y�Jßu�����L`��C�X<�_�0H}�|I`��O��RO�����,c�� �8A	�bע��-�y���dpt�r�d�~9;>o����b[�쒃���N1�͹�#��緳�b�����&�5n�+}/1W�U�bu�+�yf͈��3(f�V��ּ����_\����v�,��-�2{��a�v��k��׳m�b�?�;��٧���9~�w�r�b�Tw^Q����?�i�w=��1�׾K��u*���1("R^t���*W�t���ť#g��@ `�=|m�' �6�*w��D��)��]R�ֽ�;�k>.�V��(*P&Zs�y���&x��Y`)���~�=�99�)
&j�
�$La�@�N�u<�	͖*Q������Ho�����J䡄`١���L��r
Jy���P�lZ���
�l�W�(������}.e���@��F�����#�Np4��������3a�].�a,aĞ�F��%ܟ]���MћqW����J�|����*�y*�Aj�iS��a�¶2��b�)�������C.6��(wQ����wC*TR�V��;2�9?$�f���� ��H���5
�����L=
��#O�%�{���mf������=��-��P9�.���3�`֦}���2��d��S����^^��և{b�f��+(��+������A�D��@w�l�ٕ���AЅ�ܶ^�v���$UoK�RB=�\��b���T)拚KF1_�\�|�ug�Y7f��t�{r��d1ՙSF`47�b1e|k�a��.��'�B�o��S�]Gk?���F
��;�X�h�ԄjIX�xň��B�9���[��Dw��=9x�K�i("C86�����6*��B~�������_�D��f�����G�H��(�'D)�Y��F��BQV�Y�K��y�;�Ռ�k��o�b`�8��}��<�f����6sR�l�@�y��~�y��e�K��/k^})�}�n�txvzx2>>�Q�,0Yy[w����B���侖����y6���Y԰��3&\A0�IQ��PMbe���YQ������t���9[X={�حsٞnP�za��Vԗ4(QR�X�73)�⿬Iai�'T���k�����%*�(�)A�q���,��Vk�V�h��$ �+�: (b'��X$*S�_�����G��bW�u�������)?g�����@��(�¼t�(��(�R�!��w&{mqh�I�#�S�2����-�sۿ����ݻ2?fJ��lf�8g2�K|T��
d�Tm�ζ��(R'�fHa]���:�)��$��/����n��F�\�5:I�%���Ub��$�8(��+PU8��*�1���jE���k��N���tA�F`�|��7ǫ!5�����'������Vć�5~e)���=M0d�4���y��U�T�-�t��%�,))T;S���f�f�ٕvE��� ��;��G�7zG{k�Ԯ
�fڢы�Z ��Z�p��̭L��jp�(FQ�����ä�Ng��._=�1�z�kb��˯���;ovvĥGUX=h���	R�$M�|S�?�|+��_O>�+������`Ǭʳ�g���dAkm'}<�8����{�|�6NK�j�]��ʸ�_�<{�I_v�YA7�*���n塩���u<9�;C�����/�gٕ*Dv��t���3L���7v���"6�.�А�v�����*ϲ�ce�8���U��	�"ڧ�w��b׷:(@,n��U�`�^17�hP��(�:[�7Q�k?>�U9d�:�LBM���N�3˧������p�M�Mi��I�9y+���]3���u۷��y2׹�s��2������y2���Kϓ�U�;Oސ�u
��'��l��֘�k�ӛ�"|�K�����FcV�6&�lsH/��G�&�G��2�J-�
hvM�5�[�v_����%�Ȫ�J@ƞ�,^jU����X���/�*�b�u��������iU}Q�)'��V0
kF.���[h� KIí�&[��H G�@T)��-��1R&n��#QIg/K�H[%*���u����q��@���xg���`TXGYW��@~<�xK1S���K�Xi��)��DM�
"䡪���`1@k%@�y�D���.�,#�5m�w&�Ŝ|<���l���<�W�������Zn�}�_�n.d7/n���r��f:F���tНֈ�T�f���L�/`�v�d+�������I��
�m���j���*�{��M*l�|-��+f(����4����۫$i|��Zܽڋ/���\`{ m�j^��a]3=��h+�=�;�������R5A.�"�|��Æbv��ou+#�/�
uw5��P��2;�ѣ���3IOqn p�Nq��q|y1F���v��A&@�Q1���B���%1ݽ���;"�u;vݬ��F!��q�$[��d��p/ƫo;J�v��E�����N�%E����ޞ�H�./��!p��°��e�خ�z���<99$-mo)�9�&�,_��9�d�����@ؔ�u���e�Q	��_P�eK���`=���Y:�س�+���̨{�_��ߖP��ŵn:�ը�������p��V���b���pm�	J8��=����� t%��;���We��0�2r�c�޾������a��D��B�8��4��Ӹ�=6;.1?P%��G��	�6V���zz5FCq��#��/�ō�Ib�8ڑfh^v���}18�ot|�^/�z-r�������@���BC9��
�&��?�f��p������ f��cz���b����("ZgI���6���wD5�열&�?lz�!���UL�	�?a����l����?��~��ϷI�yɡ[p�"Q�{<��d�}6�q��:!h�wؑA�I��6��G�9�,Dپ���s����m4�NǊ%��:vqHň�;ۑ�&��jP>�ȱ��9=��_�V�װ��b~�
�/�������l_N�@�6BL/��>(���l�,�M����.�=����Y'�3��s��G�UF�ǈn�5�/	d�
�BzyTK@^�l*VRJ&@�}~S�$���ha] e#ӻV�3��⽀���Z����E
�����8� ��0�V{Bx���M��)MH|l�K�T�%��&�H�9)8J.4T�F�[���.�5����(gEЋZo��nl����z���e�	��Vo�|+�K�bω!�S��}g��}��z���$�J���l۹M^��ʵ]��Y���,y�������g���_D�;��z�._Q�"s��Nub}^tNA�S�K�����E��)���#[�]H�w� R��ծ�&тJ��ܡt�:�],���5f���R�O|K���O��݂��)�O�[�0W3�u#��)�s�d��L�o�7����p�����#uKd�xY���YG�X.�������ƌ���B�yM"�{<d��n�0^;,/J�:�*O�w �&Fe��n�^�\t�J�D���U�T�*�x��9Ɲ�{>�R�R�.��Od��>��"k
-C���c]���X-�u��ό�Պ�±������`��ٱ>��_&�g칱>��ec}Q1_>֗���>���B��J�^(d�i���{I2md֊�2�aT�'���z������=Q`3�YS5����ِ(U3��ٚ�)��5�Bj�<#�P���c
Q�6�)$zFL!R�U죡����*l���5W�V�%�M���`������y3>�ưtK��^�B�b�3�[c��&���J�y=���ٞ��v�Н� f����8�H�ʨ����D��*�'�l'#��aLm$��%���W�<K��.z�F��i�� �k�a1����xѴK�E_���.    ~e�k���,��=4�d�����H���Sߨ���7����5͂�b��j�=b-���3
b�u�E�4Q���T�;���$i��DE��WC��}P�:��"�"��[�Gs�����]���fO42�������cc�+�`��k���i�5���Mb���=���y�6�)�7=�^�����r�>�
��9�{�Go��w���iJjf-vR�]��E��;~4J�,
O��m]�j"Qe���B9qK?�v�g��5ב�}�ʓ�/c����vi)��l�xw� �M�u˫;�\��:f�b�c��Òge���%|6t86{YZps�(l7��ͮ��3��m�"��pE�hX"s#��
1�2���\;{qw���N�����D�@���Q3�׳b��\ݢy�;�I��3Elv=���j��Zd�� lf\P���3k>-ɼLK���\f$%!4ڟ���b�w0R�G�f�y�VbT~{F"��#K�͘6�)�6g����jziB��J�	����뼬m��ÑUP��֧�p�g��6;<�H���O
�r;<+�;�f(����272~�����sL���Ǫ�Z�U!�ki�΍6��*�A�L�f�3En��`�C6�GC��ԭ���@\?Vn�i֊��y�i��H��n��%��?�}��y��x�j
ˍ:��
	;�%�����{~�ht%���:�~l	 �J��e�'�\����H�i�gnt�J �a�3g3�<��=l�{�H�Wk�����9;��9h�&㟧��^����.<Jx U�	��{��e��r�`[����[����ޠy�(�p� �>��S���).`SY�Y�6�\���ǰ
߱�!AtI,�=_�?M�I�x|�p>��������=�����MƁ"=��<7u�`j�*�-xe��V��P�t�T�� �U�O��^�X���:d��� 4��V�fɶ����]-��d1����G��Ce8)%*��Ě��=�&�;�q&$$D����eRoq^��4��߰�*O^B��@�2Hdl�79��k~(q@�[��%U䭃�[\ �$��Iq�����ܛ��� ��ԃ>�#��}���_'�; �iw���0��ZQ"ed$0�b��������좉k�nqu;�]ͰuNuW�"X��(�4���!����eA�v#���5�D�#
a�v�bB�V��
�ß$���i�$m��6��hd��eJU��"�@Y��L[��ʇ*+��w,�um�Fyr�R���*@I�����}�&V�ХB�Թ*O~#ۦ��Ԓ����t��k�g���{���V�нM7�v�u��L�u���\@X����p�7�p�p  Ѫe���>( ��������vr�s�z�v'��c�	�=U�alԱ��c��ه�Շ^W��p�\{���hmYc�O�̧�
��}�2LV�fY�f{q���u�\�!y�Bd�#e����gI�m,2�?&�6��ii6;'��ݣ��ó^"��X� 9kU���WHY���e��{�����Wی�rh^d�=��q��5S�����25 u����(p��p}ì9��!D^>��1�H�
ՖI6��L*(���ŕX�-QD����ʳ!��"�I~��<B��t��� YAls�/~�ŜV�-BDĭ^g��q"6-�gc�����������	lj� 
R+��l�:k�2�e�����c��/cY�r#��l�?�;����CB4��ΐ]��-�k'�Z�D9w4�Rq�4�#��&�v�U��T9�x(�!(���+�xuB��K>�9 ���  �%+}�B�ƉE*i�L��ܚ_�Ǉ%������1#�[1���FqV�͌b��e3���TtU;�����c�t?�lo�݅w�f`�O�>`��9$�D�i$���c9��+�F�Z��7���$�o�M߃�{^�T��eO��?�M��Ym�_i����v�F����yv.'�M��^^�7i����l������D�)n��Q� ��;����3�;\g��g��۞v�O��>�n�4,���
�v��ݡPaR&g�T�@\M���&jLm�dãi���f���0j�yL����6��G�Tq�Q�����H	D>R�}�F,�]�h��<�=�}�?���Z�6�ðG�GX�kl5���D��v�������bd_c��H�p��R#�*��rign4��)���x����Wu����Մ (�P�^O/��k�L��'`�?�\�n��~$hr��fu�|G�U����(��U�9e�v(	�h�~t�G{m׌V�^����Ö�XX�>��]��S�ٵ�z��(%���7��7�D���$�.����z���p�3� YA����h�X$����.�Nh�m�M�'�݃ӝ7�eqt`��1�*�4�J�l�>7�yy!d���o_Ly5gzPmz��|�E�XgD�7{�f~Y�C3�+�}���M�+����Of3$xI;�&u�I��e��&vVx�����ło�Xz����ڼKi=U��B��8}����é&��� ���m�͸�/i�'��>J}&�9�zȮ�h�����K9D+���V�f���y�9����ɖ�=�X��^?X/'*��S�����fJ+c��l��d䕆CY)z�|����$�2����N޶��2TV�b��O�Owd����#]�ea= d�z+R�����b��O�B�D�Tm$��zD��S'΢���B�
��>��)�G��>��:������{�8�4����b�Z�8�/s:��4��-&&���s{lw>�H��n�"�<V�Q���$��)V�XbDg��L�︝zw��A4������6�g���2�|�^�_f(���ք�d���F���[���v�7��!���ŦEݯ>ʥh��A�	N%�> bYJ�[���@z�mf
���l�V��7H׉M/�B�hB͜����R66M�arMoV^\��Q�I�B-�"[���J�&���� :Et#Qb�4�c��?9;A�cFm)���+5g�̈́�
a{/�Q_�\^�_��Nοx��̹�IN`���Xf��������J�%�������G�?����A���n�}|x�v
?��|2~��s�5QcP�Tr,zْ� NAl����9`p��",����|�����NQ
{�=���T�1
��;�2m���������P���1n��qa���?'"=�t�G7�I�3����M�kqØM~�D��5�N9ۜVV	PV�1H���_��G��	{vH6��	�^�y����eu�]�7߯w�Z��3��uiZ5\ɺ\+V�D��wd��Νgl\�̿��VK1C��z�:� IF�� 0*`3�O ���E6��!�n��" ��$W�*TVX��R%�`W���+������Ʋ�#�ۚ�#GڍЦˣ�ТX��5��X�n,:��c�X�c{b�1�D�t�|8?��Ht����	6V�WоEݚvo�D2]��,�>��ZQI�Z�q/W�t�S�����BT3�1�Ii_�z���kn�oϥ.Ebix����l�:�L������ĐO���0�\Q����|+����-�g�����y���Saoe]\�����{��Z�	���T���[ov�L��h�4*<p%(S"���ʇ{�y��X ��yxW���00_
g�_L�t�b�+�G��LV*XW5Z�j?PM���g���z�,2H[׊\�D��"4g�☯�x�{w/�S��<�.�X�����u�Zbp,�oخ��!
DɎ�;v�ps���{ix���ڔ��?%���w�5(,���)ث�(�@M��dǕV;��)��5���ʏ��1w�R<��"�E���6�5��c8K��v�-C����~�W�F&��w,�f�px�ᡯ��#C�$;��J ]D.�-��l�ZF~�_gp0�1_0
ͦ�˃�����a4����Z�XƮGY��t7�#U��2�7��E�,϶�v�z�6��w�� ՛/��~��}ZA\&�z�p�T��g.Z%��h�6�
(�~���r�    ���|��l&��vmȅ��Y!�������z�������~O�u�����mk\�X^�&X-��v"��a�R��0(T�!��v0Fa�W`D\T�Xc��`_T7aAXd��dX����3�;<}��2:����z��6E��jq؁B�1X�#V�q�-$f%?�'v�e�����ǧ��n/
����	�삆J����5'�11�����#�Ҿ��DI'�����
/�+nrd5j��5UOSe؊���E��%\�pɊ�F7��ͲC޲�����(�J�՗(��������3�y��I�:����r�@�ہ�٪<�A���y&��j�@��0U�KA>��>9\be�Y��*��X��\�r[��O�Fn�M�\�����}�@JH�8x�!J.�-�H"A;x����\_nfٟ*j:�mz�@��][��
x��bA���<F�?�;�V��;Ag ���m�����N=�o���ĳ>=j&)����3���J�z����O�y�ӆ֒�����%��������3�%�)3�L���s�z�0@F�r�<K:(t]1`3�V}v�%5�vݶu3h�P�c���H��HyD�K&ZB�לIA=�Ƞ*k�KB����#a�´/Ԓ���{�����ݽ���/&	d#\����K�zz�|�=���n��q�p�+�du��5P{�C�+��Y�;�s��W���j���_P\����J��A_�.�Y�'M��~Ed��ҵňy��F��S4PBd8��GB#���xQH�� ���4yZ=�}�F�%k
���X~�|�˷tI�*O�K���:v�!h] V��6i5�H���0
��Hv���$1u1A��� ���AR$������Wg��$�zE&�h��gĸI	��U'.Bƹv�I��\����6�-mnZjf�[�@��N��kR��^�Z���\�zlKh6�w��Yo�ww޴F�
5NvH?���۩����Z���)��EEd8��	����.!,24�j+d�!���+�cU|x�MƀX��[�d���y���;�U�!�tF�p��X��N`tXL�u^��+o�� ��+g��Ms͹C 	^�Gj0���]����M��y�,�^�S4���4�|��E �3ŕ�G���T�p�xp�0_Ϙc�?��l�c�^����e�q��;f��hUm9��Ni�����b�|5�њ�.����ju��ŗ����uҏ��L��e�2��H?Ϡd�)�Z�Җ���g;m�D�K	�b��u���{�Y{�'��#�z�"m�D��Z�v�4�N!����B��@"a��c	2*d��5�����;�5?�+X}\��ȼ�o�W׭H�KN��o��]�T�����.⸰�6*f��]������kh�q���X���ۤh�h��[Eˊ�f��������޲�����YkM��$%?���6�#r�x}�зe�bV�2�F�4����������b6F4�Ƕ�G�{�۶�dI��g�<�Y'��S�������宪�?:��}��d|�{0��z�]D�PJ%��"&�y$�VUϹi��N�We+v�L`;� ��kh�f�n=�᫪m/7����_��S�6�t�ī����@Q�PU�<;���Sk���䇝��I@��c��mO����|�K��UB��f�3�QB����9e�o_�� ��Q�F�K��<�XP�2��Q�h8���<��Դ�Ne������~i�*�ʔ��{ϔa��F�R�0��-����*��]����<���=ߩ���n�v��2p�ʴ�n���7�k� b��M>g@���5r@X�wLŖ�U�[HF'�U��w<�! z��yܤ%�\n���3��I+����?9�l��2�eEi�b����׈/��b-Or_$���__�Go��jI\ˏd-�[#b�ƻ!�@�e�^�%�y�(�=��ý�l5x�de�%����f�E,��R\W��
V{l������,:xH
��#2zZ�ZpZ�l^��$�e������6t��aN���ad!���������
񂶎��mk�l\��T�����S`����\�T������Tml��.��%m�Z�i�0���F�����`�q�­2m���s�#�<&��}zW�N��G^[��v�4�ī������ш�g��H���KH�`q �5R6�
c�ᅫqg��������z�w+d�	���g�^Xc�:��Y����Aѥa��a�+%�C�%��VXF�
U��R�
������Z�W�<dx?�F;������U�F)���61�ı�U�"/�h�"�/���5�Ηn5%]�_�^1��,i�A?��z���j�!w�=p`��(�r��!�3(����(x�J"��_1�b���$����j99[��F�î�=k)��C�|%��*�)@[��U���?��"+�]7KZ(0���J��ϳP�~����aU�'[(�{���9��q��m`Cg�ww!_u&oz}U���M�h \|JD���#�h�lz�ݽÑO�3(ny�9�������,�M�@J&#��aJ����wN��nO?MEY�L}�ǯ��M��� ������V � 4��O|��}*��b���������}Il�]dQ�h�G���BD &뼎6�G��蠣�����xW�5z��*�J�XA-;���ז�5o~kvs{��Ϻy�U:��Ȓ�΄�l�/aU..��W���8	��&Ng�j��9��5CJ.\��n8��P�[��4���-Ʈ��G}������|q��_M�������pv>Ce�z�����A�/����{GÎ��*�~曝N���6���F��J�����3_��=w���zE|D3\�KK�b)ဤ�"O���hHOB\�2K��$�E�K������U9��

2Sk{���o:(O�
��6=��m�J��i[�X��j�حPE��'m�Wc���s�#�&�MԿ��|�O����ӫ��W�k�@����?���/���m����meb�<B��� NAlr����}��p�F�syH��z���z�Ѳ:�G�]P$F�������l�����˖���H�D�Aܨ4��y�f��������:	:Į�n�<�.�tN3�$V��L�U�V����<JM��g���+�L5mt�#մտ~���s��\�>MǓ��9H���/����5}�A]i�L�>�S��c�h�r�Ԥ��i�ͣ����fEu����ܲ����� ;���OƓ��q�j�q�ƅ���Z�X�v��*t�Uwn>���m�����ܷ~�^�w�8k�h7/&�[m����wN�v�wŹ">��N��'�>�Vjx���@����0{/=k^��\5��F��Т��|$�|"����m<3�I�J�M ��8Yzi�|=��3M��L9 �\s��\KZ����vQ;.�w����e�/�{��UG�\�4���]yL8�	���_pg��3Ff׳��z�<;,�E��8�8�U�u\|'�KV{�a�;��;D����VG�5�	��y.	Qh�mĚ	�	w�Z^���#�Չ_b#�M�p�,�E ����������Yq������Y�&���P��B�G@� ����PA��r�l�d9�����Nƨ�<ސHGr�ԕ��ӒD�_�X��6��Y�~!9�8�g����h!��[�C���A��jk�,���Q���&�[g�!�K��xd�ˮ��J�fu|oj�����;x�PV��r�YA�/@G�A�,,����}ۧ�5��F�:��C\+�=�`�!$�",E�ڒ����eUƠ�h ���Z ��pkON���Ϩ��u��G�i�b!�(�wY�i��/_��|�ܪl2��7�� �r����1��n5��������!�G*�{&/�N?���F{��������޿p��`�{7nҙ��Z�Nkʿ�H�M�B�������u8>:�����Oe�_�1~h���vw����xx����ūVI�d�t�+�?b�Tz!��]}����گ�Lj��b   �u�*��Kb��_�e�N�gS|�"��L���������$�~`��e'o5{���&_�Ȕ:�V��MvR�~��)��iU!�|ô��	�Z"�����'Y9�� o$�n���8�9�=���߆�aPɧ�++�]z������b�9�L�X��ɬt�+�+<�l�ZuD3���e�
�$�%��c�rc�X���������H������M�G�v��F�[(,t�W�W��/wug���N�6'��8F�~xIa��;K�d'��E޹jS��y��u�P�]�^�/���v̌f_v�43�����*'U���o_+�p[�Q�D��.��6�+tV�`�!\x�Xf�%�>-��
g[8�n5p?�o��/�xm ��D��i����^h�I�^j�Y�6�!|~Kʴ�b�P�/�O/J�8&L��=�a[{��Z���Q�p?�s�[��z�n���
܏�&h�v���	���� ^SRѱ�*Ov!�Sۼ������w���/G��U��}��p �=KJ[�(q��E�F'�Z7A�З̘.E��0�uѺ �I��O� i ��>׃�
�.��j���ej4kM�#ϗ�"Y�pW���d��d�h:�[�����t�7����n~����U��ދ&8祉�!�Ip4HM��(�в�o�&��{pv�q��x3,F��� ���*�P��P�� ��[oWj|iX>�*7��\���\� 7<�a��*v@��R.6�*���x���L���c=bP�f�r2�⺹��YΤCˣHn������~r��>�,EberUd'�l��>j��l�J�Q����D��_ζ��{��9��d�Vt%# � ���Y�{����CW�?W�9o߽��!A�,(Ԉ���+����%؛��v�KcKl�o��@�⒯э�//�������*vsN�k�e��}��t� t��W�j�'�����1��qNQ�7������[7��k�z��eǣ���m9
Ai,�v�e\ϡ�=��5��\P��X8p;���a�V�f��e�
��گ�a��������f�}X��ʳ�5�,�CC�����V#�Up��aF�YC O>�9���!���Zӿ@���>o�aߠ��%����������� 8��a�����-�v���#�}{QZ�>� ������)rx*��/Ⱦ�] e�+���7g��׻H\�l�N�����f�˿��ҍ,u�-�N����a�AS��O�w/?1�:�����r�}�������!�T����@�n�Q^89k�LQ�~K��~�/�X�QÍ�w�F�����?� J|J��w���w#���8��79,���<��__-~�M��1o"�O��$�#�*�=��2d!$���!H��ğ�1� 5����i8��	<��W$��J��nw�?�t1�to��yyg|�,VG����S���:��h;�}��^|��9�|�����FT'��*吂/;�Mj��7���۱.I���(q]�ŢN=�9�������?k��9      A      x������ � �      T      x������ � �      D      x��Yo�X�&�l�+XduF�s_�1�$wEh��K���e���$�.��	�8@5�K`�@'�1�yr���%s�s/�{i4�{FH���\"�%[x�9���;�����Ӽ0.�|Yg�,��Ia��̓�q�n�Y^�ƷF���lp1<�_^������}{p|uq��p`�V�kڻv00�ߺ�omo�1#��_�_Y���rQ��ŋ~�a/y�.��I1���YR�X��t5YV/\�a��(4-۵m��㸦���|���ޛ�l`���/�t:p��3�:�_��� G�g�������x}t�������P�89ȧwvMk`��u����mۖ*�2���ړU�x�N��"K�t���߆���',�t���A��g��[a`��h�~qz��qp>}e��Ͽ��p�<�����>?�U<�<�e�����VK��b�}l�5,�AR6ܿ8;��OgY��=�����oM{/$λ��+��+bp��oV�q1)�b>N�뢘��.I��3>��|�X�����z�8�z���l�5M+0w��Y�����w|?pmǣ�{�-,�mΑTF��|�ib���(�I��tZI���W��ء_W�4���qfT���X%�46bc�˴9~��/�tV�i~���,�AE1��p���i������2Ͳ�!�qIO6.�I���N�1���==�=���A`ږZ.�3j�ta��͆�>}c4eF�v�TL�8�7E�/���j��?��?�1�8[M����1?J��|s�H �n����M�ߵ[
��_;�m�uj
��lp�to�ߏ�Z�v��Ӕ�5N���1���4&E�����<���^�L��q���^����g��G!;66��8���Ч��:)�kR�A��)r񥫊�B���wxɲ���աOO��V�2�3F�dF߷zC�s��L��)J�lAo�{�X�M��/��C���i�wtB����gZ���	;�b��/ӂ���O��\��ˣ��]�N�\R,b�鱤�nD���M�'����FNH��C��E|���X�*��7,󂤁�8 �I�I���,!��h��P��cL�,�4�/ʄ�G�(rzC���I�NQ{#E�tgf���V��D�JU�^��g
UM�I��x�:���L��jn\��1|w���Fŝ��ǖ9On\?�,W�q�����nCg2 �Y.dMg'r�`�íƥ�����!ń������?�Y����K��bw~�=�r�,V%���?��dED%�l��|E*���LE��,���{��8'N��q����,,'�H�B�MY�d�}��ʨ�q��
j��?��I��&Ʊ�$���p����=�N�C�+�:�fK��ߤn�H֖�<}�b��Q�YƓ%�n�<D�bY�K2 ƤLფ9D*�1�������,����3��"���GG/ʂ�@�;���%�:�H҉�YJ��L�V�-�hG�����*�I���Ï]���EQ��YBW���+oA�iJ|_J���%i��IY�X�,�'��a����Wْ�-嚔IL�f�����x�ZG��W�k L�yV�����TU�� �KYo#eg������NY���F rʆ�gE^d����a'p����H��R��Dۥ���X��wmS�$�鰎j��a��@Ƈ%�Nh�$Ec��y���B6�d�,R5wPy���Xe�>�E�^���sŲÚs���p�vG�z�u����VF/ɘd��;+f`�ʘ������!e��]*�=㌞ʨ#i|�Fk����7�Ϋ$&��A�Ib`���"
����$�u�5�i��@`CI?��ew~��[[�۽k�j+k�]WM�5�ព�]y�>����x�0���ls]�-[3֓R9�$F\󓨼L�F��{�R�S���ɮ�ڮ|����d�)~���#޴�Ħ@�?l��%N'Zw7�?֥��<G1#e��<�՛g=�~s�4ޜQi��5RduU�
q��� @�r���\-c��Aj�i)���!�pM�l�r6��z�Ίj�N��tۜ�Z���3K_K�'N3M,�6�p;f��#�d�L�Aԃ����k{
\�I�[$s�Ew-�2}�q�$�C�q�{$"�*7H?��Lk�O�Ən�<���8'՞���_-R� �%2�w�<����N3��4�!�mLV��u:�:&�̉��:)Y�O�D<�@"_��2iE���Y���^��w2G��Y
�4�;�����zR��eK�t\�콖��i:��v��wa�#����m~2OZ~ZN�����s��/z�ʶ�azx��Ŗ�ִ"ҏ�C~��28�=a{��/V�����LIͥ��p�똾tQ��:9���V���6#����ۮћ�����
[Pe���u�o�^�������׶M�6��ޮ�v�����g/mY�+�w�J[;����%���-P��w �*�U�|�ە���֋Gn�Ɯ~b�9���p�T�dN���	�=�3���t�q���8E��4�ո�=�OG���'w\m������ȳ#���1]ߵ�����`��%8�}}���ïr�VLXz��C�v��Şq�pҜ�B�^T��i�:_!Z7�2B�^�1���)k=N+��֊oC9�lb��*J�D����X&<��5l���S[���a�p�7��g�M�r��jvԳ?���^lI���#������"���!�e,�|i����O7�~,�$�L5[��"��މrw��y�j|��iy��y��w�N�9zI]�����ׅ�&�q���v��Ӥ��cLQZ�gh,��4�)��[���t�*R��K1��J�rt�er��t�vt��s>��� m�*��<��F��)8�I���I�yna'��WJ�vW5��;r�ݠHi�"wpP���n,ɶ�Vз*&�g�3�d��Tp_^���%���h��Zr��ɻ*����|�D�zE_�p4�G!2���9w��U&`�tB^�{�M��mG�����5�'�Y+`>���������9�;�$f��|�^@s�@�y5_Z�A%�n�IeP�jf��]�ҧ�(�d��M��z�"M�E�TU���t�I����t'�x�z�Fǻ���vh�_^��F���]�X���݃���ow�$#
c��}��q=��ԩlzaՕr����F��w��uQ�]#�{Z����QE��M�b%zJ��A���!��s��'�A:����jō�.I]��Ấ:��~D)wIK��|@U4�5&���Q�n�k�� ]�&R��:���W���Fz����#Lշp��R׶����v�[��)�{��g�B5c��:E���=KY^S#�1";t���T�8�~�^���;;�4���ۀ��Z=�N��Q�J�(��ci���5YP��M����,�C�ހk�W�v(��U���@�l�E���H��i�n���C-Uc0&�L�	�Hmz�L�MŶ4��i}�n��O1r՘q�q�dIA�A���J%�������΋8%\�����aĥo5��mkp�y͛dr��uW�?��CTPd��HR��%zK"�]S�����⍻�cqo�u"$?Thx����`�ʢJ��ئC�`x~tzv��ݝVh��St<L�S���MD�����t<����-}J�"�o�H��$�0�R_�����o�6��g�$��x��E�Z��E$)��W�g����L�;��Bw��a��Z�l�����zD�As 1�.���yQ5u���L&I����lE/�^a~��DDk����E�L7Ij��D�O��0�N &��(�_��W�p�X��F�X�$�	F^�kP�tb�Y�g�wz�21���cR(�$��e�c���w`�|xz0|z&�_���p]K�Ρ�XA��b\R���c�J:���p�J'����x���$���Y�>@a�������..�^͒H���� ����iT!���Q赤!e�y�/}y�ߕS%z���l�^R�	�~.����v�&D��A��/H�vQ�<l����i<;!g`+�=A�vr���.����m���������蛣��oAu�Ş�9�A��GGq�����&Rȅ6�O�v�S�4NJ�t}�Q    P���-譇$�%酲;�I�Ck|~�ʧ��_�����Q�p�.)��݊�o���kyt9<}�^ǵ\�� ���?�� $W�m��m<  ���iG�]51�\�N�C�N� p�i��$���ŝDa����sk�~��В��*@��Y�j��,��~�8�wU�#.36�I�0���@\;�%{ړ��|!�w�	�M,���,���%��3���M,r?�E��yT����x���8)��C��?<@���/&,�H��<;��vh�ڊ1�HQ�ZꜾU?�^$+��lل�pB���UQ�+�)��N�yo�%苪D��'���k�$}��>
`�j9�d��8��89�vt��p>>yf/��-۲��{� ���9���Y1#^-�ι	����J�Xd��v�D/I�3�����-�w��w\�GſL��d��gm�L�!31���\�
 Ĝ�E�mC����%��5��{CZ?0��@���2`pԳo05i>+�K|��A%r��ZQ�ʿ�O�V�>�L}~��xߜ� ö,XPE�+z�AY$D_:Kh�̙��
%����E������+�Ty�{d�,��A����5F�!Z�f`�gx�"��#QN�M�&��jVe,�C1Z>�L$Шj��FDaz��!��CQ�a�⛉L���7p��撇��wC�!}�k�M:�GZT;�9�|����V�]7&eB����*p��<�1y*�n��&#w#O�׋�_-�ܰ �$Z�NێK�����/����6�w���}�+���'/w�<�3�(�wI�>V���<2^_����[t}/$��%�z�mGo��cve�,r�o��\��Z7�|1��n���(ͯ1��F0nJ<Lu�?��`��Z�R�$ல�;[VJ�&3�z��l\�_����\�<����֊���pa�ؽ\�����̋i�k�\O��Ǉ�QnC��AM��3���m�+�|J��'�?(@~�g'���m%9[w"1K��z`GݠMm��Sq�k���+��a?�V �ȆR&�2塨q�H	'�ر^�
����9�--P�Fb/�|�hj^�U_:���XM��&Uz�$�D`7��+���R i�����Zn)�Z����dZ��-(xj��?=+]��w["�DG%�ތF��H��� D�`�1 >���TI�d��;�� 5�'�*��#���k�>���`oI�JR�v'O����6&W#!�
����������'C؈��#��P�����LR��O90w�
8f�n��-/���A�F�Z��-`?z�)����]������� �$��@����MH���}��uJ.�,i-ڗW_�����'w�'�)<"Z��DF�������\�������Ne�ba���4[t��˄�-�$��L/>�h(�Uuò�$�w�'�]�r�RZ�e��%e`{�>)����)'Ŵ(�tE*�nySV����O��� TdE���$!�.�ܥ��a!�Č���
:����o���?ς�z����1�5��~h�+���=�,�7�N�Xk'� ���xKr��R+�l_WyD��`(aF]�t��S[�']eG��2Q'�u����l�7��GE����N�.� ߸YC��S2e2�(bQ�$��9^�]m�&��I��t��D��ka�ل��
��-�1e�GF)t�Ǳry@�m�	��d��ΜJ�c�JJ�k��Gۡ�&����2���\rtVs���ъ�A�$�J(�j��;-�@x�*I���8C������2�i���+Ho�$e�N��o^�.Ξ�c0d1����(�;P�"��|�n�?�,�>ч�}�/��]I@�p�K�HLA�hn����b�\���1�)��qW��k�t׉�.�!���� $�SQ�s�����ZBF���7u�������q>��������:�� �aQ,�vl9Z��^�ikB�d��G�r4q�5C�����@O�F����;�i�~���@���W���·[P�}�2@�_��p�DS�'E���3RнHY������"z8�E�v��W�������Y<�[Xp)�V���&�R���sQ;B�T��)=�BL�Ls�M�kv�'��������h�s���(�P�\ ��H��Ĺ�2�m�M�����#�m�"�;��bYN�{\�������֊�Mƙ�E1-ъ�fq֋�5b�O`�{x�����ow.�ǝc�Ȼ�u��m<�����6E�k�ڝ��5g��&�c$r-V��e�>c"W�k���Z�8�"����}�,A<��$�����U/��]�U���ƻB���Y3F�+�i=̗�kb�7�E��A{v��u��V{S���Ϛ?�j��T�p���*�C�U�B���~H��4��1�t�3�Ȧ�٤g�ʈҡ���s}�SY�l2�σ%]%��J�<c%擫�2GI+�Tw�s6�σ9k�����JP���x�!��W�c�f�k�Dz�ɦ>S��ѧȲȱT�z�y^��</�=y^'T��#+l��v7����N7����YB��-��<�w�T�D�[�ʐM@�,�S,n�����5⺏��I~W���u�>��&�S����D�������(��	���ϓ#f`�^� ����@��o�}0��~�kN��GI�Z��%�����Y��G�^�x�]1��S��rJpG�ەd<�ҽ]������X�a�F��������w��#�M)�{�1j��t������s�l��a`�\'V�=v�3}�!�F��Ԡ͜��G�v�����.�c����'��R�ȃ�|A�D�����aS;�����#�e;2�I�1����F_�H��bp�T#k�W[aL�0Ǝ� �c���
-��1i�/���E0�C��<��"��V�bN�rŏ�h�Ts�C�"�T�b�l9�͌4Ur ��7yz�d*_0h-0-s��t6��v�+�{�����h�#��9��Z��䄀Ƃۼȗ�F(��?��}g�Y�2�U��;�(��'(p]E�e�'
�o�3�M)4 k!�F9������kz�T�VțJʵ{�>fVdS)-�jmAV���-EV�'aW�gh5�;�Փ5#��m��JE�y�@���bf@�@��&8�����N?|0v]aZm�b8[����"}˞����/����b�L��@2���.5�`�^��r����P%놌�*��������K��tv�$�e�Ʋ��^&弐5��^�������E���a���s�tm������S������?��zd��@�U>��>mM���� m=��h~&mq�O')��U�z]����#z�=>o��)2Ɨz�����;�}��Hh�0��r; W*
�6��^�hd�b����A3�)r�/���Bن��|J�S�6�)vzxt��sB�5~ی�$��NZ��F�^������s�ah���S5棒Q�:��F#D�mq����h�:�e�M<��y$d��
4�)��]�ˣ���;eMP�����r���s�$���$i�m�.k0|}vqy�ao��8�H����3�!��(S�QZ���ERF����@��,��گ����P�2�C�څm�Y�)�W�'� C�������Oy3�p����9��"=淢u��)L�!�`���"ٳE�~� �t쾾�g�Z��dU{ϱ�I�i(.hD�M�L%'��X$X��Ĭ��x���Ɔe2��3p_���[2��}I߉P�|�Unֽ�B�*��7�]�W���+"����Vܠjkr)�[���i���_Ǳ��|����}��/T�'5�MB�q-ϵ�� r�q�7M��~���^=勅����I�T���t�Vu���H	������f;�?:�j�d�;��F��ɳ��������j�f2(�Z� �+���6�ȶ��t��T '���U5H��/���ttx�����& ��me�D��uTpu-�l�VVǋB[�'\�SJ�Cyݹ�/���T��c9���̿���Kn�)]}���N�����-�OѰ�$H��H�Z���33�K����ی    �bNj��<��D�/�ß���挢�^�Ѹ���E��B}�����x-�>[�ǑO��s����I����6����[�+2��nE��J��6 0\�Y�ڟk��1�٩[I���d�q�r�*h^�o�ǂ4�%���y_��`�5�1AG���Ȥ&�Dn	'�K��~��n]��t9^�P��ӌ�5.I���.���_n�����=���[��U�+u��5�w�#��D�TB4vYܾ��ə��,�Uׄ--V	�W����v��!o
Ƣ̌iJ�ҏ:����_5�_�-�����F:�M��n#���_���#=�e����j
㤂L�l�m���ؿ:�ftt�e�d���eQpg��_(v�0�b��-/ c�i�Z_H�f �b.m&x�4L��@�G�v�CDiމ
���m��� pU2���82]�;﹮�}��C*/��%{��k�lʵ��墋�����W:5���d�r�b�:D?O�_�,��Lσul��"��qm\\�R�\�s_Z'"��(��H�R��J�s9�WENň�"Gv�QE�z\��^`G�jr�L�Ͳ:G��\�zz��%�)���� v}�!��EJf4�0X��иT�3���iMY�7]��H��i9qp�d��ȡO��E�������xx~9�B X���'�L��,Y�EN�i��#�}�N�xi�[x��f1��֨S�DR���9�&hic�a�6��:m�_N�6��]�u��P1�U��W���������mXU)w��U�k}��[���#�g��}���n �)7�w*�σ�(��J��!u�������x��'P����;YH��@���]����o��^�P�w�d�Jf�S�z�?��z4��l���CZ�TIk��$�����"�瓴�Ġ4��|+�g(��JZ'�D��V{0!��=�/���"���<۪��h�l+�W�r+Χ�3h�I�+�1"RǷ2*<8;?{����3*�w��(��ο�~�+i�����Ã�vw�ݥG=9VH�`z��6�D����ո&ۓ�f,)�]+S_��d<K.m�!�&@�}ߌ<�e��y�L�O�8��}w�g��E]��Q���緢�uW)C�3T�>��H�3�|���������,�������y���)�x�c��5����r%`��@gޑ��u�_�a�2�e���_,�]��>N�jܴtn�z�oՉ;f���6�2�����t7=a��MZ��S��F��<�ޚ����K&7�t�V��������W_oZ���4!�j[X�຦M[mT1�NBֆ�8p|����Z���ʓ��]��J���Z��:lk�[����(�t�xsB��)#֣r�樒\�\�LD���::?<:�B�^����(ʵ]30�Z�b�S�{)���tڜ���% ��}Y.�I�T�ɔ� ��-X�#AS�0��jR&r,Iλ`gWz�X���x��VmMc M�P�`���W�͛�'��u�rC7�2%�h���;A'�p���E��T>�袣�1�u.I�iZ%��J�X���������/V���h4!��fJ��z�W�?��d�c�RY�3(.Wm$ì5I�m��k\)7��q��S�����#>�k�cL�����ݑ�W��p�ٍ���'�~����ЎM<k�ɛ��Ɉ�k��b��$	�L&t��-��!+�L��Ɏ���@R񔄄;�F����:�<l�`�X���>w5H2a�-M�;��;E��k�ُ���%����p�fPK�~=<p�{e&Bׂ�+3�W�l��%!5��Q�7���b7t�#��,�u��W1'Z#���ǃ=��]l���#�^Xϊa��}ڵ;��A�������i�/~.D���Nښ�v��ꅞ�G��T-�y�e�4��qS`WM������2����-T�u�ƌ'ȍo�|"h�1Xn-��,p�p]b��@�C�<�Xy%Qa�]�\����IO4�a��f���7�W��W��x�������p�bM&�XҳB��U�3-c��ˣӓ�o����9X��a�������A�L����4|�Ux�܎܃$w
�f��(�[%D3����.���5��H����ʚ[�ل�a����֓%$ר��-Z��}^;P�s��~8OQ�7K5ۅEo�ښ)�]����)ٌ��Jq����SvQy]�;lQ�[e+0�[�#凮��:z��=��.�<���Z��T|$�����MZ}g�)nH�s=.P���^����N6 D<��[�% "(T�<���=[�#�WD���잶C��40�Z��w���Ԛ����d[,G��UU{�}��*,_�*A���uNf˩>�)�`c���YV9��l�v-���qH����8eu�TP�'O�<ߜt[)�=�R`�vv�]��N7��D>a_�`�1{R��j�#V��^�ؘ��{���j���)B߷�������=\�f�
RAd�{.�h��HY�.v#��K��C:gp�.�1�f�^7�6۩�N�U?�����(�C��( �E�WWv�A�R�)QA@bOQ<K
$τ�4�(
�L�Z9	l�!����IRi`�[��j*\�:5R��j�Y��t�t|9d�S~�@""�>.�AD2'�p@N�s�g�&`r�(�p���ĭYR�3��9���/�×/��'g���(��[0�*�"���q�8�1�M0Ǔ�9�3��y�o��7r�����WG��GO�^�巜!c��/���C�Z�����b�wW�e���R�m��D-�8f.
v9HV-�{�!�ºF���B!E�q����P@�x�98ˊ|�q�<�:�_]��f_�'���LB)��Ũ!B�jh�C����Y��S�E����İ��X_2�"�gY�$i<\]_/���wqt��xtyֿ��1�ڗ"�a�m���x
y͈�Hc�55$L*
0P4��I�Ê?�
i�<��#8r�k�Z�Vu^\l��dE�ۣow����^�f|V��銜���V���it^�y����:-�g����5� ��� �>��*��K��f����3ԍ�7t��jM�����z~���T����c)�g(������z���CV�B��-i��S.����zG��͢���_�&i"�i1���{Y��	��.`����^���Cߝ���-V�o޶�9�<:�_����!~����~D�������>� �ھgaԭ������;u�P�	ngNIُ�ԯ2Q�A�^�����U���_���e�+�)_���t�W���a~r��8UUװ^�e�X�<h/���HVEM�
�Mn�@�_���fr��S�21�����b��+Tb�$����8�ĂD ��"�Z�����d����G+d��/�H�z�X���d]s�E�I:�K>(B�<��M5���Fz�K�N�/vy~�O�J��&�r�:�Xl1E�x5���[e��m{_�E�9����y�}�X�5\΄�<?;�8o�x��"
�l���ݵ:�&E.~��Q��ש���}z\���h[_%i�������<�;�W����W�~��)��8�h�t�c�Yɨ�����L{(���V��'���>���|�l��e�T3�]����s��Y�{ι��ᘟLI���=s���ݞ�=[&�����zHi� ҡ�0)7�o'������v���"�ꡣj}��|�q�O%��P�ږ�W����W��*'�a_�}���e�ξ�?^'W�|l���Щ����q�H�`N���[��Fl�EkVc��1}���ܭ���﫛xU�WJ��
����!鳝��ވ"�o��@��$x��� �vd���w�ںN����%h��f+#^��
�ј�%�f��Xo 󜍌�F4�=OF[-�Q�\g�kj����N� U�գR�ȶ��$r���\4P'"xLru46i�A�e�K9&��M�Mw��C�Ht�oEǶAN�����-�0t�)\�rnY��:���_�BnC��#��(+pۤ�:k!|�]G�mO�%�a��o<fNы� 9�9��������� ������6�    �3:И��&tE�w4n@��&]%,�%�D7�v�X��g_��\��%��F�����e��m���_�h˵-{}9�m��{@�����et�q]�F?�lb�����m=;����V�G��y���a�W������br�C\�#��"}uvqy~t��M]����!\)ˍ01D����E���+tm �����q��%w�ixR����e����[;���X���2]Ö����g���^��y2�v!Լ6����WY�������__?y:�������v���]��ma�-
�$S�Jͮ
9Мk��~���$�e���w3��zY�T���	�xzr�� �P��4@����C |����rsl���'���B^n��a���z�����r4�ذ?��9������o?Lh=��mB󼪊kd�v���o�w���s��;v�>F3��s$�imB�yd��*$5��Cn�Z�S�O�7#��n/��Z[&'K���Ӊ�F��[��E�'���8�~5�E^��
��FQ�q��1�Y�vvvz�������,�J�ܶ�tN:����q�>�uZ����鍷s��|��$G�:��f���F;)!���=�v��$P�����w�[�_�1W�G�E�.�"|�s��w@!Wo�9j�����n��3��b�"Y,�{$E>{~LtT&:�:���LW:�,)�a�<�{ƭW�k���[�0�� �S�ۊ��;���2�^�aYӅ>lɃc�2-�r�,��Z��]< ^7l������tɠ�ύ���K���e[� /�����ퟂu����q�W���m�I�O[�F��ʨuGN:H֋����oh��[����J��o��b��E��Y�I^!yIR�"�p��v��ft�>^�W�����暼M�2��i)�3&<V�PW���ظ��EcFVL��c
�G�@�Aj�2�&�J%|Hߥ������R�/�{�O_<��+:�1d>H�i9��Y����k��l#zES�`$��DTD'-��$urC�+�&��CY�]B�K+9w����_ǫ,�zO,{=�:n�0L���=��IlG�F@=��X������AV+�����{�2M��Ev�r��Z��|����u��6�y}���Ile�Z�� t;;�c��oG�@��>��5�*�����$F7�U�dN
x,  ���I��w�p>�Jӽ
��!L*)��;Jė�3Vu^�eP�ӡ!YR�|���2iA!v�tJ�A��;|��H�h�oۜ�V+���vD���uDx��sǦ�^�ڨ	�������6�G�֦���f1�݋��׶;�=I��z��ⶈ�����Lߤ�,;XO�Ez�*�H*�#hm�~Q������b�ƛGԡX��`'7�0=��B Ǚ�RA��."&Yۑ{!����6�y]��d/������*�-#(W{>p��Q�Sl3�@���¥�;k�һ�ŋ��#ٓ�a��NMW�ۇ�HՅ:��_\������������X�E���r����ַہ*��7�(�iZ>��Ĵ��z� �aP�W���6X�Rݿgm}����=�x7T��V9/'��H�C��?��Y߰���K���\�\L���2!iY��e�*�o���ٞ����� �?&GLY�|�^�e�0�t��|��}"�=���l=*lX.�-h���A�����7�r5��d�ˠR{�/����)f'0w�I���M��o����4���uB�����r�?ڂAnziQD
Q��MW[_�].�$m+��u���W�u�m�8E$�;㬜	�$�	"gr ���p"値b�.�9�C�^�1s������|^�)z����ίHG$��1���τ�NT�#���Gg'T:kt^?m3Вd�Bs�LA_"����$0k���TE�<� aw?}~du͚���1{��ښ�*���ҭ?A��g���S�E���MW_�9�������\Y��-ZӸ��a?}���3���Ե��R��(�U���w#��)w���o+�|����!a˻����r$�LQ�i�1�˧on�I�� >J_�On�C*��ǜ 3k�i]y�:l��M�,Ѭ\�Wo}3:?]�<��B��"u���\���� �m��+V��(�)��l�
;�lh=��e��Gg�i*�7��+:3-��Jk��\�� ��.l1�v+[��l�~�(׋�FJ �6��� t���ܿt��ݕ�60���B�vsa��gx|y��ZLCR/���,W_i�~`�=�mM#ͭ�4�"�ԉ�rA�wR}�ŀ,�FEw���8�c'��,�����M���qM��pm�Ua�x�Q��M-m?|�5�ykD�d��P��:��F�̈g�Zf�:��ϢV�%S��=d�u`����V��H�"���(�:��?��xHm�$
hD�	�����r��Ǥ�?xr2������бLϷ{��\e'y�%� �IwM��ȘTF�]������,�x;J��lk`��IF�+��z2DVj��"+MϞ����$�I��ٌ-����k�x$�д�`�:���Lb��Dd�z��MIh�x���Aeu}�uK��h�6ξ_c8'����'�y�1(?P��,���x
;ǔ�|_Y�7��;x������<��-�x̘y1d�;�W���ȱBm���l�E��ڐq��M��>�ë�GO_q|�s�_����F����o�����5H�d��J���t��>����>1��M^\�ͬʺ٤�ؑs,�ئ�\�rդNѣl�����g���V�/+�ڀ1����-�1M�����T6(d�����M���?jV��80���؇�-Yyq�!l��E��%e�1p�Ҳ{Gڠ�FN��夬�e���xS�v;%k���5�h��m��9�	$0~��u��Dm�����<ιih�ڨ�-����'��'/Z�O1�T\�#����|��S��J�O8��@�Pw��6�]���x���a�|�f�2����N�"q&P��<�=��a��=�Dj�5��vH'Ȕ�lm�'�o�ޑ�oVZT��&����`��W�x,�*��(��C����nǨ�;|
z���ӽʥ�ͻz/x<E��o��4��%���ru��	��P��'{��^Eэy��V�HĊ1�e���dL��	�G��?��h?�i�{>��,~��d�����^�(����5���8W�"i�*���|����mcl>�ic�	�u��56�=���*'�d��)��54v��mƂ�rU����T��뵟9:>:?�:y��<lp��)��)ph��a�����˳ѱ֤-�A�v��R��ls��t�@��r��6P�>+��@�q����"�Di����Co�W��p�I�b׭�{�f�uvM׮e�㯳+Ԭe�7����o�q���(Zg\�f����Vk
���i�o:��kA��WOK}�q�d���~�ڧ-_��o�p�e�z5/]��d����gȊ,Rb�Y��)��V�;9�1#��9��ͪQNW(�:=^��՛D,b� �fi�l����l�ʹ���&�,�)DV�/�� ���Qj���M�|��
�����n��s!P*���Lx�bQ�o���e�0�i9mu��v�5x�|f����Hy�;�+��/��H��P�M')f/�-�q��nbQ�d�#��K�^��iL�t&�y�q���w�C�ԸCi��t5���mۣp���g�N�U�r�ff�o9Բ�}�y�I���q��Tb��xNlFwX���4��a���d4#�zћՌ�IE�R���4�s�����Ƌ(��-��J�X�$9B��=�K
W�b�p ?1�V&$��&�N㎟IbҦg���A����GF��|UFsm�Hȍ��0��<��ug�M���4@Aa�,�#4YP��¥�d����k�d2��SC8?���EE�zJ��:/�/FJ~O��F[�Za?7�~a��Mg=�r�H��|	�"����sѺ��S�,l��qkbc�$����ֺ�~ɔ]��O�̕��{j#�N{s�E�9    .�E����Q/��x:S�����"+t��(I0��=�#�ZO�h�u{DsUUɁ��TP�H�FspXN�Kx�n1��pvvk+�>���h2�s��L~��FԱ��GO�O�/OE��T��f����5/�b@=`����HD��B_�����l��w�J�*!�W1�K邽�~#k��!��6�B����[��Ǽ��;JPo���"�7�tF��O�5�$	ES�s�"~�C���5�0�c�*'�Co!�%�hE��2��ۆ�X\`=n{)p��m���_f�T�8��|`�y2t������i��d����H]1@�o�ߍ��h�7��������Vl��l�`��{���2����g��^J���'V�+-^��I/�^ś�c�pp,���5��b`[��&M�j��5�[l}i�2Y�������yr�Z71���V�e�)��{������`���k�D8i`RW3R��>|�������ؚ	��g`J%�8���۹��Po��\���s�z��_�?�t�����`b�$"%V����rL����z��=<;5^�Ώ^�n���x�"�5���O���|J5s������s�܏���+zȚ�	����G��H'�ߑ�r��4��Z���%^����ӳ�v-�̂dV"{�L��ہ�$�۶FZ.&�>�b{8G�nXT_��0'�[\�	>?ɋT4�d0�zO��rN[	 �:'��/�ҵ�EMwz��Z8n���z��|Nj���΋�,iVa�2N�N��5�� ����l�0g�^������2���;X;ǎ���~�~��bs��n�;D~Hno�C��#]�1�[�T�]gt�*9'����4+S41�1Vl�	��4���,�=1���SN��Q���$�L�"�*Ws�X���1'��n8f*��xi�+�O�sz���E��%�6L�x��᝷�Q\�F�b_�����ϕ��	����^�-뜺�ي�}��(�d���bi���# ������#����wWgOo�IgD.$�"1�D]+��^(���}��"��
��T|�)��S�3o2�6�8$����w��S����e��§�W@�S�]p�����b{�,^� .S	Ϛ��V��������OwYQh���`f��6$��$���i��P��捚�G1pT,▲npM�Rt�� >�u&l�퐸��ІMrHR#�;���X�G���h��l����Q�F!�5 (�o��O��
�1�>D�%���9����|$�s�ywC*q��-�a���k�� �e����nq^B �"�eDt'r�%"��38f�)iF�/�I�g|�	�'��re|�������c���zk��e&�	�4ؒKnE�g���=�m:�&�f9�G���G�ݽl���bB�S��Ga`_a��P�&S����ӳ��'Ϯ����\!B�0X��Y�0�=�7���}H�_ �J���f�B��:_�׏B����9\�p~!��Y*ՠ�����U��0�ʠ+��[ �'�E�4ɛ����.��F��j�#�<MQ �d�n�_���~"�[C��{X��_���dVx�LӲ�^s(��wW�g5!OB8.�i����)���\����}���׀l'�<��q,����j?@�ʻqA��q��8Dv�����*rL�e1g�H^|�)�߷��3��g�,
��ӦF���9��<=;g��$��	ؽXdψ���7�v��uf��[�:OJly����	o�Ոm}��2�,�ϷEi�V��RڋB�'�rB5�'�UZ�:��^Z?�
�ъrD�٣8l�m�#�mSq��N_��/}��|��+K��D�7��.�G���Q<r��~~�s���)⺖�f�)x�'�t�\���.�՟�PvQ�5�m5���[�����ԔUv��N�X&��dEI9���n�.QɦGZc�@�2�jV�SĒ���x�><8�B��
M�zA��m���2יB��zRa88l6�Oġ���S�w�{;�h��ӡ���~h�����Ĳ^�%������]
��{0�	�7�����H����~�ڊ�}jK�4	��f	�����^6o�r�[��w</
B��A�F��R��)X7����#E:yJAx�.p^T���"��������Փ{�AdYQʂ�A��U�F���g+x��k۟�8�J9{�v��%qtB�YO�WI�'Uu����4KfZ=��j������⻧��<˳�����#rYM��A`�N$��·(����tO}�~'�����7Kq$_��\Ҏ�>�؅�w���,��w�k�K���lm�L�y��bF�;I���_�=}	/�q��G���M?������y�O_T�!�uU�ѨP �#"q��|�ą�[AqZǃ/�H@/���q?��U���T�K���i!Uh�Uu�v+xL�#X�����;��2�:�l��Vh�#�<�\��^R�My���h4"��=cw��^�Oo�B���}����2�N'bͅ�*a�a�nO�VC�퇢Ȓ,�OMо=�W$34��I��2���lk���X�X1���e�ǙU�����"-��z��F/�k1�=���̄fy��r4)���u��+����e��]އ�/���>`Y6��QՀ_�֧��|?tD~�d��n�!A��!�]e��mY�zb1	���i��ü����1���;
<3Y�-�<I�T���Ba��a�T�]:_������I*\�>;�JJA6Y"B��j�'�( A�|�-ӹSwAD��2{����yXN	w���~��z�(r���E`E6��s�9
F��1�xHz�R�7�\G��N�jy�R;K(��B(�Lj% o�A��>8!>Pu��̟��ڣ�7:�� ��O����4U2Gn_��i�ۉ�泠�Ӊ��:�gR��t���v
UȸG�LZd���gAf�30�kd>@���2~���Q�/χ_�GO���=a)�ٌ�>��MC�MnB�������TCA����(�9zkE<ow������a�,���=��#wꕄ�.1�VR�AT�;=��O䴊��b�Ǌ1I�>�;�3d��$�����Ǥօ���C�HE���&c����ؗڤ�b��54e½`���D�)�ׄ9G�5%�B��jW�s�T��dx~���;y'�� ^`��8f��x���?"-��>I�[��
���=P ���Z�p� �v�V- L�.J�S��"%��9��$m���"�����NۮE����>y�	N�̖ԍm:=Nw�.� U�1��6����L�R5���c���1
��}��*���K��q�=p�䮤6i EwFYP ă���D����I�!��]�x�.T؆d�6>�':�x]���Ï��O{��*��Ï$Hv��Y?�X&˲�� K���X�(6�br^�a�M u�d���S�4�ȭ�u^}�!�\�!����z��M������n��:�Q�@;��]��%`���������M�)�������m�2�I.��)�O֩�һ�+�$JzC�[�����F��*��󣳧w���r7 �y����`�`�J��:ȩ3�i,�G9NU��q�;�x:+�eZ�^	cDԢ6&3 *����4G������N��|����$�����.�^>}�3�MT�lhw+��m3мH?���!������ÏB��m���v��x����µ���=��.]�n㬚��3�L�ցm�Bb�<J�����[$�Hc7f�����y�],�uU���>�N�f��๪��S�Y�e|��i>��dX�j��.�gr�1��fXF�<a����wػ/b`��(��[1K��9`���Z�F�/Fې)�Sy��*R�>#"t�Tn�&d�0�Q䢯[l��3�-�Ad�Js9�IF�� �J6L�S����V�`�I�o尢�ST�A>����.@�u��P���7&v{��^+��?r��n󔻯�)w�$�ȱ��:A��DA����mb��`o6��T_@y[�:�����f��k��    �b[��Ǌ��1����QW�<�aG�^��
��"�eV8�&1�{g=�,�v���º8i�]�?��ewQ�]3d[��ӘT�����\����Xܤe
	Y��k04�g'�T�ׯ_�?}��!�&D��$%»��щ���}'l��1<˖j���&}����΍��Yf��0�)Vj�'Ǯ���D�)�����'q=��4uϊzMzz��oR � D��B���s2@�ꎿ�Q�t$#[�{A��\�B�M�P�2bL�>�nBy�S�0�/�N�*~W�J<tV���E������n	b`-<�;J2�(ɓ���������I��y�mY�cZVoN@0�)Hm� �d.�a$6�T^Xb\g����������/�c�vIvK��m�;��UNĒ L�q�L�b 8嵡<�z�����&�`k�߿�~�S�.=�LlU�o�g�@u�
��zK���Y�B�m�!���z|��D~��M�zE���oђt]�n:Ic9���o�l�X��xI#H�+`��EnpG<��L+nO��Mf�<�	~7�`�ӉC<���<L�2�w���/��)"{���
�˅�%SdC�tڝ,+0�d7P
�!�s����kl=)�G2��۬�Pa���-EE��uN+L���
t�q˩��Κ'V�)�)��W3���d�詂'njkđ c��wkA��ƴ6]�nَ�FQ�-����Tb�dIG�2�'�r~���I'����a۫������WO_T�]��F�50��H��Br�(T��\��-��P DI���A�����t��"/���i,�mVy�)�'U���	Q9�C�&T,�GZ��G�"�,/j; �ѰP�ݐR��qH[�Z������R���U�nX���^�����Xk\v.���ɝ�¯cT�ӯF[hgm$]۶�\%q��8J���ƻ�v =t|\�MÜ-қf� ��*~�s����6P�\�Sۆ��h�$�lTO=e�����t ���L�pF���P4x���@�4�i)�a�P�Gf�hhV5�*�IJ��R�S�3�9Ӷ('8�	����Je&o��L_�t�k��n\�9=iߩ��LUP����]�ηPq��ud�m�e�w_��a}�y�ݗߝ�ң�+mm���(F��[���M$y��7Y��4-W��u�R���;)�E%�)��D�`�t �B��9�-&^sv׌�lj\s���EX!`�"�h?��O9�O�9����kE]%���;[��g�l��%��y�>��|}u���l���f�c��k*�7����`:a`��'<�'�N�*�mVj���r��'�G��F�Ƅ�p8�+����I��N������z�{aW��e�a���~�۾���ڬ������3.?�^9V���(~5�J{!�����>�ŰL)����Bg,���Ք�o&F�.T��[C�^bt�����_�Q9�ʂ>�a�P���e:�w�م=c��D�j�0_b��{'�J�r�K���^�w�@Zyh�Y��V��� ���C�&����.9G8�N��5�fV�M�aU��$y�]�ߦ���n�m*d�ʲi1Sa]���������-�7{��RK��G��t���:��j��~���2��(��X���sV�m�����R�Q����S�NG��SR�B1H���w;m�}5��)z�d�"8�ֿ��Z�d�?����Pj�ɹUN�`��N���V~��y"t�M��c$}D�c����4Eb�h��D\��v�b.�z@l�Rݒ�X����X:Pd�Xh�WnZ�Q��-�6�mJay�d��]k��z�jd�mIp�����y�kp���"�����%���	'�K���Y=7خu��E% Gt�:�W�-p��J(�ud�����_O���l�a�M�E�NR�eh�n�7��.�ZJ+)�|y ^R'��B��HY4(�pwY����;������,�:Fx�$�TP/e [��O
53 ��y��zc4����4�-����LfEy��	�D~����e�����&1��w)p���?t��H�[�k����R	H����������G�=��,�푆�W����f`�B�u,8X��(��G���2�>YJ.�����΍�|�Zuc��\�X%�>���d�8��:����?yG��Bγ����8^�=5�1���
���!>�'oZ����h�
���K��USٔ bD.��@vp-�CrG}�K��)�m�,E���{e�rt~rtx֗z\��$�@��H*M䧭������d����?��  ul��h�S��-�è pU!8xU[~r����:�n�4��j2Aˍ�`����"ٿ�:8�nA�m��#+��,�!Cd�]G[=����"�]�k�..g<W�,��:|x�rtzه&��ڛ�}�u1�{Iz�#��"��N�J������H5��bZ2�x�R�H؄*��LTݲ'�S�h/[]w���*i����(o���3m���������j�h���X���16�]@��y��A��\a���8��޽K�%�-c5�'�ۦDC��ë������;�)���[�
AIpV�5��1��Z���C���x�Ї.���[�����"E��dy.χ��^��w���sw3ؖ��O%���m�D��g�n����)�"�wK��f�5<��^��<���������Q��yv�]�8�w�|�m��s��7W�Y:rH����y�G��i�^=Og;(��H�<
�v�Zg�ͧ&L2���S��D}}���f�	.c�l��G�)Q��P��)�Lx������!���rt�2�o���L�՜ ���4��^����J4ޭ�=ީo@W����f5���*+Ӯ�te�+�b[/�֮����H�N���&5��N�������̌B�|be.��v�hD��	"u(����6t�ƞ~!%U��6Y.���"�6��-Q���� �jj�
��Ğ��T-�����EZ�.��Kq������p����wW[�'�'�c3=?r�`�	�l,�nz2�����aUtQv�$�Z��,�Cc%!�FQMV���J"W���J��.
�A$E��,kV9�����J�N���0��Ȭ���\��|�9�m2Kl���e�Qd�m[�O.��`LD�ݽ�N�NW-"��)�Ǎ%�FG� ��e��r2]/�Ñq0<�o��1}+��0ᚾ����;;HZ^)��k��(kN+�j u)���{T��W9V���e��O��9�;����A-R췫$���V���a����TT�ۦ�z-�1ʹ~�ge�#��nʇ�/�q�����ux�$_��j�/�$d�77  )O�����V?C�'9�쫮gTg(�p�,2rx�
�7��V*蓦ˢ,���gq�]������N_�!BH���Os}M��=8��=�b�~�<���-�Eo�j�Q�P޽�q�v/;��j�0�e~>��
��}��v�qF�2e��҈���j�m\��J�Kc��&zO-��":�����֬��74Sߨ:I�Y��x��O�-Ī�I�����	|rՌ�ϑ��bۡkb�8tնD�9�w���ybw�S��t'�9̄4��S"#��Ӯ���w���h�W=~����� �"���V�Ď^���� �Z�P��Syo����� �c����[zA@}`���	��M��@N`t��U�6I[���e�E.�/�e�_��QPwE��6z�*\�����"L.�7��#�R+]sA��v\��u���~â,n���I���wrw�Z����I�n�I�yѱ��������ņF��#1�eD�M XlmF
�3a�\^�t꓁��իX��n+t,be�ڮ=����h9�Yx߬�K��U�7*eb�J�ۤ��[�II��A��W_2B?2%�����?���gxd���缾Mx� �S���C��h"�������g/'K��� 6�fP�H<43��r�jh+��Ϲ����H?tG�B��(�1�ȗ�01{vm��o�)q�=p�[��6`8^\�΍�/���o7a_=����}-    �v�>D;jQ��Z�/F�*MM��Ag-C������+7aTo��@���H��:�&���Cަcv*)@�@$�b�ѝ�Z�7��?�;z��جL'��Yᶯ{ӊ�N!��λ�������a���5o��}qg�'��8]�jy�9/�Q�����a�w/��*������Z�3��Ҋ���bp��?��|�e|C���obIl��!H�����f��<Oo~���jZz���2rTZ:���29YJU�q�[�R,�Y��<��~_���|�����a�[f�o�k�?#b�5��@�9��VJ����vZ�P7Xo!v��S����>P�/cL��)�$����Lؖ=�rz�r��*dc?���YBoo%+ppCl����R>�Vvp|Y�����l��<;=��'w�m�p%�Vz���&@;�Q���48MӷP��<�7KqZ��Kǆ�Eʻp[�bz|��b��{�#e�Fk�����5��ٜ��S�e*j�,���~�q+�#����?0%��17��E��6A
�ـ�ȴ�'�Q�`�[QB�U&�H`�&][(%!���i��ifՠ7�����j��vD�,;I����1�GnQ!q��cprtqy>� ����Vr�ö��]G�<����l�W���p��D��H���2�W2���3�vG��k�<�/������sI��<�=y�Gp�r[��3�u�m"�0Ur;�J�X��G��t�mIb�c��ſt#+1_��}��Ο�۶ON)ϲ���_������4�����K'�Mdo<�ty��'�?|u�[�\�c��[/�4�w����)9G�l?迪��KaG��<^��x���j�G�a�Ά����,�:�������lv�|G����%�0f_'Ʒ�h������㣏H�0��./�vv��Nw���/�v�S��}�����n���X�|p�̮����[K�Gj?����J����%T���"���+߲,�[_�E��c���8y����6.6$�;Sk���>�X��)�$�C��w�aH����n��
�/����vρ���*��z�"U	fX�N܁�vh�W���~�m_�\��.�_�5)]_k��=.�/Ծo�*�⭋ M�%#� �+ ��Ղ�a��[Ū;�5	�ÓHj�����%�� Z5�lʂ�>�ң҆��3ɟO�^���`3���vŖ�Y�k�ꖾ �t!Y�3զ���n��R��&�%�}8�\�E5/�$�j�$HlO���m2�@�u�~^�sr��zGN#�.����.ˑ[Y���.�,�j#��;s�A�"�䫜��LY����!w�N)bT��Ӿf�Yi�kV�=ʡ�'�%w�}���Ng�ʶ�ć��<�c������E'&F捓OQ⫌9T|�,i���-Wq^��6ֱ�o�un�P��j`�y����
s}�]0�W��A�A�VǣdE95\�J(f���gbi{����n��o�+2%��&�sK�F�\׃�l��`�GW�+�R�> X�r5����Y�
��W�~k��Ӈ'�w��K���������VA�m���nO^���ݘ�7:=��Z����o-��k��;�1{�����f�<�Ϩcp���U^M�E�,n8}9x�7���{���!�4�q�bU�UֳS�.G�ЗM'�D����1�y=�a൉J�&�`-`��#���H?�ss�.���^����P%����j��G@_ч�s�g�򻢡}\�P�-��U���r�26w�9��.�l5�����ϋ��On�P��������ĈG	����~�Pe���a쀯WU�ye�LX*�y{D������(��FM�D �ܖ*����A��35��yѰb{2�{ ��q
6�J6�<X5'�� �p�k��2^������%�?�����d�LbK��"�j���d�`RY\4W�I�N~�E�|��c�~J�h�:�$�Ix�!K�(�1�[,t�OgSģ/1��:+qSV�D����ǆ<�v�"ωc���o�1����Y��
���zx���`�����x>w�b��#����
e����0>4?3�:���%:�j1���Z�O�>3�l�dj�S'T��eJ��x�W`Y4�R��6�����0�D'�Ȩ�Y��#����Ab�I&�'9͋�v�����n�'���/�,��i!R�';0~���k��a�d)�@=�֯)3��R�.��o���8o:e�f�]��Y�9�p<W���e�H	E��*�I�	�袡�� �Q�j�@���vS�r��4}T#�4k���'�OU��m��;�䟢�U^��u�[*'c��4��#�~�N�o4U���y[N�?R����%���0�&�=��~�����zϧ��=?�7:�����T�)�jU���6�n���hҕ�z�I�Mו�J����K���b��-?dm�0y��V�b&ѡ�]���S�p	MЎ�ό�:	�v!ӂ����'�.-"�ھMs�ئ��a#~�~ж�Ia,cZ��k2�M�ŐjR��^�9#2�Gu�Zˏ�Ks��D�������;�U�'�ͽ�h$E5�8-⮶k6����i�	<߲VsG�X�m�K�`�p{֥��D�Y�����[q��L��*uM��^w����/~���*-۵�������x{�-%�njZ/�%���k]Aw9CS�^�PL�g9���xWV3�Ne=mVE_M�PU�@̽����?��5sIc~A�Z00Q�Ra�H�i��$qt+j�K_`����J�x�&͑�xW�1���4~�^�j%�G�5��jnV�R�_�"P-�I�z��}0�U?O�4#�j�@�� �����D�6�޲�k]�B⥃�y�ic����Rͥ�فG���JZx=j���Á^����ށby@���HR���Z"��VЙ��k}U�|�	��DU1� %���5ͤ�W������A �q̘��d
#��+C'�W�����1Z�$_¬T�,�3.��K�Z��u=��+���岬�������3��f�Ln/@�x�C���r�q<n����>}Z�=��@X+$^_�Rw+1[��"�	��+bd?���pO>��Kh���CȈ(n�ц*{v��Kz���+:��?�P=�V�Pe�uڽ��v $ӧ�z@iV����ldT�0��j1i�P��K��X��� �/W9�8��Nl��l4n�e����(���E^���E=�!ym;�I�ˁ SXI�Y�t��x>q#
m����nbW�!��=n �U@qM�O5�A����c��j�~Z� ���.��;Մ���X}��QYh-z��>�-�+�G� �d�A�X��ﴭ�lkh[�n��T�%��+������i�~K�`1HP��VÂu_�7Q@��NsV����������Rz���(����>��,h�6a7K`�:M#���/Gq�}����{;�Sw�4�1���:ܖ�q�h:]Q�a�V�8i@eQ�`gX�ۤ��U\�Ὡ�{���
���k����IG�b�4mNN�n�Ntm5>���}�ng�Z�lO���7��d�I��"7������hs���~�ŋ��x��{������gъ�[ �Q�?@f��mMgBys�I�^N�*R�o�\)����#�7�g~m��x�����[���J�rB]g6��Į����Y������R|�S�?��G��U��(�Nb��o:�p�B�-��q�g�j��8	Ә#_�8{��;��,stt�N�-
��6d���s����Av���pzM��X�,D��p�C�~&�0�ܚ��N&u���!�ڳ��Z�V(��&�]~������xt��5r�[��q��C�<{�/B�A���h���%0<�=y+~����Lg�7L�BG���尹�b6 {�$R�G�K��u��e��i�Ɏo׳��g��2F"yA=�V����j���`x��3�Q�@��_���d%��������H�H���R�Q$hLK��L�R(�3\.�������e�TZ퀳�Z�|5/[��L���B$��Q����B~l����hPJMɡH�8��	��F��1}ٝ�Y����E�䒬}�TJ�'��e�    �!<��Y�������P0�8��� \�?O+���(�L��a㑡vB��&���S��¨( ��dn���A=��ɽI�D2F�;�+#q���ABV�࡯�t{h�5��"��$��Se(���(�a�[F�\{$��@�K��Ut:$��DԞ�!�8&#6�g�1�H�z(\�ThjK�_ܒקʖ����`���B�����O o"'�&��$1 �1H�Z������I#,�/+
�X~p]0xH�K��>89�����x�K�ʘ�5B_�/������.d����K���T�W��z���<�cx���6��)t�gOdg9G��
tS�/�i���n�Ԛ�bS%T�qǳ�L�/ȫ_��U�x��PVӉs�	�3�.�&���-G�G��\|O��n��(��9H@q�7�r�`�ɽxQ쾈@���OQs��op�S<�2�5����ܭ���*+�)?c��!�����ucv����u�V�I��<���|鯵cH����������;�g����K���0��l�E^p�K��R���o�?�߅�	gw�T���m��ӛ��?�ӎ���C��#@VO��ֳ��+j��'1�1Zwҧ5L^���f�J��������|�U�-�F6�c����Nqz��ڑ�	ԘV�<W2ǔ>Q�݌r����������7�� z�4�"+�|�L��b�O�r��c\���F����h���� � �����&�v6�p$g�X�����g�0~cC�uӾ��߉l��z�}p	�|����5���3���.�B ڳ�bF�8)����:�N{��{T�}���X�:b�~m�Un�~�k-���~�XCQ�x�,lgtqw�kB�kO$������^�]�c�߾R�z���R���Q+/h�b���ŭg�~���z-0Z�}l;
����������j��A�,6尘K=?��i[I���_�*ިE�5C������չ���1�Zl��s�aڕb�[�`��|�$�*m��m���a�HS I$zƱ3+E��2���mY���:d���V�T�x�/gk��os�m��g�e���+�*��M}rvr��~���(��Iy�j4_�Q���<�S��Ѝ� �����҅��o��i��+�9XtE&v3V�Ș��w��?�v]���ӫ(��Cu�/��7E^]e<�i/hA����ɝ�r�Uq�h���С�nx:�8[����$�m)�꠬�'i��ߋ���\�>��}��~�!�y���,��	���ˏ���7��Zb�<��o��/#
-˖<xG��S�Z�R�r:�+���~�����e��ά�h�nq��՜I�s�sxv�\���+������.Yf#��& e�]���[����� }��+�e@a ��MȐd��EYe����h�mЦ5�\�bMI�����~��wn"Xk�Sj�R��Q'��)jh��P�8�e�5��E�Ѽ&�2�	D���9-�ր�g,���m����E!Oxx��w9��7Gǃ=z�=~(Ś�߆W�!5%v�S�sЊz��y��Zr�O���~�u�\QE� =+���os�Ty�t���j C*��b�*4(:��{\���y�.I׹^�㺗ǃӃ���f�7�R6�R/Z�y]���7N�|���9
osz�J�)�����F����]Ú�����?O�ᢳ$]�r� �q���ή*��}Z�4�s�����q)��۞LjO�~]���j��ڙ_���pmox�Fы|������Y ���f+���?���C�׾�DXQ�Hȑ��zg��$��Fg!��Y1_-V�C'}>H���&#HMO�W�Z{Q*pQg{�n,�u� ��N��h7��~���&\�V]-�+�2LJ1���6Zp����Z���U`A�$GI��Ln9(����w��v�`��y��z6����h48|���d�K�{Q?ٞ|�=W�K?IVք2�n�("6O�}�M͕"���s�NC���;�9��-����i������"�Aý���	R�a����]_��/�;~H(�7��X�g�� W=��Id�d�unx��o������9v���E��6�>�^Z��6��<�(���1?]�LIS��3��:�����':M"+k
��� ��wW��W{�n��gC���p���%����h�|��q��G(���&�E
-S��k�P�Ty �V7���������l��0��B�s]�=A�	"���"{�Aӳ�3��,�g��:�c{�U�u�&&��Ք{W�P��$��I�q�2���j����zor�b9�����5��?8�蜔�ǫL��e�d�b%	�3�z0� :�v_^��R�`���J'�������s�Y�X�=�0�
�[Z��g�4Bsi�i��0�w
�/!�_�P��o��t(����U7�]VcZ:(��:����Utݼ��J̽䶷���y��p������r���.=����[/��K�00�t�[�/�+9�:M��2ZSJλJ�9����c93{��;��2;{�Η�%׻�֏;���۳�j�Wk2�$�"�鼇�X�"�?���y�-��'ZSo=�d��	*����@�5�x	Ķ�P��_�V4:<�aحM�IK��h/�mT11a]a"&��~ DT$Q��*��̬�_(S�+LZ+��y1���3�Ł���p%�$<�g״�/�g�3*rMf@�ۥ���.�m�:q[{��#�����N�ޭx
��r��beh!����h���{p����!�S����&k8�i�$$��5zWTr�N2`��t^��ogE���$xm�ǔe:�F���,-/r����w�g���!]7%��P�I6#��[7��#�$��K����knWt3Ea�p�	�a#����8�Ws������Ik�DM.�./Ю6$7��?=�ߣ�\�����.ı���n7?_�<��+i��(�^���VŒB��Bf�l�b�D:gL�EZ�y3ޅTǼZ%����Z�4�Л�]��4��:�5���sє���dW�n��Y�S��n�ڂ�}9J虔bB��� �b#�
���{6j2��F�j���Ս��b&�L`���:`b��Ӥ�Q}���و�(��e����!�,q`�0�_�މB��G������yƊ���9Z,�*k��E�h��M�]A5٪���6-����vI��Ֆ�}������bp��ٖ�f�-��ڒ9���BSS1�*A&mOP&)1��so��W�ʫy�$����!S ?��s�������s28x�����ȅ"'Ez�	���B@�	.<�舷0Á2�	��@���P\�1!Ű:�Z�El���x�m^����F�N�͚P�w�@'7T
z��M�Htј=H�u2Z``�3�>�c�E�S{�/Jv��vE���a錧��b|e�R����<{>8}�UN�>En�9�N�4+��!I�L��QL�7����R��\3&~��A�(��{��V��R�FwpԬ0�s�!�˯qM�~���=\�Ȧ0�3l	VvI|�X�m�)�tJ4<�͍|�0݀�==Ĩ/| D�OO��IhSx1��~��v������^@�(ޒ1A�&q�Ғ�L��(���0�Y��t�JWSr;F�pe��:�ZX:�4����A!Lj9!ՙ��o.� ������.�*�X&����t$�ܢDL/�黌!���
��Ms���X���/��5<\ɫ�x8�L� ���-�vA�d����WU�}�]X�����3�.O���u���~Ͼ6�d�r���^�ׅ��`�aRU5�%�uq?��~�	qǃ���4�`:&ӧ^�)97��!a䧁�?�v�7��������椵^�;.�HVι߭�h9�a����R۽����lz��q ����W�㣃�o�?��L���a5���κW2��u������7�W@�U1�6���Z�Duu�If�����O�!�|�/���}�����/�ә{���mt�<ɴ˃��4��.�9�ԏH��m�_    �h�DBq�����;���s�vjZ;�;�6�͒ �����	KGmK߀�~>�>lݲ)-�e�֐��#�O}L�jˆI������KX2nY��}霖EU����#��;�����-��yn�4��h�A�Qx^,�#<��ve� 6�z��1������e|���4�dS�C���_2�=FOZFoΣ-�^!:e�՛��� �Oı�~3�&��X�i˔Mi�C��l۞|���9��D��o�j�}��j��_���۲�>��n�K�3N�nE�5��8��ִ`���p]���\nF��C=2�1��G~|[H�n0��������!�
'�&�I��ǞOm`t�J_�O�ҤzWW�?�f{��Q����T�9e����p0���s"?�ᘀ� ���c��秿5�E�{L��>5���D��`�i�E�&3�����s������f�'1�
�[E��z24@ǉ���z�}ѡ�:Js�,�e9ɯ3�8���(��d�����?K��Շ������S�/� ��QVRJ���5�iI�@��!��<!����C���u,vW�@{{����byAd�m���	?�<r�U+�א�Si9����S���] ��k��b��3��x��;r�Qj�d�卥��y�y*u����r@��W2gшjC��%��'>���&�NtV�p�#�~�EF�b�z^xª�U�V2���_�/�������F��)���x�<����Fb��M]c�7	S<����b���19,�U�X�Ն����I�����0��#6�g��'ٮ��B�����	�U�nvg��U�z;dAI�^W�L�b�f8�2xj�d'/���}�_�y{v�?lNlD-�����/d�d��sL��Q)��\	ú�4��3��eU�X���MQe��N�o.�FG��h�6�	�0da�#H��(f��ṑ��{�4�8T���t�[陂I+��mf8�^'c/eu����We�W�bњY2��/�N�W�|/��6x�PN�/��/�����Q-nTw�%�&qJT���R�k������m8�n����T:�����]�*�S�Faغ�ݘ����6ā�~�m祽��PN���:���yU��(��1������N����hp�͓G]~�^�P��7��4Z'��n|@����]�4�;!	ܦ
�o����,�wv�sA(F>�=+��ꛛ��tek�9
:�T/ �L���"�zWe+r�������&_����SG7���<~3tF���o��E����+�P���~�{Xd�a�G�:�y#�v��o�-3+�D��~R,n��ʖئ\��|�O
twX|R�2�A6�oA�vW,0՜<�p��t�N<f�Q�*.%��Z�AGt���i��Q��Y�@Y1�(#���qْ��t��F��Ql�`C҈m|���8/Y 77�|{l�[�էK&�u��~��|ul�-s�-����9�o^=�k�~�����7����W!�%�a�E�MG>���isΤA��_����q���þ>w^O��[�8e�/|��kt[�xS:��wd]��cf���	3���آ��`ı��Q�V`�um�lv��e=��g��G��dpt����bMy
�� #;w
B?1���>o�~���:���Ҩe�y�8���=�s\���f�o�?z�;�F��k�7�N�@��{�����iB��d�Z�6�w�r̃�*ý0Ő+�(��>�.�n�~0x98>>s���	�l4ͤO�����ڌL�Z�/�dV퐻482��!����W-�ʣN�h�-X0��S:�i͖�������BX�px�^�#�ݤ�(͉|���$��V�5�p)��i�$�;g	X�B�˲��e�������i�1B
���TC2�. L�Bv&��]���;l�l�Rخ�Oe:`�L\W�dq�h�?i�?�n�$7���O��O��0��&���r�P
s�׍T�j+��P1�j��j��g�amR�M������1�j[Cˋ�<;�I��d��݆xK	%� zqpx�'�݉�3}��:��DX� �)������&-����������P�;'I��&��3�U˧<�QTP�`7�����ւ��2�m�y�Mۉty>��Y�5 �g�IJ�E��P�|�o���9:(<���v��jMz�w�����EJ�0Q�y�� P�Z��A��c.�_�;]�x��.�@��gÞ�_����/Q�����q�<�$\c��gz���me�6ˮ��?��h��LΗ�^���!I�0=f�J��
W<`�
z4tL�g`f�I��A��*����`�dg؊��8KE!c�����Q���X�a,��Y�~m�%'�h�8BU��X��Q���9>m!�E&r�L�����$ �d�ѵ���$�^�A��'Q��<�Ȩ�}rv|���Yk�
��B#(�l,�/D�#����e�_��	7|��L��X����qmrU�݉}759̓��?m�/a�H����7�
��E.ׂn7؁�.��&�!iԎq��/�ҝ�
�J9%������d��|՚Z���,��bΒZkj2}@������eFV�^�z�9�����O���;�p��5�ې�����j��֮!��ߦ��+���]A�(45�jLjȦ������r��&"�+�c�_�wqV��.�^�C��ٞY6-��D��K_h-�����2�(�ZB(��%�&���h	���RJ&e�ZZT�sI�ˋeR�����e��⇡��mPɀ0�+�*~q%�GF���DA�1u��r�,f��Rj5�sG�	�fټf��֭���C���ʹ|$��M����xG���ü����oRБB�wւ v�VOS����9~�4i��}���DZ������I���g������kZ�s�(��ʖ�r�]���^�:��>�R��C���*M�*����&��Q��S�Z����ۚ˿g��)��6�Gy�f�5M���M�(u�FI(�K�3j�9���=��j|���_�[a��xR�Z�X���{5�(���4|W���i9�NP<�d�(�}��+yE��[�q^����(#y;���t..����E�כ�'-�g�fZ�Zp5�aݓ���-];�kC��v��˜��t�i�(�5]΄颧1��5]��l�ﭛ�7͘�>3�Ql�1~3�B�MFah:�{�9x=8=|z���/���8��;|�
��
h�W�l�wײ�b�Ц_��d*�V��t��Px�*K:H+�Y�"���� %*M'���VR�T�${�"�����s��}欜�R}�B�l�0�qy�K9s�[�d?��CM݄�ҡ��U^hV<.��Q�~�w�%�Nlϯ��̳�<_��Ϧ׸ͷ��_��z*<��4�c�m�^jo%]�@Xx�;�P�}�b �㧏S<�b\�@��ޞ��K�=������(bqͶ���L����¥P��r�tu�1����J :�S��ke�GB�����0�)��X������\��ջ �Ğ��:�QFS0��,z�.}z�f����4�';���+J��=���!���]lÖ�Ҩ�f�o�7+�f��m^�5�a
��c:Vw�?R�z������ԫ��Uc�k��->)(c�g0�1���*DnEWE�=�ppL�z=_�<�+�����'������`��q���5x���qk?�3���)
��ǽWdK����8�M�'���@ૉѬIA�zaP|(�X�v����I�¥w<�X��|�/�]ֈ��r��}yǥ�E�=i-[6�WA�~5E��G3:@�ђ���3����U&�������j�u��\��99t�̷jh:.��[5����V���oU�VK�IG�n^W�b�p���'Y77
�P�Ь� � n�80d��Ttf�-�q��ˀ��i�
�e4��	rSfJ��k�<�q�#4tzM~b ��(�F���+]k�_�d��3�*atIQ���� ��*�o%�Kh��{�o:=���Va���?;ޞ�p�G��n�
F��@9]I�V$����    �Ŏ�V2�]}�2�ޒ	���yw�����R�ry�WWYoc���U}������A�t�P�!��\��������P>���	�PD{x�=<�{Y����x���T�{��q�
܋�00A�n�B�V����r����Pɳ�k�Ҝ=����`���k��[��&����dYZ��=<������N���\��e�k���Y��n״I�6�|���q"|c�8v=s<5h]LU�\�Y�6��lxѦ+���t�&��,O!��#y��i:MU�N5�gٲ �S7�h͡�|�,����a�u��D��d��V��[fm�9�jM�Kk'��&�4$��i#����z�_�Y ��F����]���9�xA�a`��<�������hZ[yQ�^�O���_�G�T	�@���c�њ��F= )�(y�=Ľ��=R ��q�����:���R��ⓜ5��B�Pl�[�.@B8��9��
��}����!)�L���b��;�*f*�w�q5d��)�8���M�Še�9�&cV-��N�G��:<V�����>��-�:Q��9<��i�ϋ��&��X~t�<�9�y6�1��G��8�������a��MBhi�Z��	��qlt�@��cf�OM���`o@G�1�1]��2�Z���}���ͼiOC?p\.��M+4ey��B�){X��׿&� �WK�E�b�b'��:_h�H��L��Џx[��Hg�a���PO���ݓO���v��V=��ᎂ��������Jh�R��Y��µ�3�]x|D�X�|�J���o���p,ꆵS�X�e��(v��~pS�BΜ�|�@j�5��o��@ʥx�*��jh���L���[�⚣w�]�-��z�\��h1�KΠ�}��ҋ�|�̖`H�l���l��Ճ����!�Б�C�HI���Xa���ݚWS�] 4��{M��������-��������h��*0�鶩�ٶ��:x1Sg��^�Oى�}� �4~����	0	���z��6�5P-��c�XYvN?p��Fr�w"�~�m���kdK�o�v^�h��\ߖ�ah4��@<������Ɉ�5�,�yI�v�� ���<n�&�q��^��	��;�nJ�U�ۮs�lI�X�P�����q���%Kl,��?,���:�,��f�K{��Йȣ�;�{{tz���m�p����Uý�g�{��+��v�Z\�݂�6>,��1��%mK�C��et&��P5_����u𥧶;3��1�I��aL�\�B���x,x	����@�0�ޯ��eӟ�E�����l��
��b�S�b(G*gHȗ�ps�q�<V�D{yz�&+�����t�F�E{�u����A+[P��ԭ� 4�4�[���A�x�2����=���{���6�/��:#�֞��Rްj��"��X���(E�� <�ش����Kxs\{Y6y,�?砜d�;��UV`�.t�/#�K������D�>�:M�]�S�v�?�k��Y��� ��DF��Y��z�_2���)�eL �:��?§א��H���Bu�Y.Yݫ��Nv��|=����ʔ��,���T��&rQ9�E6�ӎ�i�E�s�b|eg��9K���W�@�99:x=<v�]����k�Ҧ�������f���3�7y��iD>D��М����u�%����2_��i�xC��\�:��S����|~]���]���Sz4<}��3'��D���������z��(�=l�/��t���Ӣft�+��6>;���~�b��g�$)����~��N��1�C�E(����;>�1R3�r�8�*@��Ϯ�"c�3f����wЭ���<�c�i�;{Ps�D�!�A�|������$��xKVF/�yD�?�����S�ٹt����
*���d~]��猔@LS��o�.������Z-�^"�N��U��
��ۢ쐭:�,�vΕ,B�p7�l48흅�쪡d<��� @��5V0�E{�6:��=�ĕO�_���_����FJ)�9�o��O��`��4��,#
��5�{���{â�̩��5PǞ��oOC�p�"Ww��O�F}���+����JɦHZ�T
�� LE��\?N�-�!vl�m��X�4dl�<�7ꥌ2_��&P�����ԧ$��
{�}��=[�%�if�^����C����k�2���10~ܬi7L|Kw�b?M�X�5p1�U5ɑ�(�	s��Ɇp���E6�� �E/�
������P0����"ʵ4�C��ޯ2By#vSnE-V5)�s�*G<rxƯ��+�rcVga�x1P	f��	���B�o�-2���3p��Ï�W�~ʸgQ���	�l�(6�$����6$f��E��u�_�m��b�BvY��Y�}�Eְ�|Ŵ���Zfc��@�춦�Q�L��x��X-1�dR�|����5��z�Q��P�������5�Z����_No��8�f�+��9���/4��A� �r�.��Mw���u�v�-KEE�3Uw��)l:-ɂ�dqk~��X,A��>�βj'���P�̧%�(������K��>����[T~������V��RV���!��؛��+V����$�ʞ�����p}�I�����O~�������<�O3��������0�s�[]rz>I^ȇ�{{ұd�1~�h�����%��}��-{ֳ �͙*s�G��A�Rرl�>I��w��ſ��Z��{I'uɉ�JߒiQ��2���F!�Ԍ?E�ҙ�P���6���K,״e�z�ۉ권�#�F�)u�;ص�7�P����bFp�!��Ҩ��X�����H_�gŒ�_���hY��'5����w��I�W2�<M��[S,H�R:^Mɪ�l�/�"�m_D*�=c*��&�E�1��1������#�Vɋ��4�k�ޡӶ�´�XM7��T�z��WS]�4�TkTbǐ���q���0�"�'�t��Ĳ�G�W�j��_ֆ���h+iCو�Ox��LS
���M�4����E.;�T	�9�5˩�����S������L�nr���%Sah�:)�Ƣ��v�N���0�	�閉��D���d�\s�	�����2�JY�R?$�}uv|�&����"z�����% F_��Mq��h�����h�lq_�N����� h�ߢ���>�L��D",k�����__ͯ3禘N;��w��L���'��)*퐡zdj��������?u�&� ��`$ΌA�՘���xa�@��0e��
�|i��}���$Ik�GF�ľ�)����cJi���^���
�eҨ�5��Ȑ�����~��-�I���M��i���9*M�:7���ʾ��̣R�@�����1gW�
i�__Y*n���������o[:��;|�KG��QĞ�n��AW��{W�Wwu�ѓHex���ִK��A�a�O2]�w�D�\s��:D��M�K��hL���_ W�]˒�h�31il�TD]�R2m�t�G�|�/a[��U%��������l�|tv��s��Y"^���S�ՙ8	<����|lx��n��]��Ce��z�xs9}w����p���y��h�*g�u7�ӕ�v;���W:���n|�Fj�&^�A[	BC�C�7�V�������j70b�ҍJʈ��UM�����8]L��/W��>:{9]:'g����O/S`�{/\���H���A�F���W[F&�Ӏ����'+J{�{��ޜ����,��^�ﷱ�֯Z�Uk���tF�b
�Jp�c���y�/ W�C۠�"_L1��}{ۑ�ڞ`8�E�#JeT23�Ī:ͪ��i��z,O�>�TL0�M����M�y����ٙ60��;�m�cnn-o��^�J�B�\�U�H]?
ͪ#�V�k��X��mEH����;:�j��zrfkf�:����'�8�;�I:�Z5���&;�Xb[om��S��Q B�9
|2m+��0���~C�L_�L�O��D)U@)��e�z����zD[��R��P����S���I2_y��c>f[G�sґ���%���E�G��|κK`<ѣ�m�N�r���/��\�    �"���qх�(�Ю�/°��뉑����cu��K��x�hv���(�L����PD'M�v����lw�v�aV���ShZ>ݞ��Ħݻ�[������f�ݍD(jk'I��l`"4�Y����NQ3��,�#��^CQU����ή$��U��rZ�|���@�j��}�%K*��Ռ�+�o$���${�A���u�w2��z�W5�f���J��յ�$8��Y8�|l:0	zb�8�|�{*ҫ�����(9ֹ���_ȓ��b	�h�v5�(6�tn1�w.Y}�s�H9gAn�1@.���FcK.���N��P��oAi�Z�ȗ3fnO�gk�6��ʝ�C���"��s�禡�/�w#!_�6���K�
��)�7%W�(U�7v]6˪kEEg�$3������,��mAI�sPNqF:]b�G2gl�|�&^C$D�BG�[��d~�Z�&�[�*ǧ8���(Q��U,��:��3���8�����qtT����A���,g�S8�(�E{J�.Ym0P=��~,?d�K�i���������oK|�5n����sJ�Ɋ������@��� �;�����bt���%^k���v73z{v|08}�E#��Ȍ�0覘�0n|���R�t��٥�ι�
���fvW�������O_��(~A��4��_E�I�>}��\�v��yŇۻ��b�r����WU���:���h�����י !Mȗ�'0��Q�G����}aS��ݐ�����	����S��Js[;S0@GV�A�q��jVL�gi-w&L0�������R���+ryu��C�m��,\�z9� �&���ܧ�08�8gG�:ۛvP�<� 2�z^�ԎSZ�&�Sﲶ�9�	�7dߙg���B�b �ƺ��C� �p���L)u/$CF6���a�-�i�[Y2i5B_�[gǮ��n�W&b���=��}��aN)���>U�Vuk]Ɩ�Y��Xc��K�ǲ9�yv����cb��S<6�>�[�crd;�68���~�a�`�� �R7�!&�M��^kH!W},�5�k�`��[ۢ�����3K�7�=������[ަw�+C~��Nl]�h�@A����	��h�@�D8�����˴���ؙ\ЫHm0�e!�ͪ�V�p������T��`4 �����펍͕��ms�ԍ���_�Acl��#f�v�9�����c%�iP۸���ui�.��Go���Ĕ�iM� �m�gJ�b��2OnZ5XZw�j�:˨�B��-��ա�#&LS_��f%+T�����T]��V��x�)�	x����!�u9:z;<]7h�Ɉ���HBF|Z6ty�$Fr(p��Y҄ҏ|5��4��߯��[書�V�L�^m�*��]���4�\/��� 6�X->�7�u����.��k���L���qH�Ό�܁�`BZo)����a���-�`�(I����7�f(.Q�a�'F~B��9l@�UU��w�������o�Q�ik�Ӝ��y�>":����x�j����,Ĭ^��ᨨ�3��8-ҝ��n2#co:UM���ǫu&��44���mYc�ҥE�9y.>�u����[쇿i}�.����´�Z�yI�ռ�P[�P�/���y������冣���7O�	����1�Fo�������h��r�+x!'ƤfS������P�,�&�sMQW�lr'%�b�M�es,���2߉B�/�<�UW���r�,���i7��..�h�<��	D�p;����҆KBI@Ʉ�D.E}Ӳ��3@��0��JR\�k���h��k���S�����E�lW3�̹���=Lig�5,�7�[.�ʞ���pH)���V���]t������~�o��������s=��0���+�"������6��Z�2��R)��򟻠0�J�'�����g���:�h�J�Y��nθE�}���>��y�%=�B3�t+.\Kj<��G�*R�� ���O�+,	E�~�+�z/���8��B@_��;%o_�gԊ>�o��Ep������4��4�h���iҚg��O�J跂�d�~-I��J�e��e�wJ���)��}���X���U������cn�U��d�u��+wW.v�-n���Ec|@�+�����'c�K6�����<�Wewx2��W�U���4Qc��L!29>���*������I���}h�s4����.ϜS���"/+�d
IS��J��q�0�`2K�}2�WOfY�7������Ǫ�U�lO���`��4Jc%a�(�2��� ����ìx�!
aa��v��8���,Sl����D�/������4^�"H�5X��'SŘx���/�iǭ���lD������(>{WV�l0�a���������U[S������ƊHMщ�,�(��I�?$���a.�MV��������E��yy<8=8�S\o{����Ã���ӽ���[Ȣ���NO�HǀV5	�T�47�������p�4���f�(:Z��?��L�*h��̌�}qY�m�Ɛ��4�&�3
Jk
�6�)�IyU�dIKD`P6Z1O�Wv?��\��:�=�Lo��
UAWdz����$�����Ɯ/��V|h���s}ؓ�=ׅ��¤�uid�"�[w]��t�-�k��]�L�(W�~����F�[A�&F��K��HBǤkj��fE��;�]W����t<�>x�]P�7pFG�[��&��t�R��7~�=<�]�ӗYF�IF�۔ކ1{�:��n���~�� ���0^Go��7o�^�R��?��&��!6����������=��R*y��(�bJ�) �Ӛ�S-n�5�\��z�c���-/n�$�Q,�u��Z�'����1�ҏ\�"M��pS5���I:(8�i9��$?�dz�{����N_�ʉm�l��"�pۺ䓞��ZS�a*��v�N���*�af%o�Ԩ��Uj����w;��H�\��?������b$ûR�W.K�Cu�}�*�d�q�wQ��o�X%��Γ2F�z5_�hi������v��Z�z�e������FTAُ�����ٓ]�B�LP�1�;�>?uc/��-Z�-hp��b;P��o�k;Bd��S����ݺ�#aAz�����>��5s`�ci�g�4�4�li�&���ը�4�Qv���Y��i�l����l:Y}�X4#�E�Wo��Ύ���hp��mӓ��Ӻ\^��LxqD�a�㎶�~�-�����������u���a��o��۾j�ƾ@|TP����ٝ|DG�Wg��m����6x4��k���	�4�/��=Գ�{����"�w���>�+.J3�T'z�ij���P,E5����Uljd��g1��[(ٱ�}I�ȹDd7���6�i��W]�6��1�j�xPco�Ռ���j��D�h��)@�>�O(��.�"4 �@qA���^�!�i��Q������1���枾2�w�⯧�!�b�+Ǌw5��Ņߣ�!N�8�M^v>�;�]��ًq�|}����Y��kp�?�[(^Іq��nBwJҞ�M �QbN��.��o+:�+�c�+�� O'�N�x:(El
�E6�8�?�`�	��E��&��vZ.Y�g�uP�n��JH����)�J=W<-U���5ZJ��� �f����G���^�eKI��WX,�!pH=�=8��I_�^r�8�>�!W��jZv���hǑ�1����$�[�c���f=7��s�V��{��#���t�� G˦��7��G����u#�牨���[���!q�����վ9|ȹ�\n���s�lV�E��Y�������t�����l�M�­�;��4���-"�E5QyXŽ�o���Bd�b�%o�d�U�+I�yX�~���(��B�	���ڣ��ۘ��Y�S�$�i�L�7�kDh�|Z�us���=��W�5E�T@����%���P;��lF�w|�u"�ћ��Z+�����	{�-G�ॉ�&���� 4e.� ��/r��,ׅP�f_��)R�|[�Ļ)�j8�����8�,���5��    Z��F\<�U�ᆛ����-o�E^]�&KQ�t֨Kr�љ`J�����ɩT���0r�l��88����gT�9�yD��k���wWPM��H:�.r�M6���c�Q�8j���I�j�������>����¼;��z���^7߼98���6�nD b�y�H\��a��y���FI�������fb�pH�n�!� A���m�[n�]�-��P<k��#5�ߔ�nz���η�����
�~٤_��������p]�a�^q��}�s�El�����bҔ�*��.�tz�`�u�2���e�x�]S���CF6�0Rq�a��ڐ���T�����+��C+�醆��i��iՔ����ܤ���>��ɹ�FAǺ-}�0�1��k:�f�=�@�9���?��ɓi���G�2�Ig�N�1)7���[�g\ol��)�b:�)}y!�#`��`pqt|<�9��c��h�r���|��NPw��m� 6�5�C��7A�w�WAK�jj-\,T�<�0(L����I	��ҤB�@�g�n�fуb0��M�l�Tڅ��{��-!mm/2�ժ�M%�%9��<��[��s�o��۷t8h�PJV�5�᜖*m�˲*M���Z�9w���:�8���G�oPZA�,��@����C@�3*��v>��/�3�g��Gױy$D]�>�0���ҍ
��Y��1i ~4G���T�X���ד�^�2ہ�G��K1���h�	�4�*p�)0��r�p���~@]#:��� �&��Εe��8I�w��Iu�<j蜠n��n��
úθ�%_��i��}��:z���-����#:H��%�bk�x}9�g���8���8��8�9N}W�7�x�v6aZ����YPT���~�6�&�p�e�㣵���։�ʪ﹑+b��UՉ]C�7��ogO�n�o5?�>��D�^� ��]�<;I�7v}J�D�bœv����
���߶S��u�f|~ch�T�&�Uɍ��3
�n���ïۭ}���Y9E�lhX�p7��zΙ�W�&�}G[F4��I�oe׷�:[�,$s��n3TŦ���5���^��m��xa��� �D��Z�nR���f"�K�ǽ�Ca���ْ(�JǼz��@?9U�6h��m�p��u� hq��OS&��@y�u�*Oֿ��rϚ�/�[β*J ��uO��Lꤖ z���+٣'�N�����ȗ� ����苣�:��MV��HQ�yn`Y��Jp�dU��M����Q`b�\g?�9x���-%u7G6���<=;?[Gس�r�n� EET}�^�È��˔x�jSM�L��U��
�ټ��j�祩h�p��n�׃�Q�M#{S��ZKA:�y|�}�	�l@e*=c�<^�*3TsdR/���酢<Q@@M2����NSe��YM
t�a�u�8#ҡ��R��5aX"
�|����9Ƙ9ɡQΧXV��;v���ъE�Dzj6w_�bk9�7�
)�K�^��n�!Uu=Jh�C�$g8�p8�G��n�Q � )H�6-�B���D�z��JfLD4V#8�26�uӪ�44���?Q������ ȵ(�����h'|�C
ؘ-��R\����S�;��X�C�mȟ��C����tୡW;W��ټ.���O�H�~��9�pq��EA	�1�01�rI�w5���Y�&xwU�����M�����m�_�X�F�q$>��p�eEJ�49!�µ��M��^ώ�C�/뵗�u��e��]���a?u�w�뻆��?Ϣ�o~�DU�6[M���2�	q�N��`-��f# W���0�n�D �k���Z�Q�����0M^�5[6WqU �z �&�'�h=ר��ր�#�Z��eW+�;�n�6��@����=Z��u��M�x��� �fC^��>W��U�P匈?��N�ý���pr�44b�y]� z3��w.JT_�����ߡ;^c���7G��I`�ghUA==v�O�O����ξs�"��>�����M\�܃\<2�-��ӣh	�?���?������?SBĎkW������G���擢jI��, 7@3�%(�	�ՠ����w�:w��:���sp��n��+Z��Žx5�i���OE����6E�rHt˪����dc���������lt���p;'SA�!�^���"�['X�O���j��"O[d��*w&�ޕM�t18}5��uy��atýf�׬��P8q)�f�YW��ײ�ˮuDn�kr��eV)����O׆z��9)(tFg��)<|��uw?D=e�U�6��B6�3 im�(گ|U�r�_���R"�ĎOB��l�Y�Y<��
�)Ɇ�B!�Kb�_N)D������$���6�V�l����Iѡ�zf�W�����#��6��ק�ucߨ4�C��5���ݣQ<��.�����͍�� �Ä�Q�~d0!RH�g�'��bi�σ�o�	��8��Z�N����OWo�1A��Ǿ�I�ĝ �5ڭ�yw.��g�*���s8�#�W�a]��#��j"}�W�+��l,�yD�=�W�R��o[�S:��#���8E�Q�S]I�ȼ4ޣ�g��q��
�I�\�-X�Ҁ�j����b����$|�AЁ�������V,)��G=¬t�1�l�2HH3��?�Ä=e\�;ãQ�ޕ��hˮMW�qOI��ZâA�S�����+b��t���� N:�B!7=�m��g2ְ��@Ѭ>�;�|!-	����i�>�Q�A�\f��XMe���B���4��Q���J����V�i�(��*�M[���l��|2!x�:����q}��:�/�E+r?/zPv��c;�Ԛ^s�B�	��W����y���,�!�	6f�(-��P�l`F^��\�E��Ɵ�L�B���le�]� e/�R4�_UL�8��O9W�L��� ��0�!K@�*��wHD�k ��}�o֬� �z�����`ɪY9/>fsc�Z�Q�j�.9�10���c;fW����9̍U`/���ó��ћm,���"H�Է" ����HJ���D���O+y<�����d��@��l)>q�gw*�7����I�ΛV��Vʭ�l�=������?ԋ���(�#_����` Zx�@Bc ;�/����rJ�.���]�����,��EE��/�</d�^����CG���]��!"-ۏo�.�P�aj����wR���9�{��"G�H��������W_��ntR,q�>�P�[��{{R,�yn�����em��f����P/��9�)T��겔n�Ӂ���٣0���'���1����iHh��*&8T����/E[�܏�콱;�������@����R��	�S�N�!-B4ߎ&|Î}�y����� �h'z'Gg�7?}��VBi����]/�;�
FO,HE�"-��yqm�o�2��	�9;=z��)2_�}���L}`Oz��Bй�&M�H�r����31�&ҷ���ɵ-E���'l����U��w�+|�O�*�3���f7�%�v6�(�5�����;�)�SK���-����1s�qOnLAs��G�%g��M���.�N������cM�d� ~yH�����Ǖ
��\���8����Q���zKL���H=w13�n�q�;d���ǎ}����RF3�e?f5����6�Ë������9��m���b)7\$�Q_Ǣ�B&�=�^dhgM*I�-<�b
7֜��>��g������V�G���q�X<:z�Lq ̀�b���Ɔk�λ
T]XIL�[����[��s\�O�^P���z�����d�*�ǈ�1^���B�(V�\.��f�}���.��韭h��
�ɚ���u�i$�;fک�Y�a�W������y^������[�r���)Lk�ahv��70 �v~ԫ��]<��q�wF9�e$���*b,���R/�A|�n�:���n^��6���(Pv�׹���!f��pv�A_��m':Z�X�s"c���ɨY�(�􎨷HQ�ǾWgA�߼�(��X���O o��oL�R��c�P    F'j6VOݯ{ߺj�|����;�Cm��q�'��k�)� ���`����&vf������n���hH������f�AlY}oߡ?K�5�MI����	'�SH�4�{]�,���ɜ���,�Su[�Kj,�8�~IL��I�7���K����[? ���'D���Fs�b�d��tN�GUC�y\���{��4��4�Qr�)?��xu��\�>�ݨ/�rU��Kh����ތN�@t6�	J�B�&���\�M��Ϛ'�F���UU��Fa6��>�x�8؍X�QZ^x�'�%{i��6�zi�-��C�4��Hޣs�\ ���=J�Gg���T~�v��i̧��L���	d7���Xg�f�zK�˄PN���Pe7M��0�o��e��4�#=�>,Yܠ9,�j3�y.�k����kja>��*l���id�]�n�]�E+>�w^c_�8����+�����pB1�<h*[�۵"L�'a�2�F�H��{��S�d�J�f��$.������ś�5«����K�b]c��{Ib�BO�>�bs��v�|����C�\�i��1d�y&�Ӏ�Pa�~7|_3d���Wկ0v3��-o�Ų�!7F�Qc]��]\��ar��v%���K�k�IIU�J��|�����wz�Ս
Z�\�9�B������.�K�DaLo�H�Y).����%�ޜ�\�Բ��_ISҨ�%�����(�,����s���t)2m�n�*R��mX u�>c����{�ʿ���)ߍW|M-_��V|�y%:��Ϣ#�T4����~�&�$p��lZ�W�lE���ƙT������w8�wN�G�k�s��<�=�!��Ȋ�p�u�@�?�ݬ�AM�g0(�����i&��nq
E�IA����Y�W��) d����u�C�]*���
���亅��w丅b��9l������ʈ4d;$����'�Eb���qM�BD�cg���>�����;eA^R�M�^pho_��p�UG[���������":��o�(j��<o}B�^ށi�v��Y�_xi�Z��u� �F�>�8J�����s_��-7�?�I�3:ݧk�ip���Fk�
7{R�q��
O�E#
��<���l��^�,�V~�Q+��b���C<��#e)J�
ϓ��R#xY�9?:��;]� &ny�c����	rkH{7���ϓ�)dvZ�i�3�� �=�#?F������h�&q
ܚ�E
�6�DcM�@}��K���k��R��6��rguK#�4"�0�R8i4QY`�C�j^\�)�J�P�é3���9�P�w(A-��xُj�e�)L�<r��ߪr���e>|{��ݖՒa�7���Xc_J������E��]�rYdS(�����\n�[��è*��	~E^uY�"�g��k��@��H/n���P���'�&)+�7�{xdΠ%����7bs����5�L�g�u���\tF%剗 <���0�E�x�DŨ������*��j����1�͑�]��q�$��Y@{�ྠd��44�t$�>�)˷N#�볗"��L�6{W~o���k	s�FZ+v��'��k�i-a�.�)k5 �綴|si��e��K|�E�}�Ҳ��>�DQk�V���f�7sg
 ��f��������B��-�F�P�B�S)����龶N��茧����蛼=}{���/\�π ����:�e��k(D�3Ա���ЂY�{u���:[�T�d��r����V��<�t�G;���wY�bS�C9�-3�y�ql-?��3��&l���q�,SQ�m�]���F`�oko,8����z@{*/��.�d�4�V,L�=�L����SB�o�H�9�~1�e�y���~<K��t��'eQO�2�e���2�z��1�#��48�o�1t(�˜� L��9y�G/rkI�W�*��TmY�#���0TU���L�x|m�$�w9�D:u��bL��&ⱖ�#��hp:'y5�'�Y��������M�D"(ǃ��2��ؾ���M:P�gFCc��*��tfudM�}�D_�����/�k�������g�}�@a��m�g�-���M��N���纶�a�k@��rt�vx�f�zè�ԗ}�6�����&Thx�g��]>�T�v[�0lU\���s^�Sz>:�<{���֚qJ�1$H��و)�fʱ�$��?��e��#R�@^�x��8��������}�~�x۟�`+�3}t˅�)r��í���
&�2�H�.+���Z��RfJE���AwVJ��p���jB�Ssn��h-��6>kL�=��{F�Q��ֽ��H����|�-��ln�oώ�[��0	⦽�'6�R���y�lb�F�@T@��C
�>\�O
�:��/U�]KFn��������?8��2a�������q�P}E9S/��+�wFx�Ȧ+�!�+?#��3��-���{d2%�te�_���pE�c�2�̗�N�O��r�z�Jt@��7tSW��B/nWS)$	e�%@���F+$SVsz�ۢ�1?�T�^7\c9�*��P�g!ASX�G���!����ID�C��(Mz�}�5�N�}���c�x����Τ��A�q�.����d+}�@�z.��6�AM\݄b��������H,�z���4^���~�V��q�m�ґ;��D�"rC��7H`}�Kb3�ո�_r�hV�дT���Z�j����=����"`p����������;c{����h,����Z�MR6��ӣ52��E�Q���M�Ћ(t��ȋ�6�Z��R� -�̽(�no/���zA��ڄQ�R���3��
1U�����XU�Kz�1�bK��Ӳ�����G�Λ����hCJ�,"� ��G�s�ۂ��EҲ�	��S��AJ7砫鳀o�hՋ �X�p�$�-�+�r���c���1֯��춓H[��"��k�v��Gr18�8����mD�K��8��*^;�
S��7�'��X�$�GTT��k�йǹjO��|W���`ųi(��1������UGG[��)�Qpp�L�yþ=:=��]P��Ǐ��G������6?y(��&q��QHK��R���/����%����p��0g�_=�5�S§띋�^H�_O8Ǎ�M ö��L닖���J�Y��S٩��~�F�c��N��FE�qba;��g��c��w��3���q,j��b���Hl?5↧W�� �\_�ӟ��7ů$L��Lg�_֘���D�o~�o�K4^�m�@[U
]�R��䷗g�d�6�~I��+�x	K&Yq�ҿ�`�}N)
IE�����'�tF��sSV�.���ݱi������j�?��A6oG��X��6g�����U[|{w>t0���#�qt��������oeO���;��%�W�!	#3s���[f�ƥ��Vq#���hx�w2<ӡ�/엃�h��.t׍�И�OӐ�Je��ԍ�v����k	���w�ꘪN��@�����UWw�w�w��G
�i������h����9���o�4�#��?y�˵�F
E!��B�wB��e��[ms'6�_M�\h����9- ��|w+{!�́F7�,x��q��w݂������޾UX�z�ã�[�*�m�v/���8[Cǔ�"�B/�3fI���M�4�sy�CM�u%��9�Fp8!ܞ$#�g��i#������	<��˂Ρ~����������MB�R�����5c	h�.���bRH8�Yi�ܽN�d��ʯ��|�h�9U����.����J�3�;��f�\V��cd�=�iR�V,Wu�׬����]��\{�Ւ~x��>����۪�%,)#W��ѵ,���w(f)�����;U��W2�3!���r�U��G�"�H�jL{G�2�qw'��S+r���޲TN.u�4�:��l�@J���v�-�i���9��R�{�V��U��G�Z��'��$:3���R��LLw� k}k�X$�
Z�h��Y���Ӄ��O[IA�$$/�z���ݫ�`lI�8LZ�5q��Z����0RV��+��9�`C1�С��a��x�������    3�cWW
�+w�s5�+ј�Q�����E���u@�j�k6�s��y���}��F!#���֙�j�	�����Yn#��D�x�0�6��})*<<��W Q�H*l�z�D��D� 3�U��}�k6cV��E-���zYz�~�{�q��� ��J��5me��p�H��9����;�����.��v]^_�d@b���|��_�]�$�IDX�i=D�"q�s�`�C�mM��n�w��d;Kd�)��h<��'���H6V��	�QθX8�1�p�pi/\���;�tb]h�0�\ѫ_V�P���8 ���[�GV�?#�LJ�2{�E��di��m?1�#�:�fU�D7`zX��Ή��¥����L�-:kֆ޲&�kRE�+�'R�L�]ol6�:]��{�2��?��<]eK�M`�Ԍ� �|C H�{� R��6){~fսĪ�ܶ6#���{�z�ޣ����pu��|Љ{�N��|����ɻw��^�����wasY
c��$D��aV�e�μ�S¶n5�f��=Z�����o�������re;9s�v^��b��oқ�n|�-�k�j[��34���:���>r�#rx��,]�[�Y�fJ,u\n�V�PB���M�}���>�Zw����Ϣ��E��\����.d�����!�:;�Z��\��^����_��`�s���ͧ?:W��f�c��Be��Ӯ(�3t�<���I��m$�H�ݻ�Q"uW"�V�o�~��rA�s��#7"�`	`#������#}��q�1�z��k����K�\7�`�.�~��u�n�9�߹;Y�]p����J�����Iv5�i��u�J#Q��	�����e�EjQ�M s�-r����gk%'yYEl�t]p~���\����u_�'��C��Z�`��
�"v�{@#�D�R����V��P=nv�E<o�֠��)�b���>�����l���kʓ�x<�M���88�O�;̪}jg�t�
C����H�N��(ޒ�x���$���WU�{�}�mev|g �Gu�����I��blz.zg۴�[���Z���d�=-!�ç/�;�}V�c�Z	�ʲ�
9ݾ���Ժ��5�ۣ�2���.�~�%o�S�n{o��)]�ƭ�kM�j��l��/�?d�Ftq�_�V���@����EG%�𞚰�C�\�X�0SU�jc��p^�y�m�g�_��8?�X���������}ިt��R@wa�tUȀ���{ ��`а���/fp�ޢkqϋ2O��u�@�?���H���z����b���^��1,���")���0�Ѣ��
��F|������o��4`1����у lS�t�W�Kۮ��e黁�@�'͊k"�cT�ի��,�"7,�'�X����-(	`��$��ߗ�h��p0x}xh����~.0�a�v�X�%�}nY_�I��u������-`�S��cd.|��L�/G�ip������%	E����S
�I�ծ�{���h��k���w�6���+��>R��n�7�M�[�1+��C>�OX�}�&�y��7x�v<�K���#��s�d,E6e��m�e��;nM�IhEYN�P�u��MAMj��N&J힚�6�`)0[�%�]h��������+t�������Ɏ��~/�0-�Mm��(w;^r�z�lѵ������������qq#��D�	��ʠ0jjO_��ues�Zd�zJ�`X[G�	��[6d�R�c]��%�@��t���R�h^��i�v�Sg��	SU�C����uZ�);_�ue�O~�=��Vj�ˉ��fE5 ����GPF7���G�1ǷI 
^<�U�X%l�d�Qx��� bF�,X_T_�����aJ,�|�r�����X�I(����?������&�\Cd��f��,���j��m{��J�9ө8�ۏ�����ƕ�.��|�=<�bqG$:��O�R/
��"+��)SN�3cd�xbqi�m�h��ץ����G�&x6��S*7����"P`)o�~��R���j�aoW1��;9~��Ҁ���/y�H=�ګt����*��X�����NF�}� PE�2�F�#= �
Lc��8��)�j�P��1���UfLV�w��K�\-���O��s=9����gϠ?X"ڃ��i��B�+�dD.ğ�J{r�V���N�2��~�*������[��l����M���^�C�gO)����.Z���ӑ��UV.`N�{2�0Ru3C����h���"���V����2.h)��K��~�D���<�j��km^�
ֵy���p��;W��x��U���9�?rN����}�q�ތ&��	��}�^�T���I�4nT	WN3+������V��iTryT+��ye�}er���B�X�I6��l�m��+wuW��2m϶M�)�*�s�#ķDBQѹzj�Kc]Π?�M]�� �2�}�%���w�p�1�U����
inL]S�����O@<�*j�|}�jn�BiǧrLt�Ҙ 0��&g�����]�,����^��(�r�Rh�A&�4�]�@9iJ���!fLGaW&����`�`n�䔵��/�p)�R��M2)9���E��n��i��ك#����ș`���� wr�1
�~ ���;[���w����F2�����3�؃���'��Ģ��Jh�K��Y��7��	/M����6?3_���7Y�*�� �ٓD������ti]���XOS0$�M���.{S�=��},K�%�v����~�v�h?����GFj��c�)<a��F/R����W��
���~֒W�eQ�`�������:��#�w�^,�)��D1�S9���:�h��`�[W�u�=��Z�W�A��)�e�a�y.L�i����ù)1�.�ߟ+��㓃�ּDB���j�!�a�s�(�'�B,j>-�?qnx���)"�UM�->�}���=�K쒁>���A��T'�t
����W���ʫf�(�����~}�&�A*�O��dX�1<�[� �J��~�_�C���9���1�0��f�{Ն ����H�U�qw�^(b'�ID�u\UԬ��@p�*�W��4��I��1��cN��*��/���͑aT�έEʝ�a{�uo)��[<�5 ��]������n��~�"��?��� ai��ޛ�K�F�E���.� 7p�Ï ����Z�T4�E��
� �آ��:�I���k*��р����j4����_��`:������p0M'/.f�7����A�d8��^\��ߌ�&0����e?�2�rߠں�ݺAʹ}a�3�AZ|��*KM1��H- ��Y=��%�h*� ����p��)�����4t
M�^C����3��Zl}�}��l�$1v�7���M~Ys���;��M��:>���v|x%=G�E���m
��ff唬�?!o��_�/{}pYM�*	_^�_�!��_`t>}U*E2)�>�ҡⲎ�a�;{n}�F��h�y0��ɐd�<%Z��[T�Ġ?{�0x�G��#�K�)��Pn��Q��1͐~@D�i�o��	�*�,��Tڀe_`ڷ�t2~b�΍^�`_�s���Xʱ$H��	D�v�z�"�9���eN�by�\%`���z��7Mj;.҉�Ȝ�J�-(�Ĵ�s������(8��։���|�^/0i�t�)�M��I��S���kʛ6gdk2+'%bЪ�( K�9��u���<	��zd���W��Y�U*tU���Q[�fS���^`�y�[�b�5�42+���$\����y�֋;�As���ޝPD	+�PB�b.w����N���q���g)w�e��Y9-y)-�e�S*vˢ���ZY�uAa��Z%sZl�k��k-�l��TA���'�'�ϫ�Y�=D�+RR���41�k�<¼|ۜ�2?�=8`�o���YWe�J�Te��p(�_	�-K�W�&En��8>��M%����N�� ǜ��<��������P��O|�.��AV�;^��ɗ�ڷ��	���y����##]:R5�<;��
(�|    8Ά;�CU}Q%�*���NIc|��l콨K"�R���ao��ιޗ�屿�*ܱ��;�}������Ё��3����um���Ԩ�s�؎M�{>t\֯h����W�(C0��XW��5I�H ��/�_�2y�}MB��}�X���J�8��(殘m�j�S�����ڌ?�jK��D���Pm���xz�S����6|_�|�k�����N{�c�Y.19��i��B&I�eֱt�Ϻ�tc~=�A�6Iu8fm�կ��{��K�T���^������$
#�S0�f�	�4ϥ��8�]��x&���g��.�!ǟ�����X�u,�TIZ`O��-T��5���h���`ځQT&��jeʋ�S*d����X>K֝_:�ܔ�Y&߱YSf� ;���Y`�}� �6����U��P��O�.�u5]�A�����]�'�k4$�
��owYL~�z%`���Ώwl��˼Pz�a_��� ��e�x�����L����/�Fb6g"�~�ˠh��e�����(B��R�V���?�����tx� � z#)S��d���0�V1���U2a�������/&���7S��;�H��,�up%:����:���ƪ0�f�S2;i���L[�Hg�EGe�L����Y���G�5�ᒒ�T�o�Jw�`@���k��1�=?Pܷ�Y"���	���̫�dW=�~�I�Y�!,��CcL�ڵ4�>��&p�� ,�q7�B�u�)�OF�ƖGOl�����g��Pk���m���ɘ�OD��1�ܹ����bG5��4�{ۗeS�T�^��9C��G��2��4�|uG��RW�+4�N��;kj���`L�N+���v�hPt6wj�v~Զ���6����ea�`�Τ*� B-�s��@F�-lq����>,yGͳ��H�7޾˝P2���K�[��iA��S�b�Qr�/$�hl�,��*p�J]9�_M���lW&�>_D�1�Pp�O��D�#�Tx�Bj_�Z�|#�Cd'L��1�f�r�{��M�m]���A%�0�EX���])��	��R(
}?�A��{΍�����M���h<����J��Xݿ,
�[�a��I�U*U������߷f�q�2%��y/��S�@�} ɇMnW^��q?̆�ze���νc�2�G�E�Q��p��X��� �j����l�׼���B���Y�*&�� N�,A9��)����/[S {;�.�嫅U���j6z3���rRD�6�������V��|��נ�H"Ϝ|�j��S@�GT�%��h0MvP���%:aHUI�
�N�pav>\M�\?����5Qm�iy��2�fX�b:��r��t���%�ݐPi�~�Z�H����$R�k6���f��{ꁄ��N/�w�������&�4Y�@�\E�tX'�`�^ԤH(	̘G5���V�Qf���̈́�$��uݪ�ܷm�������<\;7��J��D0�H��u|���[��p��0���G���?^�j�\���%0�;���-	#ǝ�đ<8JO�=�,!�)�SԱ(x==����O��DtnۢX��2`�9}M����������Oy�8["�3��e:L+@"�u�=�Ro��5&�zH9��Z���N�Z>�=����^���o��k����Xw�����<����P�-wy&��X�Pův�p6��xx���&j�%�(��w�7ˤ��oY�"{6(�$E�w�˄���r?<��n��b�ɰ�7��N��4Ł�C����M���{��{�:v�4vcئ�i��ND%|h�c=Mo���Ţb>�Q��u��AݜKT�@
}K��Z��^�'۟�s��&63�h�LJX�2�� ��m�1���{v���-\��"��W�T��������فN'n	���D��-���@�-Ƴ�?�Z;����K�bz�s� ;/�F1�l����D�klI����/`��C�Bg:>8�k�O_|������9��)�OB��<���(T�%�8������	/��b�H� ?�y�Z�X�������\��0Tʉ,�(n�&*(q� _��FS����߽˗H�dtU|{�VP��	@�+(���	�+kr�%��
z�"����.@��1�~��aR���*j��#U����܏�W7u�n��J��0��y��H��UE�B���.��b�����n�ԱL����-����}�[�!w��h>~�M��%�r�1���[Q�=��?kan�$f��\���b���&�0i�����'������.�z�IH�yӢ���8��]�����
le��:���
l��'�wȭ�u�6�7�b�~��#�-��| ����-�-"�5F�{�A�a�h�8^���� ڞܟf�$n��e�я��B�<8�07-��4�}7��i0�xA���v�I��E'ͭ�����<�����vE���eRv���ϩ�.��]W����ֱ�������;�fg��>wA
��+����l��@Y�b�bR+��*_�1�h��c����<��]�~N���t�f4�|lj"^���GɎGd��gɪ�zA5�O��6��1E��ܸq`�<>U�I��������P\��fV0||����櫻��H&e������M�X�K�D����x<��<�ޭF�?�Xi�:ݩ`eD)��j��7�����e
�/8i:������Y*Lj5�Vp@aGeC¼����ˠ_�������N�u/,�˸��;.�v�uY�b�++�mԋZh!e�[���םm	�UC�G��1���.d���m�h��ҳ�>�S���aˑ }�pΟ�ߺ�����{��N"G.3_���Gdl.�4{Q�%������ӗ�iD�iJ����)�JA�[���c��!�o��&:����CF<a�f�pb�(ڐ���e������i`��Vڗ#���D|�%��K���V� 5��M�{�m�71�)�?敌�q:ٵ�ym�7�L�UA�PQJ,@(�I»#^<ty�c�*��\�T�VC�p����.�l�G�\s�V�����p�c��|�S�o��r���H1�|tNYh���t|}u�}GZ\@p/%�F`�2�nRh�=#b�%�2ٻ %��`pw�n��w}j�C�%�6���*!pH ��5\��́���f�8������&oxvW` �)�[n
�u?���SX��ǔ�����ҽx���8���`��2���H�^WcÀ��{���k���lMY�[Yg��ni��"�5��������F�d��lޢ}�;��O���{`kE�e�$�+��o�*�2�Ь�.L�bW/���ѧ�#��`NeAc�Gն�2�4*ܪk<�mN���3j�DQkz�/�s5=���1��|�uGg9:�]6IC�N��`6=�^�R	lsH].�\���<Vn�[D���]���+ms3�[C�o�6�����o�W�q0���~��?����JX""�6��Š�b��X��N~ݷO�3"ˤݲ��E��߾EzV��6��|4�L_�:�n�8l���~�ܔ�q�����+�0	��W-c���2x��] ���c�x�tc����;�`��X����s@��p �e����~Y����ȅ����Ԫ���Ҩ�RGRv����vK�sli�|(�6������|�����-�~*��k��CO��ML��6:��☠�`*x�h�����b���oC����%������9��c2�v��n�g�E�+���]�(���V�v��b�n�п[X�@�j����0�������H!�Q���B�����֎V�ݢ�K����~Gކ?�����P�b��l�����UO(�-�h�ж�ق�8��M�ԕ���?��I��a�����n����c�����ƣ]� {9��z"Ѫ֠�e�ៅ��$��sQ�mM�V�{Z�b��n���x�Ʃ󔌜�:������?P�H��YE><0�P�R�ҜL�O���ϑ�}�"	�����<z[,�ӆ��E�Ζw�wEťA�����@||H���/Ɇ�P���q�?��i�    ��
�S��|�f�pV��(m1�Q �0ǩ��M�������L�$y)b�P�l�f�?�:i�<����W��g�Ҿ���Ԧ���#�-V�����U~��|e�anA`xN7�ϝ����OdiG]�����;�4�$;�Φ����q���%Ƽ�p�}��Hv�y�PwSlPdiP�x���-H��c�k��inC����b���`��4]-����:��VpZ�,^ñ9������h8����|l:{���}/�kk8����ã���?���i-�8�^?�}��J\��ų�)�/6�[~��zq����X*��K9A����ʀ�y��0'�s0��E�47��.��/����7&�Ʋ�,脤��΍��'{���&Nˆ�'t���M�PrCa6��N2ŚHN�dÍ.d������tj��#�*����P/�Dn,�K�`�������[��%��e���^��"��s��7S���ߠy9G����i�F�{i!Dd}5���,�T��h�U�K�`n�%V�E��W�W0y#�ܬg罯�����#ƶ�y��`(�.]�D���0'��YS�x7�L�x�-us�u��'��w�*]�y��K�L�sP�p�'>�����uҟ��"Lt���/���/؋j�%5��"�)@HP���Hn^b��������^B't���T$�a�q��M��"j�/��{xD` �ȴF�jhX���9\�;S:eBӶ�f]K!����ӗ�;��>b�d��~���⿭���x1��^���p\̆�?�?�W��Y?����h��������d6�G0P.6��/e�W�����1�G�(�5��_|�zt��/��ԋ�dz���j,\F[��`�;^����!���AJ�U���f��@5�ĺ��l�[����ō�f��H���I0����ë�J���5l`�C*ԡ���8�qY[�_yD��� �[�rc�Y_�pe�-�X��g�e"�;洨m{"=<":��dxX�%������vR��CjN��;x��e��$�'��z��︐{8��i��2��_?|_��aH�+I)%\Ϳ��l:-%�$"��G�T�Ë7�R���iQ�(���q����._�qqEP�!�4��-,A�+��^Vxkn�Ej��-�IMz�zk����gn�n���'� ��AZ7��]� Kރں�8����6�2)������j�]*���ћ�e�Pc�V���%f�" �ӱZ�to#t�D��u/��\��%5�6v �@l��� "��Bn�+pX�jR��������,�,R&:'������_G��Q[�z�=����)qh�SKEx��p�6E���7��x�ĭ�{�7�QV'�C::�� �D�y��ț�H)�>���Y�>�Y���#��(}$r�8�	�#�7��*�)[�]�����V` ~U�eN���Ξ�E����[bLs������*�N�r/oQfL����b�_���ק:�"��_�A�o�߆ւ�=4�0%w�B�G�ϮV���,�089B��Q�g��g�AN�Tao`�u���B�El%���Q0 9���w�Ky���q��g�3�ٳ�
!)��#���>�TK��N�圭�Z���gnh�^?W�?&g�u��%�m$�a�ڙ�Q�\�]%�m:,��z�2�����7U���y,15��AU,��7P�66�U-�*�i�sZ��k)��Q�3=~ן=�m��P�4IpH��!�H�y��H�׽.m�rܯ��9�yq���R�3�IS�0�l�X̻|E^lT�V׀@	u�5�hIQ�l���@%�8��Ȥ�6���*}�2�$�ۖ�]iq�� �֙�@0)��|%��Q��=|��px����xg������t4x}x������a�(��W?����>L��~��ڢz�w�bq��lu�1���PP(��r��lM�u���p��bz����;�\n(	�;�:���{����0B�]o4�A`��r�x��&��m�e�B�#��	.�P� Y�2�4�=8�<������.拷Ya�_���(�Q��ҧ�:Dt�����߫��cR_�1q��\l[�v2P�'9��<������Lk`��]��#[8T�@�y������]Z��UZ��"<��`\OR/M��tG���WpJ��)U�i$5l���q���ڲ���^���9�|��!1�U.7������)���ݢ����Y샰�[d�����&g����0�Y=�����"妛p����SE��/[��mԩ�`U!Y�y���) L�$0��	���r�V�i�A��@Ŷ$9v]�]he]}��=6��Q�ld����h�0�e�=�IaדD�'E]���$nR�&/��ҷ�x�/�O�jo���H�F2�jb�����*U΂�
KM(�� + ��b8���v<l�TeNc%����A�� ]�TƳ;��`���@&��J���lۡ��G��x���-E3(TԺ�f�\Z������:����C��kD?���ٟ�Y���
�>��-��;����_�4@u�f~7�n7Y�Li��ca�{.�i�+���7Q����q�X͟~�
-���4;"�Y<�`6?r��Qm.J}�@��j?`����=�T��]��.�F�����;�u��g��{�n_yY��DۥВ(�U�fS�m�Mi{�_�{ X����@ۢᇥQ��I�� U^0e��.�^̧?�I��+�\Q�n���ub z]�?��_�:�דU��褮�����.�]no���ʨ8����Y0_�<CMVRD��mR���U�_I!wI��V\�I�k}W��ݎVWF���Ҙ')v�,sy������Mq����}z�[�\E�y�{��.d$no_yǾ��u���[� D�/�2'1aa���}�\���0H����<\cA��u(9��Mfr�@�n�u�p�zt#%���L�Eb��%��*��d����U� ���z ��#��*����DW���N�_e|�8��x�L_Oࠂ���o���mը�_~�S��T��$�d"Q�#�0�UE��!��a�S��\�,�)��űMz�
�r���9��yɎͻY�/�?�s՟u�(�M��{F�U��c����^���Q�c��]�<"��� W�G3���mU�I�����ާs
k�eM� �}ny��GW�!�p���_tej����8۝� ���os�@��7X��V��e��r�.'nr��y���M�׌ő�;o��pW^���<<��*�or�(���4�r����H>���?�M|���A�Q�J�?���*�\ۮL�����{��/s��M�'��J�#���(y
Kxa��y	L�JA��KΖ4���q����}M!�/��ٮ�p:�>�$�q!s3�@�4���l�	m���^����Z���.��[8tYP*��s����7g�~���T�y���hR�3	`*��s\v���~�Vo�Ţ�����a�U[��*��+�)a.\�L�F�%�<�}J�i\�uu#Q���|��A���ɺ���r�3�>�k99�����]�X�cL
�V��h�Z��Ƚ]1o%�`�q�����$/��ADJ�8Q`1��z��4��%>���kJ�>�[ũ'w�����'��~�/��)H�w[��$�V6l�$�c8��UV����Y�DI@ձ�/	 ��w9Z�(�V`\��<}����ۮM�F�0�u�^o5�J�	7^	7�*�Z�7e��l8��`ɓUұ�8�e�uܥ�2�v�Y�xdTm#x�*5v$��).�H� &8���@�wnNm|����׊6ې\*=UX,�*Э�����^�%����A�ϓ�	��(�
��<�,�����E�T�C��\S7
�٨��9�Ȏ(nM�V8�ط�
p�H��,�M^���n�ߤ�B����ߥ�X#��x0�"!w�n�9���!�H�`���fR�k{�5ۄ"Ԧ�5���.qX��w�YCQ�]�����Y���{�07��N�R��P�񆔏���g��'��.��
v=f��    s���F������]^������UXΆ;G9Wl��M�Bm��A_˦G�q�+�� 	V��r��ߵ�9��X/�^rK�eq�e���^�-=&���O�Kl�V��86�O�3�N,�n���l��ʽ3�s�E��SK��������)���i�C�G��Ta�#��zC/%�dq"��-�h� f߮�O)�R�%0Q����U���W���դ��c�ً�v6�6����<��X�&�ece��ʧ������HDڹ��	�����e�T��\ذi��ƪFBѳ�+��~�%�r�BWV]�+֣��dثjY^���D?*�)�H'1'ʅ{�*�6+��O�����4##����yY�g�օ0�r��Ǖe~���h̗���rѿ����O��^�6_;������� ��$U&�΅E�W�[k2��Kr1��s��?�siҿVٸ3jxr�.� ;�\9������e|}��\R���L�|mV��P�y��:�4�cn�M�0o����="]/=FE�](2$n�	+�Fx��oW��!�	?F�D�u���=�_�;9�D�����������
�	%�����+C��=��r�з
(?��ۛO<
>�odRgk\�r���Q��b�a�֖��qpn��H�Q0|N�IǍ���?�����F�v��ڱ�'E�y�kd~\7s�n�z�g��2��_J6����՛�Q�.*r�:�^R�t�qi��]җ����b��R.G�`x�]v�?4v�1ĄH��EEQ8�6���pm+l��e+�;�:c��VQ�U��e~�m��.-�S�q/��ëף�Ypy1���*3�*�d]fo�լ�^{E�N�m�����k�~C�lC*%Uj�nF[a��-���!;�I���3����f$��0PUS��wy���:�2��X����&�H �?n�Q	�w0 �/?߈q���u�v�<_U�og�-�k���=�7j*�x����_��r���Ng!wl*)��=�7n�o��@���\<f�:т�W��&v�Go���w�G��aٴOvN9�:�������Zߟ~W��D����8���lY��!�d��#�x\�&}���L=�4�[tow٧}lp���m�c�m�2]��ۂ�?d��.���៳���GMEUy/�_�:��ry>�^��\E�$3���X(�8����䲒ka������_�Mk�K�:|w����]��E���-sL/lZ2fr��/+oS����T�g�����7i�4i	X~B�%��e�2A���``��~�5���eع;���e�(��cQ^2;��_��w(� l��?���a�x��"�]�	�٤il,���${���{�q�;]��<5&��+�dXz��)��0�#�ON��^�v��{�@��'��`;��Ӣ��V/�[��ls;��ȱ�L�������;��e~H]K^dKk��I,�#Uy�?��V >�Sƨ_����w/l�(n6O�٢n�L�3�j�����Ǩ���Ko5]��ŉ�{�6��d�-Q+G�['�����*c��5�2�K}R�
3���t�f�^��s[��� ��z����B��>Ly�����\�%�1�)l %�XΧ�79����U~�)�)p$N�;Q�J��R������ �7RnWe�wY�gԝE��"���]�:o�����4�P�g+��*�bm��B�G~�*�E�-��lB��>/��`1�c�G�˺0�H�6�*/�HQ<�d-�UY�K���V�/\�j�Me�:݀xz��m�z�;�DIҾ� b�-���Xt���1sY��v���j�1��7�l��g�͎��$wϊw�A����Q5�u��N�.O�����ไ� ��Zh�L�!�$a��\����_�7�頋*�M��>�e
�ϰ^�-�ؚ?hn���o����a0���(��vu%�7��:[Q�H����@r�W����E[�n�Iğ#Y�����>�%�q�/�L ���0|����?�`�V����-����`�sS�6�\?��c�ß��*����6���=c��mD��zx2�+��t��g�~0�~0����=W��E�za����&����t���TR���?�|�Q�.؋����.[����xE�K�	~g�o F������s���[ќ�%3U�f׉��_Q���l�M��|a����=�����j��VQ�����R�V�N�\�g\��(�/ӏؓ�:�KX�dϋ�+iNJ�����@�(n�3IG���jq
^���.�d�N��ÿ������y�[�D�+cJa�U�D� V��z�K�&q�\jo������˛l��^���L���h���t6���������GSl�%���l�Нą)���d����?.�E0H�wgVd���`:��!��=@s%9d�0��g�8��|��$�QG���X�{s|Oo��y�Tz������l�?����#��r��&Q�7�X�i��7�k�Łڜ�=~<�-�*xU`Gp2<B�{5�N����?9f�@"%\1%�7�C��򵤋;�kz�����
�`�/�Z��ǣ���:���E�v��$a*ii<o�kW���tu�%��l�x���������=��#�T�w����@F1�-Y�M��KDR�0
�m}z��&+V٦\�������������:0D���CU��R~�$	9�/b E��o|�rq�F�x���ޠ9��3�NG��q�fH��+�u{��ԗ�>Z������ �cD'���N�J	��+��=O�V H�"�f����qN���7��Q��*�W]6�s��i
�=���W,i_bw�T���%�hW�o���ٺ�ҩ��^??�GÙ�w��n��t�LJ)���� S2��:nw�֍�z���vn�~A�Vx��W)6:�_ ������1
Obo ��`]�י4ȕ9k���`SF�\��6=�O����o�q�"��k3�b孨1��+�,2�bҹ7 _;�E[[��$r��[��� Ԙ.��2�����!U��W�=/p&�(�� �!�7��~�Rt'�b�q���I�΂��v��+�U:Ǆ�W��`����U0���^`D�!�ᄡJ3`>#����@��������}pV H-�u˫���|�k����b��D
y�\��%U�Izqy��Ž+J�I1y��@��|�^T,t��7	&����W�$�X�HH�t�ހ�*$�6�I��_���Ƿ|q���dx:��
��l�K�·I͘D{�@����D�7i����"�A�,�*�q�E �� H�.E$	�H��BAr3`>Ï�pg�y�$E�+E���N���kTba�dM�K$��	��8�D�~a�$-�3waL��U��
�A�^�J���7�����@N�� @�{B�b;e5i@�r��N��2�����;�cfӓ�;��_p��k�Ӊ0S�`���v8��d$JW�X�5�}\���2�˂7������h����w�?�[�����^'�{	��5��?I�m}g�I�WyA��ue%Vѕ��l����](��K�>i�ſ���q`��@~�\{؆QɶHu'I��mv�,��aZ���*5|����^?����	�Q�♧��_���N ����w �xUۆ�&�:�%�����o9v��|�qD�{���?�����5%IK�Ȝ��ٺ��$��pзґux����b��FPۂi0^M���Q6ykM~��o��8��o��)Ak�K�M���;ܺ�Y$46��"t'���7�;攖�A:��,����_��v��v��� ��_
4�g�s�m^����4��s
�˟�-(��2`�R�菿{=�T�Yoy�X+jٱ�jꋗ�Ԡ�
Yl��i �[՛l,/aQ�O�c����j��������Y�K�3@��爁]�ux:����\gE0(�A��(�����Cyr�E�P�0XC|̰3�v����tq�y_ 3�� I{��8�A��<Q�$.K#{m�<@FF��[$��7/�p8��#Вӽ/OJ�@������I�:��3i���J�)���׿ۖ    $`�YZ�[��!���pp՟u��3��X[5��k�{c������5 �f�7IQ�����6]��W)���q�����?�*�ӟ��z8������a����	��� �l�Ԏt;�tI�rWZ��zo�����d::���A��+����u8�j�k�I��dF>�7��!��r�u�L[����?���E
����H����h��˙4	�U	�  r�Y�ـ8Bp3,P�> ��`�h���e2m  R�����sk�Sw�����2U坺X�r|���̾��F3���
��o��3͂B��!w �ع���r'�
����{��m^��5v5�ҿO�l��+�������?��R��R@�e�Q�� �3 ѫ��Qqo�d.�
����IF�؀{�q���B�R,ƹjM����-U[�Ǜ4����*�s�}!N�7Hfp�}4`�`VmW��r���?���˫�� �Ŭ.(8U"��H�1�;��I���]nR�C�6l�7���z����h&_�pg�YKb�/����j;^�7IbV+��4���M�D���8\YG+��E)�h��dl�D���N�3�v��0\ѐz��pT��<8�����NM�6"�.o${��WQ;�ÛĕQ��j�:�eqB%+�����d�et��7RX�T�ő�8��:B�$yl"W#�U�H��m�/��A�v�']N�gӫ~p2��nu�~������?�?��wEk��A��HŉnIWo�?<0�ޛ|�S
f��t|}��3Q)�]S�6�`,a,n��I�*�J`�cE�#唦�����8�z>�= ���T�m/�;Iϑy�$�ŵ:��;�>`zġ͑F���
��q�I\`⤐�J�?�88͋�� �N/�>5���p��Z���y�Z���6�+w7K��H�,�9p{�(D���hD����X1�������(r'ii���5����G>�n�ɽ^K^�Bѵt�Ƅ�V�7iĦt�%�>�A�H�%�2[�my�]t��~e�8�o��Šս����&M���s�U�KY@��[���\^�'�I��?��2*��vw@�%����N.e1�` 9�j~X��w���p��T��L`-����� �U�|U�$����'��Zӷi�\��t�[��o����ɬ�#��G��4��p��v�tX��w�&�e�A�:>N�����ӸƢ1�Sg �0a���q'M�s���e�U�E��<x�X���E�{տ�����{T|�	�4`>c��b�^�')��kW�$�Ћ�-��>{� ���XD�t���E����;i@��>Mv�~&�qb�CLt�(-����V�ʟ$��<���1U��䍲��AG$<����+��7I�_z�&�3X�@������l2}�j������ITf�|���*�'I�'�b*�K�9�VLՂ)�.J�6x
�2����w�	nb4<V��`�{;k[L��:V� UX'�ҷ����e����l�#ߕ��0�Rw@mg�`3�\wZE�e��������EG)�>Eg�L�^F��.��$2n{�I��<��XV���gף�!l?QE�27��YP�^6�Z�gr3��Ƚ�x��;r��.i+א���8�d���ѝ$M'�z]X�Yz��?Ώ�'�����݇���@L<���0�#t�L��E��:�jt�R[���S�o���<$jJ�(���f� ��H4�z|��A��u�Z\e�"} _��v��>�yan)�%Ho�G�q���N�k�3��J�Y �.vQ���~������ se23D�9ȞX{�ry;��N�L�<oi�4�A���k���]��{�1���֟@)^���zo �v��t��$����nG1�_���r���{s���D�93��S��B,Ek/͝4�
�--)��/��*�d6w�?<8 >Le�̥(��
4�7 ��P;5Û4��KO.�`���L
H���x0�P�Dw�c�rGbQ�A�y��2��Q���z�w�R�I��Nu1�Z�N�O��,ԃ�L��bS�v-�F��j��{=M�������+�n�DJZ�ހ�Z����I�{|�����t�D��w��QB�`K���� M/o��z�&!�yK���p@g_�������ހƮnmFoҦ�x�cޝ׌?���|�<9w �T��؎;I�5�S��qпY���ƤT���Ä��I���0�w�� }�C���$-K�Pr�Uq��WY#�\��CF�_
f�Q����w ���fRq';B���k]�1c{���	���R\�Da'g@�U�M�_�y�0���Ưj�����w�雑�GX�Cf�g�2 <-߹;I!����R��,x���-�a���&�8+Zc��3�0'�#�Mϫ'wb+?����6����Z�\�P�u6��:R<��t�_r��W�4RMZ2��"D#�`\va~o�L7���cA*�<��`�o�)�XP���vj�5�7�V�?��ۢ�dm� �{`�%����OR��?ǲ���e���MɈhp�x<�]�Vh�Y5�0���?3`>#Wاm5�N�(WҋH�u��7�{�EaS(Z'::���`$�Jb��� �D���3iA�r#+���ea�!Ŵ��2#1����j�w��m�[x������2/5��sW!e�P���*�v�ڝ��-oa�7�W�Ğ;����,p�y�$O�������L��o�����#δb�����(or'��׽�"�^h�$³�!_[¶2w�|88Du�6��Rj�b��,^֢I�'MF����W�s�wi��`��/5l8�_^""h "�kL0���1�&+�&� ����J�����ؾ�/P�b˔�E)-���OiI/���I�4�J�྿�[�o��S�Q��?!=���; ��4nE��I:B?�a�H;��?���Ǫ�U�1��!���`aź����$���]���La��2�l����H��X+���2 �3��gM;����J�S�2j�J���l��;�2B�j���@S[�:�t�>���Tm��Z��Z�r��@a���@w�2�K�����e����h���Aڔ��j�	C���oP�up���fEh>/�fu%�o�B�����-�J�5 ��Hw@��m�o���WkZ�Te=�aS�l�#gq(�5�D��`�r�6ѳ;i�����إ�#�tQF��Ѝ�����̧ D��y8���ݜW�b��Z������j6������g$,�`���HB����NvHJ���W~�0��>&��$��3���ڑE�L�%��d;�u�-��d8;\$+L�C�(��04��X�;If��תj��ty�ݦ�gICUI�B�(��퐗�2��OW�;�W�z��K,遦�>޿�"2��b�c��; T�r�Й��w�گ�w�1-B�:c�ɴ���LUr��w���IRڋhֈ�M�����s{��&A��猬yg s"�nv[�v��YQ�^X�lk��I��Cm�G���7ܦ�1�U_�1�����I��~DK���h����U��$�Fg@�kՂ���r�@Ғ��?�����\�,3�~�ف�͂�Sh��@�"
�m�:�F��a;�N5ýrp����5�*�7�xf���$���x��v�-��˹m=�=Wy�Z1�"Bfm���AI�M��{�
�m��AU�N/�6) � �3���e�&ț4XNz+�W؄�K��<��1���Q�1�;I�G+o�����V��Eg��М��
�:x˜ɞ)���t(�{x]��Zu`��; BTm׾7I�R��
�%~r��]V���kz"� �Nu<��%w�,b�:NU�����ϒ�-�s�y�X��x�1�(gr'�h�J�hg���a[�C�'\F�ub���3�@�dL�Rٙ왤Aﶲ�+9�e�P��Z�J��΀"���q&�.��\x�}�"��;as y5��7 X6�;R[�I���$��v�cY
6,7��[�r��q�    h��h��{��$=�
�v�2��*&����%xS��5�"�$��0v�y͕0x�>�*��"�<쯐
J؎�N1QA9	�=�K��IH>m"��R��d��,ť�ٓ��a���Q��X��	T��ß��6�Vg {Y:0����ף�� 4����QI!��Ө3 ����˝46%�DO̫{V�����
���!Q#�Iuc�f������_(���Dp�w`U�g��s'i�Q��x��/V��t�cMHV`��&!�yҟ����"m���Re&�7 ��S��3i.��SuO��rG'�=�qU~��za8��]t�8����P���xS,���dL
K�sXB/a�[��yP�!r��˷�I{?�SK�MY-6������ 9�����d��#�1w ��d]��dϔQ��1�vzYK/�ܬ�$|�vV2�������x�dǙ$/rȽ�I�������� ��W]}׳�hz ځX؀��n�
��;ű�����z���'�� ��K�bK&��d*yتDN'#r9i$g�UIEUv��g�w��]p��Q�*��rz>�z=��ʀ����a*��d�`{����;I�W�,U�.�G�<��S��Ŷ���,2yġ��D~.�(�t�B�I{�tb"[U��[����9ƉQ��9�����EQۉ3i�<�]�j;]�t5a�O�^��1ǥzT`�p��)۔{�$Y\:�Ԋvs�mf0�Z�$�*�ReU��6y�M�?I�+�Q��y-�.�����  5��;��:�v�� ��{�]��L��'e��L���r	v�Y��b��"}���L+���iCmzNݢ潳L�p8L!u�7�e�=�ڑug�x<s��;��޻��?�(z� ��\Α��7��٪���$��P��t�I"p�D�I�"�E:/�u�dz5��_������#��0��8l��ǟ4�#+����D��˃�l�/�csZ��s0�V��(�3Ij����U��`B�(����]�R�~�~Z����)F��8�v���P�b)��>��F@;�N�ź.�:��U�J��M`�i#!�d8�Յp��#Ʋ����+�8l��d<w�֏��Y���M0Xf��jS-,�`0�êe������;���v�^o��0k�Y���pV,��ۛm������>�����l�V|���Ģ|lm�c�yub�jw`�&�`eh�v��]���p}'}0L��Ԭc @7���\��_��lE��I�D�'�<�4�fN;_x���R[���rp�5���6�� JW���;I��ǻJ�I��Q2x} �aY��8J�J��Y0�kSx�FҸ��J�&C�0��o�%�Pi�8%�0��[�-&&��<�Z{]�O���e�E�F¸�X���� X���&L����[ j�m,�M��q�JO�����L�[�=G�z'	F��"x�or���:30>�R���d��'�)w $	(�v��7I�땡)�+l���]�.0�p��ۏ[�1�tr�Zۀ��#�7�,�ݶϛ��՞[S{���ݢH��	?�
�.��P���	8 �d��� r��"��Ƌ{�X�.��[䉸Hכ�:��.��]���5a��h���dBuh��=����~ʏл������r���*�U�ș�9&��JE�'IF��FW�znu�xN�Y�z���Hw )"@]t4�q&-&w �����¶��:�u�K��QƱU$��Nh�h�-���$�� ��g����`�?;�#!�!ʲ*Pp����g����r{��(�-��|���͠�U���j�(.LlKLL"l�����,�h��L�ڔ[ב�F�͆C;|d6�5�6'�m]�msè�*O�'IG��[\�{���~�9[��7�6{�n�Ŧ�f7N?�������Y.���|w0����H�eW��<
�L�
@4yzH��Hc�q�i�|�����&�u�V��<e��^-V��x��f^�&p|���L���P2����@�=����U�$6c����+�εIu�h��03��g�=�ءLZ3�1��7 �^u��z����G���1���Ue���൙���p"2-Z.Io�mwh��v�~B�Ó1l���t|�ȁ���y��/w �BȨ��L���/\��>]�<F����t���I*Ңv��؏	^�`��j�u1F����m���C"��@�B�Y��LZD뭍W!܋�Wy�c#�u�=��N���u�T�2�*P':!G5���m�u���w���2��<8M��]��U�����PI^�4`dl�1jw 0+�M��ҝ4~e������z�⑸Ͳ"_���o�^�|6�4x3��x�� UB��ؗ�{�IDG`ě��(]��N�'j�yr�rL�=1��rIz���|y�&�]-����2��hz�����qG,g����<�h��`W2Ep.	؍EЫ	+H��w�����LJ.��>��E���G��'������a$mT�ѕ� 
�\���1�#	�Y�Y��뜪���E�S�l���?�?�+aUO8$� x� �?�jb�L��e�5�!`[�`�/�g�����!C�8LĪ��ۛ�^����5V����u�(�z�f{`vqĴ�� ��:�I�I��B��d1%���{��ض�0XTz9:?��~4��	� �o@aH�~��$�Q{8e���;����S��mVD㱎������`�����0�-��t;�Cl$�& �&��r��E���b�a��`8>�i-#kIj�J�;�3 C��6-�I\`w��*�dÓ����2}xx�(��M�OA4����1<,΅7 y�;̫z���=&浗Lg*��냗�3��]qB���f�|FR�$j5 �'���#�D<��Ht��7<�i�c����0W�P=FCf���)���yAD�-ĝ$��{U+��I�sп�V0��ޡ�>G��������R��AD��*�Z�-o�^"�� *i����c�� �DƤ���	�7����}(�l%n����Dx�T��mb�IZ�f�<����8LIZe
KK_�"��@�3 �N�A��MSح���2�6.o�����r��΂����� �I�(��h�9�0��0�M��O�E읥��YF�d�H�Y�7M���鯐���B��<E̪
5NM8��lsE{��n��F�ȽY<���|	������ n755�/�ƺ��@�')W/UU��܁qw��Rę$���N�D���;ϋ5 ׻w��X��N!���F:1�?��e0��>XG�n-�#�F$�7 ����/p')f��׵N�YN���l+�2�v���d��w��2�0A��f�|}y-H�O�;���F��'<����� ��TĘ�# )x�eW�Kg����qf��Y���r(��1�$�O�S��I�^���S��ܣ3S������T��t�� r��6��7i����Z��|2J�B�(�J��TWy]�uտ���7{?ت��҄#�]� o@1��ݍ��$��b�Y����Vw��b�b��7A�F��:��)���(>;zV������u�/���X��Jd�p��(��tbҩ�"ʝ49]a�5�H���e�����pr �dI��SO��o@`�p��?I���u&�Պ�re�N���W� �?�����?���!�	���
s�.�LZT:dQ��g��t	\n�G�"9�~����8�쏯��k��l�Q,�|�5]� ��Q�?i�TG��e�7\g����������1A��P�}��"cP5"D*'g  Q�Ŭ^M���a�q�x�-ٷ/N���\co<�:��?X�R'I�Ծ`R
n�g��uGv�;I8����}B�to��a��G��ϱ}� +̀�����M��O>���,?�;�_�3L"�.�7��Zw,��j�B��*�0O[{��D�D_G�J��"�i����c	;�L/��и6Yı+v;v$��Ul�O҂#�>ň��l���.����;rޖք�@I����A�d�(C�B�G����}�Q>o���'���`�    ?��3�7�7�
��b!סB��%��(Y�~���N��E�8R3;g���E�j��XW�
�a���ȻJo�E	��6ϖ;i���3��\�s�ȉϭ}������-B
���g�w�
v'	�$Im7S�ݍ�e?o�� R���Z����z6� �Y�ԩ�ǻ�0dqjW�x�t5��q�.�=��0!$���k��+,�������[�;���2��3 ��d;�OՓ��$O����M�N�������c�»���^�}]:3�`:;%F�P�0a�*9�C1��@�B��SƝ4^��{�����U��R�Mphe��pš5�@��ͩ�7cc���'��ݬR�ͥ=͜R�xV`���6���T�BX��0��@��H;�;��F�xg�Nk0��vе �p���f@��86�s�4q��џ4�X��¸%߀�|�Ȋ���`<�>[�=*�o�g���pt�nr��{�I�u`�9��(���)Н�pa�]LWDlgE��,��tU�ڳ��j<<�?�J�!XbѬ�&Jo�#'gG;kw�^&wyF`���O�7�
Q_�O�O���p���L�����H�X�v��7I�.����*�w�X>��|��y&��Z�ij�WY��h�N���� �~�<���d�����ީ�J"}#��'�����mu��FaH�Z&^b�	h�l�Tlh2�]"u�V�q_Xy	�� Gq&�J�*�$�σ�O�k�f I�Q��Q����`bE(�%��$y���D�Jj���'��:g4�$Rg �^��&����g$�]E}'���pJ�`u"ʧ-\*�(���K�!���z(n'k^�_���ԉz���d��}�KM�P��y�\M�	j��kwb}�LaQ''�)� �C���La;i���P�'+5�C&�$��)t�8�6w@��i�@��&.��-ÞIf?Æ{y0�� ��2�d�����X;�H�Fc[!#U>Ǫ
o@(���-�$=�؋aK*��wE�l4����<`�$�l&�Dh�g�V~�[�7i�+��p�TJ&������lYg����U^�_�H�Ab��x\c�Ҏ��L���з�D.���?X.tx6��`������L�u��)���>��x��pr��G���B�~0,�M��7�� ����&M��s�K�M�Rη�w�,��OXi[])8��C�0�%�(�p'I9�vU�$�q��ܐ#Ė����gӣ�u?�I�U�[R�Ùe���"��> Ԉ\���mo6<==@i�->	�:�P�}����M�+'q壘|���wY��-�WX���~�8�rO8�?� -a�l �	ހD�[�F��$��d�a�ڝh ��;)T��bq9<���L���O�M��^�D�T�d��̱�p�������ж����a��� �n��i�M�I�B�q�:)�
'Tф`�����H�ح�!�`[ё'lE�̀�B	7��?i w��2JX{�r�9Ub�'r�	.D��`d��9=�����fp�>f�ȹa̹,y8���b�c�H�A���㎺7w�'}]�s���y�-��g�e���j��,Who�\Z�bv���y��,` ~���W�lYWa?@��݁[Մ�q�r�ﬓ���r1/�p����+x��_`h�B �1K_)o@
P2^�I�e=G�m>�@.�9s�;E���Lj�CT,��i����H*k�&oҜ���V��f~��6.������tIϐ����7�5W�ݝǛ4���G��v��O�0=�lRU��)�ur� �j���ɝ4��U/,�� x�y	�G���� ��Q#`W	
4����{Թ��å������ʖY��r��hl�,0h.f��s:UQN�t~8)$����iG�Wo�.��@���g�̽�rcǲ.6�[`d;¡ޫ���G �fCn ��w�fC��b}@RG�xx��;p�o\�<�z1gV�Z+�(i�Ă��Z�gKU����/߼G��G�[c������lr�8�I���尃*ҷOMRPv�̅`-�0�/Ŭ�d��ן�B��r2�ex��첇��u�V�^%�#Ht�2S����@`n񒰛�����#�����=��,�՘�Ѐ�	ATq�[a�=a�K+i���=}>�/o&=�������)?>ҷO(��wΌ���������7�x&���A�(3���)�ڑ����-V5*�l�� ?d.���RF�
k��p�_�!8�;sPƏ1#��S��
�AD/&���B��U�)F0`�*]��D����Ӏ
Ήh��k��t�$�-$1������r�XHR3�!�)Q���⌁K��}��^��5#ގoǋ�V����ݚ�GD,5!��QY�w�R� ,�������?iz��Ӳm�0�B���n8�L�wE/�J���6����
�)�*��3��Y*F CG�BB�2�+e~5,����e����M,I0������r�C�(�Qxoh��?PطN�nN�2ӵ�I������=���=�dt36H��s��S��rØ�eq]�fً������\5�2�vQdjl�)��# �I7�͙1Ωh���|�8Ȏ6��EF��x��V�;|ӗ8��x(� ��0$�9���Slǁy-y�D�8?�Ƴ���������Q��,�9�{]�mG�QY������'��@�>|��I�M��䶏ی,���xp;"!}[p8���rp�,�����m����{����0�L#�`+�	����-tw�g/!������@?�a�;Ȼh���O�$��h�+&�u�)�M��5�Kl���$;�T���Q���o-�%�2�i�䜥��is,�6�� M�o��Ӕx��!}��9}(k83��1�a!8�t����������G쿝O��We�xQ��dDB��وY�Iq2f��PG�ȿH+|hϬ���93���#:3�����瀼�,W}�5�bpd8���2��8�� ��X�d��4��ǻ����X͆��n������79��Q�X� 1���}yoM��2�9N�����o�!��m����o�`�����G#S�� �9X��K.����)a� s��mg�$�_���r���!4Y�nC�"�b�8!�B����3jG�ºF�|���G��ݧ�k3[�����8������?t=m�(�Cބ4��A�*S�< ��nU,;�K������S�������Xw�!}#���1R���jE�?:[�߯����R���`bq��m�x��θ$�X�Ym��"�L[8���i�^?&��+��k/���lm�~��^LV����8�&8��J��&X,���g�u�cQe��[b7�v�����cK�xr|?)�rX��?��)��[�|]�Ak�̸7�����f�y�aG �V����b~|Oޛ��DL����
�͔�\@G%<¯�=z�A�p�j)s�Ro8L.'5�F��#��n_H�Qf��Y ,��=����*T�ҝَ=�	�[�`y�Z�3����	ɢ9_ߡ7�ƹuP_StDUG�A�	�5���U=��"83�OE0g�O��_�68����v�]��ۻ�=�ݎon�`�MF��_�8��c���9��1����B7e�Mj��`������eY ��\�TnC�,�
�&%`�a��Zʌ>�fٹ�nS,5�k'ۉ�')�L;���a�$%`�KaHcF-"+R�ڒ�9v��<�G-oFߏG�n{������_"�o���u
�83�!�Y1_x�El��#�����i��L��	��5��|�e*�j�S�5C'�������J3�4����'�?������j��o�����r:.����n�QM��Ieۄ��t�)e�{J�=�c�8뢀W� ����U��wQK�F)p� ���RX�Td��֧����<���O��p�I��^$���4u;93g-��B�aBr��w`B^��R�_eU����Y�9u#7�ٍ�Ia�n�<1��7II�= O���!*_��@$c�s�G��_WB�    �m��Q�w�|�;�|�< (�d9���{�,�O,)��4#����nE6e�Ս0���MF|��8Ws����S$�!D�q����`��Rݖ'ƌJ��n)B]x~Xzt1���~�]�Jׅ�U�0�8D.k�ұaF��ZG�l�G`��R��Q��F-���ץ�ͫ�����&����'%�+]���xE��q6��n���i�!�4�s�b�M�2�:5�b�#���"^O�L��^/����hRR��旋�tYL	���I�"b�#ls"�ͿUa�,aFm!�*i;�/m�G��T�a�K�b��SH^w�6��U��k�9J�	q�[�@�)�:�,����������<T��u�K����Fa�!��-ud1f��	T��~;�?�����w0��x8]g��o���v��4jBJ0���n�cf�I�㱶�;�������Gr]��ǋ��j>���p����`�"0���tV��N�)���V]a�W���?oڂs8U��	�L��|6zw��5U�Y��ʀ��T�y�����Andä�!b1PcA���ż���O5!�WR� �%�l,��ʘ1KG���Q�0#��al���]c��twG@Dn�Ӌ��d\!�=�bl8�
na�<��W�FhP.�fgF���ZH��3{�o�W��o$���	)'Yacw��!��c|��L�I�x�p|}��4�� ������l�g@D�AB��&�� f�{Q�8i٥�Q��8�2 �+���D��.�f���I�AZ�LwC�R��h�χ�F�|�/ם��E�OAQ�?��	���#@��=��/�tkS�`��n>|ĪϦ��)��/.ǋ�?�`�&U�R�J�`��������z�pv��z��!���_�u�r�;��R�6~4f�^93,\`O�g�U������ޛ�kL��,@�{ؚ�(���V����̨F-v��5>Oן�Bk�}~�>Qpr3���rdO��h�zF0`���~(3
�h6�{M��_�W��A�\p��t�*W�[$0�N �1�IgY|+��'7w۔�ٯ�K�^oƋ�㿷z�^>&��2��^hy%�x\�6��W�#Y~�����c{�g&n��ڗ'��@�8���8��; �����<������<^Y�W9�,@�+4#` �*�(�,�y��6����ϛ�Oء�l..n0f��W�ջɬ�W��.����q!R�YC ��2���������'���_i^6�/χ�����kx�'�UR�(�H��Ղ8ڨSB����(J�K/��_�;#�K�{7������I�,bA������)UK&n��y��|7�'��ԍ��p�ȚW6Q}�?jW��f�gp��*�/m�)�E�l���������s�q��p1]"Lj�-�.ҹ��F�Ҍ ���`4cF�TQP|u0�3��|��7_�D�
i(�2�! �V8c�;��hh�b�a��^�������;�����vQSÜ�p���S]���0!�2ӑS?D	s6��v	�bw������_َͅ[h�Z��	����td̔!S���Sk�,���n�����f�R0s4.Q���V*�A,�jU���x��Hˌ��*Q���C>=�"u�ޕ@{^;���;�ԉ��#����:�EŔ$e��C,�?��������,#`M�(�_ʌ.j��}azv��tJ�~on�Q䒨���A��*0���,\`�䒴���ꫦ�9��-W��+�Ƴ���=���<x��5b�Q��Do���2��F��A����&6����� �j�0�x�>l:3�.���brs�C:"��0����!�'H��ͦ�h5����;h�}����������b����ݫ����*�����6a����hQ1�b-z��l�Vd�_k{�Hs�8��x�2!`>�� ��@�)��d�3t�b�2�+��-5<���W򯕐u�[���W1hk�m�̔@f�K Ɵ��[:�|�S���[dU�#y�w�;�+���0���׭���x���EP�|Ռ���q�^Yn�<:��T�j!}c7��B�sf���GҺ��Đ�0�*��Q��P�������ۜĘ������t��¾�?�pa��%�d��	AV��E���x��e�'��N��l�Qo��Q�Dt*� t��&��`�hn`�@�US#�����O�n��l�̰������Y���!�y&(���	����a�h4:A��:ם�=���f�~��jӂ�|9�N�}�	��\#]j�Ҏ������I�dmkU���i�����V*����ݐP���i�|�y����C�l)3�q�rAO���O����v�x���N����]ܼ}[xe�b�yi��8��~At�ᔙ���~�"Gb&xg/���{pyT��Ҁc���r���ߩ��E�eE(S�/A��vyC��EpҀP���]�A�B{/aF�3�}�}?��R�9�9��SG|��
�*�L�~A}X�X5�9f[��[?�y�f�nx=��Ǟ��L�����2�YlD�	9m����Lճ�����rGVy�����k��)5_ ��̔���r�UM��z�z�͖���z�Z���I���a+�@D:F@�":c_83�܎��N�����;�A"���@1�zt˨1�rU v(�e���|�L�g�kc��w8T�j��|x�=?H��j�]4�X�o��gW��K/�)!Hx�ݲ9�L�'۪�#X����_��}�ĳ�;HP�`K	!h_��P�I����&;4J�]~��v?�0���n��F�&�������	�|-Te�d0�$�'�Qd�m$���xHʩ׷�v�a��0���_9��Y�Ӝ� �l�\h!�hͳ���
���h��XԻ�!ݑ�rI�ՠi�'�ySH�f4$@d�л�{H��{�A��.����[-AU 7���)��q`v�	E
�?��S���w��������W6�RaAl���0�1���8�ǖ>,��<���o��k�����Xdh�"C�Ra��1����A�P���k���ү\���?����Ä�T���0fD����_;l�L�?�R�ʇ&�0M�GN)����� �N�cƇ�(�tW��}���;6 ã7l��dV�{姖u��#�g`�ƻ��a����-`��qI�Ը$Ry�}:�2��8z�p{	3D�d-�n�)��87���rNMtPVM�I��y���|w$$c֕�hk�G��~}�ez�Z�pbmo���}�����3d#�̞ɺR,<z�~�#�%D� 6�����V'!A.YF@8��J�O3�P�H_��|s�]��1Ю�`�i��2{M�U)�ہ3d�i�`MZ����N��ݩ`tˠ�#1�4z4]���)`�j��������g���Ͳ�ʥʪ������HH�X��0�&%��"%Jo�(]F�� X4L[�޷-+� l�RPRc�%�X�5�/�Ul���?כ������g����H��L	
��LW�Pf<DEÂ������7�=��<� ����O���$�(�Zf4c%��5�m~���f���~��.�~d	��v=��g�~8�/�#Xi1�Y��̘�TJQ��j����?�O�G�W^*8%��*XF�]ݍ�S�Y��tw2���1�7*N��<|؂O�4�ʪ��k�O6=��r�`=|
�鄙Z�6����m�䪚'PဉTU��2ΐp�_�L���ղL�}�?>m�o����f�\�g��]��� ��%��Z���6%����$������n��6���j��)K���m:�N�/c�*!��j��6��B�o�n��H��k|W���p�u�¡v�L83j|Z���Jw
�|�~~|BΟE��q���K�8��p�3��(��L�T�Q�Z�?�@wjj���U��9穝82�$���eF!dh�Dk��x�yx�3s�^y_:����!PR��"�nړ1�����Vg���ݧ���f����G����k��@<�|    �_���f�����������=�\P�bh+%���C7�C���g�=F��q�i;X>Ao���p9|w|k�'�%0�汏=�w:��ę9�A�HELԋ���/��޽�8=�X"�o� ��Ng,e��6�A��k��}Z?�إ����ϛ�3<���@���S6(2��~�P�{K��q������z�݀��5����v2�cA������}�D�'�O��͠<���(3
NMR��B��c�4��/.z�b����
|W1B@ ͂:��9̱������M���=�Q2�J+0�D��-D�)�n���a(�3� X�I���l���o��ׅ�J�LF�Y}֢�-��� y�Ɩ��_�,˚*a�R�,~�l�tPfܲ�t��v��C����b~U�2��a*�OD��"����_
�k����� w�:�~�c��Xj���8�H�*x:�xe$#��[[������l{���~����j1����?��B�0�	#(�� 	ƌ�XI�O��r����}�b�Mɺ��K&��ОFwZ�83>O��D���a:�To(Y2���L�`����mP�0s�2�Q2\4c����QG����V�؏��ob}����ï��ߛ{��/է6{�wC��0�SVU��#e�u���o�D����~��=�9�A��@�7�g8�p���Pҟ�D���kVd�8Sk�Lg!�K�[	A�s���i*�
W�˰���83�� EDe�j���q�z�Mڥ~�M��I�JT
�y�ZV��kD�ɮbN��#'��3NL�P\�B2�Bi�>H%B�YSf�fV��ƀfn�}�����SӅt��;^���|p;^^ߎFG��-�S9�T��F��c�c��2�ׁ��Aa.�^�|�p_���C��I�!)�D��.�e�]V�����1q��D�cv`������%��43 {s!x�s��b3n�������n�}-�����I��HNO���P�\Č(@fRAt� �e��ԥч�ND)_N�=[r�JW�
8����dw\2c�`KE���Ϝڽ������Y�^�+�-C%� ��	���),~����-��x����0Bd4�o6��9H�,����g��yr���+5���,vtv1�3�X���R�7�B���h�m�\��"B%��h��	���̮QhD ��~A���lkf�Ii���O1���5m�&F@0NW�M�q��Ƙ�h��n4MpY<��߄����]��
#�+,���i:�p{@ӕ!��v�
0f�GN�"�2ċ���?5U�;Qj�g��S3̳ìJ�X�y&�h�ѩ�F4C33.�����xz���C�U�v��*(��Ǒ``��B�̬i�#��\2c��fЈt�b;*���c�ݭ0Ŕ0��#���z�����v�v�;�;��>���Zmx>��{8>�T�0p�5#�Z��1���M}F���@OT�&�LA(O	�?V������ZV��hi��r��n���m��<5Qp�y���o�T���1c	��3#yc:�����1?6�[?��6Ɛ�3�qs�Gt��3z q�N��T Ǹ}�L �����1(�z���p�T��5��3W�3�����R�3�i������f�^�a�e�E��#ue6-K���N`y#]�1������E9�8��@&[��q�)#8l��T�sf6޴���_|�M?qv����d���q].�<|Е�`��$ݍ�f*����%18���=�*([�z��k��56�*�3��� 
�`�Ih=P_��T3�ߪ< Jj�iFR��
|�nQe��.0z�Uj��N���;���7��\n"� �ǘ)S���$t*�93��/�(˲��˳F�����u�H}"��N:���QX�bq$#�V���1&���#r\�����9�W��b�QN	�aU�� �)M� ���o.J���"t ! �)%�3�X�L���n�|���07��������x�G��o*�b������~�U�� |3f2i}��Tu�@��<d3�rD,�f,���f�������g��F2DF��ۯ#
��|1�]Nz(��c~+'���#�������-cFIl�e���[�������\^�=��M����Q�HH�>B�w�rf������ߴ5(�	;pu�*'1�!}��d��I��?e�I6»�O��KE�����g��7�=T�%ii��`�)�{Y�� �L/��yy� >�o�Lm߿߬�����x Gz;���A��,.�� �Ռ���w��qf��xf���w�����ݧ�}�e5��ޝo�zo��u���ਾ\e����?4y83JE 0���=�D����=B�|\? ���j2��1T��
k�Ӓ���D�1ahM ���ӑ���������?b�:vt�a�(�U�9��tK�5��3��	J�{m	7�"qH�Zʊ�H'���8&u�	NRK�N���RةaF�c)<����Z4�1�Ԏ���2�b9N��)K������(3
(���}�����0����*6���f�3�,5RM�?���A��s>��Q��{���U�l�Q~�P"aFq�Y�� o^>���&�����W���~�?�ߜ�E�l bBP;c!}c�8_] ʌ��0�x��/ճ����0�N
��c���w�l�L[��MƄ��qa�g8�V�9R��P7�%��QS��0�
��,� 4�6���$m�}#���o�6}#2��tp�3
`0��3�mwZ�j�������M�|�6��Oc@+�)!�8�n^�1S`���^�^?߯Aـ]�#��?�7�:�v2���u��VF���g8D0���3�U��*T�k��u�A@�P�� ��(Sh� ���� ��WP��f��U�ޡy[iF@s��E����pn�5�}��S�b��V�
�����b*�L�U:��3���o׃���c���'s�Np�[�cۄ�LQBD� _�������ě�'Eܽ��nsOQy����L4{���`��0Ș��h��V��f`&Z9�W�L p�����))t?0f�if�V�N��w3:Vl0r���8^���2���څ��ff�4������lJ�L������!�G�"nB!�B�� =��,��;��X`��g{�m���ٞ��\|;�,{����J ^�u����p��ΙѰ��/+r��������n�v����5�e�1(4���>�1�%���F�qݶP�A�1�˺�� #�b�m=
6���c �OB��]Lz����ˬ�&��O��m��Ҿ����d��A�p�B�#O{���Yq���,# ���.`�n����K)�����,z��7�8P�J`�-!pRN�ܑ0��傢�n���76˻��ݧ�o'��dx5��]���\������щ��A�*'�aց3�&arV�Q2�l������{R,%�����%B�Q�h�nvw��S4b�hi���|ڇ�'����`�F���M(3Yv�j��h'a���SeU[uab!X��Լ\���q�°�g �>Yc����X��z��\�zx�.�NY�*��	A�7ҝ�J�)��Ə���Է������Gp�� �p��������&���b��Y|3>~�=�tɢ@��b���M��Qf�+�L��xY'�v��.�c��B���`5��Ѧa��`�k��h�K ��n2��AO�����Q����j�ކ�	�QI���Lx!:!�L∆�0|�M�D��\����`��
��:z��N���;�ue��^0��\�*�3����ꂪ:o�FgX����F��ZJW����щ�\�V�̂]�[̱����k�����a�o�JN���Y��[�](����/jż6��m_�@��aWib���ߟ7�{�N��/�� 6����?~��F���������4b���,\�a�2���kX��׻�6g�l:��z7�m�7:��K����;1f�*Z�N���t�B�������    )�%#���t�R(3�R�t��fц_b^�/�F3M͇�F3M�J��n��2s��J�}����OO�+��88R��̝hF`sA_�
	%��0|#8��v3K���5{k-�э���u�b1a�Jg4D������ń.F�	�ǀ}7�D�IZ�\���l�+0���秳�on�߿��W�=�3��M����	B�{jt7�ƘqO�)�j�'���]y��#�%��Vmh���nB`�n�cb�N��:݂�}������"��xƽ��0�1�6�t�~��j��l�@Y�dR��k���`��m���ć�����Ϗw��x����Wmp���bBI\9��ɦ�Ge�����:�������C�<��9pb�!H��X� L��iS��\��۝���dc�Bp�=#�;5��`̘�`����j
���������٪d�<5v~(l�b��*u�Sf|��<�uI�d��Ǧ.�^�!�7��F9	^�����0��2�D���������O��n��ا���*a�>���0l
6_��a�p���j���=H�=�%~\�Z#�S�����B-`�	o�~�pLD�͓3f8����-�>mZc��#Z,Q��k-�>�:]�]�i`#���n��$���!�Zf:�P�����h�#[	(!�ITu�i�/�bjtk>���&uɠc�Կ�uUJ!�́��bnJ�#cF�1�0����G&�,G�� ���R4��Ql0�F�A��Θ�G5����0�;Z��Rh���p�/ k@���HH�R�9':pT�y;���3W�?;O;��?3�0x-n:���G����މ@e���Pi)3Z<�Ut�*� ��c;�f�����r8����ǋEY����OQ1ă5 %�N���(3�`�b�3/��9{�57��y<
�g��C	��d� ����d�ċ\�Y|��+V��K���K0=s1G��J[��Sղ#X3�Rx{���������gg7�~��5��qG�*b	J���tzg93>FEт�����P�z����1���f6y!���W�ju��F !���ͤ���;L!�av������6C� ���HKF��:�=�m:62G��`��3]sɮɦ+)eh�S���)XG߭���B9R�ğ�k�0fܭdjD4���(��q���̧�����o����dp�RO��pG�uݜ�"�x�y��Ά�7h�g�� ����}V��\����3�K�oZ���o$��y�����#l��i���{|V��/ۻ�W���b�2ov��}���XWo#}���K7��������Xoѫ����^�0��A�<K݀��f.�	��%�C���-;W�C�Fǽ��{���������o�_\�<����j~������Ë?�m���e�wJ�ZA^\�I.x\�a��'�-[���(A	��AE����������+?�/o<�2����%����a�5���A�ȗ��X�L��.,���D��a�k�ǯx����Ysp��h?�����F�Ư$g�AQ���$g�k6�� U]ˬYT��8�^B8#����{��S,�]Mn烋������@�7��_��]�����n/}��r�+����vX��j���߾LF���b<�+s}=��1V���w����n%[�&}&��������w����x���a�2UkIƯ�T1G���ŞT@��V@�W|���,�F������ �.|���
�F�:�b����#�z�|�ϸ|Ŭ0%��WX9���g���B��p��wi�X{��}��*���3z������Zc��Mb��M�����`4�z26�����^��^�v��39�L�*�W�nx�;��h�]ڀc��ϖc�~W�:҃���bx1^f��h&\�囱���v3u{n-~�'?��j��/��Y�r�.��U��+n��](���"~v��y�ꯡ��� ��'Z�����rq�����*��\B���������4�*�w�f&~��� O�)��(8W�p��ժ�Q��2�����/q��Eڅd6�6n�y�o���}a����r>����j�����j�'���S�3�+�ҭ���%�c�'P��S���Y���g�aО�d1�a���~�|,��F��v7�3^4ͥV�������L`�~����FU��p�D.�W܏b������|�vI�<�>���L�1N��D���50��|�XL�3�{�`#���ơ�g�r]gda�/�y�8�F�j����s���;9�3���+v&�6��N��;�p�S�H���Ǉ�����˚�4w	���h�,�%�'�q��4;�4��"��:5�./�>���4�I�	eA��ǐ>^���NV�6���)=Ӹ�o�*�����c�3&�k���_`KځnkSi�3�,��Z�*���tY?�S�H������x�m5����6Bs�E�
QX�|y�'s�HUD�,\{�*����b��Ѱ�ą�;bƥ�B ��ҺS��[����c<�`ѭ�M� /��0N�¥�Y��-�w���N�7���1kK"S�(�bа��U���}7Y~�������e��>A�HR��>���Y�������#L��G8��
[ ��O�M�È��M�Kg�M~��ߗp�t0��?�S"6���q��2�V�TL_�2��U�%�$�����.9�<�ߏ-Y�%�ޛz�����q���{�T|�m�*~����$[�tr5����~t�菞����ү�_OV��޷0�p�]c]��Ғu^rĉ\�ËS-���!}�Z�bIg�Ig9�ཋo�i�h���X��ٺm\w]����]m�Ʉ�44������і��rm���I�`�L�Tɀ+�.�i�K��s����Z-_zjq��Y��=��	���z<��(�N#��F��Zǯ�t^
�f�d�G�c/N$K��1�Wi�Yz�$��z�D�L�<�9�H���!}FsP0���d6��o�4p1^�o����l>�]�(Er�&�0�3
rn�zE�߬~4<��}���*�)`H�������x1=Uۉ�L���gi�&��|2~:_.��,����{�11��,ů�����>�z>������~{�Ƀ����br*F�U�?����v�Z̯'��Ne��B��t����|g�����o˛��|2�`!��b>��;��	��VO��x�y)2���ĲW��o��h�v�l���|�%�N%^�2F�z����C�s�^�����f:���7x�Û�Aݴ��o�>���W��y�<d�����b�=��̀�>X���D�����@�L�>�4Y��%9�`�8q8XMf�����iL��Q��.�ɫ���:v�����d����aI���g�������.����f5X��|BQ��**��y~���@��.0Xp�-X�km����+G�g����.�W�������}k!��h�[ZJ��wp5�^�1�;^a��i�G�ᶭ&b�d�DV��C8��em��HiR`�⚙g��X�k^�Ф�Q�V`ůҺUgݧs��5��Wi��`�W��ڙ�����h���5��5G�����o� ���@GVX��KƁGp�St���q�P�M�:~���(����p����H��	.�pN)Z���9���Uh���$Ff�U�'���gjy�{^���?��q�m ��}�����	�	z�r8��J�aI|,~ELh�=E֞��	��$aL�_�	��]�O��9G�>�J��/Fd�Ɇ�D�?Q!���������g\�aoWd�8���>-fz�~7���V��-��3]�֟u������rX+��z�8��둾���E�Ї˦���j���JK6�Kfၞm$,�1k�WiѠO�����|
>Q����󞯅ֶ@�W�?g���m HV�YY9�I��9�+��
�����%2$~F/��衴x��p��j4�@�gw8D���Tx����?|�à���)���k����	K����Nq_��ۀi����u)�U�`�b8[Fp�溟���B�W%~��    W��^uW1���c|�º*z�L�p��5Rw�����.�[�{Y�t�J����1�����2�UEۏ�Wt�����z��=A���|y*�*�E������dg)1#�m�$����f�F4�?����5
ɋ�lr�������ҚC����,x��p�5�I�O��>ݥʴټ�+,�kp�iq��E��S	L!� M��3�e��A��Ny�"���+��o�Ѷ5-vx�ߜ.�<�j��-u(���tF��I�d�L���E�¢O#��-@�*=�F�.�W�ջ�청�CҞ����#�ϨXY�Q��xRQHʩ��xzm�?��<�-�����&��X�����\V����F���F>��7#���o�uQ�h��x'���M�]�L:a��Ȭ����+Z���1��7^���v�����c����u�>�z�:��
��oߴ������������ X�����N��l��"�^,��o~�>�ޔP�E�'��`�.J0�asg|e�����s�0���j�����nH�8�A	���&$B����Z��  Ό�d�qC�n�b3����d�kq����ͦ��~z6�gi�c/@�f�y��-�����7=����Y)�g	�[��8-��R��������b���Aʯ��<�I��V�IF�G�vG�QfT�`Z�
6<��;�c��U�R��p�ffa��s'�V��8W����b�~�+��]Ʈ�y,���ϧG~���3m�VF2����ݡyvP8�?�z�G�̦���$�q��u���4�c�'%�;�1�'HȸUM��&���e��S,%�� G|g�g��h�s0i6�ř�mp��Ӷ>���S�^�&�	�����<5B�AÝ�ţ���n���$���m\��fѡ���`���҄t�V k�����N�a�h&+�v�L��5�m���ߥ =N�k*U�l�%U_D�p�&%x�p�_wa��C���s�6ۇ����];s4����f:��X��2T��#xi�0�q���'�1�v�qy"��w���=�"x��m�<^_J���ޕ�o͌:D���n7x\�y��kT������Q��J�����|���fN��I����Wݳ���2L�jQ>�Z��x�B�Q�RVvgM�JtD0c��q�L:�=�?�>>l:��9���ӱ�_]����Z�G�vz�R8��A�8Fށ!ߙ�Ș�aܶ���n�����p|�x��HG�8V�:8Ug�W3t?ʌa1�<�����)Y����%�W�n�<���T٢�Z8r�<�+L��dC�@�~a���:�����l|�C��O�j�c"���3�-�,��%�65�߳O��8�;pI)A"�����T:�T�قNz�&1h����A/+}�HA���!>̮�ʘ�8��Ż��a˱s��z�N��� �EU�@ކ�0��2���q�̠҃������#8O�u-����$ߍ��ّ�	�7�Ƥ���I	����u����u�i�����O���ϟ�*\��?�I�W7WWG�âv��/�s(A�Y�݁�hX ڈ�u���Mg�wC��<��Z�Y� E �/(A�,�U�qRf*��g'�絁����п���5��YW1B@���FDÌ���'�B�u}<FmL�00i��a�0b��)3��Ď�,z�����02��=}���c���n���ޝ��G�htԔ��1$Z)�N�ew�=e�][~�&�����zp��<���y�b~�`���ٱ�hU����z/�Y׸{��g*�7���O��v�T�P�����Q���U*0�Ɋ�5D�����E��o�w��_������'r���L~�ͦ(>Z���W� ��5��̸ي�F���y[/|>[��ǎ)%�L�`��g!�
�XW�f��B�#<Ƞ=>�0(��v�]S���ۏ�@}��5��x�� �*����N����e��������~��N�
����X�a ����ᮖ ���|Sf���ⅈ����z��Sw�c�=�+���������6]{�2Sx��b6�EpU������7��}^?������C�~ο�ݑ-�,P�3�|-�UA�f,<O�LWֱM���H_��?�`�m>��ғ޴�	.���ۧ��a��3c��bQN�M�o�O�6��?�>l�s�(��({z������������a]�L�<�,h��������n������\�W����ػL�,�2A��%x�&oW�Rf�%������X��9��D�8��
%�蒔�'53�"�yZ��i�w����r>� �ִ�;�E���Ef-#RGu�2�O��;\�vw�փ�����q���vR��!�*����
�Lq?.�y�m���Rū�lrd��^:�~[F@wSr0����ʕ������#qQ�8��ص|U� �鰮�UJ�:x���e��U<��j#�=�����?l��z4\�z�~�c�N��Vy�t��D��:�c��I`Yq���2��hw���K�%�&�#�[�s��+F��i
�a�����Je�����yD;v$3�A*8J,�"���*��(3�'���І������*}X�?��v:\����~'��d�kp007�FI|u]�0��ˆ�כ��W��np���F�V���z|}�N��F�F�F��b�iag-3zԊ������z��y���7xw3^�8A�#>�7l5!`���}��Y���b�4y�u�����l��+��h>��\;|�r~�f�3)ޞ �Y��̨M?�p�_ȥ���3�M��jud	�U��DRB���V]=B��$óc������ip��~��~Oy���VdV!�y���RJ��)3Uc�S�(@������c�R �dpt��������e�foa�c�,{��W���7X	���H@���3�Fd��W,L@�S�{x������	������&)�c��0����<+f�z} a.6�'_-ɝ����u�[�2�hpJ�`�`@/t�c�34�����Gk��A��'���?<����M���b��Mn��Uա��@�OYF0k�ȋ2cTK��o�.�w�����k��1Y;Z��y�§Ji�C5��!�7��S;{����\�d�kL�������qt<�������s�N�\�*���0��JWH�f���^����&O���c9�N���s9f�S������|!�@�������N����o���]��W�>O�+!8|�]��1�{嵶�J�����B�m����� �W^y�~kK���o�d:50�g�߮~�m�bQ|x�h8/����0tX8�"3��X��-$��x���y�y�i;�m�������}+_%C�i��7!x_9�m�c��{r�,�I�v���ҵ�2�eJ ѫl)0K���򞈠K�x���7����k,�k4�j�X�������٥�<���U��kÜ�\d�,MB6����ןR�o��}nCѠm������D��HB��u�t&�L�u�B*�:`g���xv>��9Hk�	Xi,��^VF�X,_ȉQf|�<kX̤���~��Qn��J�\�2�E=#�uC��n��0ӽ�Դ�,����zp�_�s}�is	�����鱟��wd�wX!�X��� �����<��d���Dߞ{̲�`pl�fP�pה0�"&�w""���l�X���&�	�d��MzpQ:���d����ap���Կ�O���j|l[��(Tl�6O	��^[Y�!�&���T�m/7���σ��o���Vv�_��<֧�`�H�#(̩�������0# ?���/m�\ғ�v�UMc��S�ʖB+ eF���O���ɻ�-� s��|��x1?�T�K��z�,+ҷJ�;q=�L	ڊm�����^�ǘ^k�\�q>ͱ�C|�(�t�1���k�H�2����=�ش�KtwdőKpV�f���e=`sw�I�);�o�+��?m�����ٷ��;�?�	^�� V�x0�-#h���L�M�_YF���|(Wq�����/U��7XJ�Ų���I�-�`��Wi��P��M�簮    i1��v>����7��>��@O�_i�a��^�B2�2����0�٘��[l�CS�՘i�ѱ����v�eA���D�)F`�6�K���o�x�u��^W]�#r+U�
��!�QnS�e����8��A�O������B�]�l0g	�W�7��j2>r�eeB�\��5#�݌�t
aFAd<�e3|����B喝%
t1_�B0��i��Ä�B�1a,v��������v� �:���@:��Z��l9��27O{�6��� �峾`�f<O�d;5,�y����#W7��F�r����bF���v�Iʌ����|Kܛ���ln8�����6#\	,q��*�؀sb:���(t�bB�1��h�>c;�	堻�A��MA�fԊްm��.���
��&���!c8��u�L�w��j!�Sw'�6�cb�����M0f���^�,�SHh���/ۻO$8�SgT�R��!��a�?���F3��n���pq9��F+��0ɭDlRJPpߪ[�D��؄di`s����������CL�L���`6?���'��0Q�ɷ�NP��YvCt�Y�#%3k�뇏�F�sWA.�DΑ�����JTA@<#�|p)C�iw��� ���&���c��+��N��)@���AKl�2�����9�9���2��c�T6@��w��Y%�#	vtw�� 6�]\Aʌb���Zf�.1�����5��i�����ձ7�L�v�
�fB`��
0a�L^G`N��-��~�>�\:^Lf��v�BF��Z�w��;�n�aƋ� ~�K~�} wcn��?�Òf�W�"�����47��	���B7aFߪb��=�)�y���/��E-b=V�zF@h�6%��0)-�G�N��U�>�MΒ�5��Wʌ�ǰ�T�6Y�Ow�����0� 1�.n�L��'���o��g�:_M���o)#OI���q`�$B��q�e���̴��mIa���kF������&�#�~�:���(�G�	�]c/;��E��Q�b�W��h0��@�E	�����q3�n�3jh�;b����������~1�E2�q`�U���[��\F����W����i�
��1����	���f��9�K�
]��m���\Pk��kR/�>�J������J��m����}h��b��F��8�W�8���ű�x\NHan-ؘ�#��mZ����0�"�@9�6��O�*��<�n�22�i�/p�m��3p����E�j�nz{���9�����m(���d�΁2�zK/l�x�v�{x�4F�T&�c�] ���ؑ�P���RE1؛ X
X���<c�5oϊ�����g+p}������r9�������o��Ǌ�)��̤"�	*���|�w��O�ǧ�6#��]�.��(^��h�n�2��q��_�k7����G���i�uߙNUX)��`M@!\J��8��q�_�wO��^s�.�I�o~�#�5�;Y}f�����Ԣ}����v�����Q���� ۶���dB �[(_UB����+ڽtO��`�Hpd����B	�Ĳ��%��Dy�X�P�ERo�'�*�ƧT~��$s��C��h�kf���'�=~��P.��.%`ј�F�3!�M�x���p`ه�蠳�x��nǋ�G�k/N���^���G�:.?c��1�c���>�b5���f(J8�:0���$xf�*</@�I|���S*�}��&q�
#h������2�n��n�F��b�KG��Uٺ�c�a��-�)3�y�?Ln�p&�y�@���+ď�&)� �d��2SH�?Vf�
P,T�u�P��ǂ��ǖ��j���iF`��B�21sc	^|�e`:�Y�g���A��N&p��ڡ�V�4���� c�=*�1Ӵ��!��l>X�y;6���]�,6�V �x�2�2�<<����C������~C�7.n��=�W�F�c�8FgjP�W	]/�1�2��n��~���-��Kԙ�t6Z?b���'����slV��pq�)!��R��d���i��]0B��O��p1���ܭ�SA# l��"03�Y�Aɖ�T�����La/5��h�Q�Fd�Bw.e��&N�,n�0�w�.�ȇ����`qr���R�LU̢�� ������t�O�D�%"���ݱ$]ݤ+q���(��V��0�c��(��'.�Y��S��g0��82�`�����H�L�&�����SUD�/�2�aE$%x,z,��Sf�s�Ǿ؄>Z?m(Z�j<�)|t���]Z�+�����Q��C�g�ޞ"\�p�k$��T�ړt,�,�Bf�z}�� D1��Ӌ��d|��羞��C�h�jeea�e�u������V�~آ����+�3�c��%=�ReѲ���� �����58:1�l���9�^��|����<7K
��"v�Q��`��̔�cO�񦬫��i����A�~�!�kl ӏ��A�����<���������?7�':�lx1�F��xu����!��`�#`v3A�o/��mj��V���\�{+d$ht���W]��2	����"=����~�x����NQ��ڢs��	A;S2}3�>�5��;����O��{!A���]Q��qtH�0�e�g�Y���X�]���w��jK�]��&KD����Y�ʝ$����c��A־t�"�P��L�*�1SZ�b���f��~�cp���������{���7��>�W��}��z�r��-J���!��(aFA��1jX�zX)6P�xe��I��|zsu>b���g�,�V�p�����Aw�Pf��=�j�M���O������_�b�?��$�M�F��YF�K��ϮF"̘�f�ˌ���8L4� a��¹��
%B��	Ft}T�L.9�@;g\�w���P��1�c����ؕo>[J�pg����w'�1f2�X��/Ozh��]���oG�]��!�ڴ=	!6)�SiXA�Qf*-b�%�sj�S=����f��#���r(L�$̨�$�6�����4mp�?Lw�2k9� �?��ZFPA#�jaf[�L�{^=���&p��w��^z]�ك!X��űW]��0���\ⲰQ;��c��E#ڦ�4��6ʔl	�,iU��d��׿V�v��~��˳����|zq�y�s�ʃ�e`�X��a��W~z��kx���M[+��T�k���)��!%���u�D��?�P���f�{x~�����XA�o_g���[ϒp@�
��L�)3��zէړ� M����$��A�+�6Sf�M,�V۷��9�̎]-�s�87����ҍ1fz��͆�5_m�@E�辩�����}�Np�\��c�9��� �.HF0�J�%1f<X�Gu����������e��)ۀ�9D�A	XkZ��eo}��Q�����zR�y��,� �Rua��"7f�������;��M��ŦJ#�3ҷ�M����L�i���g��X{:B$��a(}f��!���Ю;���sd�8U`m+Fp�R_��k�ѰS�`�t�	��T��b;�j��|�x;�$g��!V6]8�v+������o�����>KE����۶*��)3�5�Y�ܐ����Ln�
J(N3��XnXhx'�h�K�vF��:�l�����KL��o�}7M��qW@�{�FKWu��Lοc{��NL垯qrAjB�Um�Q�E��t��U�@�jQr�	3n�aL࠹��4N,84en�7���h:���؍�>A��T��~	J؋ �ix�L�K��-����4���`�]ǡ�m�rr3���l9��s��y�ڍ�fT�����χf�]M�ݗ��K!j@��Q�p����L�ɕ��&-A�8 �-�C6l��B�����S�ƙ�~r��J�Tk���_�P"_HлG�iB�2��ev� ��S%?��/����؝�6�h�� A�1��\�������[�K��u    Җ~�`i�I�,#Di�-Lc��Wp9#��2yxܢ�8�>ΆP-$��i���޴P�G�9�h�v*!H��Ç3��&�c� d�I��i��n��Ҏ���x~��N�&l�l��.B�r<Z�W�8a�b~�����s�0�*����u��0f:H�:�z)
�A(�L���Fb;0�A�ڻdƌ���l�:�:��F��y�2���|5>:\xn����L�EX���8V�f⎰Q�n�t�r�S���y���&�p�">��h"� �Bd��D23E7,5eH�C|�y�m!����h�`]�
n��_�0B O�����X	v��x�0���3ltt����g2z�OGDfL\Y�+#8����kQf�B�a��#� ���"@��}��(�\8��#)�#������n�(cF���l[�%�z�Mz���}��i���JY[���Mt�^�!s���@�4�C��ވ���6�w
!���y��y�i۳R�`�v1���?	tA�*��K��3��Oa(a��S����:H��9.����^	��)���(�hj�b�,
����X�7�J>��O�:Y,ը��^���A
��.�_f<؊_bͶz��>.@{N��l�ATlN� :��p1#��ZD��$��.�9<I�l��8�	
�nB�i	l!pO
ړ0��}����tC4�1��f �4��*�}Q�C���!eF〵�Z�˞[��ӕ��J@,�+
���-�5zs��l���NO�J���T8#����\a�a&�^�e��Bԩ
$���<!|pZ[F���
>F�cF`��\,n�wz�xs5��G6R�Gn&�#l~K�΁���2��4m��xG��?������T�9����[G(��D�Lڄ��hu����f<=vlą<f5E�XfJP�h_��E����V�y�����/p�����5�
�/�Q&y�nv�1S�/b�8}��*��Fas%h��0��2���xP��8��װ]R5�G�H���ĠU`�8#]���??���]��W��[���#j!�d�YU��-����8�eg6���4uՆGx%�Y���y���B&�e���� .==~�-{�ة��Ԫ깂ވ�^Ny,������t53z�`�ҭ2ˆ�/�~3���b��l��TP����!}c�F��+ʙg�
s�_jjoPUo���ԛ��O{��Ƞ!8N�#Z �u�Ϝw���Y������U����a�K��� ��:���ut2��[��;黸��-U����ќM�z��s���-O�˕��"�V��\-!�)F@�#�2��a��m[	��w�7�B��93�$��F0���1f�,�d����{��&�{�'ΰ�q�
#;�����+�3��,-��bp�>�8A/��ڳsT��eױ g���`7����O3��8�:Y�ƢV����w�MQSf45\=H������~�a����#9P0��>O�m�^J�ydz�2�� ����{������옘`E_#�պ*�2SE��о�.�9��|gpOp��2��t�k�2f!���c�r��9��m�ɱ��0���d�u˔��!vv�j�E�pK����_7?n�5�؞����7��su��w`�J�2��YH�fR�t�=@��ݯ�d�q�'����N�-��oC��g]
E)3Ջ��Js d���v2;�T+��q��*��a|�2��T,�hx�*e(�bІy�#��mHql��F�(3��<�cXZ�����6��^@ބ�m���ﱇ��mX3q��`�/A9�����QWc�'D�p����wa�5c&�/�n3v��[T}+�Z/ ț�"$!���VH5f�Q+f��b� �~�0z��'�0��F8�Pv����Q�bY�0�����O�6�����]n�"�rl�;�ł������$�#��c��AL(�ī��ߟ��e}���"�G���)vn1�#����PM�P�O�)�΂ ��\�>�A�y�����}k�\���� kp����=��g G,��8>���;�3��e���Σ���������{<躖k���{�2�B�3ېl�/,�Jf���WI�V��>1�5�Y޻�����z�qi�5���4�!���Jе(���ѭϷwۻ{p Yz}���%��~F�����y�4#�\U@��̜�b�x��|�����ıN蘆�D�F	�:�ta2;e�u���a0+�
�b��#�덚fy�y�"9b�@T�c�&R7�2�d��� ��v��C��ϛ������!�	�o���%�P�RA[���0�HU��׾8����φ�F�uUF����sZ��Q����tȲM�R����SD!U�(VgG��� �a
���E�*w<�L�V����<�L��u���:#R�d��t�� .v(�F�L�.�)�Q���,���?�o>֕����ت��c�$!��o
��e)�}�?�:�pZ�z�qܬ382���l(�Vʌ�5���������gj\�Ʊ�{x;��}���#{j��xWa��0���u���L��e/�Ʊ��~�0(�4�|�=uFWi�;�8���Y$��h���/`��̨P,�pը�㟿��8�m?~�P�[�B4�|��Srl��s����@�>B�ÇÄ(�n	";�C��wpl�Nj+����rx|h�<�
{�|�ొ�P�D�{�ƴ>'P��~�}�lnL�JI	�r NU��!̔�d�f�~âvqsg���pp=�X̗�V�!�u�8?08F�
[��e�Lf�P��A2��X]�/���/�y�M��g�+#��`,b������Ƙ�H��j�8��)��SpC�m���48U�c���wO}Rfac5,5�cVS�e*}���3�DG4yB���7`�B��3[(���4JN>�<QG��8�U� WJ �d��L���,�fa=��>q��M��RJ�x��'p�^W$f:H����D�r��	����=�F���jru��zz� /���@K�ƌ�\�kz�������ԩj,x����I���Rh����jrӇ�M���`�Y�W�ƀ�Dv<���e�c�;c�83����Y�+3k�AF��b6�9v�G2P���#� �]B�q{e�r������wk���7�w���MC:B6L1���(�	i���Z���'���1�ؽ�ߠ��e{׳���ՍA��J�t�YR���� ��v6�G�wu�v?�D�YׁjmD��B��e�a��XY�q	k@��!�#���?wσ�`����y���v���[�s$�)�X��Rù�nM%e�t<;��R+ra�GI*������m��[�Θ1�ņ�ZE3A�_=[��:x7_,�>�m�C0kZt"�o0�����!f��3�	�=�
`N�h�u��'���A9'u�
�1S��_G]0�/�����M���Qm]��%"$8�e� ��z�	3E�Xt.�;�)�����ܻl7�Y�c�W`VՃ�:�v��^�@&H� ��̥	��"�d!�L)�zПp�wֵ��~���� fpgD�Ρj)SI3�D��n�m{_�ص}��!���BHfp��P�9�3�x�mxI��}^�c�W�'Oq�h��?��Qx��jQg�T�Js��5��N.�����������Q�z�s	"ɔ��F�+���_�h�m�#l���W��I�Q��/xf�
�̗�uVj!!Tn�=�Bѳ���dԨ���NP�Rp+��:ˈ�5/�p��J�oΨa�*M�`��BuC�'&�5��������`6�(�3NKc���75�:0�*+=�?Rzj!��4}=k6o �6������Ys&!����g��
g��:���vN~�g��5�Hd��|eR^���� �AV��NSv&�rM����>�$t?�����Ш��3X9����g��q�����p�%�FpV�=�ĺ��C�$� �ʊvu�w���:�$O�7�y�Mye;�ԇ܆O*��I�S.��A4��b��;s����wWKx,�r!�;��#�&����Ǌ|�p�V0"ęb[~v�4�E�v�Q�Y՛:U&�    @uթ�! ia�F2g�1��ô�oڮ%hO̢��K��̀UYW��g���;6��?�{�s�@�����95��+���a(u'���2\:�Ծ\n	����C�K�
�<�2:�[xF �ax)��\���;��V�"�B^�U�`�AgJ52�2���@V !�u~�Y�?���۟W�X�K����GVN�3�*�sV:m�%-ee�ԙJ�,u]���]3/�٣
^$����oWA�g�U��D|�ԏh��w��2����l^��δ2vݶ��߭��ߑ*��E�8�F짙�q����d�e�X�䱹p�=0]-��4�+O��h�!;j���rר3^6�_6|N}����`�����'�`p���k���0�E>��Ĝ��@T]{�/p��a0�_>>�ow�۳9��"F�B����ba�"@�q5-H:NN���vOG�6��uӵ3�Zk�p��,�TMw|�L�U���J�Z�\���;�E�id.DkBj�mA��J/k�o "������U@Nnf���s��n�"�c�*f0���˝��oU�jG�*@��"B�/g���u�R�É�:5�[��~Z[g�I�H��j�-��<]R�����XтB�	���ۨHb\C�"��x����t�dx6�Eׁi�b�284�7��y,C�)3q��$?�9������	�y�z�N�׍s	֫��/2�l����gT;B�Ʋ�L��2L�kI�w��o���WH�D�A638���3�Y�]�Γb�е��1^><Eő�#�#x;��.bW}v���x~��G��X��p�Hf
�`k�<{g,p)Y��]�W������}%���d�gi0�(���<�)�é���x���`��>U�%,��8+�:�씝�UDz)e���b����l�Qg*�S�d�y����W�
��iz-%3�*,� �Tw�![��'����l?ZZ�<h���xĀ`s]��Q�I�4sꀼ>�r� -�b0/��·D�z\��H$3��D���k�x�k*�Y�Mv�Ɖ���Y=���`�qW4ȉ3��KL��o�i���S� 	�%sA�A4���<ӕa.�ѐ�|��+;z����~\']T���P�{���R5�9+���/�։~L1qp~�y�5���X���@H���䭈3�&�`��kB�_���0�l�+��� �����W�Q�a�#�]�@��wV#f�f�%�s��3�SZ�Z(}�B�V{�y�Q��h�E	C$�t��'���Q���Z{K�W)i�'5 ��+��Y�T4����_9��H��*�A���9�4Ɉ��BU/�}X⹜nn���f8=��LƋ�E2�����`_`o0���
�s��x�����5��u���3�(i]!�"��b)(�s�d��y!��'�&l"0��Lą��B������k���U/����g���zq5���ir��A��0b�ᏤҌ�;���uԮ��D���J$?����*ʥ�{�/�k��_��FG�uw�U���b�1D����5
>��}D��H|ku�uL��N8�h��Z�*5�[�?Z�BU��7�'�Ж���O� ����� ���,�uĦ�O�Ϗ�y���z�@.���h4��.��F�DY/,�)1D�Z*0g��ّ5����r{���<,��^�3����Y�5�H�A �V�Za���f\qy����>�tӓ�{TD}v�`�A�"T����1f��v>����+�
�<@�t֣�5�`��0�Qg�>���Σ���;$��L���Ë�b�~���ꧮ��t�aq����3+��L�-V�߱<��X�$��G򻶑mb���\y��3n*G͘���
�Dp��v�q�L>>������ �7p�v�AH�@R+����������ƥθ@$_F��������v׽H�@��N)$̍Ch5`�OU�ݨ3Ŷ�-2�L8m`p��۶���cf�Aࠏ4�Ԁ�F�i[g�;���ܾ�6����������c��`e�pg�f���V*XĹ����Z���,�g���P �/�<2C�FU�t�3�`ͅ�i���L���t�H�2y�D8%�kG�^���L��K�]K�\��iԊ<4'�"�638�c���gz'���N���IsO�"W?�"�#����ĀrB���%q��&{�-�0lӫ�U��|�{2�����w��io�<�V��3F<<#���b���8�?�i����oH�DF��9��+�a��p���\���m$_'k���[����>������W��L"���|q��SV�1���| �� O÷��u�a7y���� ��k�	u&��/[�綪y
���y��JA��`��������>gHKÑKb�vo��]p햻H�q��J��"A4���Z"�,��Pϧ~�G�@�!.���q�L��bca��FI?0�H�b�|r:똪�'�>�;Fn"0�N��1q&���q�`���?AJ�2�VD��"���R��9����N��g7�d4Ʈ��x���LɔDz>o�Wɐ~�B���avŝ�h��W�R۫�a�#�#�d5�:_m����2�l"j��Ι�R�د����������ΐ����Ϩ.��� j��KU��̙z	B�u�Z7�	��`��_�:�`4�v�&�y�w�q�Ԁm�P*�1g�M來�.ߐ����t�Kѝ���5X��6�@��W�3�B�N������y����)�T��@�)��LJ`ѽ��ę�O��=��6ˎ��h	��ӛ����������L����Khx�!�i�����:�:���8��Z����|=�wOX̙�ېzRdZ�`�e�;g꒰�7/Eb�r_Y�����(����x�2jP��x�:�
���o"�9��[�E;��ew(Qm����
js�ęrNV�5n����z�]�=�RG�%1`ږWs���KN�|�|���n��ϛ��-gV.����9�+���f�X����3��Iے;O���H����	|����t|qյXG�����HB��g�d�^��Rę_�@e+��ݙ|7G�D׏�S	^�3��&C�9��*�:uƷ�r~?��J�1��ũ���5��q:N%Z+��B~�\Y��θɿ���U|��ok�pK������y�.sL�`5JS1�S�V��{g�Dx���y������w����5�����ɠ�j��Ti�S��3����4�&l��Q�6��!��ϸ3���j��`�w��#]�A�+5���B.A�'%z��2�/9Rא���j�n{��AC�.j���C�3�,P	d5�p�t�y�������;�.�nz���2�ב�Bu�w�b�f�Ɩ�9}���?��O�?-�V��ۏ�u�Z�/2��yd����Ts�$["���{���v?
��\�q>��{f0X%��I��j�3ɩ�ӸKK���i�e������G�FIf�8̻��Ϝ1^k�~�k��Ee�_>�o��%��ﻎK]���
�H�7I�a S�2�3��jdy����;H��z��eI%����e׽v�ʢ1��m4������־sƯ�;�q���m0���_�p})�hx�u���s[���2�D)��ɜi�Ʒ,����X�:��34ld&������{�*I��Rlm9":]�U���>8��6����e��K�hy�Xg?������F;K����	f�3ҕ��:S��&%������5V|��T�q�tKBK+J�/s�v��l/��]oW��ɾގ!c��aQM�ŷ�(�QQ�FFtq��l��������#w?\T��g$���h��lC9Üi�J�쩐��\�.uX5|^�f��[�6��L�%�KkŜVOn�e�CIΛL6p��!J�D	��9b�X�c�(�9�b��k%��+���7�ch+g���Җ$��㛯�t ���&�Y�h%�N0$#AKd�RN�kӘ�Y����1����è�||:M����n��<�-J H���+c$ԙ    ���\��p��r��)�c�ט�ϔ��Q#G>�tP�քJ�D�t���x>�O3�aӐf�<�^�0�1--�p����VYz��&E�8���e� �����θ��+~�y�Y�A��]�i��:8T��� �� j��ĉ�t�����b�+�����x:�z�ִ
60�!���eї9K��/V�H�z�t&ވ��I��K���u��쬭�DUJ�A����
ghm��%'�lB%�"�Xo��eP������j0:�L쾘"�[b�A6Xߥ����/��9*������n�|�-	�t�5K��~� 	5X�l�JHu��=K�D1���rݼ�m�d,�� ��n51(�@�Wy%����i��s|�-L���������~U�	g��p~:@}%�C�
]��G�>�-1D��mYF��yR �<g�&�������oR*���I��)��4� ����A���t�,HJ���M<]R����2�nx#������+�����B��<%%�����N9+����|��n�t���AP������VU�3���v�RI�)������4�Տ�ʾ��i�XX��µk�R8�SJPg%����B����/�뇏e�w�����!6k0F���gxWa5�Rg©�3lwٛ�x��]ޯ���>��X"�\�u^vY�W��R��z�'�_(u�$��޼�f����[�n2�/�p��85(�}(k�̙�C]H��s�$q[��+�[�G�!����fp����  q�ޛd�R`�C,����iO������f�~v�u�)��E�-f@GSyo�3.��2����L��1K~���ϯ�R��-3x���J��8���YQ\����?�|���l�l�6�R��8�S�y�3}�|;y3�f�͟I�~�S�a�kZfO��15`��GRg��4l]9*힐��%Tǧ?�f���|<��g�:�+d�;$��?�/K��-/���i���{�]=�Gz��@��b��|���O��i�5	�[��u����^�� �<)f=<Q�8�b�}�[��mo4
	�$�H����G�����g,
~�m��;|78�\����� ��I�T��G�l�w� ��>7u&����{���%>2�1O�C k��:0���
-<q�c��1���oLA3���E	ˎo��Z�£(�j��\��ʜ��`��݇E;-����U"��pe(8w���9����? �a9�;c9�8��h���x���6����||b ��ᏳyJ��w~�����rZ3�W@�]i����a�^琨���<���#�r�G-��C���HwO�h�]�Rg�I��EͪC�8U+�կT�n��!ʍgo��6�������KǎD�������y;���lȶ���� G�J����bu�k��a7�b�\�GV���[f�������w��9�L��ҳ�8i<x����j�ׇ�p;^~z����ϻ��<r��&2��B�Ze6k�q����k{���b��>�!g�C��>:*s��y�B/Ԡ�C�2�&��Q��~�$T��z�yl&̖�6%l��!��8�6T�sVJ$-�����s�6{Vum ��mÞ�� ���S��C8҅�E�/��#���|r}1�@''=1��G�?ڟ�Q�eS3̙��NM�9cq5\����h�=M�,�TR�yUb�L��V&^�TR�[ �z��vIl@(���(�M�:[a�fΔ4���Դ�	d��v�$��u!����1��J-�:c��)��C~ļ����tx��l:�������h��i� ����H�q����	�M'2.��G���z�6s9!�accU�p P�
�8c>ذ��v�N7���,�V�����+ܟ������d�չ�U��9H�r��D�1X�����Rg���Ԑ֕�>s�.�Ӯ�X��/E�0HC�6�6+s�2$?���&��/�O�5�}��,ps�:g�	H9�1�Xf�gRW�������Ԝ�Zpp/f��uǍ;m�``�G<3�7�\��g�ԉ�/�,ơR��d�r��m�RIfP�̔$O��M(�5ڦݶ��a_���}���*f@�Ɨ�K����[�j��~]���#6��W�O�
Am�\�&��$�A
�,3����^�3��x�k�V���Bķ�]�L�m-�V5�  
��v��x��#c՗b�~蕝�<��E��rԀ
���3gj�v7�4�mO�:���V����^!�A)�K�s�rЩ}AD�41w9�8�w]�jZ"�Gp�R�l���:S����9~n�U���HG�=�� ��}C-�dH?㈣��Fw�4:����������7��燏�����������lz�5�e�i<N�"���&�$b�x�H^��U&�=�\���Y��	�m�t��J	�:#\��caj�f�a��M���dF5J1�Fv�
;u�'��\�V�y����z���� a�"������� �֙�Z_< .���ד�E��Y�]��Kb�I�I-ʐ�9ci �:���ԇ��-j��D?��
������Ԣ�3g�_4o�9���h�~�DӪ���3l��48�U���$�عd<A_�6��U���5�j��O�K��h�ΓrĢ%~��!����y��kHS�2�߄w��7���?<�N3��#�^��cy�<����i����^?�=Ç�q���賀	���t{���gE��:OJ��!�s[��!3��g��,c��a}F8�u�=��`��Ĩ2�F����w�'Tp�Du-�&6=��pNB�^M�}�����ɢ�����M��`�W��s�D�a�\K�|��y��<<��˞_�Rɸ�/f@m�+�0ę^����٫��)��`�$f��
�"qƏ�ag�儮<�û�|\>�I���~s����������1��e�:�b�\U٠��Ƽ�HP�]9����@�Ż;g��X �_��ࣷ������@B�ct�J�uƘ�7�T6?���_���*�'l!L;������t���p��TJ��yR�}��3��s_"�N2�G$GE]�:c��X��s\�RrP��>������b�"Ք!u��1_�?��ﶫ��V�A�E����C�6��r��9�]��:c����E��1� ����!tbEt
'_��ɐ~�w_Yc6s欄��~��s. �k�sK:s� �ıgjPJJW��0g*HZ� �Cҟ���_y<?$6,�@2��:1zWF��aJ_�sE�-��۟+��՝�.Ά�Cv�M]e3W�ϩ�B�&Jj2振���T閉�v�|z&I��Z{��	2=���sb@�Q��δ��.�?����=
e�pk�7kO��:3��J�� �`�ա2EH��aE���T�-}���ݔD�8��7��2���"Γ�ڒE�(�;�K\'M8q�bw\02��[��3U�Y�ꠝW�Kʬ�8i�X�K��8�p�3�I9���D��
�m,����u�G4� $ܐ(�9�w��H��VF�3��fG��w���me'��>ǳdY��6��AKT�D���G��B�����+��k���3H�!��HL!���:co�q؄�E�������,O��U~߹�G�GT�28�Jp	�R�;c���C��3n��D�(��Z#p%�q�E'C���剒t�Pq��Ѳs��6g���'�����5��v��T'�ƫad̠M$^��Z��di~(y��VE�r�7�Ũ��@��r�	[��Ȱ#+���	֑�a��t��qE�/zF$'F`Tx�C��H�Z�Z�w�md�ih��-4�`?��I��������<3q@�a�:���t�9�`�[nY�����M���yf������'u�У����8���l��8�D�'g]W2�̑6dD����`q\�R+e��J8�������i�L>}^m1 =߬؜g_R�.5�d�������L\Ʀ�3c˗*j�����_�[U��&���4��4� �ײ��d�xX�Ch隯v�W����n�v�أ6)�.��}�v�9S+����k򤙛b    :K&�:g�)���Y��S��UpeV�Ž3�|��5��s=��\�S9�H(BS��2uƅ1I��"�%=2l��&��Qp��KS5](�]EV�	¼�V�9�l����7�p�0J��o{g,���V��:P��_n��E�_&���TSg:�,�d�	���Q��'���b<u�"��<�Zk�De2���zG¸Ì�;S��٭�yF_#��~�*�Rc<8j�KÇ�}�9�j߼P)��`�mC�P��d4܌�7�Q��q�,��p�E�A�H[F3ԙ����8���j{�]Cs
�VO���ڏ���b��!�M��H�!=��?e�Ư'W>ߤl�r��W�L)�B@����R�$ ���PQy"���7�۔/)vMW��-Wo�Id��}��E��DBK5�`l�{yP�3�!�M�kb}"��X�5� �2z���<q�}� u�U-�V��#]@�wB� ��A|Z*#q&\c�Ҽp\[�T_[(2?�q�8�Qak�[��g:�,}�_�B��9�b���D�zf�
���Eꌩ��"oCmW� �*!�yPm������٤�F���iS�@M���9c9��h8#rR�^ߒ��!����Q���7��֙���+i�-�N�����H�~������@_G\��P�-#�He��OQg
J�Y�d��o�P\�|{߬�u�E�Ԁ��y=�
��K�� C�N}|PL��b>��E�����짎O�N0~� �XSB.D(��*D��5�����5ߜ���L�X6jh��
u��<�ȃ���9���U↣��
��=1���Z�M����dG��8�}����`|�����O�_|�,�1���{�M0̠ Xiʲ"s�����f��UZ�[B4�̾����j�1Whju����$,�ƄK�q���VeO�6.!$#���������f8=��LƋZ�vĵ�Dv��X���2��[�d�3ޣ�U�d�{Lx����Ok&�6�Y�[?�����v��k$)��H	Sv՘3�.�G5��xjIT1\�>n���v�ņ<ҨS�	nĀs
M����x�x޸P���7�qqM�D��U5��A$�+oU�<)�BKh��vg�������򁔥 Jթ��y\˦D=mx6�a���ju�g���d0&23��������1�����30�H��uƻ�W/�!�ͮ���;�b]������1�B4Jmؘ8c*eإ�)�/������ϼ\r;�eb�m����@��F�*MR�Lʂp]e��?��"�OO�im�f����u��
�G}FD�A����ܴ�U�|�;�l�-h�]-����_�g�OT���H�|C��R:j�.1��15Y��3�T�'�e9�	�%��o�:f���ű'l�Z������83�����Gr �����i��3C�H��tx��K�mA�"#J�����\Ci윱�qp����\�,������з�<�>�ȣܑ��H�`��QeF�8S^�"[��ډ��λ��h8���v{r�up��f�p:`��.Ʋ�٦θۂ}�-Ard{����;����>-���y5����
�4�Cxy����E�uB��YgH��ϣB_B���#*1���i��yY��G������C4��v|�e���Dj�e��R���x=s0��Z]�u"���MbSoo@m7���ٙ`X�#6����>^h�ϛ���ytST��t>*
C@р�����(�O����BP������?�Aj��uA���`��s2��`�H?Z�w�O������h8����b��c�u���D~�����s��L$sV�&S)��=1���n�	���}=�~����7��H���P��E�
�qF��a	 �Pn�4ûX��	wCX'wH3zF��{�D�KC�)^�}>��7�X[,�PL�b�S��8�"9@VEj��q�\s����/���q&�'4��H	�|�ܚ���M���:�g�Ȅ��fxG��G�c���+��D���Ť6Nw�mL�#E6������w��'�-_2)����t�i��+�<M�W����nێ�Y��(�J����oT�$�3���;�o�}����7O��A�xc2<�_	|���V6|S���)���t�ljx�~Y��O�g���gg�4hY��iw�����N�>x�y�[�-_/wy�@��������0P�"�ڡ������1�!�kE)�_��J_����������E`���dr���r�E�$e��9c��q����f�b�/��z���{����c�EjO�1!7�!&�T 凘�����4�>�y�}���Q��(אm�P��PbB�("�Lo-_c8h�_n�o��v�������� x��?�ʭ�]}��n-�A7;�%��:��gi���c4�TϏӻ�F*|~�AK�8+�ę�vC9V@��bg�k�'�:���b<�{?��4�P�jc3��b7���K�-c3+����Hz{��8��R��3���Ueލ:S� �-[s�n���a���0�w�5fX���i��P���<��8c� Y�ر��
����o�|xګ���ջidລԉ�D��t#�T���%�����Gf�er��L���|��jr�S !���eHi��p�S�I	�;�n^��b��&d�C���֎����)�&Q��D�'�"�E�q�+��83��W� ��؉�A&�����9�"y5�}i�X�/������A��5���Wup@_d,,r��4��\����D�a`#���tZ�N�l���T�a�X9kKch���϶���?�a|�Z���$���[3�Qָ���������/��^�_�Y9�2[Q�� Z����;&T���3%ᬘ�R5����5$k�/r4�&��B�����ߕ�u�����T���r2Vc��\������� �I%+7)q�\���9�+>���1�/1�s�ʟ�RF��EC��a)3Y&w��γ�3�X��gj�I�ԉ|�D�bb�Jվ6��gҜ�y��ě��F�,�o��iǻ�enU�F��KA(,�M��@�1p�]�B��ύ�}_�Y� �*��qf�"���`��3u�<���T՗n��eȈ7�_�e�r��q���#5da� ܬ����1>��j�E�Eb�ȦX��Qg\�e<=��)���p�C����թ i������!w���u��b{֒-G����p�#��$>� ����n�����nu����[��܎nc������L�ý�4[�%��ƚ �=5 �����3VY����2[��V��7��>_�"4�{�A&���p���1P��js�f���S��-om�T"�1(<��&s����A�=D�i�ޮ��b�,�t2�:Bm2�T�k��� w�w:
�L�.��4��9��À�vc��#�$�-&�UE����].��� �Oc*W0u漘�w�[�qq-�v/��g�ø�[6}I8�kW⌭����VH}�s.�o�R9*�R�Q�*�.�Acf_���������x_	K��C�a|*�+��:��j�~��q�\>܏!]�y�92Z�y����������A��y��9��x=~;MP��l�o�\��7�m�R�`
l���<IC�lo�Aj�X}Z?���WA~��҉riAb H*�nW��Zg�����nZ���$���i�����5l����p�;�]6i�Q�U�YQ>��Y40a�9zmW8���؛Vx땫�:���R�oA���ހB�5r`�L(�^VZ<�u��SD������<��iPj�Ǚ���*��:h�i�ʾ	�ۈ�z�e:�b��ҕZ	u�h��յ�Y����dF�� d��̀H��qQ�ك��{[���|��O�u�a�������j��e�?�k3�,�
U7uƇ���/6����2�W�Iǵ�&�,�T��lp��C.���D�q�T�B7-������z�ڰ-�4b~ �e�*�=�L�	�i?�OHRzUU8�t�ܟC��`�&T�m�L    ��4�C�*�3��_Sp��xa��<u	�ũ�[o G+�v����z������q����9�?v^k�L��֢*�b�$��06sƔ�#�<���n��
aۿ<#�ry���]�9����8v�G�Ѹ��vT������&5��C��˜1Ρ&�`�0��v٧���GZ>�8�ƒ��a�|_2�j-="D-3x�t|�©3U�hSV��ñ��Gt]
�c��ux��!�,��F�wƋ��9��Ƽl����,r�u��K$PR㥉��̀��,��L-���������r�����c+F
 =r{%���e���� {�t��`����(G��7�&U����t>`�[�փ��á�2��Δu����>�Kv����Y��,�p����j��Cr��%��f��q���6y꣢\R���t��\d����/u��3���5�ْNޏ1?��|�d�.m�!3�#3̙��e�Z\����|���.��?_�u�B�<,��$�3��T�BL���RHyș����a=>039W���}K@V`�̀5]�s3g-����&����f���<�0�^Z�:�0#g�i\�6��T�}ę^ͮUV�Ƀ|�(�w��6�>�ȳB#��.g��]̑��kğ/o!7^��o��w�{^�6W�y%$��dc�OWI��3^����]g��d��x�͊ "f��8jP�����p��x8��l}����y�R���]/0jh��>1��
adQ@��lz�>H9�����~E�^a��k��	$��mC�G��L��OwF��g�����w�;�^G�����l���rܑ��Ỳ��
��9���_FN��ԫէ���D(E�\)��\.rm��i�r��9Ӗ��G����?En0G6
����D3U6���σ}l?{H����������qy��pp:;�\Te�Y�m�q��(�A;��8��Tg����&���#_P�<&&"�n��#'D|�	AY��F��i<�NUM�kGQP #��u|���D�i�)�[��yr8k��8��i��g�(�[{a+�!�+^*�
�A"!�.	F�3�Y�=�c�tE���M�������p0��=7�3�PX%�f����\4uV�0�Г����=�����쉂"���8�N'�+�9ԙ�wt����Ɇp�����.�g����g�!]�<+� �����g�HX��,nj�)��V��`�l3�u�s��I����W��,H _e:8Յ⼯�����p �B}I���	��f���
�4�蚳�����X(1� �acT�B���>,�Ϯ�³�%���T��^����#YZ!�_�z�!����8�G��J�s���u�u1��}��w�eO��&ia��;g��nFϤ1�Û�;r��4,4:���}+,lQ0�)fN��D�0g\��������_G�a���~�����	�>�F������B�6tZf�t�T�ؘ������(A�NW�H�K�vǌ���)�����%� 	v�D�9c�xHd^�C'��w���O˲Zg�î��Nx�X�U�c��5T��ę�bG�x�8�E1�ׄ��<�
���hI2��"TT����.ȱ'�,�x|:M����k�Z���<��#��`uT�.�6uV��0J���@��ef���_�����#KfMIt�k��R��!���1d�6qȘ,B[a ��Xw9跘o�OR�=��������`��[��9����
�Z-w�����d8?끙*E�"�,�5!'�Ph�θ(�J��:���� �?�������󮫂>cӌ��q�3x��/dԙP$��ҿ�f�rĹ����l:���tYZ�8���`�A��4挕y�oO�5�!H�7�O���l��W ���� Սq�$� �b����?F���Ћ�A_�`�0N���hS���=<)����5�.ꌑ�e_��sc�t�]�� CAD�q1E��q�-�a��P�*<�s�b�f�S��@��H����f��R�Ġ���d�J���J�.F���5u��nH%&�Ɛ�Rq�������9,ڏ�C<l�Qv�B&OQ��̠�C+�w�k�`M1�ǐү=�'s����C���8�H�Q��v΄n��f�$"�GH��(��_�l���cC��\U�k8��3^F�a9l}b�����j0�>�Nvz�
��3�L�.���G�~�l�"1 �����ΙF~��rS��m����S�9Y>����|<��f�����f4�[7MB��oߠ;3X�=�2�Δ��W����T$9�K ?�� "� 1HY��\��ղ9�F'��!�G���f�h�F�xx$�P�`��5����3�K���9���iy����������W�N�O�iќ^�|� 5v�*�I��Ĳb�c�������r��U��o�%�;��>�'�]K}Z�op�*Xm��W��4ը�$���nւ�?T�UN�f�N̽��
Ϻ��Я�4���R��T�{�L�-{J]]u�0|��z4��v}��\%
2� ;Bp���T���8��)�����\J�p����~Ѽz��d=@؎4	{�	��r�;��?�4=��	�=��^2��Ylׂ��q{o@� 	�Vy��x��?�n��wS�pVo󮩼'XM�w%GZ+E{��Ez}�$�g�����!��+%r:O�(�������2e\Ȝ1�i?������]�A�A��v����sg���CXK}�.;�*����Zى�3����}�D��y��Y1ؘ�ԤZ�3��yגI#�@;zت��6$n;�w�!�95x\@Sv��3��%��
R+�d��*���	
N�
g�t	�a�Tfy)KSjԾ���~���);bpH_^o�Γrʮe�>`+Y����uu_�n���OFY��"دDVQg� ���ѻ-�K�U}̙k��O�OP��	5h�/{gLP8���'`ҕ�0	��ZLԛ���s��=��35*8 ���NU��.t�°��=N~P��)W��"�x$y2�_�:{�я���0v�3@��HS2�Qg�Gs�����ެq��O���q�:U��D,�26ٙ*l��)7�7��������3;��H�ü�;t�a��H�C�q�@��و $甬�(2�I	.�. J��T�TY�<Ș�a TI��3�=Y��ߐ
t�/�>�y2�ϻ&�
M��O��2�A�	����ⵠ6񰑽�����=�MD�1�O�>��ܲ3����ZP�l�'��=�M�]�3��Yٲ�B��9t��M���-��nkZ$�H�/5�`��hg��8�mp��tU@��`��	\ ���r�`���R�:�4���x��>o�Oq�V���_~;��,�/=�u-����!EW����P�EW����C�>��㑽�>�*B�#1�
r��J;g�*b~����m�/0��q M��@UԒ:�9˼P0E�?��˻5b��m��l��[0��&=��B@�!�� 
�Lw��ޕh�F�����}U�E� 1��(��LEb�vSգ�$+��y�z�p��D
�[3 y�(�1�36y�*��)���7��h����U��0,`��`�/w�:�U�4l}X�x3�i_�����@���y
"���A�:�,�(8��1̠��M]0g,]@���U<�Ç?o%�pz�}_
ձ6J�qؕ�����l���p�ר��I�d�#��S%&�9S���v�=1�~Y�n:�ۤ2�>"�)��c����'�s�G���h�'���Աc�O�k�J n]���m�Vi�i�Ю���Ԇ�TЏ����ޕ]��ý�7H"[��β~(8��KR���%��x޵\�N\*i@V�qZb��v�q��L#ǖ�^H���k�ڻ~�3�?�-��S���ϫ�<F��=<�R�R�!�\9��I��M&֛��Z�W�M;g�n)���\ǭZR.�0��W�˸]�����a?�|-�������[~���yE�� ��_�@�i }���R8�9�	��­M���:�mI-͔P���N�d�:�>���WҬW����E�j�x��7    �,��B�oo�uC��x��ߘ��%\a����	�{�_�n�W��w41h��U)˜鎖l�%��S�/��(���#A8�Il�A����3�(_���km��|Z-������5bWO�$��?@.>@��a�Be��:�w����h���W�WB{�>���g-�_�9|a�3��T���c��ͧ%��wY&��w��1ܶ��x�oKY'E{���H*�A9o���̜����C˧<z�u��>g���_��/��k%��ë́9�Z-_�����/U�V�.������G�)��Ku��K����Tb0�UJ�3g�by�]�������np��}Zn���'����pnB��G�7�oq���0i����?��}�<�ԙ. ��p2����`��d]��O�gד�P��+�IB<X-m@tm4ğ$!��E0˝���A�nA�9Y���9"���N�^��0�,��Si; o�$�[��gA�.��3֓�����|¶#�I^nW��ϟ�>��&�\۬k��2���Ǔ���E�����"��9�����+3��a�6ʓ��_�װ���'���)�9��79�SKG^e�=��������l�މ����/no�г4a��G-ܪ��oz�^���|�0����Q�Lu���u�ݺi����R���mW�o�G�c(�#E�p~5�6����L��<���F@NYV�3fc��h�_��
�Jg��v����f}�]o�HD�쿚���z\4l��F��\P� �/�	�a%�&�x]1���N�.!x�\n�2�ܢ��w��pt����/��'���a������'Ǿ�r��x�	��P;�/`θ���ʝ,>���?�i�1�>�ov�����b��]�{�X������]4��= yS��0g^���#m_��v� 9��h6����R;?)�a��MQ^<�h�tM�䇟׏��6���燇�j����/������jpG�>�~���]������x��p��x���U+v�"Ԁ�i�s��<�?�����~�ہI��lz:�λ~=�aP�gϙ��\E|�:c;�Ǯ��1�.6�Q�A�l1�����U�+�ܣ��DMb����@щ3o [�do���i�������UFC��z�\�b����g̙�<�Ъ=��D<!���v3��!,�q?�~6�e:�r@�4v�<5�>���uƐ�W��ZX��ϛ��w�d��=��^P�c�ɜ=b��Ġ�&@�V�@�;c�,�9�o�����x��_W��%�8��S���kp��R�$Dj�%E�(GG��J�3�j��ț�_�A��7�0���?v|��f4D"
�+e�nHc+s��/��j��t}�������O+�w~�˓4�&W�������gV?�����bV2��O{͇��ۇ���K�EnW�����-�;"��d1v��x-j��tK��$��;�3�,�a~�s�o���3��8��N��m�\/���컮�;;y,O���1����!g�W� �w��r�\=��p��P>��.\�T3�kSX��3�pܱ��I9(��8�.oW���~���Jj1m=�ތO����`&,6���bg!�)Zܙ�W�X|@a|����3(Q���~�U���|�X���s��&��a��]�Z��#�J���tJd��C��c䔇��g�2�������b�G�3�|r�W!��zT��*g\,�7�9�%��H�88[?@�s��������g4��!�<3)`1�!8�p���dg�m���]��]#�)���
�vr��z~�u1]�o�"�B��� MI�Ȝ��a!-���v󸺽��$�n-�*��Ǿ`�'��@����AE��9�Uķѷ9T1�s3��������\��&���
G u�OO�5��&������|�X,����p�����8@��+�-�ԙ�X3ڲ�Y�+�#!�v�a���!��WiNz�z�ɜg���JA�:S���v��Z<C�8X@0�!� O~ONχ�5�̃�1��J3��n����:cI�EV����� �����.���uy�@���? ��vE��ox�-�
����� `}� �qg���Ϸ�É��S,�?.��8_(W;�
��#���{C@蔩0�Rg\"�[���:�P�fj��7�󵉯6vǙg�+�9+5}kN���<���ܓ̏?a��uV!�<�[5�.�.���Ѕ8ӭ��h�L�!Y���#!f=^�㳮+P.�'�F";S�̠���T�䈳���Hg%����j��+������@��2ݧ��!gE��b������`]��a[G�'����ͨ< �T#F���:��q)�)��/b8�����ǇU��E �G�L�א4]���x>�tz�,�O���\�^
�J	=���/�{aJk��Ү/~����2g�8PF!�̊����Iɴ���[u��ra��.A0�����Z�[q
3 �օ2ǧ�t�R>��TDF����W�~zz}���}���X+��vk#�)�}(����ħr�3<�˨�sp�$��������Ǿ_�^L�Q�.KX4�ǿ,�g.:��?ۿ�t.y�5|U��>J��f���d��00���?f�x�4���g6�������x�u�X�6�ml����i�Z��'����C���=͏#�w,��!��H��\Ġj�/38���mE���JKW�C�����Cr2>�L'�4ȱ�e��r�;*�N�����^�7,w��߱v��a�4#q�~(��gnG�Bq����	�x�:Su8P��U��5�o�+x�IS`���Ĳ�臣�y��hz���ց���Jf 挸"�k�ɀ'���}A�n4���/�}3E�ˍq"�0τo�*�:�.���9�[Q�ě���"j�\���;�LD���KtJ ������A`��s>�E��%-�C�M;��4"I8J�y�LH�@u��ǿ������ӂ]��U�Vc=X�0��R]�`'��ud!��aN�l�s͞���7���5�coa�d��U7̐D�j�{g�B>��}�c?c���?�?��plB2�C����u��WD�ݩմ��X(�>�L5@F�r̠��
��:S}�5��_.!�~۪n�EŷC0���iY`�J[���(5������,��-8b���O�˞�:U[dO��ȍ��3|f�P
H5u&P�	���+�;�F��p�k<�}3����2�2[Ç%53��tM�˜�y����
6��������2����t���'3��eK3X����3��9�p����6��٩���U>�c��%��E��15�_�2�D��a|�"���K���b|v=���ye!M�A8)0$���ߡKg�$G�F����d�*�ǾN��-D8^Z�43D��R�9���o�y0	ǳB��<���F5����@Rd�HrY?��y�`�4� ���j�Ԑ�����Y�hvq�y�\�����{fP�5�"�A����ѶЍ�)$dțGRi�0�w�'�+�u�1���_�ԉK�y^�6&~�%r�/�v�D�2��,3�Z���Qg�<Cp���ڐ��Ԙ�]�H�'|��_�%C�~a	�a1�̜�hX�R%>�i��s9<�xe&1�H��(��:f�
���$�8s�Bn�9y�t���,��E_ea)�2=!�65Xܯh*SgY�-Gp!I���$)o�xT�%�A�k����sM�K'Wr��<�ǀ�p��%t*�A���;�Z59���P����V�3���g�V'���aE7���:�i��r�u�B���1��2���-A9����E�]M�����3�.��[��ؒ2)S|��/�Pg԰ A���u�ê[bM�r�)֧�������e�V�< 2�i����#q�ө%;��e���߶[��pdjPȳ^f��Y�_yT3�� �ñL�6��\F�����kh�NQ�2���U&ޘ3Fmұ�Մ�5g�M.F��t8/ �>�t	4X�<��4>�ĀPZ �  ����Γ~�+_ �D��y��Ϩn@H�!#����K�"�,�
�$��o�����v�!����|�ui~�tk�	3����nSg�_�<�j'I|���w�����U�(ܔ,M�Y������zv?�0����M3<����d��1�2�R��D�ę��<-Ş�t����>�^���t:;�u���k���m;\��wQ����V`�,������/��������)6��B҅Ɣ�`̙>Eö�B���a�F�o�F}T E��h����2�hxĞ�<����8�3��f�~	z\w�&�<7j">�A495��ESARgj��r�:R��'���?z<!�65���5�m��H�1Dg}8��ځ���������'W�ǃ)D;p�^̺.S���%�5j���&(W�V�3���FxM�<c.:"$i��O�]�x��l��m�B�H��C�`����e�Ü	��_���˿���l��      F   {  x�e�k�c����\�~�����rz'�H�R��llc`�W}���!�W����4��j���~5��*�7�΁i�����~c���jgMC*�Ew#R�K^9�rDԢ߁T3������Լ�j.�54�*}Wf��o�*�Z��ʯ��]�ѕF̆��S\R�ͪiS�"��9�v0L鞸0u5���L��b0�1u:-�-�[�i(oL�D���Ф�d����f��bf��cLc�Ms0aO�\�c��N�L�_�ڙ��r�zl�s`�(�L�Z i�蛥����f���SOq>���(%i3�D mVW��$z9'v��@��W ������>Y��1m�*6�11藓�l-�+�ڧ�<�y{w�g�י�G���%�fe�@:L�67���ݥ6���a��0L�<B�����a�c�w�8�X
@�P��m����r�d�{�}�</�6���1��V�Z9I��`>�>ZW�ow���������P���b���l+�i�����q�[fV0����b��0��wG>!��8}T���6��eY�)�G�O?,�Q�)�)�����+i�(潚��]o��T�e)� �5$��1J���۳�CmL- y<�	B����S�= 92�7P3�Z@�Cb�l�lo�r"@[�c��풝f�( ��@���6�}�{x���ݳArwJ#@2��ӻA�-X{�Q��/����q��=�C�C���>���>�g7HvΝ�ڌ轮����	o: y;^��ac�����:{�4$3�`� ɶ>Hv-@�|��c������X8(��l�k�[�����:lcfP<�a���!�6�� Y�kT�Hn�[[ Y�*��iP��9Jy���2mq�WT��%���?�r@2��N ��T�z�ȻPe@�K���:L��[������;Q���A���
ڷ.� ����S3Tи=^�|)��a�A�M� T�����nH��{�V$���n�{gm�� Dŵ�?��$���x��#�00�`��_2�P�6 �O�VW���C�a������]A��snx"�
��Υ��:|��Va����sF�gQf����7�+�P�F�lH���.�{�) ��s��4�{�� �n��|x�X��S�����O���X`�δg��pB%z��I�L���W~��~SV3H��|��L���L�����S �{�F6�j���x�����Ea,���@Z���vW�d\m�@�fK�͆��׃�Ҳ_�A�$Pmk�b|@r}�(�Qˆ����J�dG��|$��/��,��W�!�g{�l�P�l{Q��S��M�/@�}�z�F�T�;uMP���T�T~�{��$G�m����{��񔝙\ع�;^�^�� ��%{=7e�@���x{�O�B1凉�S
$�&Sa	H���;H�a�A��x~Ȏ�S�Aǈ��ٺlx�K��s%w�OfEM����uڈ@Ð�D��V-j����p"��ذ��Ͷ݃�7�.�	�.��G�8r ᤵj3p��71�8� �(�])��3� �/ҢBpp��-�w�@��cF�h bxe���7�0��$~��eP�NLvP�G �$/U@�'ќw[ �.��jp	[��z�t�>������ �\��у(7aa�f��>oby�� b߄�%w�<u,Tm���A880 �"��`�D���@���O���n�6��N���CWf���� �E���?�U��t4���3(��z'�61'T���sm>��>���8c焊���<����A�-�:Z�����\���_�?�.�>�Ng�魧�Z��}�9t �;�v ��D*�@ɞ��d�� |y��O��V�2���e��I�$�Ĺ�:���<l�w1J~�����-Om���&�����S��h�tsY�}W%G�K2����,�C�
�ܼ?<?T�Y;���ޜ� ��gv8Hg�F(�������A\���eĊD�Q^��"��,��77Q�|Q�r;�|;����}�Ѳ���z"p>7bǙ���}�Ut�/PV5_��Z������&RD����<Uߔ�7@�\���>�I�a����>�	�Ӣ�E�|���5Σ�O�?��}8����9hq�b�L�&�䋭d��?�X���(߻� Ծ���[��bVG�s����+N>"
�b�K���7ո�Ռ(J8����"�U/���A�y�}#�r<P��2�J�$�� �
D��矛j?Ts�H"�"*D�Ė�R����E-���x����>
󮾗&*EĈ��B��6.M�@(z9����
��6�j��M��*V�5<�WZe��]�w�#��b6�H�z]Z� s��X�9��0��]
}������fX�ݖ;�Fp��v��83�m�&/-"��ף�L�φ_�@(+��Le*�F�6sn.&d\R�m�z[f��oC��c���3���z�Y��U��*�_i��c�sn�i�Ǆ]�uG�I_�fz~�\�ӎ8���ٹ�y��Ly�^v9�&l��7�NQ� ff���  �n"�u��+��P^��0 �.�1�G���X�.>���g���^���WN�F��C-��n9�M�D�~#Ɯs;�QJ��i������=ل�rX�^?m�5�>�J\��x�Ɂ��$~���Η^��~��;����o�������հI�\���<f�N?��}�ME�ʶ|(��&z�P��p��)�Wy&���El��3 �n�=9����1�_�o���'��.6��0��`��p��l3�H}s��h& UK��p�#��iݦ�3����K�3�� Sݷ�'"1-��M�6�Ge��s�3fM��#Iw�ʬ5����u0�� ��Wֱ�q����x��#޵jqho��"��nm;v�ݻ��Ջ|p��yVr'��pѯN3������\G��/�,��/\�A�rwb-����⢏䷓}�$��n3��ǯ��&Xao�uG���g�ֳ���m�yL��
`�z�2�Y�'0G�q����g��������-�{9���Y������k���R���V�N��v�l���fv�b���Z���~Y����YF�~n{y/&K���o���6���Û����s��cw���s�������<Kk��]��S�&�_sܕ>	�ooV�ڼH�ZeYڌ�;� b\Da������^�� �\�@�J� ��!U6q]>�R����d̝7D	B��i�8"��O�ç�������&Ƌ����8i1�2�����QX���F���W���d��q.H@(>:�u�c��ܗ�+7?K�P������V���Uf݌P��>�*��n���9�O����kG#Vl(�BY��q�y�oeo�UW~#;��L��<x#i�e�3i��<���K)�b3��      L   �   x�e�A
�0E��)�@7E�U<��tlb'Skoo�v�����$�Z/����$6.�����K#�Ҳ]-�iDް��	��ӌ�}fL��Y�{���[m@�Sy�g�Bñ�w�1�j�;�`����^=���l8�      M      x������ � �      N   ~  x�mVٍ�J��D1	L�7�ċ`�_�?�Z>Ƣ0�*�wQy��!����Z�K稈|��"�>ӎ�����5Mk����������L�0^��O���.�%s�_ ��e28$}�D��g��GN���fv+=���m/�V�ud̸ �(�0�yL����6�8\�5�Z���	Q9��^����o�ِ(��pY^��	"ג�g�h<7-˺9�K#�rN��wy��9��A ��lsgd��컓��"�f.��b�L�ʺ��/�K�
��{ynK12�2�l;<�ǅv֞e�4{_n��\:'Bf�����g���Zb�ҸsI�L��N��9sJ\ ^���1��a{�����,��?�����煆"��l��e����e�L���vm�	����GR�ktBR�G[&H�?G�1<:,�-:�j��D�5�ቼ��֐^�(m�@6� Y���:���`�j �K���+@w�� �
�����[Д`w(��6:Q�� ����a��隃��]�J�]:�FA��|��/���Ф�g�f���x�[:����Y��I�K��YP�����q`Y�ã&���Ο��n	��BJ��;`�Փg�[v�~#�+[,o����	��(D����P�.���^��O��I��%Ġ{ߋ}U�Y�?��|��p4�p�7�~�����	S� ��X�v� �Y���I� (4XP�D��nύ�3�ī�>�}ٍ��{���5ٯy�}�'����F��S ;���`���[�A����z����A���n*����6Q�7�h4=��Rv �O|�bp~��in�C����n}*���ׅ&��=$�x1C�mv��I$E�^hN�v^E��%F�����ހE�E�g|}}���      P   t  x���O�� ���]ug�8T�FьԪM��H��`2����G�yz�\���3��*�'��}��Χ�
�
<��B�Q^�B&�X��
��mh>t��R�޾Yg����=U*P�9_7�As���~;"�KS+�t�z���{�ZSkټ]Xyh�`�3QI��G�ʺ`�|�$�ᔒi���-
>������:-c4��4J�Pn��!W�nMݦ�5�-��	7*߅���l��fh)cWU�&��� ����)��J�?���5$�U�*�����97��*g;nW�� Zf���O˦���\$͙`|��ٿ�)!|�)mQ��z�����Ume>4�����?�W�f _[ʷ����*�p�b�gY�H�ѡ      V   H   x��K
�0�u�a?�4nBRh�$��_g5��TS�r�a����㭫e6$yYF��]L�_��8& l�      R   !  x��U�r�6=����v�@�nV<��Ld�J.��LgEC4$���/�!=��c]�JJ�5�t ���݇ݷ��;t�#��u�i�m�K�Z�h��ڷpkc4
�px0+웎V���8�!�R�BW���
�c��Э�mݲ��rY�B���W�j���t�3�~���ȟ�f�����K��5��+�t����8�q}��ݗ�_a���v���U^���z��i��뼳�3H.��D�LOG��tw�vv{3�J)+�%� O<����5��)���i����C0�v�y�s8�������[�� )��ڄ��7�t`q{��J������Ȍ��/�̠(+ɹN�r��:��u��y�aG���"���wSe�)d^��X�y��Ê�g:G��0巐R~MJ�&_���z�B1Z�_�Q�q?ŔVJ�$?��ip3������?]��}X���<�1{IJ�Mcw&��w�yh>��_��ϙ`e�4��<6' u簤U4aok�G�C3>	�%,p����y a���v�u>P#�p������p��6��%=��� +�8tλ��c�?����Poz�ÓpeC�kv>���[2�`e��CN��J0��.ujV!httؐ��}H������,��wkϵ�S�L��G�%�I9d�â��1������m�~�;����,�e�h*�Z���ý?�t��{��Z��Ѫϕ'}J�XL�"h�)ͪ"9��+�!�����I�R;��~�Nm�kz�	���Z��裤��Ssָ�X���{M�`�)��.9Ӭ$�_./..���]�      S   P  x���=O�0���W��9��|�ǈ������RH[�������"��5�{�>grr��*nC�m��e�_�p�P[^(Kʣ?W�¢��u<�$��H)Z]�1G�*�}���]�YV̢i�4������'��L֧����"�l�I�4�@��v�0���OgIIl��9i�?�����@����:�y�$v�q��!v�''�<ò[}�w[x2L,��@>�vJ
�]���&FTZ,)�Q��M����Y��<�+l�0��Yb�ٞ.!hS;O���(CŲ�$�{�������&-v��հb���bq������ЗEY��GlT�      Z   H   x�3�6*�rJ�Jw	�2��pO��1�rq�2��t5�3pMq��O�-N�t��.�t�,1�I������ \-w     