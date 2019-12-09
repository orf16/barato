PGDMP                         w            metabuscador    10.8    10.8 �    a           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
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
   beyodntest    false    208            �            1259    42802    lista_producto_new    TABLE     V  CREATE TABLE public.lista_producto_new (
    id integer NOT NULL,
    idlista integer,
    idproducto integer,
    nombreproducto text,
    descripcion text,
    precioproducto text,
    url text,
    items integer,
    imagen text,
    relaciones text,
    tienda_nombre text,
    precio_dob double precision,
    ahorro double precision
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
       public         postgres    false    6            �            1259    25052    producto_twebscr_hist    TABLE     P  CREATE TABLE public.producto_twebscr_hist (
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
    relacion character varying(20),
    activo boolean,
    tienda_nom text
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
   beyodntest    false    199   �      U          0    25305    caracteristica 
   TABLE DATA               f   COPY public.caracteristica (id, id_tipo, caracteristica, alias, idpadre, mostrar, imagen) FROM stdin;
    public       postgres    false    237   '      2          0    24979 	   categoria 
   TABLE DATA               W   COPY public.categoria (idcategoria, nombre, abreviatura, direccion_imagen) FROM stdin;
    public    
   beyodntest    false    202   A      4          0    24988    departamento 
   TABLE DATA               ^   COPY public.departamento (iddepartamento, indicativo, estado, nombredepartamento) FROM stdin;
    public    
   beyodntest    false    204   �      X          0    33130    diccionario 
   TABLE DATA               2   COPY public.diccionario (id, palabra) FROM stdin;
    public       postgres    false    240   �      6          0    24997    lista 
   TABLE DATA               n   COPY public.lista (idlista, idusuariodireccion, fechacreada, estado, idusuario, nombrelista, key) FROM stdin;
    public    
   beyodntest    false    206   ��      \          0    42794 	   lista_new 
   TABLE DATA               L   COPY public.lista_new (id, fechacreada, idusuario, nombrelista) FROM stdin;
    public       postgres    false    244   s�      8          0    25004    lista_producto 
   TABLE DATA               �   COPY public.lista_producto (idlistaproducto, idlista, nombreproducto, descripcionproducto, precioproducto, url, direccionproducto, fechaagregado, producto_idproducto) FROM stdin;
    public    
   beyodntest    false    208   M�      ^          0    42802    lista_producto_new 
   TABLE DATA               �   COPY public.lista_producto_new (id, idlista, idproducto, nombreproducto, descripcion, precioproducto, url, items, imagen, relaciones, tienda_nombre, precio_dob, ahorro) FROM stdin;
    public       postgres    false    246   "�      9          0    25012    listas_compartidas 
   TABLE DATA               j   COPY public.listas_compartidas (idcompartida, idusuario, fechacompartido, idlista, emailuser) FROM stdin;
    public    
   beyodntest    false    209   �      ;          0    25018 	   municipio 
   TABLE DATA               j   COPY public.municipio (idmunicipio, iddepartamento, nombremunicipio, codigomunicipio, estado) FROM stdin;
    public    
   beyodntest    false    211   \�      =          0    25027    pagina 
   TABLE DATA               N   COPY public.pagina (idpagina, nombreestablecimiento, descripcion) FROM stdin;
    public    
   beyodntest    false    213   ��      >          0    25034    producto 
   TABLE DATA               g   COPY public.producto (idproducto, nombre, detalle, direccion_imagen, lista_predeterminada) FROM stdin;
    public    
   beyodntest    false    214   ��      @          0    25042    producto_tienda 
   TABLE DATA               �   COPY public.producto_tienda (idproducto_tienda, producto_idproducto, tienda_idtienda, nombre, valor, valor_unidad, estado, codigotienda) FROM stdin;
    public    
   beyodntest    false    216   -      A          0    25045    producto_tienda_cadena 
   TABLE DATA               �   COPY public.producto_tienda_cadena (idproducto_tienda_cadena, producto_idproducto, tienda_idtienda, nombre, valor, valor_unidad, estado) FROM stdin;
    public    
   beyodntest    false    217   v�      T          0    25300    producto_twebscr_car 
   TABLE DATA               G   COPY public.producto_twebscr_car (id, id_producto, id_car) FROM stdin;
    public       postgres    false    236   ��      D          0    25052    producto_twebscr_hist 
   TABLE DATA               �   COPY public.producto_twebscr_hist (idproducto, nombre, detalle, fecha, hora, fechahora, idtarea, direccion_imagen, idcategoria, codigotienda, descripcion, precio, url, relacion, activo, tienda_nom) FROM stdin;
    public    
   beyodntest    false    220   ��      F          0    25063    productoxcategoria 
   TABLE DATA               m   COPY public.productoxcategoria (producto_idproducto, categoria_idcategotia, valor, valor_unidad) FROM stdin;
    public    
   beyodntest    false    222   �      L          0    25076 
   sub_pagina 
   TABLE DATA               M   COPY public.sub_pagina (idsubpagina, url, idpagina, descripcion) FROM stdin;
    public    
   beyodntest    false    228   ��      M          0    25083    subcategoria 
   TABLE DATA               Q   COPY public.subcategoria (idsubcategoria, "nombreItem", idcategoria) FROM stdin;
    public    
   beyodntest    false    229   5�      N          0    25090    tareawebscraper 
   TABLE DATA                  COPY public.tareawebscraper (idtarea, fechahoraini, fechahorafin, cantidadproductos, idalmacen, productoscopiados) FROM stdin;
    public    
   beyodntest    false    230   R�      P          0    25097    tienda 
   TABLE DATA               o   COPY public.tienda (idtienda, nombre, detalle, lugar, lat, lng, place_id, imagen, url_web, scr_id) FROM stdin;
    public    
   beyodntest    false    232   A�      V          0    25313    tipo_car 
   TABLE DATA               :   COPY public.tipo_car (id_car, caracteristica) FROM stdin;
    public       postgres    false    238   ��      R          0    25105    usuario 
   TABLE DATA               �   COPY public.usuario (idusuario, nombre, apellido, email, clave, idtipodocumento, documento, sexo, estadocivil, fechanacimiento, telefono, tipousuario) FROM stdin;
    public    
   beyodntest    false    234   �      S          0    25112    usuario_direccion 
   TABLE DATA               �   COPY public.usuario_direccion (idusuariodireccion, iddepartamento, idmunicipio, direccion, nombredireccion, idusuario, lat, lng) FROM stdin;
    public    
   beyodntest    false    235   N�      Z          0    42786    usuario_new 
   TABLE DATA               3   COPY public.usuario_new (id, key_user) FROM stdin;
    public       postgres    false    242   ��      �           0    0    almacen_idalmacen_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.almacen_idalmacen_seq', 22, true);
            public    
   beyodntest    false    200            �           0    0    diccionario_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.diccionario_id_seq', 7174, true);
            public       postgres    false    239            �           0    0    lista_new_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.lista_new_id_seq', 17, true);
            public       postgres    false    243            �           0    0    lista_producto_new_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.lista_producto_new_id_seq', 43, true);
            public       postgres    false    245            �           0    0    producto_idproducto_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.producto_idproducto_seq', 5296, true);
            public    
   beyodntest    false    215            �           0    0 3   producto_tienda_cadena_idproducto_tienda_cadena_seq    SEQUENCE SET     b   SELECT pg_catalog.setval('public.producto_tienda_cadena_idproducto_tienda_cadena_seq', 1, false);
            public    
   beyodntest    false    218            �           0    0 %   producto_tienda_idproducto_tienda_seq    SEQUENCE SET     V   SELECT pg_catalog.setval('public.producto_tienda_idproducto_tienda_seq', 7955, true);
            public    
   beyodntest    false    219            �           0    0 $   producto_twebscr_hist_idproducto_seq    SEQUENCE SET     W   SELECT pg_catalog.setval('public.producto_twebscr_hist_idproducto_seq', 106554, true);
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
   beyodntest    false    227            �           0    0    tareawebscraper_idtarea_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.tareawebscraper_idtarea_seq', 57, true);
            public    
   beyodntest    false    231            �           0    0    tienda_idtienda_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.tienda_idtienda_seq', 5, true);
            public    
   beyodntest    false    233            �           0    0    usuario_new_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.usuario_new_id_seq', 3, true);
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
3e�bȄ�=D?*��ʞ��e��fSs6̻�(<��-��b������ Ru-�l7ØQ�џ�s�VY�U��!n���o�`n��2H�#�wW2�5Ŕ��ݧpI�KU"�X������=���.d��<^(*u�Ѐ��N1̘�u�Z��W`���}"�������u�SM!�}��P�z'S^�Z9}�S��8c޷t��?�K\�lz]P��~�����C��M���](YR�g��uco,z�o���4���'.n@1{��.�`I�:˫�0QvA�I���ѐ�1�^ӏ���)X��ω��q�ǯs��Z�V{R.���z�����<�V�s������0�      \   �   x�m��N�@ ���+�L�c�Թ;��H$n�"Mڐ(��_/+����C����#��dJd%C3���C�����\,�>A��Y	ɺn̷X�
�N��i�
rѝXZ����N�,�3�`�mx���V���:T�����	b���j�[��O�!İ��xo�!�)�JP{��T[�Ы����B�|Hy�,��c�׫��f�$�Ҩ\�      8   �  x�՛�nG���O�w�X������h�kJT(ɉ� �ŕ�&9�t�y��>B^lOuSk�BۤXt ;b;����:u��i�Ϭ�ڣ���Y�XV�$kw.�1��,{�X��[��o�ӛrTN��M���,o��ߊ�]sTN�7�a^�_��aq;?�X!���p˅��@��Łͷ�w���UV����(N���'�<(�xhqޒ�)��D��ax �N��r<����U1�s֩��9��	��]���]�O�ÇG�����Q^-'����i~7��W��r��Zc�B+#��^��s�����?sz�O�J��y��ٰρ�M��)�>S.;ʫ*�ST;o�(_�r�:y�OǓ����aˮf����u�~l_�b!cD���ϝ�-%��nC�ՁTL���-śN�L	����fؤl@+��DX4��1�Rg*|#Բi�M�&�2����"���9h�w�xξ�}��O�����ewx�{}���&&���K��-�.�sr�>��`�o��4�f�ʆ�6P��`��.��pΰ����;|1���A��%m�\*g~)[[��k-�6Glµ�m)���bD���;�
j:�NW�����d�$%<������!�M��LQF6�(�i�w�e��٠�f���i�;d���u��"_�y����b7�Z��z���J�wN!�k�@(Ƒd��lS�LX�@{�d�aS�	#b�Fo
Tr6l���9�DL!���[[P�#�ėQ,�ɛ��6e�^��GY��mQ�)ĭ��=[��������):�n%}�G�c��2;o����^���{�w�����:ll3��[F��l�@�é���*٣�mɺ3v�=��Eu����3U�W��*-�PI�k�+�ٜ�A�I�l��l(�0n������b�:Z�`R|�ͮr��Ճ�� ������*
�,8�����>K!����]c��nX�Ɗݾ[�#���C(��XΣ�JgyZH��Q����B�|���}=�^@�D[M����p��vU�_Y�k$6	�#��o��&qjv4$�9�g���QC�UFqv���5$by��#���P2j��D��a}��*�g�"�&i��΅}�Ӓ��M��`�]CVdQC`����OCkl�� �X�WCVX�4$��u5d��h/h��#Rʭ�a�bQ��3�YL;���:i�BXTm�Q�9��sl#X
���[��[��@�G���C�/��],�Eq[f��>{����;�)�L	�������>��Pj����0��R�g�'�Y��}�ZQ��\�iN}]�VE�y{TL��lQ�AU܍g8�٤����U�Q8�ڝ��죢lӐ�1�)�
��`a2����1�<��9��'�|\�rSV첬��[�"r%�Cv9�����1#���a��-�wc���:�� 6�w��֪UA٘'��xv;J>���|��g��v�`�]��ȭ�iX[�8%6�>ƣzW�sq�����dR���d�6��A�����ԅ�EPL�gm��n�"��D%�<��h�Mm���6�j}�'l�3����ؖ�M�$�����۟Z ��a#�����������I���"�Ջa�r��;�l�!�[��:ϣkU��Y�2L�ϭ�o�<Z
(�	Mp���&m��ȤiXpR��:~���Qނ� ~]K���і���I��BH���5�zh%��)��������|y?�F�!��)��]z+��<=���8t��|��@|��>�;+��gCGn��:γ��U���}�\�}1�_�Nˊ��No�����Yo'K�m� R(/8���-8��[XJOo�o�z���y�}�J�Y�5�g��54�^��u�}�|�Z�Χ��su���6T�ը�b�2�p1+S۷�	9�a�{>g����1:_��.;���v�'��r���l�G��\_[@�1�m�y� �I���BSj�䬁g��}jp�}1q?���>^�A��h]�;l�)55�p�Z�ڂ�x��2�W��ef��3D���� n$�c����B=ʔ2@B:wh�)�*On�|��:�����L�T�N��6i!}6hx(�O�V��-)���<�L{�K6��$]���tfO��k��veE;��әL�E���F�N��C��	�B��[[P��6۬��7<a���N��
�a�;`�u��Q���g?3)�{�Q���Y �A`8���M@G����%;��WS�_���?:|��N�P�I�pW忓t���{�'���s�U�)$L�'�D%��6d����)�x�ީF���ѩt�#�^���v^��GeR2�[ƴ�0�H'@&#��ބ|�-��MCه�RQ���C3eh�B���tF��l��C��0�B���e2�0tI��H��F+-��Q�@8���<�ή.��W��]fA�nOE���uZH�����O�� 麜Ĝ�18Q>�,S��i�1t�d��~Zإ�iP���=��/:Dx�A����#<�����0vO��i��J�M���� �V����|ad��"�	�kY����&���X����"h��� b��6�N�i��;��sB?�J����R)��4����ZZ4�W�����RsH���(�I~[,h>{���U�r߬*�'�\nVZ���5��E�E��t������gIO|{^�&͌���\ze]�5���#4���Pau�@#��&�,���w;��,�t=�~�;��$�ߪ��Y��'���y���. /z?�g�z�G38UO��w��O�Q�T�4�e�&�뼄u��<�ӫ�e�{y������G�>�h�i#⃓���� g,�f[���!E�W�� �M��|RYc������CS9�E~K_o����M1z��l�C���yI��ɭķ�?wϮv�*&�z:Н���f��czI�i#=)خ���ӌ���&$�я���~�ŭ�o�I�"8�� �X��?q2X�_�3�_��F��      ^   �   x����!�3����H�kK9�#q|B��E��8��������N˥�N�@wʩH��9��.@��cB!�PLj˾혤����[2Y�h��U3#eK��<m*�n*��C�'��<��R�D���ӄi�-L��Sũ�^�vWd����ѲfJ��j�������SAC�����_�dd�      9   d   x�}�A
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
�u����_بB�����TzAM�0���ݯ��o/} )  Lo?�x�]����Vn���Z�@%�n �`��w��O�|��,�|Ժ��WŰ����{���������ob��*췡����)%'���v�����m��s����f>��z��J����&������t�nܶ1��Xe�m��f��S_c���1߭��԰u�{��|�w(p��"S����Aq��z�x�ǃe���c|�ccH��m\c:������*6�3��7�%��m�hZ��w�ܘ���5ԩ�q��r��������ac)ic�|�=�6���M'��z�w�wiQQ��c.�~8$�e�#X�� h-�i�L��!lӻ�Ϳ��,o?,n?�m��_��%���í�Z:�R�o`M���5�A��U���(���,X����ll2]�n��<���+)5�R��m��V�-:��7�u���n���A��U�vlL����J�&�����]^Ut�⛩;��� JH�Z��6^�t��.�_v���H�R��>��q��<o�@됌n��L��].����<f��t��l��|0!|e'N[j4G˼L�����cIMՂ:� �"��h~���)�-�0:z\�����0�҅����2�H�n�����óܶ!�H�Q�`(���c�b�^�i���^[/6�X����H`m��8%�pQ�E���ڠ�	;	�V���f���b�̼����Sgt�Kߓ��ex�m����n���0$H�XC��Ű  x ��}�M����g�A�� @h��m�v�ޮ�t�)~+a�.Vy
���ߢ�d}�N��O� e�
�ʀ�gJ�&m<A��n�S$@$G6t��^%4��2�B�����Q������h��N���+R_领 �S�`8��mX�k
�@�
�����X�8�/0��S��{~�g
pUjQZy����)�`��Z7Lb���,��K]r������d8�l�4��{
��1�yb@�"�,����t}���.����6]s�v8�,��������pS�����`�0�l��Ҷ�f�Y�+�;�G f��=.��p2��=8��N�8Ջ0�ǣ����
�/~����l�����s���޹$��_agƣ���?�_����N{%�h!�Vǋ.+�Ha������6~����F Br6�o����$^a�D��9�"l쯴p�6t=�J����b���1~Kcw�Q��l4��'��P
I>V2CRb%d�!e���j̀��p�n�*|��˛�09tq^��$- ]6Fz��Y��M��?_��/��#IQ[      @      x����r[I�6���l����)ى{���7�((A��*e� 
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
��گ�a��������f�}X��ʳ�5�,�CC�����V#�Up��aF�YC O>�9���!���Zӿ@���>o�aߠ��%����������� 8��a�����-�v���#�}{QZ�>� ������)rx*��/Ⱦ�] e�+���7g��׻H\�l�N�����f�˿��ҍ,u�-�N����a�AS��O�w/?1�:�����r�}�������!�T����@�n�Q^89k�LQ�~K��~�/�X�QÍ�w�F�����?� J|J��w���w#���8��79,���<��__-~�M��1o"�O��$�#�*�=��2d!$���!H��ğ�1� 5����i8��	<��W$��J��nw�?�t1�to��yyg|�,VG����S���:��h;�}��^|��9�|�����FT'��*吂/;�Mj��7���۱.I���(q]�ŢN=�9�������?k��9      A      x������ � �      T      x������ � �      D      x��Yo�X�&�l�+Xd�F�s_�1�$wEhK-�$
���Q&z�HKҨp�S�O�����_:��yH̓��/��{I^�]s�X$SVU.�-��{��ȵ�hp��w���8��������_^�iE���kZ��̍>����
]K������.���/������M�,�&��E:�gI�bQ�z��^����4M;�]ۏ��?��e�~x�<��s��z1X�`���:��g�{H��K���b�ndy�Ɇ�:�b�(�Y�Ǚ��F�þ���y:��IEq<o��ݺwx�ڵ�mf[��tD/r<K����+�l������I��q��t�nI��@��q�".�X�wE�"�V/;�}�{�m�.�5�]g�?����};�� 
��!�� ��{�38L����M:�Q����j:�=�9�/�D����ÿ����4D��׏g���῎�83.��W��G�7N���3�Ɉ���|f�{�m[N���_YVK�j/�I�Wd�|�Nb�Τ�,t]�����/�t��7<1���>��H�g9��ȍ*Η�Mb�N^��?�s:�<�#i�Vd�Z~�_�b~[�����-��;fێ^��n�l˵{pW11�>q��Ę�e|�fYQщ��<ɉX���HH���Vt��$K')���1.J�� ��,��U�E��E�9q9M�#�4�,�Ҹ$���'���b�d�F���ttp5�x\�a��iy�e$I���kF���4���I7���i�F�{�3���oU-ض�z� ~����vH����j�U��X6��w]/��6���E��ϱ��I2H��d]B�|R&�8K�PH�cL�,�q�I�>��E����so`{�������J�¸J���r��0�qR��Ҹ��t���5W�����hh�/��蛃��ˣ�[d���U���9&��P����+���%�~N�uq�i��d����J�%˕yL��P�!������?;;]�G�uh����?�%Mo�ӜD�Ol��b��pyz��qp1}i�..���88ybc���W=�U�"\9.������U1��E<���_�__=��v�	=�E@��M@`:n�� +g}��X�۞�.4��;>�����I7������v^��b�~]-��ӏ��W5n�qY'�46b�$-A����K�
�!��R���� �o#�d�`��A�qCጥ� �<К.�������#k�&�����iF�2&�O34[R���`3:I*&H�M��"�I����I���?��?����
�ґ������McL�E&�}��wT"_�ߵ;:��_�Tm�sL\r���eb���}x7N��H�i�T'c�$��q��d�tҘlR�6�^����ɽA�? ��{�.��Cxc�%=�c��}����2�I����{�\|i]ѽH�X�~U�,��9^0�e��:Y�{ƈ^�������w:��n̤��ۢ$Β�ŝ[�t������9t�8��|_'��Oz�EZ�P+4V_h�eZГ�k(�������ף�'�rc�&jq#�'n���Rx���6��)��%]�t�#ҩY��m��N��u�u�zv��󟔶��������e2O�$��{�*�����r#��m�뇞�*���ww��m�M�!@VW����A0xU��CL�H���U��;�d�h/���􆱨��~�'�_N�E]��y�KnLj"-�lc��5"�x�T�ʒ�x���+I�@���G��0��I�@�7�jS�"@���ceT�8HD�L�+�I��6Ʊ�B��7p����KP�a�5��%y
�oR�� $q�x���Ǳ��(Ǭ��t7H�T�,�%�cR��PR��d;�X��{"V���ޥ�V�pf|<QdV����EIA-��x$�K�t�Iމ�YJ��L�j���v���qY̡�ɴ��0;��UJ|] j���,)}'�YyL�Q�`l]\�-���e��5��|����>�Ζ�)פLb:7˿��V��kչY�O�]�`*�ɳ�u�������$�z�z�;#��7���u�����P5���7<+�"�O��I�j���H_$-ci41�vi��7��]�T�4Ip:��Z�hp�p��a���&�@טUA���p3���<��eA�	;#/��$u6a}DzEh�{񾇿dP5;�K���	�w���&�Bj*��E��<^�yɄw*txV���ژ<���.�9�wܗjq�8��2����Ѿ����M�G(�*�����|�0�����ĳp�z���ʹ:'!�����%���?����m���޻@�!���މkפȣ�i����蓈���
�J��6�۲{F�zRZGڤ�k~��	��"�|�B*r
����1�5��ʺq���O��"���q��16~�ac��q�1��9w�.p�����:�y��t�z~��B�i5�����l�J�g�ё!��Z7TH�f"~ŨD]�]��6��8C89���j`���Y�Y]�y:+�=:�����|��[ϟ���������tz"��ч�5�n?z>@�!���%H{pqty5<~�BoD�o�ɟr�]˷L�s�.��P\i�D��s��6QP�Ӵ1�j��.��&c1�sR�)�n��"�i �[";}o��	��4�M�R�Ƥn��hJ71�lN�7I�&a�&��F5 զ��H+��=�Ɋ,e��a��9B\�R����竧%�ͤ��͖x�	xO]�tT��¨G=������<�j9Z���3���m�m��t��і���"Ҙ�C����9О�;����1��xKz���Ҫh��iM��n|�����ve3=�ͨW*���mW�������
[Pxe�tv,-�C-!�Tz�q{L�mS��.1yU���>���gGm�Yoi����"\S����%W�-PY�w "y��)a>��J�\�����a�޿Xc�v='�C�E�ٵ{�j���z�,Z�~�y=�Ե,d�xEWz�Z��:��K�u1zv�ktrL��!��ua�?)jq�D(�Q,P%���L^z��L�v��Şq�p/Ԝ�B:�^T��D5�-#S���y�-+e�z�S?����P�#냨���Rԑp�C�N6���c��%j��v8��N���!��3�tT��]��\�g"}����Bˏ򚎚ދ(�#�q%�c���w����t�U���^�㼂!g �H������gi^t�� �[ެd�����^����)�����=UE�㞮��4)sx S��ZpQ�tJ��6,�-]��&k�E����B<j�ܤ9��#���9��sMg�_�@�y/�$�T��T������d����;�Mپ�"滪!	��K�p�6E��D�����6����K���b"��{cL��Lw��%h�]�kА-�`SGt������_�KO��W��-_c�"����s�_kr�6P��3�Y��mJ�0����Sq��y��k<�C4�L>m���*��z�ε�����׆*i_s;� �HT����5#������@'�DsR�MG�o�x��@���:��Ŝį�k����dڡ�;|y=�8<�^�v�c�Nw�_w����(��,z�n��i�(m�u�W
�{[�$��NA���O����D���Ste�z�.��3�)NGܐ�鏹���)Z���ƾ=��n���J�p]j�ߨ~DY�x}���0QzZE�������hs�o�|_�� fl��5L��p�cZ׶{�ާퟷ\]���ƴ�Ja�j6�t�u����,�z�b�Ɨ���_�k���-z"�j���9��X�mq�o���r_1r�e�R9V�gp��F
{�3�oE&��ҩX�7�>�	Ϥ�߉���\�& 1�y�O�m黐|� ��ń	�W&K
l
cU�g�_���$�U�n(y�_���F\*V�7۶ǜ�M&����q��n�C}Avމ�{Z�_�$�ݷ��p��޸+� ��6�C��q�1����f\���>^��]>}ߤZ.������
"���n�`9�MWp��b���7���C����R���̙�c��������mS�#�����ȁ�     %��z���t��	t�{�X�;t<�[k�t�\��!���t1!ϋ��.���_�՝$�ct���^tSc��+)DqT�����I �Y��/Q%�$9��X"� }�?�s�(�\�y��I0���i���:��b��0i�m��ɭ�T�6IAg���� ��|�}ؿ�l�zLV��
_���ep]K�ڡ�XA��b|Q@	��c�\V�^k�8m�#����x���$���q��:aӾ�]���.��^��x�
�� ���-R l�	���DJ��P����+�J�5�[�-��I�&trٓl�r�.!z�X�=|Y�7���@8���8O�A��[!�	
�����t�֨�b�3m'�ӣ˃W������ebo���PR(+��؏g��rU���ߩ���)wZ�'%t�>��Q��t�C���4E�:yI,D3z~S��T�FoFC7���Q�q�.)��}��Nޅ"�:��>}7��Z���H���j�E^���v~oЋ�ز6>툍S'f�
�9���M��B��'	*�opK�aߦ,���F����w��-�\���	��!�����-�U�&���؈vP_̅^07�yɞ�$AP,��^�z,���Qt���X�Q�&z&��Q��(�g3�*�'`�?؏'�����5>�����&���`��~�$r��+��k�֮��Z���c�a�K)ӷ���/'�	�]v�BD9!e�awU��|Jz~�J��W%��D~�U��g7�I��>9��,����~�q��qr�����y|��^���-;��~���!�GTG�P�rvˈ���O976�ľ��D��I�wH��<��w��an��k�3���7��e��\'��z�^c���9~o�̎�t�V���'l3d;�87t�xl���������̢����LDA"K��UM�/�N|>�dz�2��T���|�e!�*�y��G��:P ��Y��>{d�t�� ��|5������_�e�r�ci�l��.s=HW�p�]`�$*���mפ�v$Jɴ�$r��g�hƂG��S��_�q:D��fnD:n7)��������>l/|h���c3�ou�����H��:o:_?h��5�ōI�P/�
(�i1OsL���z����
ܒ��BT�8���E����5��k��w�4���-�z���`_����c������ �'���e�6��������Gƫ����O��{!9,.y.��nh;�F� ��n��yE.����tA��6�/fy��B�M�~J��q���LHxz���,~)GpoY3��m.�u�4��l`K��˯y~�p;^X����u���~&��p%l-/���;��&�p�.�i���9��"7����<nl��xe�OI'�d�G����dt���$|��<${�?�r���9q�m�1Ǹa@�~��Gsؕ��u�2����ɬLy<�&>Aሥ���v��
��4��-�.PHGq��t�J:5�u������T9mӯ�m�P��Ӈw1;�i^-|��_�\m�Q�^G��8O�e�r�O������c��%|�#�K�TrTpE����Iz!"r�x�6�'��>QUB�ym�c�tBCI�I�J���<����O|�8�[�1����w��� ���I�C��(��)�쓙lE��y�[�YAdy&�_�CS�l7
�ܒ�#^�$R�V%�f��`?z�)������v]9yhS�a ��E�3;2�DZ_l|���9K:{���W#�[�`xr��ν�>UDq��
��p>��� t��F O���f�L�Q&��Q�l��F����2�F=!Ö�?�[z�ɯ�EX�����n
��Z�w��#h`{�=A}�5�A'Ŵ(�&@��-ހzg�g�G�[  ��P�}���m����0���n�M�[��SZrЏ�o���Iς"І��Q�1�5m�~��+W��=�bX⽯�����ZB=2A���P�e� �}�y��ʡt�b�������av48��?������e�!0���UTd�;~,Ӹ�H��<e2�(�Q�$�Թ^�]o���m������s-�)���)��vLYV�ݸ�q��GP�n�'�,nr��E��II1єss;��"�zM��q�b��K.Q=P��ԫ�C�#��B�j%T��
@�VI��G��z-��N���N�J_DZ�6)�t�0�~s>�<{r����=a�6ߏ���@���\��M������P�����kD�:̈�J�{�g�Qbr�Co��<����s��� ��
]���$Mφ��JNu,L����(��8OGN��vŬ��[O���ut}y1<5.F�����~��븦�,�E1u�ʵ������hB�s������<��*1[/����<�z�vd7jh8 ���+#O ��� #�������xt1܂���# �ʕ����qIL{=��F}���/R�$osH}8	
L��k�[�+��>�Ïx�,���/,��^QT���+|�\T�hU�EJ��3��������	�m-3��89����(Q�_`�{x��������}�b/�oz�&�]���	7�wb�,��W?RnPv(�bl�CNrQLK��u9���9s�g$ŝ|x��ѷ��ڋ����^�v�jn�f,�W9�x�b�5�����5�W(�{$�-V���>{"W�����Z�;�+��c�����c�3=��Լ_��[e�ko�7����<k���MdZ���5=�훁ʨ�YA�v���2P��������d��"s�J.�3Snv�*k�}� $�x=��=��ĳ�˦+�Y�g�܈ޡ�2��,Iu}�S�l2�σ1z���RJ�<c��;���?�&�_��n3#m
 ��6�o�CW��2�x\"��W�d���}s�~ܻ��>k.u�ҧx�ȱ��z��c�6��1R�ܱ*Ñvg�0�Hs/���N�t���Y=O�&�<��)7d"�u�������jqf����D7m��ŕ`}~�r�Q!���nA��Ï��·(�	���ϓ/f`�^���kvw�l�w������kO��I�F��%��x��,y�wYf�N�K&*�~9	�#�J�;���c� �/nǱ�� ��������'�#�KG�{�1�ҫ�t������3�l��a`�\�'���噾Ҹ�M��iPg��5;M��z��1���5�
�)��A�d� ���Z���D����� sQ�YL����]I?��wS�F=FAY������Я��e�YA�c��u�
-��=�
w<K�E����'�፼>[�8A�?r��Ӟ{�P٦��c�Ec~�	�����ӻ$S���r��h�{��հ����_),����.F{"h����4�.&\1�|F�7�@�u="M>={����W-S�ĮQ���@Wt9�*��h�y��e�p���k�Tno�!SY�!_+)7�i�@lfE6�2�1v�$Ɗ|�R$�v{"�x��f�>�B�ɚ����0W���|�A���b�A����P�䬫�*�.D|0v�
����pV����2}�1�~?p_^o�ڙrI�slWm�j�Q3���^;��8$�ɀ+ٴ������/��z�z
FVIz��n���,����������WZ-Q��(0���$휊]�$_·���2���2��?�Ժ��r?��u>��>�M��
{�գp�3)��~:a�#�N�.R�S����U�����������;��5=��>��a/P�U=/$����uݕ�9�hc�<j�G%M�kb����u�@�&�p�8u�bk�qӲ�2���������!�c`��{��^�t�:bu��0����!+����]85\<��Z�sD]�t+�B6��]^�mX��v�9'7�?��U�Z{X�9G�U��I���	HY������O;=�|��Ǎ�xj�B�{�A�4!�@��@�7��;Ĭ��)��w���9�]+Z����B�� r[d��wl�L�ֵD���oNVu7[��1��,�iU T�C�qR��"���6L�D�O<�`#�,�IN?�AdC��1    �ɇ������{���vc*_'�i��{��q�6�9FD���M߈�Tm�O.�[a�'ߴ���0��q�fo2_��w5���s��� �F]�U�Э%{v��D��-�q��P,��o��S�d�oq�x�hF��NˣEi��H���q?�|Wm�����/���H6R���c�n��з�g� .*�Ц�X�%�Ѭ���XlX�ٶB���p���@IT��n�����::݄�����s��	�E\�S���V|���P* �Kg��S��XN's����M ⒻxJ�@5"���@a  l��W�1Q�F���&/ЬU��f;��L����6㶘���)Ob5�pϻ��'yӰ:�(��b^m��n�4*�МyG&)$��ȣϖ�b���^(gU`��|��K�5	�-J��ahwLH���m(��K(����;����G�[mM�"�)�����E��~,H3Y2C�
��6K�c�cm�q=`�ߣ���$~i��A>�;wg?]��
�<����P�_���j���喈o���K�v�����P%�������l�S|�����j���\@90����������E��ݕ{���Z�=>�`0�̘��:}�ad{��[�]�-����H�E}�.���F��+X�~E~+.D�L�݅���FKE�����^��}����r���p�	ˢ���]K?P�ar��<^@F?���m�=T���LpY�J�N�]ہ����-�����$&A�����r��tmll� �u?�;j4y�E��N_�dC�k,P�V��8z�CGG�p3M��ܢH�Q�S�*�l��`;����#�\��VmX#��\`�6��&
(���*�L+��������J�#���g=��鯴�
}5�E��v�
�#1^.^=�'�=%�qzػ��m�@A��0��j�Դt���um��W=�%I���q��6���<C�?�����������j���'�\��O�f���Y}` A<ѧ�c�<�@�co�o�JV�!��p���F�2&�"�%ωBAG!�W(�ّ٧��[Q��x��A��:S�������z�88;>;��B�
�0��9��Qa~����U�O>�a��Z�n|�}ʽ�+E��AjT�\����\y
B�T)m�h�����k󛎷���k�Җ���6��P���z�|T�����c�B�"eZc�7>��J`��$�~l��Y�����(�/bE�%�R	섛�j+ �4>���s�j�n ����Y�V� � PͶ�uZ�[>��?��ڴ�2�r �*�7}#�ʃ����/}[a`a�!�}׊�N���������v/��9|����.=�ɱBh�
ӛ|��"�7����\l3HY=c�`I�Q�2�%?U�Ƴ䆨m�]W;����#���a��SGd|
j�)&8�ۇ���-��e�`j'?�����J;/��r����O�h�a�B�V~ʧX�g�û�.��rh�MN�ssl�h��{!n�.k�L�����l2M�^!��������~��5���YO�>O�~�jR��أ�m4��gwW�n���L�<$f���L�I�68sʼ���dr{G��hZ�W&���jӚ�Ǥ�[���5�j�j��	�q�.8	������$�����&$��1S��?��AG6!_��j���m�������+�FP����4G]��rj"
D�������Bc�/��Iq�횁٫7�!�U=e��z\?�J�񔁶rw�7/��e2I���)eI�zn�qG��Xa�3�ԤL䬐?����.6n�w���W���5�)��6��4�3�o!��CI=�6��=��$˔����jn��N���e:OPw]b1aQu�Ú̔ЀӴJ��B���m��P�S�>�19����B*�˸�W+L�_c@p�N��/H���\����$o��-�qM����E�Oq����2����8f��ף����#9�dJ��.�'?�����^}�/%�x��L��E��3I7B�S�,HF�L�5_2=D�)��؏3� �EB1�0�)�
w�� �+G[��a��('X�&�o���8ëi������X�%�0��]���P�>��m��$V��W�ӡ7\+9�'<���_��U= ���X�G��ɼ�'p{{kC�9{��\-B�s�I��%�<g�)=�PP7�:��?���b|VtC��`M�m�Q��m3��`D}�������B�@!���:��4�z���ͩ:��$�Ri�S�����Ec�e2+J9�[2{���J�[�Fp Ӫ�� 4xY�������f��y�+'��JF�¦���XRa��h�"#1�d�zoh���[�e�4^��<}c`F*\�X`G��3���P-��eT˘�������蛧�gyv�x�! ��S��P:��#� �{�e1F#-�9�B��jȅ�͙�cuY�܍����H�X���^���aM�����[H�Qs*�;�����v`�r�8�p����,�j �ȵmV�Fo�.���d�d&V4�ͪ��OYy��8\a��m�QH�`9o�C��
�(>���{J�_y����[�۠�#��ĉ�o��{�uqK*ᶘ��{��թq���d��c^+���V��_�89�|E�-/X���Ր�B-V��"�n��Zwz!��w��Ml���\������5��M���(������ױU~�h��r5��]���m��Ս�����+hv���F�rN:��/�ff)`]W��]/�NO��-�[X����ޖ���#�v����H6��y�g�Y�*��a�N���8�xzo���ނdy�%2��~�0R�ŋ�Ϳ�xG3�Et'�R�nkt�	'�]��͞�����j������g_�0�Kq��D]r��YR 	'���^m�آ�IxS!8O�L���� zK_�S�|7ɕ*��)�n�16��EY��N��f�"����領�9��ѡ�@�٣�}�ᵎ1nØ2��'��tܹ�|9<=9��7�<:�l�"l� Ka����bl���7�"O��0�Ȳ�yJ�:�R��_��=9�x���񇴎�{2<��v�ky��ӳ�]z�]�b�7zH�w9�㘱�(P� [9����m�5
����
���~����~B���{��,+��%s��@gx�#��%ӬK2�h��s�ߡ}�Mr%�gE������K:�����i>˒%I�a}s�,��5��������L���1�!ک"�e�m����
Y҈���Fk0j	�T��4wu�(�2@���x䈇��<�Wu|��\�Xx�ɺ�7G���_Fo{�*�YI<ǟ�5�R9��!/��8l��2N���L�Gl2�~�2�47\E����V�\
��5Ktǈ%!�D]3K���}���Ȯ����Mu7c4WZJGJS���Fs����֍��T��%��yʣs;�6�Cwk־YTc�� ��Ѧ]���"��x/k�.t��U�7p��&"��1z����ġ7�.��N����=��Z`��djZ�xy;i�@M�A׫-���¼~�Y��0�����_)��*Y&�JhP�>�H��k�d�W��H�E23t��"���΀� { NU5��s>T�遜����x@ԓG�B�\�m��3Ѕ�%����e:])<n��^GRr�����T��$����x�܅J���"a����Q��!H?$"�W���_3Fw�n4C����d�s˥�I:m
K(C/�[������ʗ�ʴ_&�}}O�t��q&csh:�X�UE���jZ�1�	����$_�E�i���y��X�1\Υ��8;�85�x\�"
�l���U�VfIM�t�@턢�L�9���}zw�n�r�vm���4OЃ�OG��g̝������ˑ��yD�qᏼ" wx`*4�� �v����������H��E
�D��r����[�4�v��Tt�	5T�Tw�3c��c~2=-[���]�J�o�2AM����!��G��t�1-A��U�^�K� �.y����n����擨���TR���;�kG|U܌˸6Nꜜ    y���wI����:�|�bxm�\�RȲ���B����ȱ"u�L �8��Yo��3�Yc�u_���?q����׷q]��J�:ྩ5(�ݝ<�Uފ�&�o���w�K(		6�f��������V��$�-yI���K!�r�h�Y�b.I�S�Ŧ�6����E���d�ձE�uv�f��6ؽ�)�fd�� ��0��'h�?Zx&�:
�t�����xȖ�g���'~$��w"��b�TI^�E$�=.�Nw�D�mk�Ύ������c�dnR�+�%|�]'�P_����;��
ƭ�_�b�_H�q��A�k)�/�@ ��l�l/�r���M�4f̺	]W�n�[�b����(ϒT�_���p����@H̼�)��MNy���M�V�n��6��Ŗݖk[����r;��M�����P���v?��lbR��́m��
V�`q�z����.���˂��t���s9��>.ߎ�BG}yvyuqt��M�
��!-ˍ0�D�ӏ�-����Z�a� \���jP
(�$����/�1Rl;�T^��?B������vԵ��:{���.(u�'��z��r"eC���*����Ye�����ɓ�t��(�^ ���.���Ew{Q�KV���� �#u������^�d�L�<㰌o�MjF̄���'�5/
�H�˱�M�i� 'B=��GO��	<����$����[�o�A󃾞�y�9��o�ϑ��s��af-F�o����ض��3�*��ښ�\���n=���9�� s�%��J�c�����M��M>��'\�����q�c���~J|�I%<��j���$�2QYZ-��N�!W�AL=��GO�3DT��]�yRyu�K1.f�!w{J�����������q�P�̽m��*v�t+-�vC#�����P;(��[�������B�I��y�˕z%�Ʈ���5T��4�ޔ���1��FB_E���$��g��J^5��^Y�断E�uF�Ds�e}��!.�łxHQ���JGe���2ꚴ��pp��E�yef�a5H�`������v�q��4eޙ�� ��)ϣ�r��=� �2�b'�e����eZ2R�"Yr����-��x�i2/��H|��ߧK~n�U��з-G�"8F]x�,"�!'J����Z��l�L�\����䋭���H�
n����,�ۚ�cti[ս�]�Vl�����Hu�8�W�<eq)2w1	qk�8l3����~�5��7�Iݤ(�8��>d£�	Ee�����8�Qgd�$�>�\x ��d.��*�j�~HߦM*z�Bh�B�!쯂����D�p�W��b@\�+�e����	4���q�Z�5	x1u	��K�=�I�+ A��{(���D#i%���������M��q�����F���t�,�3_�ŢV�"��˵3�U4�qE�v�����P�AҼ��R��T�6�(�z^|����D�g_>=�;8Q���Zl�1܄1�nķ�` �B�[5���yI�@� R5��m<A9��J��9V"*d�*�&<> M�v�B�(�J�z<���������vlZ�t��E�4F k�E�LZ�P��>ڲg�e�����.R<=��7]�j����c���cx�nvǦX�3k�"i�ã���.���ML-�v;����3���BÞS��������%1�&-;XOF�$X�ĠV�`��P�(Z�!,��}D��[�0||�F�<ukT�=�R�u���$���/ņ����4o���F&�77��3޻@�~�w�=����Mf�:i�ٿB�]xgCQz7��q� �q�{� ^M?��-����a�,RumD�K�.�F��Ccxquv������"��=vh�n�y�m�v�Jn���A7�ob�A�t�\��B(܌+�j����ޱ�C�����?g��+�fuΛ��>�*_���]��Y~f��H�Y�t.&�T���,��g��wب����9�o�ª���5e���;��hS)�O�R6������a�������z����mȕ=b���J�`���H���K1�8�1�OʜLq��~��oEW����RWgW����r���RU��m��=�ؘ�"�ҵ�;�ܦL�*�I�����Te|k��3� 'B�[��N��lٙ��k}���9�˿5>'��/���Ʈ���S�i�dW������Pۉjc�׳t�v�@�v�F��Ӷ�A�k4�!4T&p9�[L;��H�@O[�
*v���G\�l��.$SK\�.a��!�S��jzȘ��1�ߟ��x��y�������.�uLb�26�7R9�S��j?C;�Jc��И�nG���%-��[1�N��Xn��;�em�J���x5:^��;*�<]'~��m6 x���H����vH�vQ�`�9mW���g�N�s��u�qU�ף����ˋ�-�,R�!�^�u�B��`�f�b��ٮ�RZ"�Ͷ�P����o��&�;j�
�UG��qCm��~�ƴ�b���/�4�mж쟳U�Q#d/R�0,{�" �f��B�9���l[/�]P= �w1jݬ�V�b�������-��^`���XnЃ�qB?�ќе͑F��:����AyR���Y>-�5Z��+Y�gAT�!*���p���k�]?�k��
�ū��|jI��g�@:o�t��w�y[���
�����"�O3�g�,Z%����b����}πTa'^D�u��[inv����j}�.��;"�4��?PQN�Qd��<91Ѧ�]�^�X��� CW�jH^/EX�(:���}��*�/���(�-���knÖL�%�L�V0*�$#Wكf*�V*���"�MNў���+�Ws��xK�o�v����}<Rdh1N0g�5Y+��Zb^W�'�P�:^?�|PY���P�t�Nz[Oξ[c�1��|�'�~y��.?P��D�+�x�;━_Y��Ϋ�
;~��z�|���y�x�6d��"��q�(r���v��w�vD�"F]�9��l��������\����-?$��Ƶ�}��uR�a���M�SЦY]�P<ø�����d�"�6�.�x�i{i�v�LN&��'7�\5iJ (�t���Ù¸�a���G]��4[!�Aɝ6�����T?(�����n�5�gRsT���v?����>��(�w�fLn;��X�y&�	m�A���Ho�L�\���i�ވ~�g1lw���y�f#t��F{��d�}	�ߠd�7EQ�fir3�sn��xo4��������铗"�ȧHK�2�����t}���I�Oe�'�7�@�s��.$ݞ��x���'�|l�;�����v����Q��>v�Z��c�o-���ܸ��Zd���@�-�ȿƷ5�:��JF���3��;�j�j����(���8�����1���������t�r��.
��NO�M��q�fU�$�xY��I�����s���Ӻ���-oe����i��@��x���t���ވv��6�����<Mv�kK8��0�2 ,`���O�]��;(��q%lT��B��ކh �V��5B
�sܺ1o�ܺ��Zۋ�L��W�~�����:\τ.�A�zY�99���`�����]]�<}� �5�P����bt<���� "����kS���J�G�7�B�c��u���1�����{,���iP������Ua��iWuL�q�5�F�H��O�zk������*��R���3-h{�-��iaϊ���i>��ا�u��u�u��k�@�k�p�jXg�f�G���.����6�_���y$"���>����t�@ĸ�E��WbUb>Hv��3dT)�p�I-��ĈEwu�VΙ���c�Et�����!
��s��r\�NĚ,�?"��!ך]��b+���$�V�~��X����� ��Q�&K��-��Oۂy�1w!��R4�.�g��+����X�k��ig1*̰`fFN��b!~����n)d\W�:�nT�e1����t�bv��b���fl(US��Y�    $w`�kS��j���"� �NO�|"����!.E��B	_O��qט)�i�ë3zU�ش�|A�]�����B���䃴��I���6��e��}�2<��3eͶF��p�^����&	��g���x�d� ��x}(�����E�vL�#D�i=�3���&O�x���eB�n��4���$,]j��q_��h�~>�bFn૒�k`BnHP%��+�S�A��* n=��6((��MD'K5�RĔ�.V��|m@N��}j��#�W���}O)���g�##%Oط���"+�B=O�~et櫙Qg=:s����`qp���s�����,o��q�dk�$B��k����'��)���(y��Ș+{���&˝�Ks#V��3sѤY0��ԩT=k�?�H�W�ͥ���6Ua�Ľ�T�6]�Gd3�iU%x��N�D��:7 �%��\��Z�dd�A���
ˑ�i�
����.3�/��
�َ�_����җ��]K*[^��Yݛr�c?���-IDe����t	�-3�VSCU�:!�W��K��~'� �(��.#C��������Ǽ�
p�T��"��T�)�J�T���T ѴK�P\2%�;7*�}j��z?���7�	���_��
�f�j[	����Xa=n[	�tQ���ÿ��T�>|�~l�y�u������)���DaNؑ�ց"	�v
�[��Wo0'<�	[P`�Q���1�ڲ�awE��H+&�W.�Yn��ȋX���n�����D���U��8�w�2���Z�(r��t�Qw�N�ߐ��N]���_��:��g��8v��^l���h0�Y�b��p��;��i�!0�N�3�f&�q=#տk����da7�L��ͻ�@I�\��T"���.���x�.kC�1�L�4�+7u� <^���v�����[�N}:�1�(�_� `���٩q>�8zy�i���	����_8�:t}�{��/X�?u�7�מӴAi��ѣ6�O(<N��?B�x�H:���¥nV������Wd.��!�k�d.$C����Mٹ�XH��]æ�b��N+��s̈��MͥP�.q�u"0������HEQ#?�β!��_���
��s�t-��Н^���2�n�̨g��sR%xQԳ�]c���8�>yr�Ɋ��2_8b2��D�z�\�#�dz�@Y�[�`�;=gw��t;�d���!2Lr��&d1�R��cӦ!J<��U����D�Y������ �K4���#'Vf1o�Ah�g�rzf��)�8q/e�9XY��#�"\���p��1��TQ@I���8W��;/2t&5-��8o
�;]p�2�Ï�d�����>'A����O�=�Z���Y�.��:����*�)B�d��u�4ʢו E���W#������gOo�ID.�"7�V]+��/��J��>rȿ�����;mJa9���Y8�l��P"��`�e��JS�KV�&���L E�Z1���5�)��eq�8T%|p����#v�.��>afE��[�xd��m���w�"��$DA�7/�6a���bw��xp�[�xg�]���/W�3bmu���v4k�Ѝ"��l�C� �mؚ���Ŋ<�WՈ�����(���(P���e�i<
���F�s��|�?����� "Q2��I�����%��w�ލ�0n��u����2�u�bwx7!@��ґ�2����Ѵ2���T����ח���3�������x.rY�F�ب�A��Za@�o����2l�y�"׳Q׌̈Na���P3�z����裇��Ӷ��A1!=
� �0�3�0��,F�o���������ٓ�g\ČH�9B�3��ٳ0�=�7����H�_�K���^6F�B:�&|a�7�B��/Q�9��T�B+���	�6��D�\�S�8/��`/omT>�L���$o�ۊ�����@�Lx�E�d�4E2n��r8��ӿ����r�bOe������E2M��[x-���4�7�HԈ��<-��憃A��6���˓��ӳ�?��턞�hF�LW�� ��u�Ro�����A{�#:��'o'<T���pY�`��Cx��w]-���_���M�U"�4�?Y:�4����٦�г2����۶���.��n����r]\�II.o4�4�=��[%�LS�6�m�Y�v�����dN��H%n�⡎ⶖ�σ�B�tbQhjT�mvm|�J�m���Q�i�L_#��M�ʒ�j=�������ѷ�ُG.�<}`{�sX���kYj�B��~2N�����Z��^�K�M�u�ڃj|�Xr���ǈ���l�#M{��2!�v/�Kʩ����6��B�l��7&�5-�^e��b�8�8��/�G[H [��Y/(�m^�X�:k��To+��f��8t� �>�dY4���;U#M:����&*�m+F��9��������������R��� �_H�~S�&J�)Y�N��s$#��V���)
��I����qR&�> ��&.R����N��EG�c��j;Љc8*�_HǦq{R����7�
E���_�>8;<�8=�~r/7�,�!zY0M��J�i� &�l�7tm��q�)g�׎�K�q��� |����x��yRU��Q�K�d֫:�\E~5:=]^~����gyv�±]�""�TH��Dbҽ龈":ڨI5GA(��qb��o���.�T���f�� �d���iMQ�[�����i7�\%�H�I1K�I����Ϟ����/9m7��9~��%�������?}i��h��,����x�t9����\�$.��m�j>?"a�2��z�G�|{�L��҃}�c�	����C2�	bQ�d\�z�0���S[�)���L�zFp%�{^y��qro��a��(r���Q�{9>�qK|1�?#��3�J��&��5#ꒊ���7�4cD���=���N�$�6A���^��0��:aLdTs�t�}0�e*�l�f����س�39d���9���EZ3u��co!���Ō�,$'��A���4�I1<��c��d�H�cI�ʼє� �b1�}���lEC��@�O��~��7I�"}g�ą���v���eF苈����O+�O�|�ƌH	/�9֌&�S����o!�a�FxV�U/�&jM��J�K�{�������𫳋�$%d("
, �4I�@�K��lo����2��Y��8�$�@�J���m$0���d�sm� Vd�?<W�֡���r��,�~-�u��͠�ͳ��Ѽ�ΤQ�"�[��+ ?��n���2V���v`��?@mG��Fl$6M�ؑ���8]c>�|�v�ѣ|���vE�TF�*�=e��B2���! W�Y��;�����_��j��ˋ����ӫm�qX��6�P�d��y���f��P��<d76$�D� p2�;�t�n�FAϻ�x��b�[,�]ax�y���;�
�fߛ\��n��{N����؊�%Ғ�Ǌ�I����)Zg1��i�㳓��d���7�n�����L���BX;���MY��Z+�ʄ�ԴՂ����_��h�ה$cp) �ɔ������C�`l�y<3�B ��㹾�����zH���'VȪ��	�<��1,�	���J���É���b(v*rb�v��+גn|Y����{���iן���������'O`�I������MG㤇�2R>������B���D���~��?4�Z�R�g��׹��\�����c%&�Kר)�Dʂ�'~-e�44�Ï�wZN)�D�w�BV��S��Q}�qƫF�V���?��G^�5�����H�*l�����L�e�]N�X8�(S�z*Š��MS�r�ݗ����^�+���?h�0T�^�k>��5���V������߉l<�V3�%�߶�_H�1��#52����TFQɁ�>�\��:����e��GIoa���������T��xxqt��n]	W�c�6���>���5$�ݺ��	�nW�q��k��^����x�V�+A�WB�U�h���$�:���4G=�����{xY��|����$�h�ᷗ_���    W���&�i�$��+�d
l3���~���C,m�������;<�����+�vc�M����w�8��O�j����C0];W�kP�*m�Nhu��#���(�|��>E�V�S4���UE�}ؽ�$Ƿ��U�O�h�O����[��|���:��<��.��.���%� ;�am �#�MQ^'o�Q>���Q��w$7	��v�7�d�F���!Y\�P^��}F�X����Ȑ�ÄJ���t�c\Ιv�]T|*���$*��,~�l㊧f�O�����L	�QL9��,4�����)c x�� ��`��ߵx{\��1�����n���������
�I��d������ ����61�j�GL�j.����>��X[�Cf��/kݗ�b�����i8U� F�՛�PÔN�n�!F��q0PN"����H�|�Q�7<
C��?H�o��+J��q���ˤ"�j�uDÜ9����6-6`H���^���?;����:�x�ڂCNO�L�Ij���).�����N�-N��0[�Y��70����<u}�2�}�yS��"A�v���$�L���V�<��y|$��xVH|�F٫�@^�_��}�M�d�������]�(#�;Bޟ\WC�M
�o}�(*}:݇���<a�=^!�0�W��y�x�w�rB c�`��o�� 66"t���$)��~9�����^H�Pp_���ٖe:�ei�	��)�B���W�r�GbgIu�E-�M�-hA.�u�v��>�<��dw���&��{��/��$'��/F�S^�ʓ��I9~�q�����;,2(y
\�������C^�&Y���q)":K^�������[A�������/���P�vy��!��nJ�h'i,'�_3tp�Ջe���T=�t;vxrZ�w�s������d&F��wSv8ڈųZq{���(�.p/[]���"�'S� �]X^2Q6t�J�e��@��8��V=e�[Uc�D��]+�J�#\�t���V��J��P)��6+�Ck�."���$^��oʒI��
�j�ǌ�D��5y���vxf;�E��#�_��� r:J������r�lO:������-�^�N/��|�����n��X�
������F�:v��o��:K����FD�L$d>�2yq�,TLc�S��@�Tq.��6��0P�K�U1jAi��?z(y}�X��]�J��
�{P�B���e,7ٗR)���a#�ꦦ�����0�6��my}R��%�����aN�m��2��Ptm�����uCL)�v���5�z�ԅ�����"�m�'�ɡctp9g�G���NIf}�6\z�gdB�F��S��}ω��J�ߑ	Β�>�/�+�8ͫEZ�%�$��m7���UC������{㌴д+4��T�nȢ%|��T��ɛ��З�3�Q��eF�✞����(f�������G[��8a�:2>�����/�N�^��>���oOw�QwO��6;�C�qcd�2��d+	�,�H��pR?�8-k����R�߱�)�HU�I��t4 �� ���B��&�sv錳lj\s1�E "�'�"��>��O9a����@�	/<��j+�p�>a���g�r,&K��}����<����a����C3�I�5��x�?�TЮ0���^�����N������r�M������qMN����(ܑ���MR�	���*�����a����l�/�[bvWъleH�[ڽy`Oa�i�g\�O�~�(� 1���Mw9�������հL{�0��w�h,���הr&F1�.����V�~itݽ����� �}C�F1(:?�tN�nr{�0���a�Ĳ��^�� Q!�s�mJG{]i��@ꕟ��1�p�o5#0���wh�
�����3����i����ʱm����^���	L󻔗Mm�'~�F�Y6-f*@n��w�>>><{��An�lQ@�
]��>�mGa�N`��q+��3A�L�e
�5V�b��5P��.*��T#�h3�4����ख�\P����NW�aOBM�p��!�	�����M"3����oeD�Ƭr��EX89m�~<v�?�u�-|�&�	#�/��'9K"�G�X� ZM8�W)U�1�o}@x��ݒ�X����X}����0N�ܺp�-�57N�R�w��m���w��r�ի�q|�\L�yb��v����M�ng�(.�b�+:�p ?L>����ϚI�n��v;��^�����0|�sB��#�
�l�������-�ۡi���JM��-�&}�K���J�@���4ǉ�H��"�R��8Ƭ@(�������O��h�Z&z)�TP8e����jVAV����o,�#�̉�;neb�p�̊��]��U�k�}��K2�������ͯ���L�ؿ����J,Y��.�����^_��k42��Y�g��F&�_����㚁�"Mױ<������\yj�
L��Yr�~ޑL��y؆�{�iTT1�u��)ѥ�L�� �����ۇ�'_1	�@�����81N�WG�GOMy�9�������@�ÓC�_a��9Z��Ę�5�Q����J�1�"�@7��5Z:�G��>���x�L���z�2�r5�89:<����6I:0L"�P9oK��X^��v��35]����= ��&���S�n.��� �U'8�UW�2�����Mn䪔�C=�����#0t��D��?\/� ߶����،�x��I�\���%����ڊ��9л�q9��i��`����Ë���+���juF<�ʐn*i3��n$�Xc:a'�rKJ�"�w�i���D>*vRa��X�$3ZM������l-yӥNT��}]��*Y1hh�
U-�״���q�k�ɥe� �$�/������I�@�N��J�q�M�oSāIy�XV����)1�����xzMBQRd
�s�V٣$;������O-κ���*�'�8��^��;��L�"E��f��.��G�ty�G�3���܅2��))Y�b�9~mQ��O��e���S�Ff�h�m=k�x0<��u]C�-��@��H#����)���-k [�H.}������@r]�`���Lm�
�fB�vP0Z�T�y*
p �cu�=�c+L�d=�v��ͅ�֛�B@&��[`:zŶD_[K_�O�e«C���9-��W��m�3В�ƻ���n�3]��(H�v���T�v ��j�F�KH��6�^�f��]�����B�.�������1�S�F"�ǽd2�M�?�[E�:B���3��7_�X}ٷ�~#n���:�`FO~3��j�E%m��.Y.���"�6H�i�hMB���IX�{�^h{a�D��,Ғ7k�3E惃�������ﯷ�s�a�ogz~�����X	�U�d v�g5�a��a[�t�v���Z�͆2 pc�$)FQM�RXh%E,_w:���3�.!�"�gƵ��\Z��t%�'+��|<��Ȳ�����Ƞt��m�L�kXf�Qd��[�On��`�E嚽zQ~�~u{��L��n��@	�qh6.���Խ4G���`t��������k�r��v&���RH��z�Q֞VtH4��R����;��o��pO�2�Y.���K����D/�y��]�dw<��NfTW���'���}��,Y>Fy�OB��Lv��7���e�3�������x���'p
�|��N��$�)H(r2D{،�����wGv�7.6�3�Q��	���B��Dz��d�(�$+�Y�������������6	ɸ]s�/ |_�"j+`�. ��%�y�}'CP��҆��W��Q�M!�Z�Ym��q��s�\���W���>8�)#.O��(x��l��l��X��g�іxj�����o����v-8���oGmK�Іz�g���)㩣�Yu1�><�9�O����;�|rgl;tMW���2i�h��ڼ`:O��hK�^�]Ő3��so�HJ�{W�H���[��x4�U���9�N�<�C7ʣ+�+�b�M�V�o���    6೼UK����jݷ��]L�~�A} 	ѡ
e�O̐pN`��]�U�56I��vf�E.;7�J��կ��(h:�"V[�F<ȍ���/1�r۸۸�ZU��t��M������=jq7~8M�D�+�{O7$c���$o'��+���Ͽ<;9^n1x<B��F@��>n�UW&D��2!*	�����ucE����s�e����	.�\W�TƷ��7@v��
I�L_Uiv�4p|�4)�]�h>�l�K�(��Av���w�� �o�p�{�)on^!���ID�Phz�ȍ����{ 7������"�:�1���%���p����%��9w��|���Pbh�4e�����n���>+N�����-N��W���s���M�`�(q.�&��Z�̃��biG�>�V���Z��X�X��%g��V��U~��Ǖ�0j�(c���4��Noj��Cޥcv<)j@B��b�Խ��7�?5��ѓٮoL'�I�}�b̕ҳ���	��) R&���9���zg�'��f�j��Y3PZ��6�%�at�~/�+��݄>O��N����$���$k��O�z%�sߒ��۟��X��`����~�~�z}r^$��}�zE=��)9*E����2QYbUϲ��u)�-~��M_2�ex�YI�sH�a�[�޷��?#���à�'/I��?R$��i)r�b���F8OE�;/ ���:��1�:3�����F�cWP9��E�z����~�%����"�J�����3+>� _O�`p�l?������R��6|qvz��O���0�
�@���C�DG�om� ��iO�b����BcҾ���)���()o6������F�U��Dϖ��ʥ�/��U�ްBQ��=a�{v�FDŶ�e³ӯ6�8~D��>�����:�|�uږ-H"9P*����;jX�",JL��ʄ	��&��ľs"\�^�@ܩ[�KC�	�Nw[˔����m')�b��>��m2$,���N�.�.�<jx�\=�-�ͳg��g��Vʀ��)�N�F~�� 7g>$Ն����+�B��ǶE໣L&��R�V�"��ǉLI��$~�N�Ҟ��#�o�����V�n"J1U�;�J��O��ѓܒ$��a�˜�V�P�^]<�}�m�!RC�e�}����J�q�wH]<+q@���6�S��h���;M!a��H�p���G�Y�ɦ�X[�@�Pdͼ����z:;}:��:�F�N��[Hf����޻,G�e١c��f-떑���=� =#�ŗ����4����QNwge�H�p��fY3� ���4�a�O�%w�}��#3�ΒJ֪���	�}���ZL~Z�V�l�R��~KU!y���]�=v&��j8
�"����V�����0�oFd7�$�|I��K��{��ӽ�����=�T{?H�1����!��D��^��\��F�o����{��^g�~ɀ�a�7k�8�Ŋ�0��"����/UF��km��^�Z^�&�.J읙Ɓ#4j}��$�3�<�c�4
|IeB�L�m���K�n6�Ot��c/�7-ko��Ӻܙ�!�[j )ᦱ�z�_i�hV��~�G�4��[+-ܬa���S�rh1��Ru�5�D�Њ�$y��Z@��w;f�WT4�Q�l�p�r|��_��EuY۴nD.�~2S�Wk�>���\*@��4}���]Gacut���tFҝ!B����DT�])��O/��ϰ��~�׀�P�#�E(~T�E��6�ad�=p��F�e��&.у*>1�"���n�7Q>Gٰ2&n�}q�41m[͕,�rg�z�d��}ktc0��|��&���P�ǆ���Ci�	��u�B�:~%[�)��B1�-y���1m=@87�]��&�MvE��ڤ�n�
i�zЙ���3����z-9>�$�\���W9ܾ$k�_����:0�u�}�����b����};?��Հ��O�g������G鞼�9>L�1�ot� �6���s-��k z�4���ߥ�3X&-`��AZ@��:�f�:7��˛�Z�\!�D�46k&#R/�
ɫ̲k�.'VΦVل�����<�xmږ��NX�Y��D��Ig� ����j����fWIa����Yg��x��j�Ӏ�UU~_4���5����?:�����^e�+4y�/1˻lt���#蓀�/��;��'$��#1S����>CV9P����v�׮*�1��0��;��Jk�G[@�P��"%nK�U�� %���Y��h��U��?�A��XlU��\���w	!�z���5��Y-�
���P�Ŋ����ƄU�U'ѯ���O����U2�0)=.�+�$����>K[�Qo%B4�%i�^�$����	Dʈ�=㼳9b�� !h���A+���AES�J��<T��<9��;�)�|����������o����PI���[����I�Z^R��hO��j�sAs_�9�i��Ӭ�w<�2}�Sf�'c���:��^-��Y*���W`k4�S��6����"=�E/>�ȨK�1������MS�se��$q|����#+"���-yF���2<�E��0	��%�kq�d`���jj�J��C����2)�k�:���vQ`���Svk6�U蠁Ϲ����\�/Fk(q�zY=��=1���>FkK� ����Z`t7e���)u��@��dٹ��~��T�P܅�(�,P$��k�ΏK3�:�w|����N�/5D^#Ä����;�Xf�'N{�aJ7L�=z�=�@{�=��O�,�{~��tf���ݫ_SV֪_w�Q� ���-9��;	�`�"�����n4���X�����x#kӪ�c�*��ź�%:5���I��� ����iP2����?+�y١˪�ܴp@�==n��{��%*�%M˳�F�i�Z��h%�3b���Twlg)�ejn K��Ƭ\��z`X����ۏXR�3��#�k��a�����^��J��wl��`5J}�k�4[$\�59�(�~1k��Q�yA�ޭ8[�/bź��C��b�V�W?ZC��;l��
�	��t{�0��nj�0�MS��.(dƜݩ�I�X�\�c�L�|_V�<��z�h7T�Y�I���З���D��(Μݘ�"�Ԛa���� �)I�݊���H0�Ka^%I�<K�I�/F�U�K\�R5��46�y5!�j2�/X��p��R���#}0�U?O5c�kMG(� ������.�߱bo]4�B�q�E�Þ�G���R���9�G���5���� ����Y�%���h0"I�G��Zi���$m^����)L�Ԥ��_��E�y&%5�����/�-��{���Y�����2��x�Ƀ�)���M��I���Ru��.��$l���ͭ+"��\]
��.Weu�5����h���&@�gQ���*���f��	������	l@Wϋ�ke��6g�U[d<A\Wmq�E�����;����{5&^�6����V m�Nh/�x���}������كj��	U�Y��ۮ�Br�J�����<i�FF�sy���f�	�.��Tَu%��Rq�Ӌ3�<��v���vAC�._����э2��q䅂}~]�+�-�WP�庬(�5�4Kȳ޶/�3nD�O�+��M�խ@��0z��ThEP�S�s���%N��y��a��� �wr��x�P59� ~V$%m�̲��_V3�.�R���Sք����^�zʶ���<)�}i�%cI��}��Vk�d
��N�Nenb,Y��~����mg��$�7�엍���o���eA��C�djA˷	�Y�����T^�9
޶SA��&����;�9�P�P��y[^�(�%��E�����$��Ei(��q]��J����P͈�t�� \xV+�u��B��O�is�R��"p3��Y���;v;;�
#��,�|�1%NƁ�Ta��u�5���4��ݑ��^(^}�ǣ���'�WtXӈ֕��a���rdx=���"kXM�I-��j�\�3�����>�k���1-)$38і�&�RJ����9�)��n�p�����ג_    PNp[���|�q��ڀ��^ñK��� �e;.ge=��1G��q���w0>����lH\/
�:侂�s1��$C�%����������>#X���	QNg�����wk�zDqA�����-��
4C�����+������MH��[���m��`O����<��F;dU.Ā����;�Vd]p:�aJ:���g�,q����h��H	&��M��}c�1&�g;��&d-�Λ)��C r��5=�P��&�c��F}a!?|�'ړ����P��LGD��z����cz�%�ו�^���"��L�'uB�,/a$� �Ru��Ԃ��E��D-���4��@Y-�,�-:�����ymJ�)�)0V@�0@�Aj����	�e�؛��Qؤ�d%��z$|�N�6C��SU�6������
�U������%�"B���7���Y#��6j'���\o��nΒj�H�N#����ã��3h�<�O)�HB�(@���HF��'~��֠��>�*�F}e���*�~�TJ*uAKsZ��k��aD��uM���z	��dN?�ɔ�9�>lLYRz
W(E�ڞ�W����Оe{�j\�#���De����v���"�'C�a�p�$f�����s�+ ƗՈ��G�FƤC*�38���'��PL�`�LD�Z�/B�����N�ލ'2�r�!�n���+/|�^xd�0&�"#���'
���|�e��b�yM}ھ�ȧw�aj�֩���B��,g�9'�~�\9�N_�}Y�g�����OY5��RhQ�?ҡL�����^m�z��C�/���s�Ͼ/��WH��4�)��P|��fE�*_x�|H�u�v=`c�05P��jx�C�d������,o��C�_���0�y֓��u��Ǩ��5�<���o�Рe?�To�f���˼� ��(z��$���$�%~�_K�+�N�|��Z[�����ާ�K1��\<&�Ӟ��'��W�R�Ob�h�1�gkP���6�ٺa��Ŭ-���<��[<��(�X��5����&��R��y�D�)Ѣ������_3���gs�p>�����ˬ@��`-�i>cҕr1::>�8ߍ'����H"A1��/(���m4� 5�Ļ��'(p9Ϙ)a�8��� �>�f'��Pf������O��IE�&�iD�i�~�m$qLA���b�Z�Y���E�TN�/F��M	&D�E���oAa�`l���{F��+1��`C��0u[��
�V�Ti_݆v����m��v��kv�\P\���'Gyz����4U3��f�!4��������?t�
�����F�)"���4l��ݧ �5��nȚ��'�;�R)��C���G�خ���������4��9�2=�i�l���v�pˎ�!�!�s�0�v=�AY�gr��Et���c����O�sV��9���]o�����9�����"
p�qD� �n��i���7�Ԉ2�r���/�$P�ta�X��?՜匊�
��"3�[�Șć��r��AW#�U*WJ� Wv�o����x�Ҿ��e��<'�.�9���5�Y��B������l�p�e;�[R��A��O�(2��Cʻ	(r���<����cV)4jhyY�׆x_pcM/EfF��4nx%&��%s7��0�bzZ�-%����1�.���t&L��}�X��]r�:"�kb�Y{�AP��9�TS"y����٩sqt2Dq��Ô�g�]I&����@�7Ên^E��t�E.>-2b{�]I9�k�p$ݞ�Y*�Ꭶ�[Z����)�͔�.ju���'�/'��[8���s��eP�T/e
1��w^S@w82�פg��Qm�C�?΋�51�;Kﻷ�Gۨ�Ʃx�A�c���]���ۣ��=�?��̳���tF͟��T���65^#����ߒ��s�g�_�?�kV����ޖ�z<�9g�<k���y5���(e�F����-To�2���]/�8�����`ЃA،��X���f�E�7�\~���ӈh��v��Ԃ���Ƚ�ڞQW�Ciװ�r������6�2+�X���C<��	����u4���j~��s���Ŵ��6&�?�=�+n��j��ڥ������7�cp��U>�S�����:x��f2*��J8���c�׾5�TZ�R*�9��z��%o�Fbg)gw4W�X/׺�%��>J����C���������3����"�XAJ7��(0o�
� �9�VK]X�/�3�.1�VMZrD�o�Z5��S�<-$�Nɸ��m9ػ���wk)�7�񾅬��u�H�O&�÷Ct&�ޫ���������ԠjM(?�����F꿯�ǹ��pJ�t�Q��q�	�MEn�v��C�����o�����vг��³�B��4$��Pw����?`��Mo$�8�&l�;�Rәd1TZ�:��A�8W�~܇�;^h-އ�6�>_w��m�y�P���S~��Y/���Gg�oO�9�n�g:_"k���停C��l��>{���.��������GT���+���P*��V]��P6GM��ª(a�h�(x���1㨕�:������1aP�����*-��	+o��!�~A���h4���g'��z�s���Ta)/٧���p�P�d�|�Y�r�2��1��B����5�i���_��87[,>:��9)?W�$�˪�Z�S�����k��ļT�����w��N��q����Z���
2�ta�[L�"���/d���	S�1o
&�/!�
�_�\�q˅k�tL?���U2V�S:|�s:����U޼�G%���6�7ň�lU��F|���J`��Wx�r��V���za`�;b����)��D-��-#:%4��$&�39�}G?�3��`�¾����:���\7�� ���&o�a��P�I$�D��{��$�CFZ� �@Z~�ϴL�ކ�qɼ�3�+=��k,�Pi)ʢ����h�*8���q��6y��0��ewl�F���D�
��f�!��#�B`���Uff��B��5a<Z�����)&������+Yh�!�nm�^����>�`,�ly���n��bߖ�װ��v3K ���Y<�i���5�ӛW�?\�1�0����� �]9b7f�b�r��$�6нD~�#@�J�Ir��\���|��[�1�����{m�ǔ�:��l��YeI�ȵ�K�J��,Ϩ��[��Jb�Y�t�lr=�n.>�S<I��e_-~��[�m�����ePǏ���"���\��Z�L���u��%��n����G�{�ڋW1�K�؅
�m�� s�� �%�cKC��O����Z�.j�-�&>-dn�(\�����z�՞7�WH�̋Wr��Sͩ�Jn�#]�OF��r:�@u���Z��02;F�玾�]Ir�g�����pSW'̜�QjC/��Ŝ�"3Ĕ��+x�+��QS�`d���\���-V��	���T�QGN,�45�x�5;�4
��0]��6�$�Kj���:�g2�?}��vUֳ�X�<G#�;NeMS״�t�8���CC ި�tu��>�i?�U�ۗ���^��z������p����fc/���9?���USW1�*�.6P*�!�%�s�6���l|�W�|E�]��C� ޺�����ۋ��3�dt����@8"��?�o�%�& ��' 4���'l�m�2Cq������^��l�kP���;���\�n��߬�ج�Gŉ7
�rC%�u�č��*�a�,��R9}4�2�[�d���E�{]B��Oe����[̖�9��bݒ�=�>���$�b�K� x��Y�����kF��(�˝VF~���!�I?e� W��M���3�h��)���Dj��s�x�%�jo\ۡB��� -�9��T[��]2� ��A���T�&���J�X�������W>��§'%�4����t�7�0�9�ۉ��m�\�$���\j�A�0-n�ԙ��Ri�����w�6'w�{�U��_Q�O �A�    F�����Ϸ�"�rQH����蛫�#:5O&ӹK��߿��3�- � �,��tn�>��Z�����9�Y\�X�8��5�\ɋ��9�L?�@���-bwAAg�������&K��J-�3�|�p�<�_����3|��=n��.e��}�%����y��RX� �������& �NΞ~D~�I�4@��zA���L����>�����ۡn��L�g3k�6�C�z���@#Aa9���u���A]��4t
ڎ�ۯp�ͯ�)��\��}r�f||t������x�V]��iD*/�@w3�J����5���G��*��FE�]5�Q련>r=��J72�z��I��G��ş�-;���}zFs��~����'"��y�B��4MD�����Ҵ�'[�W$fv��8�{�GOd��l��6O���)�$ů�y��������o@y�Xd�nߔӾQk(Y�!�>�l�}�$�R��o�����yN��rNˢ�Kp�j&s�;ߎ�ǧ[ ���4i�,Bўw�|��XG{������@l�aR�)�6���g|�?���esI6�+	�_2���OZ�oΩ-�d!:}͕����� �Oı���2�Ć���[�iˠM��c��l۪|����wK�"
c߼��|��y��_�Ɖ۲�>$��o���3��nu�e5��;�ߝYH�ĚA�]/�DnF��c=(>`>O��|���
,���g?����/&��kC���|(5i{>���M(�I?�J�:H^_=�ܚen��3G�+�.ȚR�F��9�7Á�Ή�|��T6��W�ˀ�֔["5=2�#�|����'�w]:k�O-m��8l.G��ۓד�����*�4����ЀH'�����5V>�+1�e�2���,�Μ��b��
X�M���,u6�KFO�CG��t�'YvXK�k��t:&%
�,�o�|�s?m���^�	��	�b2�]p��1�N������s�۬Z뾉|\K��d4y{<A� ��!��[(�b�O8�'��b���(��I2�fyc/�u�Ki-���!0j;����Y6���gus��Og���r':#E��	�����b9e�0<gU�A�A���h�ߎ/Ǔ����@;ks��{�{<c�D��u}�4� M]c�9	S<����b���q�ԣU�(��������@��<��6�Gg��gٮr�BQ���T
"�uC%����B�+�)�)%Q{E\}�b4+�Zp���܋ ��8y�w�O�՞�׍��͉���l���Y+���|tT"(E�jX=��D���UY2ޡ�yyST٧&e�&ݣ��g���!2�nH?Y� �8U�z"��B$Bxn�5u�0M#�sz=�Wz&b�
�w�	��Tg��Zʯ�����y�lMa���g��Zʗ�(�^9����+:�@�Ki����zt��0c�6��v�³S]%*�M��������m`����B�*���^��O�(�	�0l]�n�<bASu�@w!?�������R&��p�>X����\�%� >t�uIb4�����������g������{�co"!s�Z&�=� ��c�iHwE�MY($�s8O� ����P|���V�?��:#��B�rwH�S��d�o4�o����*[�+�7��&/7��\N?H�=�)�|���۱3�v��}����W�AN����l  h�:FA>:���[9�,��x[Ԉ�ۂ�(�f��۪li~��^,n�Y��~�T��z�-�;P��K}5g�Y27:)�l8�UE���ZQK�#H��[�X2�I��U�(k.�,�3�~`���Iu יnP�89z�puH51������%k��f��o�ȸ	Z}���[o��o��aᜯ�!�m4γ�]���#����gw08�"��S� �G�}�#,D�������X��@O�<<i�2�ww�Ws\|���w���������N�+_D�������r����Ya:��r�����^X�lY�L���T1)-G�9�Y.lY�$+��zh�f�wG�#�dtt>�c�h�EQ�<�ȎQ��Q7�
B?1���l�~��͚�a�Q���q�T�&+��)Q�˦t��９���7nt�z�+�m)����]�	���Y�_k�b��b9��dWn�9�zQf�ARt�t��c�������s|6�ݳ��>����K52���ܾh��m�����u(��j�{C����6�5<A@<�C�Vq���.���)�u�������I�&H�Q��ݟ&a�:�Q��Z�M�'���9�X�J��_�%<�v5(qWO�O�Px̀)�b�!!�� ��a&�3{�˴���u��c�g�vU�+�A�d-��f�"�-h�Ic�Yc�iv�6(ȱ^�|*�nx�P�2�7��ߕSh�R(��n��U�
���A^��`KE�X{���q�ч~���� ��^h������7�9^B/�^���kw:��blJc'"��t�ݔ��XLl�i���nx��Orl[B�h����	�4wp�����Y�/)*QX�_W�h�"܂'�2�m�y�S�+�j}ĕ�8i`�/ğ���4�����VL�thx&$���q��Y�9K��F�Ic�4�Y��&�@!k�sujcl�t~��y�{�Cu��?y��%x�n�د��P���k�~��Z�5ƀ���ǀ�o+����z���{���~�8�b�魠�!�0������[�b�GL\A򆮆�-�x�F��ԑrD�����:���8Hvƭ�b�([J�mE���V1G"uc���e��6^q��p��U�čM/������fd!7��p���/��*�M��><���"�����|B8=�c����'g�GC0���<T0J�*�7]��/D�c�O���d����	7|� {?�T�/��qmx�c�}�75䃧 +?o��g�Hb����F�.�T3F����y L��AiKj�҂�Ww�Q�s^��)g��s�e�1��9ߴ&p�%x�Yߛu�%��db���R�.(g�K����4��s��+p[��=�|Ɵ}IqU�k�u���������%`C�-�M?Gp����>��qj�֘7�B�%p�p�����%u�J��]G�H��QG\fW��sJ�ټ��n�>솶�ݠ������^J����R�ZHn"�ض�DKx(�w��R
*��Ү��K�b^2��=��VƎ�Ua��IȕJ��Y^�DR�+�A2�,�.�����UqK^<.��S���0��ʀ��6[��ߝ�+�>���:�&/	E|ӷ�ʥ���\�yރ���^Yq8+�x�?�e\'���	@<s��)�hM�n����Xˡ=���l���
4_�_���kZ��ǉ��V�r�]�D�^�:�E�Rl��B���*MȒ��g�f�Rj�S�Z��M�/�r�e77im�O��ͪk>&���)����Q�!��P�����\s���{һ�⻇�Vw(����tS��Lܙl��:N�����Ы�y������Δ� E��0�Wt��c�조��xB�˻��p`ly���#gP.��5�OZ�Ӱ�_���j�Ⱥ�g�	��nZh.
��[S�K_�ӀQb5`���4��7`�
�t�[7�o36c�Ql3~Nc�"�MF�O�[�r9�vtz��0&�~�_M�S�q*���_F�<0�. �#o�U�G����\�[���x���EU+Vt�V�, 7/e�:a��ɝ����Y�AE��7T��Ň�Y;7��zٔA���:�����(�@�#���ǚ�
���c)���<�\P7-��u.'���_{{�g�E�~O�^�.�:p������t�A䥱��8 �m�S������s^ mk;�'`�?,�-㺠F���_��T/���GQ�k�h�dgf���^�1�\�s��댡f�WT�0 �����X��$����U�{��yK�\����UU�]Q09�	�[Uu!�i�8���E����w �;�U���R�؎�����멥Z}v9&�^8���mXT�A�D5 N��n���Յ�xKx����Ί���O�>��s㪷F���b*k�x�J+s��
�3)1Z     v��� �
�C����p%�P�/[ l��D�Ǘ����/�����ݺ����58����l?���o�)�A��V�+��K�{Ǧ����@ૉ�JA�{aP�(^�v���Y�B��<jY��|�/�]V��RY�Cy�e�e�]p--7�WV`=G�խ3z#�$���3w
��U&i������f��2���?9:�·mh�/���6���ֶ���m��:%�d���,�����p���g9K7
	P8ќ����A��80���T��:�%�:Wf�Ev�-+ܖ��)hb����Y�e��B��-��4_��e��KO��?��u�_k+�gs�*���e_�� ��t�o�%�Mh��{Ooj=�_�gWa8���<k���Hw��:Jl��k�t%�Zu�`g\瀷,Bň�����㘙WLh�;ޕ�ފ�LU�e\0]_e���вW��!K��G���}��x��r����?:|��mB�p�R�(B����4{R�e�j�O��{����ܻ�'�ֽ8��)��h{����},\�xwP�}J�GA��>0���\�7նR񊟐�K�r����A|�%l�<� �:��欙�28�:m6�B~�k�$jX>]o�:�1]�O���ɷ.Ъ��f�!KF6K^�����Rݶ!��zKU#���H���E��VU�W��lU ��]��P��G�e2��@պ��QbV[�f����[�m�M�jS�Kk�)��&��4'�!��)��;��&`��Db�R��Gz.۵���>Ay$(���'S�=��_�tMk[/�Ý�m����TJQ�#�;�L*��Y��H
'�=ZY�#4���dW��0�]�B�S�D�=R��,U)�K l�$H�
�{��?��\�0���(�y�4��<�\�s��%��L��@��6�Q⤢۠i��ײJ���U��N�F���t{���9�6��-�!:]��s{`w��ݾ(�ӛ�O��sP�٭s�g���qztq����G��?��]?L^�I�� �D@$	��qlt�@o�cF��QL�;�`ao@PК�a$]ϑr�Z9�G������i�C�qZ���%j+��y2��9�Y�Կ&)�WKu���r'�^��Ю��9�B<(���(z�\h㡛��RO���ݓO���v��V=n���ρ+��HP��Z%_���F׊�j��L�w��pbL>�a3�I�w��-y��dP�c�=���E,Y��X�p��7j�̢�'�Y5
���9�\J^�v �I@&�{�۔�"��*�9Χ�����Z/����L~sɣ4�_��r.{q�OW�
<r�U��k�Y���Z>�y:��~�G�b���L��"�x55��%��״$x�w���u�d@	U�A{�4w��t���l���;xu��zͽ���}��Ah�}���l�M��,�Ͳk kVŧL���:�V~��R���Dv+�]+ִg����-�Ŋ������"�vX��0'?��_-m�A�"��Dn�ȏ0n�D�6��n�d�)h�Pb���$w��:w/�&�%)������~�g�z���_o��ƒ�Y���3�˲��j��/��lv�$�'|߉<:��wG�g{����{��@�5�{}v�����*�����F�/�k�2ـa/�[uT��tLϤS�櫂�h=�=�zn�3Gc�3��=����-)P�<���AN?������b6��G\0��Ho���kh*�[8~ڱ���1�����h~���+�g�^������"ٝ���u�g��b�~άUW���խO�5�5�[f���Y��5�>gVyw�X�
mUV�@%�6T�+/��zvbЪ��J���,�U�g�k}�QbG��@P�شkW!�װ��%������r�����WY\�	�8���M��Jv�F�`��5m�^�Nl�m���0�W��]�6x�������?�`�d�;S�̈#u�T
�k�!<�PB��5˗��dϯJ�{9m�5�H�*zJJ ���r[ޖ��F��|A��N�/���hv�o/X�O�����������c����q�)٪	�]�k��F	�:�}���K�SdE�͐�T1N��1i��Xm�c7�M#�2����V:͸<�ץ�T������T�ޓ�雭�B7&�h~(��5M<E��q|�&r��=��5C�}�$�1�����h���3z<�!� I)��6@�E��O�$
@B�'/oh��Ŭ����U:����*2�c֭|QJ�w=!�|t�<&�������$-rK�)����H"��wdet�8�G���k@�1��n�]L|닪���A�I���C�8D<U1m>���(�P�[cvj��Z�%��LN�OQӻ]��qW��3��QK4�s%HQ>�m9��N����];��v(��&�F�(��F�5������+6����v�v�[ʈ������oC�25M)��)�p��ď�/�m�}��Xs����h���k���19i�����w�g�H�f�KGs�k�R�*�V�҃8S7����S�S���ږW��%&3�G� �uBx���F�0�##(co��~�S�aT{���v�U[&&�i����y2H`���k3���13~ܬo7L��r��~�4�0�JIj��2�W�j�#�Q3fP14��?2�A�tcW�F0�_�2������$�a�߃+u)�kGh��*O�_e��F�D���Z�kJ�}�U�08����e����@���#����A����g�w<{ �\�,��t����0�~<r����6�iDA
:, S����Lג::��P�a����e~ͷ���p��h��\���s�H��ʦ�ց��]MA���L�1/
w�^a��ɤ���zڊ�ٍP-�ӌ�t�CeU�1����ʢUO�9���n��Udi�v$̝�	�B^hB_�8)Hb!]z���ܩwC��n��JEð�2�c�9,;/i��dw�~��X�խ���j'�ƣ�ʷOK�Ql���1"FW��:�����*���`��+Zu��M�[����ܓ�`oVN��X-QÓ\3{^D���N�G��E�'q��Nqyg��;6�K?}ʄ�g��%�+���w���<������g�$2s���J����5�����[V�g:�u[4j�����eXaϾik�&}��������0i���N�K] ���꿔���4
ɲf�*��j(� �/�l�����M[��O�n��-��icJ���.��a�$��;�ؘyM�S��+s>�llpJ2.����bŰ4N@	��k��i���
�ʔ�k�:'Gq�Y$\}���d�Y6˗u1���D*A>c�.��&V�C�2�Z�ZΘ��t��9�Y�*A�:�ңw�Ƞn6t��h=F*�=�빮���5z�g��ѩupw�L���	>/�4�Xң|-i5q�kIϚ�h�1iI���W�H�&�A��W:'��K���2�U��9�J˹�����]�������^v����%�ah�@)��Ƣ�l��X��zzط�PAm���|�t���㉄|B'��2�J'��\I6����p o���"z������%�F_��M���h�P�g�h�q��ޜì��Dh`�)�{�����Dj�*Qر��C֋�̹)���=�%���	mp�b{�\�ir#���N���B^�M���e}5eZ�3@��Hۙ�rl���4x�~���$I�D���!�}/tSJ���ǔMi�,�.�$���& �$CX�ځ�C'Cܱ�No�`��<�jj�Ql;Bm����P�?����((2����c�����jPt����N��#�i�Hҥ���Kڤ�"�� v�z���{ʿ��l��TvxN�!o�nI��B(gl���I^q���k�Y�H�����ߟ����W˶c�c��X�1llVD}�R:nt��'6}�ga��U%����O�8A�����������2\"^���S�՛�	<���.(���n��\^=��s���y����y�����'#��gd'��$V����q��.��A*��;����]Yy��5R�5���z��ʑx���g��W,[{�$V�त�    z��,�/����ӵ5��m�vm�������99;=�{�[�B@�{��ŇBtzȁDidH� �e��}�1V����lM)ӵ�������d�f`�G�ʾ���[�i��v=l�Rj�Ë)�4*�,��R���W�R�a׬�"_�1��}�k��ڪ����k���-�VJx��ݪ(�i��z Q">�a\Lo�N��ɦM�{X�q��8����n��gtnoo��^�JtD�b�U!I]?
�,O��k���[�qז�%�U�t\��q�D�֌+�(m]O�q�J�tεj���-y�qI׆�u�^ii{�w��p������� K��m6}I���?��AUAU���U�~Nk��rN��R�f�Q�f��$I����ٯ��Eڞ������R��;䋴}����FM4Ц=���������b k���i���k0�%G�M�*�g�iZm��=ۛ�_�����E�S�G�gZ��"�s �8iZ�~��"��=���-.~�r�����r�IlZ�υ�"�/z�,���w#���I��>�`�.����,�Rf}����xV���%�ᳪ�SAiW�x��>-V�\�X���(k��}�5�_���-�IR�'J6P�DlJ�q�5�ۘ~�[P���ٚ�gpP,�{�T��K��F�����$���q��U4XC�(��C�ir��w��;#��gy��^�h�j"Wl0����\(��:�Δrђ�	�2"�\���&�\<�]=�I��-�zu#_ј4>%�Lflt�EtX]� ��Ed��禡٭��zG!��9�?��+����F�:%W��U�7v`v�U׊B�N�Yf��eu!�YM���w%|�A9�����s��)����x��=Yvт����im��
i9���`�N�֒�>��I�ۅ&���}�&I������0 ��[�o�������nsV��{�WY�'������� L��s)�1/�P�(�Y�]�O��͛�xy�ނL��m�$b��$����#H�k���@�;Q���ҽ��M�ļ�I�;;>�>�ґQ�kdRI��T��C~�P�+�R���od��O�eV�F�D70���ٿ����~��u�0��W�
A��&���S#t}�bK9 �7��򊏷��Z����3���T��譹7��w���_s�=!_��(�Gi!]��{�D�M��wC��-��p���2�U��Z��B:�*���mX,׷Ō��uof.8��Ay�@�/��p�������)�Ţ![�����.1:�9gGVM�M�)t�F
 �q=�2���Z�	
ջO�\ba��z�$�¬;���2Z׵�6<
�w
P�*U��d�f9�9���7Py'�.�>�B�+t���k.���X��m'	�$���w�0�1Wes������.�˅�J[������f��<�d#�0�J�)r�g�m�1<r�zK���G���~�s���� �R7����oo��!�D�>��z�5�A��-RO�Av����'�����'H�ٖ���*���[��T�=��a/�t愆'\_�ǿ��(���.o�R�eZr�Z�N.�u�#�6G����Uƫ;Er�rU��f*�e��ute�v_��(��m�ׄ����_�AcrߵQ�C'���&��A�ZQiP[����i�L��'o���ДC�iM6 Sn�mJ�b&�2OtZ;[w�j��}����Ӗ��k��3�	�W{��Z��U�T����x/*��� �!�v99z7>��d�O)t$�+>-!�ZM�'9��M�.i��'���J6��O�/�;��?Y��M�l�6|�� �0r�0�݂Al��Z�o2,�U����V:�e���gzɷ�*��:E��rC��+�z�Ab���M�N��艣$�
��+�d�M��E!�AF�	�X�X]c���m������;�u&$M[;k4��tP,����K�G���7�A,���S�a"G�"��f .q~�;͛�dF��tŚtA�gN��Z v8p�t
�m�Ⱥ%�1-X�p �k�m�90�b?��֗����}T�vY�K��[j���C)�ӻsR�Ǔ��#�+'G���������c�MގG{�G��h�fW�N�94L=�.�i}3�tx��/5E]M��a)1�N�E��6�*���v��n;GcM���\��93l��ǣ��3�DϿ*:�tܴa���P�2�/�K�Ἤ��!y����?�j)�r���4���K�_���E��]���J��4TzC<�1�]Ɨ�$&��,�c ���\
�RwX-^�
v��:�?~.���⼖�A\����끼�_H��\Q�`��%��-&��T��Z��K9Ȝ���j�uUr=�>���qV���C���$K�͸��#&w��/��9�@�P��#�Vc�Nd�%qIڂG��b2�_e��;� �����+,�E�~�+�/�䗿8��B@_���龮�u}X:�������峯l\�i�1#�#7Ӥ5�����o��N�Z���|-�!����J3�UV���C�d���r�)��ħ�FRk����)��\��;��L.|��X��׬�6SiO��7 ��T__�b����t�^�WE�hSjMe ,�1���~[�J�s��o2�O�-�\B���9Js�������9�a�1�ɦ�5A���0��a��������o�5�&�t��Vѷ?U%��Ph{B�[����L�4V���>(�1ژj�3I�	ELȧ"i�2��n�7r�A�6SL��[J�	�������~
/~�� �¯	��It�(=pw��T��lDԚD���(z{_V	��6�ò5> ?���!�
�����dx��!j�A�M��p�[Q�R�W$��q�MV��y�*!`���E���y}<:=8�Sy{����ッ��ӽ��ѻE�ߎ&�g����	���6	�T97���׌��q�4����f�.:l�?/�La:h?c��-m!�⪘vq#c����O-��)$�G:�ƍ�T���I�A}j�B���c��)��P���X�IT�m�����"�E�n�$1��$l��|����I�>N�ԓ�D�%804&6������KW��*��Z���	�ߍ�훳��Vpŉ��1 YI��tM-ۼ��{�kפ.28r�a#O���z������:�I""�� :F�{�m�F���%��F���6�}b��=o�z�w���?Ծ��!_L��ɻ}����7����9ń��SĆ�b?�<�t�� 7�>9BO�$K~h�棘Rj
������������q|=2j��.��2�E0��/��y2>S����.��`
7�d�,�^;��i>/יd���Jx�������hP�m�Ep��A���%�X��"hM��,�w�����?T�37yS�F���ycD���9�N��;}�U�5�W#(ޗzltU"f����MT9p.�����z�C�c(68|��1j���jMdǷ�.�^��p	]���*_I����L�Tٛ�����ٳ���"�U�10D�E?uc/�0�qWP�J������A ��c�4�Kmt� ��M%	M�s#���x���]_0G�?��	ǽF����Vp.n�@�)��z8�k��mj�\�4}��.���*��֟>�p��������ٱs0�����6=���>���5a�z@AG�0�=�iwAbw�`1��������o%�46��V\����a��u����9��GC�0;tpz]� "��ћ3��6�t�L"i�Q`�I�˙C	<�P�ʻ�w�w�3����\���q&�͞_Ba�WO��d��W��_�|[��d�J�@�;9ޜ{�'�\��Kv_���D&�x��Ƅ���_�r[xI���:�Y\s���{���B�����T���Qs�d��d�}�q�7�U"�#7B=�d�BՐ�]9:����)v��<��(����˺?	�wޠ���w���Mn�9÷���;�R��m���&t�$�)�#"J�)f��Ch�.�J���:�� ��Y�9�4v���9ś�)���/?(�y֑-`��p7/W    �z�3��:(}�ƛ% �vr~�# W�������̱��%7� y��M3D�	���}h��f+)���Yh�qw�q��8ŅJ_�A29�?�^��j^�>}ю8�3Ӣ�Tܤ�[���F�f�8�k�~+���m��C�](�`��y��͙;i=m� �.F���Cc���n{���`���t�RN��h��w ;�|������泄�d#���m�H��~st:rNFG��a�q�P�X�g�H��RDM���"��[Yu�|u~���'û@�BdI��=�����&�Q�͔�%�;{����q+��^��v�h'g�J�s�ѡ��y����S�8jT|}ה�R��4P[��׼fd����z�24Y��k�-M�~������uO��?<�/M�6јH}���)W�~�s�f�.�2L8k�s$����B%�M�U�o�����⚿Y�0Q8Ơ�kD�\��E�O�ے�X��՚��I�ǡ��Bw������|�Q�J�Q=c{ɖ+�΃���(�Fu�w�gA�Ͷ�e��j�	G�H(���@n��'��9��0
=Gmz�� ��ണ�;�w��Sz�Yaެ�Ey��^�����&�������m^,W�qZ:;�� 1鋾������#n	���ţ%����A��K�kp�Q����0�戥#��l����ry��r%ƃlf�c{yvz0:�Tl�7���|���{����JE�ƦX8��(0�M=��z�%x����gAs�o�dW�\i&����C6\]\�X���6d#�>�-Mx��j��_��x"��|C���rZ;����Ĺ7+8R�ϡ�s��Y&�ޢ�J0,ԕ�����;M��ߎNΟ�.�����-����DV�I)���To�\��y�~�]�,�sf%���>�f�FG���əs8>v�F��tX6���tZ+�/�o��A�Y{��~C�~z!���E�E�R��`%�$��6Ҧ8�a�B�j�ԩ����\��G,|r�����l�������H=e�ȑ6��VkU�|���`�����Ov�݈h�u(%{�rA˖��eY�&?����=�]�>��5V����!�eФ�fkP�x�Š��nXO_��W���3v�H��yHD}��>Ӡ닇��}��b}�4���Y	~��bO�?k�e���j�'����!��0�vi`f0�sS`�����q����)]#������Ƹ���j��8��7�����<<霠��0t���C�δ�%o��	�~���Bzp��]�q��:TV�W�O�K�G�U�L_��6
�����r���0o"�ؐi��R*�CQi�*�������F�q�����=+�\�s#W�&��=��^s�G�S��>����/j;}D�Iy������y֒\1n���扰� (�	$����@Y8��>�ͱ�����
�	�'�Nu8
R�(ݻi<h��_w�����ݖs�5ͶIg[n�>��XOt�Zݤs���p}�[�+�A��Q�9�gw*m��`��)[��FoN϶м�0bl��%�P�1>���{[@����� M�޺�45�#�|S ��TM[����Ւ��-	���+ i����ױ׌���Uf"�{����uVUQ���^��{�(���aR|'�(��o$_�>F�l�и/�|e��]���8эl��E���s� K$mW�cPSC(Ą��/G^�B��u�^��~Q�Q"Qw�d����ӳ�!����]0�(Wz k����5#K���-�F֠:P�l�tLZ�� �-�}�v���pqa��f4W��ו=�u�4�n�Z�d�](���0 [^�J�V�7��-��֎tT��tbQ�(����,M�rҷ�`LD��2)~�`8�>Έ��Nc
M���¾��㯇�z��m�cr�u��9?�=��t�2s^�>7[˯Gd�A݀�H����Zⵛ�Hy]���ؠP��/0�đ��q8�]Iʂ uNˮPՅ|��,�z!!�5M�PQ1��P~]����!�����U}[~Td�U٧k�.>j�'��V�uY)�]���J6r��R���EO�O�ܣS�Q���qC�v����E]T� �O�Z�{���pqMХF�]=��01�|I����Ik1�����
]R�N3�[������T���qT>��q�KJ�4�#��횙}�r���=f�����0�$o���0	C�@~��oB�w�g?��~�U�����l=��K��K3|xv:r�G�|囍\%��R��Qh�<��s����z�����kVr��^���Ͳ���z�S-tF9w�Tẗ�>�ZS�RU�ð��5 npG�ߦ�Y�]��t��6���5�Zd��:�^�U����Ӣ��C��N�Ga�HC#n��׫�0`�{��E�Zμw��U�{��k̅~�濒�n%t�gM�"����f@����PAC[�h�9Y��[NY�s�F�&�C.�i��+PA��
1?�ʪL�����_�Li�w�]�����4�]>+����rʣ^��9��T8�k�Ѯ�cct�c|��mdGi��d�G�=n1�߆S9�S){���#T�'zuUqÒ���Rr���g`M��i|qp69���x;g��A#��(��֙���3m(H���-��u�;3`�&������QI�<bl�p�����y>��D��,�������ku��^3�������R.���
��%��R��L�.��@���W�� �$!��ۀh�A�������h��U�ʕ~e^�JW��B>!Q'���"�cƃ����!kz�$����)�1[���� 0�^�F�nP�%*z$^/lBv�!���%t��ʍ��d�~Ԍ,��oԭ|�A]t�p�^E��(�aj��b���I�e��Y��Sr�>r������s�� +�	�ҿ5NI�&
:��U��y���8�3��uO%�u�a��;q��s�f/��ÝK�#v(�x���"��+�,�Ҏ�D�$R����7��tr"�?b�A�0���j�Ƿ��9��W"�Z3�"�(�Ti�$2/�?i4�Yz�&
C�M�z?@�A����Z�Ҳ�a�����EU�ɩ��Ŗ�U1g��߮�S�}wO��!!��#<������}����a����-;44�ƖҒ뵆c�^������;���SP���J�i�ynS��=�ч����f�"ݙ�KiOhf�4i-�)��%ܴ�eݠ��9٩Z��f�O%v��$�%X,0-%}�E�i��ݰ�ҝϦ�[���3'?��J�^J�2�X�2'��2�G%���z�MA�����r������k�C"ћ�[D2Eǔ%S�o!��i�%��e9��X�djċ�q��3trϱ���Ԣ��s��𫊹ǣa*jZ�Y��5�!�����I�s�)(S�{7�+�(�@WaJR�d�m�(>ec�\����m��9�19�; #����η'�07�Bw��MN��nc)P��B��~'J�K��Z�����+��+=���GŤ\>�D&��G�P%���3Xn�iv�R#/([���mu�i����Kd�W�C9B���z��$ ELt	H��s�lOJH����5N�^�iY�E<Z�q�_~�rR����op��5��hnV�z��s`�k��"�����c2�+�PMQ0��Nj����z��E���3�F��;�wG�o�зnt.q�W>�\�g"�Ew.�yZ��������������P/��B�s����-݀��!��G����<҈�J�<�}���T�uep����R_�v1z?�f���A(G�3}�$��pN%ޞ08J= �!��"���o8`�n�}��� +i��'Gg�s?��XBɡ���]/�{��F�-HE�1;t?��Եɾ��j1>|vz��uXd�muC��@Kj���4B���.MgJ�r�͑-3��'�wه���;:x+)-��o�mU�L� (4�O�*糜�Y��2�;w3�e���F0R^h��M1���g�o���K�v��Yi!�-y5�׭!��ל��7�Z��8:uF�gߞ    kB�� �1�{@�|�-.���u@���\���%Hh��,��7Ƽ�:"Sp������sA濞�i��د��\�(��OY��(��ϸ�y9:=89'��ó-@����.e����2�uDZ�i����~��,K%��������ҚM����Ǵ����9:=�
*��@�G��^��;\~�'��5��}�3�*�D����ر��9��珝X�)n��=���:�6��
��jc�����)M��3�`��u_�������"-�}#�?Y�~�^m�����*�s�� �����xb�u����uU}�7�Bה!�r�a�5�A��Oz5�n��C,����m�
"�&`���K-8��[�Z���u�_t�7ܔ=�u�r}�uUl8��P�֏��6�\6O��w"����ϨY�(�XG�[�1�S�k`q�߿�賖{�����<o��o�S�i�G(#5����Ƿ^DzN���ʼ�k��IdZ 2�u5�Ğ1��)�ob�͓�����P��C��Tz���
�e�}���e�Z%�9* L�9�CN����������,X����=E��e��򌃠��􎛄�މ�މ{��a�G�<5C�̈#۩i�p(*J_e��0A5R_Ƶ�Y0�5� H��O�e%�;�tR�Xѡ�؟��)��-��<v����� ph��2��14�w��o/Y"� ٔm���98���T���>�('̢փ�G�=��lJ����P��Q؀R�^Ons�����\e3бr.���ǣ3�||n�ج�i�3x��_�1I���i&�3T�l}�����\(��_~���&j~��s4D��⑏Z��=DYt�9D�N7��.��:��+e�Zf�k�
7�*�5�QW�[M�rي!��o�G~Z�p��]�?��,�pE��Lj.����B"L/$a�*3Y]�H�����WUW~�Jph��$B�3@
���Ӌ�����RL�2]r�!�$1N�'�_jI{��v�b`���a�M.�4�����<�$H�i@g�0[���c��M��텽��Fڢw�rU�<���ɫ����..ώ�n6���D��`ӡk�_)!ݵ���o�rR1C�NO����C�h,7�^�CL�i�m�4�������=RNX
	���vt�ɇ�'��4u6#� i�
A��� �@]b���fV�'��)��jE���-eE���T���o�T[���6�}��7o��l�7��ZW6���Ȏ������t��R��XE�Wev�"�z_ek���7άڿ���l{��}�d|tq9��p�湯�}�q�G��Q�������Zz�IV	��[ �g��覧�50�%�/ڛ�E�E꙲OI���~��*����D�� џ�}K�~f����������ֈFd&��e����"1���x�|���Q�@���8ׄm�ک��_)ګ^W�JD������NmnX�p�!Qͯ�Et,�D��(j��l�I�R���{�K�|+��8�7
Ra�O�`菣��()2��լI����0�}Fg�|��+����f2(B��<��W��x,#Q��K�	vk����f؁��oP�?�������$E	Y!�R?*b��Ƙk��o��6��-�ptT:�o�(y�-?���e������2p�4rK_S?En�l��L�o'�
ܚ�F��6�FcSֻ}�#�K���k���s2!�-�'���J��8i}`n�H�h� �����آ��s��ơ��shNg	&���5�&Q��Z3$J����ԔΔ�:���;�S��Z��|��aq{WV+�Aߐ�J���f`��})������t8�¿�B]�C҅�.=�}>͵4
��*�9Ԫ���d�H�.�;d�l����軿���RhzJn}�Y��ފ��6�spI���,�9~rt�-�X�g�!^�Mf�j���K ����y�"N<s҅�YͲ�e�im)������K�>��0�]��q�$��\@��`��B�44�d��g̷�O�g�����$�vA_Xq�6��	snH�,v�D)��k_h3��L���٬4��e��,:&����[tv�/3kv��o)��Z�U�����웂��Y�`2>}�S�P���H�y��� ���[զ��0�v�^^�f�t�s\�h��f�O�=IW}�3�(�ĥ�4��|�P���w�:��]�[�{���!�Ζ,�,9Wh�\e8Vw5Oe=����?E��ϻ,��0����[�đqo-&�,2��f��O��71S��Km�]������oko,9B���zP}./{{wQ�{�2������t/F���SBڋo!�Z�k�1[h�2y����<5��t��Y=e��X��v�����F�<��lӐ����1�o�A�
#���^�0يB.�kU<���²Q�bp�Xd���x�|k�~�r��T:�֢�U-�����i}�W������8Ƅ��`|��&�#J����A	�1��Ad����Mz �F�c��U��)������%��(}F�I_:�����`�.JmTJa�͚ӟ����
�kI@��uP�� �.'G�Ƨ�FU������y~_�)4ѫB� ����%IO%zwU	#W�_|l�U�Ѱ瓳˳�к� $\���7L-���n�mk�^�x�ˏX���8����A2����s~�_~<�?ۧ�7o{�����6�4�G�\��"Y�A����P��ک�&�b�t�:.�l&��?����hM������}^���jn��� ?�.`=Q����g�;uo�U���@�L����r>�f�����`t���!� nZ�~�%�
���=���(��,7tx��먋Y���S��*�kɋ�S�B�ꑬH�G��@�������0͗��)dV�a�����|�>�w�g$}�;��"sWN&�򏮡]�K��"��(�l}Q���@PBO�	��.�@��C��Th>���񪐄���z.��$��h3�����zA�tW�v$R=��WWl�J�a�H�HSZ����omx%����i�&�D_w�E_@�y�oB�tUhVW�Q���>]���d+}�@�4{.�6�CMބk�C��C�kG$V3�Z���a�n�Хum=9:���m�ޑ=BLD�pE�&er�����fx�ُ��q���i	�&�a�����M����'���B��*�6}\G��*�YSKT��$:2�˩I��f{z4 ��Y� ������8����8mѥ/(%���E�ї�֭�%"��C/�؟0J�V"�c�qVW��*������yM=e^rI�wZUs������y{��<�4z�aH�`�<@��@Ҳ��� ��"iY���
(RY� �[p`�ts��p���G �b�A�A���N�օJ��b���qX��8�7�a��H[��"��� �x�F�r1:�9ߎ��ۈ(|��qD�W$�vL�Ȑ)�o�P�)z�ȩ>)�л�@�|_�������P�a1���M���m'G[ �)GR@v��y��;:=ۛ�]P@�Ǐ��G�������?|(�'q���O��V�{-c_K>X��{�C��y�N�9z�r
��O�?�߽��CK�ǍQ ,Ŷ�k��-��o� ����rA��d@�e�T�ÂFH�q������i�d�����e2��q-j"�bD�&]�v���R�,}�A���N�b��)�%a�vz�����TaNg�~�~�_��ke|������*˥T��5 ���	�m�ɓ(_byl��J�f����ɥ�9)�*gK`�:��&ղ�kY��T��:��6l��.__�%�8
٢�ۇ+���<��o5m���ۋ�R".#
��Ӹ��$-��[�'�����
���W0E���=]��-�l�b�i۸���r2��;���0֗���d2�S����Qh��iH%@��Z��i;����O��Fkt��P����a�N���U7y�@}ç�ЖZ�����͙3y{�����iG���@��I9)t��N������c�ٌ�t��<ͅ�ݾ��ə��w��/b��t���    ��7�?q�����W��kR0�t:<������Ͱ����[g+���W�f��QR����6�m$Y��of�n�t_�
���^� D!� ���1�	!*� � �)��.�#\���e-r1ֳ�e�M�I�9�="����*�ִ��Rt�H��9��������S�}�ɸ�B���WU���i��=8��L��;�gƌ��Q��3c���M���������u	��O�q5��^<�C�ht�����+9�H x��j-&�F ?+���[�L�{�⮑��朌]�M���o�Zq��>���/���?F�k�܃i�p'Ε�M�B���mN�NB�4,ȇA�5|�o�=�Ǆ7�q��6>��/(����-��4���>Y�N�~]��*�v"���G�����3U F��3xG� ࣺ&Aۅ���������?_Cd�*+_R�'5iǧM�Y�
.+�N@�v�{O?�����׎&o����ۦ�GslP�V���.Dy��Q/��:�ge�uO]P2���=�ɂ��c���}�_�=�M��DZeB��[O�va�w�X�\W��@�Qb�f��+�X,K��>���ws�s�՛�a돥�aV���>�3����Z��p�0�3+�U��O˒4����A�!��Qw��,Dߩ7V�f��@�?����v����ɥ��?�����_����,��Y�	F��"1ȅ�`�S�gm͎7�U�yu[�,	Ɵ2����]V��	X¶=���ڋ��U3����u{���>4�!���h�-��U��5���0X��i�F *����#<.���&-��{��.��h�=�p�a�k�:'F�����6��Y)~���H9����HMd0Ix��9~�|�®"����{�,��ָ	�k՚��P��$}6}i�����j�J��#�	��{�dz�ߣ����p�ѭ�܉y�N��|��c��<��n��~x��к)�G��w4�}cpK�����)�C��U���=Z����fEu����ހMC@u�Vl���x���6�{�������V����хj������Q�-M�e�����c�W�aV=4���@���SN�s��=��}�B��ޭ_">x�;��%Yw�x�"s�0¸�A,wޮ,6��(4.Y�����q��F���Ԕx��r;�X�������J7��y�
��k^R,�pM����%����J�S�+�)�p�:��ˏ��oQީV�6$V��i��YWѸt$:�f-��mou�߼Ծy5�.���{£U���!����z�#z��K�e�$ ^��'"�/��o�& i�Lt�Ț�Y���#H��yc�����K����������|�Y�.����ft�s�<Ka�Q�ۘ�`;哒�͐!�F� ģ��8�	5l1{�戴���n�@[��>Â�$>��r�
��'����p4L'��`�{���>�v&��9�`1g��Fk�(֒�%���$�Ž��m�3{�q�J��� ϣ�9�fO>dʮr�݋��M^ϵ�C��U'�q�2'�5 ��ӟ���F���~'�:� �� ��U�w����/*�����T�����n��aTμ��돣��%/��j�AC���X>V�G�E٠�]���T0�@{��-c�t�q�� ��*l�P-U�[D���X�=�lzX�1���p����9VlY˪�zg|r��*]��E�&��&����M��a��1*�}���n�[th *z�d2S)r�c��?����?�'�0fvx�����O`��ߋ����ä�G���%��;�+� 	
H�T�`+��p�+��F��O�	j�
.m�l���ѿx�Qw��'��۷��ѸA�]zaQb1����+)�DG��o�ĸ����}x���&/0La�E,Df���Ҳ�D�p�CW���/.� �3��#�z|�F�On���Ip�����5�b�/��S����0�0�T�S�&t�l���o�5�N�k�ZZ?X��f�[�>�]W���J�!���?.߂_���Z�{�G��'��?��H��K�U��r�+mӜ�c�(-
��c;�:�nQ���x���d�tN�y���:�qG�Cw��Nqb���%:������f�#���""�J2j����D��\�9;�j�.��h��x�T�7�U�Ԩ+���3T�"̨6��JŹK���t��Z` +_�!��*�B7m舒�i��r,��bAI+�G�0Լu�/r�x6 Um��
z���E����UޥP�v0�;?�֋��	��UD������9ŪY�`��!=&�d�/���x.�1L�і��ӷA���b�ʨ��g���×X���fQ���a�fI�ʓPX%��f��ՙ�~�Mb����-��]��=������������LX�h��X5[�?�S]��P��ӿ�����Ȧ.��|�� ��q�(��٦�E�|Z8���5�_���O?#f�"6�F��V��zM���34�-����`ํc���8��s/��LsTpx�w��{�o0Yi5ո�c}ջ����/�Oy ʉڔ`	�`��RK��#ڬ�N����<@p�7���UOQ�7���w�āl�����L���g�(,�C��]e� 2F*$�W�R��҉%�Q�&X�D��O�fP*��v ���}��5Q�������?�U�!�z0�����)�,ʢ�e������X2�d�T�����&��[��<�"�D���&p�m�x������iT�[m��6
���-����0�`&<�י�x�Uv�c�,��1�7o���&��{����|�iҦ�,E^�j(��h/�������LL�D[5h�V��6nE�]e��0��Pjvv���CGe�,�����G�$��	�"#�>�^}�q��n�$6�����������n�ߠ�T��4��J#n"�(��ZPW�� ���2�U���@�Z?�1ڵ�7����P�܆?��G�U�O)ܠ�+U~D�]
���%��&�݊���C�Y�+Ie}���+v O�+h<�?�P筣�~C���n�c�C�9�X-6p5�2	��UB+9�F�A�|�.�����؃c������.��g� ��#�3L�<V7�Y/9�(��i��$8�n��+W�������eK��At_��0�����B��a'[xc�x����jI��"�\�T�_���&	o�OZ��D�`	Ə�B"q�V�*���
����광�Q�l�U�ZZ��$���ew��X�q��6#��aA��2�9U��6�,��o�g-(U�ZF�*���@=Ǐy�1��� �~�r��JX*����i�vM�E�ƙ8G�q�J?�|pJ�aF���}X`f��}v��ۖƅ*f��/���T���g��'1�/�i���.�/��[��X�f�o�B1�_+FuU�D`�T<]*5{��*�=P�F�^��rBX���d'qj���Rx��~���:1/a��Θ�z�UP�8c��Tn��a��k���1�z���cg]l���(�D#�jI��xob�;����_c��ȪeA��?��~�@/�Zxo FU�j�R�+Lt�X�E%��E)K�ǳjFS���̚��HcևB� �~��3\J~X�������z��K������G����J %6n�_Qlˌ�0CR��̫���qK�]�)x҈k��y?��d��k�d�ɺx��m�������^�'��w����d��r:|�;���N�����U����|S~��8�LV�FG�9h�������_���s��~^�*:R j��dբ袳�M�`���n�m`����H��pG���0,�.�J�nd��`0L�g\��q�dȎ62z����`Qg��7!��u�j1c�;D/�J-'�e���M6��U�*�?��.ѿ�]�����7��$|y�|��N�z�� �@���$���cY(y�E�f�=�>w#~C,�?�O�h��`���/����G�7}�by��	+�K���B���Qd���!�����    ޗ�w�-m��T|�Ej�2���K�'v�B���>zx(�sES�%�@��о�HD!�д0����,~�;q�Es뵷�M��T����M:�/ʒ̓��e�5�s��-�[ur*��-�������F���jUb*���TF��h��e'r����ͭNJW���Nĩm{X ���gjl�1W���q��(�ʮ��r�����ݬ�VO'�o5�[�s��n�C�y���� ��@�~��Q1;/Ԫ���2��>�
E��&�%d,��O]bx��y?����Dӝ;�f���O�ȏU��Hs��Sv���_.�<6(>=/7eFs3x�i�r��]��QunBe�\̷E~�y� �L7�GI�IJ�?6\�*���Lp()��hF���	l�T����jZ��B�-�mE������uY����9��ʁ�>t*n\��(��7�C����i�Wm�|�5��wyy�z�y���x�ҽ�-�jc�Մ���;��q�f�h���->U@��`:�ɬ*��HqXf�4{r�W9i�/�5��0�����H$nu��Ùɶ�y�/�c��p�?�0T�e�q��3?V�fq!���������A�[����\�/h�����I0�;���kep�$p�*"d���2 �4y��MB&�ݍXhp�)�p������週�#��l��vt��_�n'J[���LG��Z�u4ذ���-�q�=.���pj�{�
�r�ɡm1�v c��U�I��.*������1����O%=��KK�eB|;<|i�Kw������E����+I��s����=���|�O�n"�d8�E�dx��6�ɱ+;ϐ��j(�9l3*u�j[	�ʮ�Kok0��jRk�
�&�F}�CI�ٶU�K��&�)����1L�_n�ĩbΝ��q4��/�g��I��u�� �Ί�إ̮���H��`|����$2��d_0��@»���s�\��!D��G��R0L-\���{@U�1<����eY�t��!M�R�9�0wu_�W�]���_�jAc^�(�;.8����M�@�`�cؗ��C¬c@'et�7L�V��Y�\]���a/ �z6�~�!����j�rc��.2�a\
��8ʬJ�L���֪0�gYQ�=��ͲI�������&mg�ο!��i��-8V��ֿQ�o�[J��`�R������<EP�3�-{�b��
��Ϋ�xW��~���*�)QX4��cL���1�~���N4oz*hhdn��R��6k��G�0R¢'6~uG�A�3�y�e��P����p��13���ۢH-s�n.N��CV�N(�Q%��7�6۹ǖ;�~p�	�טֳ��wtP���Ƭ��d|��Y�����["ɰu�H��ፊk�������P�**h��X"���*d��"��W9d��3Rme��Ȇ�U=��8~��]e��ޖ����W,S�|F�����l��]�{��}��U=�>s޻�������}�$,��ġ�f�2��"(��A;�}���Ef�TJ8mz�96�k���,o7sx8|4z��H��a�Q�C��~"��Rھ�P)F����#?����Ka��p4����K��X�?.
S��D��KA)��]�d��?N9�V+���I��6a���U]`Y?U:����؎xi�#���t���^Q���0FN'��?%�FM�3��Zޝ���7-���/���m�X�ZF#�� `�ۜ����Պ"�?oM; �e�#5�]�,��ݲ����7��/?E�dꉃi0#����xdr�5m@��zi6��2E�&fYbJ
v�r[]���x��>�b�%	�-J�S#�9��� �if\E����(8�L���^S��v �r2��s��Ȳ��ѯ4JRs[B��w�w�&M?W�\���f�*C�/�;^?wYp�n���]~��3����*�_�i�!����#���!Z�-.��Pq�v�����pY7�k��y�W��Bw���#������^#�D0!��7��;�7ַϱ���������������Ru�P��a�P�ނ�$�]G���}�E �eE�퐞*�^Q����>�}R$�3Fũ�����"�D�P�]�s:E�M�8x�Pw�z�`[5� 1�	AV�������u�1ѵ7D�N���s�#�t"{v�y9��{\���������"�U�#�<���%���zY��X��F̶���t����&��U�&K�^F�~7��l�$>���톚D�=J�i!���iB�`��/�ŽO�PCl�����O���K�28���m��[�Ih�{��;�Yl�ll��U��$�ܓR��a�z�^n�x�e�r�vܲ��&��-�N��,rD�6h��Y�v�<0�~t��q����K,�i`�R��X~i�N �{wڲ�>nfp��ep[-�����Q��#��lgg�,1K��xn/c��^���r�v<"�v
p�ylX1i$L:��AS.�`�ӿQL���V�=�/�;�%�K��1t�Wɭ�]��x5�6�������tws��S'��&w|l�_"�S(�mu�������	oݺ|$��(��Z.s�@/���1
[=W�"�4�i;؊�l6��/��T&���O��H�tU?|;��Sh��J��rf�v�����	��a�\_���uƸ�%�
B��_���o�!LZz�xEN�!�]R�L�]yzE�_�e����*}kF^�qWl1֒�P$/n�����!/.�3�ەfq�����C�V��ص�}�w��8ܹ���#�����oZ7[��.^�0n1t���y�s��9?��_�}���Fa�Pg��O��q��@B����ݚ��P���E�΢��oȩ��7����Д�v7'!F�5�H2��vl�����as���k�� ���o^'���6%��7q�)���ؕ	@��^�=�?��0I쨪E�ю����?8 Q�.�v6�m���u0i(xM���z���l$���������|�@�>�k��b��Է���F�������珔����g??1؏7;�j�����P/q��I��W�&���L;��=�6�&}��|(ӏO���X��hf�YU&�"F�!Hot6|3\=�]fDR��I���J�M���J+�nAҶO	l��c�N��r� y��t�b�iuM�a�u���۹���#&�b��mG�D��>�O�y���� �w��h��3xl��9@j�I�uׂ�Y���!x���|��9h��t����.&�R��V�巄c
=	�Z~ï,�^�����;�v�ˬ.�\�$����/VM���7�T��h�<C����u�B��ժ�h{�`mHW�����Qu��'X|���U��&0F�?�Ϯ��"=�{���.�&�a���3�c�X�^��aIHclit7Z��n��t���J��44��c��4����L� �ixY=Ĳv��wN�F��t߹jS���Ϝ��t��0�D��ϴ�>{��I�#[!A��X�<��aZoe~[o>~�Z���d�k{3��o�����l��d^�Y 8���cl<4��c攠�R��Q�Zs���m��7b�կ۬}���dL�������<�ݮ��k]�����Z�P��ӫ����л��À�^��E����������ңKP>9�5�p�U�ڟߣ�L$n��r]VJz�P���V.Wp�K��}�)��:q��IC�Q'�{qWc�C7�jnk��?����}���cN��O�N��1<��c,>�6@�����!ːx��J���d�|C-�WV�ڠ�\���T��B7�E^j�[����+��uZ,��C��v:���;rA�(,�B����L�j	&�[5?��1�E�:vX@,6E�%*m���
�Wl-��ݼF֢�Fu\`J�j��!��h~X`����W*�u_�A�1鿙���s��:��Q���Jh�z2���E�� �L`�C�Y�d�[{�c�ක��W�u���h���&� �~��lp0Yzx!�\F�d|�{�cL��_ʄ%"�O�.���Ew���g�o+��I�۸To��}Y/��o���. �NǓW���"��2AW"b<�e��o�Tbm[
��]�    ��a�E�H�DԽ��^�����o��L���M�z��Kűf��a@拆����?�T��ßj��}����nl�llGi�so7m?�����X/iS�͢����w�z��X\���Pi>�Vc/�8k�Z0i�ea�$Ǵ}�,@��꧟�r�	�߆D&�5��j@���3�����gϰ+���Y���}�<|SX
�E2����=cݞ��wϰr����D���^���sR�&�%ba�����'���۹pA��#\�߯��{�Z����	�*]�W,�aV�v����%%�;�����[���.��>���GP@9���vu;LDc.}S.����r�1�����n4�ŕ�G8�`��]+��f��4�x~��%�|a{Q�-N�Z4v;��e������MQS:�����@�/�O�����*H�M2��Y���ҩ�dN}���}����$/���u�SvV���j��uY�����]�2��g׵�J<�!��?V�G��>4ߠ�I�+�t_-ʻ��}R�	�Gg�ޏƎ��s���ӫ�x��+�|K��"fQf*�q;� �:o�E;�5��f�mK��`�R[��5�(�\.�G y�C�����T[���x�w�?��w��jR���; �wd�h�v>|�O&W��q��K��0� +����� P�x[�.�ua+�H����5��7#9��]��앯0Nw�/�b����
��%�ܪ(��p�F�W����Yo<���� L�N�g}A���ܘL���>�Qrd��?���uw�,��>؍�Qa�+dK�+J��K�����*gU��G덥�窑$#:����'G��	a�}�����8j����jrp���m)�^�]�8��Ը�xӣfAz�ZO�M��:�������}hB���Pۉ.{#���Z$�O�R��^��ξ���	��i��Y	�ࠌA�B�t�6Z ���]�e9��� ����֛��A_�7���[*��?�ݢ�z1G��Y5��9E{,�<�������J��h��<6i%ԍ�@ŵBDDQ���u0�$(��mC�������i_���0|�/~(0 j�W���[}�T�$lG��������]�̗p6���+���M?z���ƇG��,~�~������E��)5��D�dF 6A=7�#yz�3[c���Y����A�ٗw*���PQ@D*�A���`K�m<&���d�#�:4ͫU����*S�q]=����칢����f�7>bdf����O�k�_�����N�n�ד`0.��������y/�����p�F�?����ppq:�#�^WKn�xkR����=���,D������7��W_���L��'W�����d��]���*� ��c^���: ���X�W*��&VB�M���x���ל'I��� �6?!�&���}xUA>�X��m����,4��h=4�~�D%�h��b"���;�8��,U���r�D��vG�5!DC�%�I}��U�f�ge�ҍ�0����S��^k�x��J�'NM�ʞ�А�9���e��J@ �|;x��HҔ��3M��-����'�sK�=�#��@��=��p}J�M����Z���}��R{�4u�'�i�H[46W�#�``F�W�:���V6M)}/��MU�uE��5ȻF����@�{Pg�w�/AA�7�&��T�4�bRW����=|ӻ
����ʑ���H� V� ������)G���mȲq�.����� �S~#�� "�Y��'*U%���7P���4�P���g�A��N��٦�6>�-F����T��v���Y&<ij�9��è<�~x(�>w����ؕ�L�s�!/��� Z��<x}�~�f�>}���Yo@�v*�e���R��3F9j�I�h	�`i�\U���ae���=����墢3�wѬ��û�R|��aF3Q�|U�[�������ǼF�Я^b��|��P���{"�O�H�����"L�E�L0�G������d_����T��1�>��>NN��~ ��ġ�D0C���Mex�W^?7SF3�Єyw$������\�;ث�6��7.z�s؟��YT�H)r£4c0�}u�̨�1?:���R�\b��\�$�-�4�n�T��鰫F#�IzE�(T���7�N�V���]8��e;�|��m���,0�5��A�,J�z���I����E�ދ��Ǽ^)U��?'{6��7}�8aa�R%�!�Uj�#	�=�Y/�
��w�[��u�������C1��u*��3y�	7��wՒ<�
�2��0��߶�;:��qL�I��M�#�mjU&H�|�i�����Z� �V���Pi�v1��ֿqw�m9p��g;�G����ٰ���B;Z��#�Q�
&�H��V��H��Kt��퓼3�ts۫�#��v��Pad{��=��f������u#��� ���Cr�'_҆c��,j6<�P�w�kX)~9����ʡU�{R���[ѥ�4�PUy@:-Ui���)#�?�a���ȼ|[Ԫ�~5�l���Q�����]��2�������e���2#S��#��4#��V�Iӆ���ҥPM��ڐw�2��o>��MY`ۆw�߄�#w��:��_%�C�����D�Nbš��Iҁ
��0ު�j7�;*�� AD	�A�@��H�c�E$��)�1�܋-�t�c���؟byW�N�[��7��Ã����h��,N�����A$��Qێ?o]Ǩ�Q���5�diWuyG)[
�W`��V�i�_,�3#g�����T�+�v�5��}����x[�'2��D�)�>����9�;�$iw^Q�k��$�0S�P�?6��@�j��"m+c E�E:�PO�N?	^�	| a�[���p� }DV�ō�u���7�'[S+���
z�����&��IS8��>�S��kDPbR�G�w�(���}GQ܈lP����-'���Ć5Qm�.:�PE�+DH�"��-�]����>����;��ӷ�/[(H���S�����U�&3���a�{:��J�"�S�Y�q���?��Z�t�lqL�f]>T��c1?6k�Q������v���o����h�,�,��^ᓅ[�:��_x��3_�м�Y�^��KщRlfCK�HZ��UѺ�@��F�^�1`�'�n| ]��"{ibMtJ)c�BaU'�4�	t�¼}=�~�瓟���$��������_�c�v��T�I
;"�Ykѿ�˻`������R�8�׽�y�ݜ>C�V�D�β�����]	�
nҘ���bW��^�f��Zg�Al�e���R��i��=���/(�5yy[�V�y�ϸ���ed��Q��i�KbU��.���[u�Ϻ�R��e��K&,�`!��e���,��qCW�aK����O3�eɼ�-T&�؍��f�pS���Ս7��H�U ņr�RM�js��>�aY �`�&_��HB�M�<��f&k�2z͍4��p1������q��F_��������7L�K�￐�)�y!S��X!�y-��1lnKpd�27�M�+9vql��P=�N�#l����d��.�,���q�u)�.{�w.�b�&�H�ꓽ8�}1�ެ���D�=dnm��t;K�U3]nq�ns��|����\��恢�槜��z�D|֑4���{�c��7�lZC�e��§�ͩ;�~���~A���k��­vL�g`5;�X���Wp3ؕy�Z���E�S�r�(Շv��b��(b>��,�W��*���
�^i��(^��qp���m�*RIa���=�����#E���5���1�d��̅�ʰ]󪁰��PUi��%�D�L��j������t�A�l�u8�ܜ�Z6���y{ ����Lm�)m��V/�����V7z��G9�#B���?G��>00fp6���&V��\��.����z��bN���`�|�]^:�E?SN�r�L����G���"�II+p�:.�U0\-���@`�`T�F�6�$�    ~�r@?:�ZV�q,���;�Wa�V���<��=�3��k���{��W��[��/�jh�"�^��g{AW��!xI�2N$��m�-YZj�yc"�2�O���4��/�W��:V+;��c�䋻�C�XKZ�4�ݲh~J{��_��J����0Yϛ�
NkQ�C�8��:�j��6+��E�"w݅����Ʀ���@����í��mz�r�|:�_���ʋ԰5�8�ӣ�yp�/������Q�����\ٝ��g��| �(�"ݓ���J��q���k�->�bM2��uaAx�FW=�f��jx�W S�5�����
���(�
�OzL�p%@5�����V���չ�� p�QsWs����Q�T �l��=Cs�N�"��uU/��nQ���P� ����X�P>���}���§`E�v�<�Qi��p�T�tgs 9�K�B-�Mc��>��wz'�U�؟�8ج�'��	(G��O$���.*:��<��$�h����a��te>_��Ǭ�{.���a�����{�)�!r�K[1	I�ڃ����Ƞ,O1A�K��Hz�}�/"4$���â��ʽ3��`qD��o=�;ɗ�ũ��$♕�*b�>"xd5(�G��?�>�Q�,We5�m���b�{&�)�/$Z����e^�]�Q'#&�3,�|�C(b$��~w$�m���;�;�Bv4��~+�����{���`����kPy`�*�=�`�z�l�� �R�ĦJ��x���M���e��&!�=�k��ĳlo꿽�S������n$�̸��	����3!2�ET&�syC�� ��[�M϶��ڠ�`H.	�qw%�I�����Ia=�Q{;�.�
�65��M"4�5�<�D4q�U��uM����m��_�B���b�a�9�]!&|��tk�_����f�\���.'��S���q�79�Jl#[3c K2P�h|�&�΅)5gE�~`mn��RrU��3ˤ�/�����k��)���� (m�������7��~��4cQ��ȡ�]S��i�Sɩ���r���ʉ��g`ہ�H��穮�u������/���R5�dY�OPL����yO�d�f�)�cV`��1z��eII�ˀ��%Z��ջj��A���5���TE����zs�����c��$s�X�*����(��Jcd�!��N�]G"��@4'T2;nFA?��,�i���'�9��NN�j���WȘ��Ι �N;�Z��ݗ�Xg!S��j�y��D��V	�6�R���Q��"��-N����w�[#�
4�`�c^�WmJ��pξ�MϞ!�(͇��C.1!n���Գ/�OX̳��@�����.o���F^��F�Uu_���}�4�U���&�����ypu9����4nkӔ�L�Ī�ώ���I��Ġ��W��:�TJ�1i���r� c*����!?�J��B:�4TIk$� S[7���wU�*U᪠��.�6���W*�AI�s?��	�w3���?�q���;e=�W���N�[S���4~�����oAf������~�̍��y]�ܰ��4��󔽝�k��5�{4{�c��b<�~=0}4|3�c�8�ȇ-��l:yʷ�bx�&�`���������K��fq���++O�5�Z�7QԼ�M)��Cꃮ'X�v,`
_m>(l��kn� =vp��/m�c��-�"d@�� �E��=q��_�����{91k=�uqwΟ���;��mn�z)�|��Pt�:� 
��Ģ�����^��n �»O\�^���i�������:q�K��75���b�* ����x��W�^�D,%1�Q��M��\#��I�W��S����
쟃}�TC�{��(
�(��o��
G�* �����w�&�E��(fK8�;�֍m�r�dY�o���=��E�u,��ˣr^�#���|=�f���Y����Sx��s�T1R���R�Q�|���^h6�)�Q������Y�{��f��j�&/�������v�|����*�<ۜ��6k���Ly�Y���E$�y�Yq�y�氚q��u��7�M�nF�DF�.x��2���N����m�F�����ld��(
��Mc��6�2�=Ӯ
s���d��*u����^hy�ae���+��!&e�)�H�@��Q��wT>�$o�����ۊ�y=5Vݮ�.�����B7�T?�����G��ͲIMo*��ht'�Zt�V.?�q��Q���9~��p�B+�4c U���&F<Q�	�}�H��6�&�Q�l�ˆ���0�(�֛6C���Q5<��1��ِu7~���pQ��V�U�|�m�Z���@f�'J��m4�qS���c�8fa�fFQ��@-�7&��[���a��g<���'�}� M��o����VEW�D�%�n��M��\b�e ��N��L�a�$a�}L�������7���Z�����|A�v�$�a�kЉ6��H=��Ƈ�i���>�W��n�(K��L�e��k���9�"H���|��\V�4�����D���������M��$~)��g�g���\9����ȺxX��r��������f=��.p�OB��>E?X�ԛ�M���: ������t4!���(��M��`�mts5|�{ބыH�����8;A�,Rc*؞J����O
�;����K��ׅ�$q��g�<�b�,������K�!ۓ�d&�Q6���\SC����u���yy����=�n)-)�"��(�� �_d�t�hN�\Vm\�}ʗ(����s�=�+X�x�K�K�NM�)f�53��Q��1Iǈ��%J�����|]�8�z���;³���Ձ�!��I��cqYX���^�5�+�{�R�3��[�/n��}y������a�5<���t8���!=G�RL�1d*9X��:�I\�d�Y'� }��q���~��X��8���'�q����T��#��3rh@}�1��Dn?L{�n���`q,>zsrOr\ԛyn�]z�G7㳛�w��{Gt-#��#ck ��س}~�$�I�Ks�jv����d�[��� �"x����t2�L����I�¥�"��PJ����1'qM/���xb�K��:We�	��h��`ߢ5K�a�<&�YY�0�8Қ�%ŎJ�����
�Y�|	}�v�#_�F��=�D(�Z&}�$��@F1OIcM��LD���(�.��I��ۢ^�f����z0ܻ�����1�ds X&§,�I;,r�e�@�£�ب��.����1�G���p4L�;�NG��'VAg�z���ו�<��1�F���ǈl�lN�z	o�W�W�"�[��[���vG;��_݌��_
������LY���5�Ab�Ľ��$�,s�5�T��jS�UX��RH:g}���b0�&V����3�I�4M�f�5�d�w�ޜ��c�c{���(͂^M-0�x��(b;�]"`��J�D�-�Obk ��`�GmL*̜�F<=:�v�X�7�K��q��b��gk]���1����XZ�ښ��u�,RR�b2�5 >���]�Iˑ `]�h
�H��}U y`�M�����y��Wi]q
�+���4��Z��$]U�L�B��9�WEpV�Πwu���H�
c�kl1;�����h�ˌ����0�I���H�n-Ӟ��D��2%k��}p^ح�5u@l����b�+�5�
c�dI*Dd ��#s�Iz�)�/9K���)�(��l*���%�s���8���'{^c�Hem"���U`q��4&	�g�%�G}�n^���`<8~}�t��qIg�Ҍ�}� R�D��֤�
����c	���.�]���A��]Ƥ$R��0)W�k�Q�����I�11x�zugm�4T�<�'�&�X�3��"v_�9I���]K�zm���EJ�¸D�&������g��+�}��%��ⒽZ��T�F�K��J��Z���b<�#���m7�o�옫W�'a�5��D���2'�M]���..��YpY��墸+�7'����W��cЏW��[��
���'')�"I�~��$�F�+8�L�P��jr��Z    +��]�����+�>:�\a&͖��ۯ�)�	��������2uŮ9Ibﷳr��z^-���;�.N���\���֟"z�L��7@(�`8z�0c`ųtmTk�.�SN�O����5���3�(_�;�#��S �g��p߯8Ԏ�py�0�1�q�A�:�ۜ�S��Y�],����� G�cWl�G��I�=�MGCk����]��1c�xkJЊ��gy���~�ĵ[�E"c1�{:6�'mM���2K#��N�i�>���ʟ��7y�7yߋU�	�kt
��2D��k�ؓ��e(�/(`}�/~|WR)�����&��}�z8n��"��L�a�z�N}�"��*��D"O�9 ?�u�I�"�8�9B��Q�,�_<��t�a�������XN�눁�"�9HsҳF!�&�Y#�buЯ7A�`�$�����]s��E�P�0XI|°wxfL�S,��%���P%~$G2�0�����I\V����"[)�3X=l�5 <�ymX��Qp��V��}�i�� �AЉ �!�@�J�f�-`E���w�iH؂��taC�H�A��7����0b�񬰝��r�B�1��p��@�����qmM�d��p�Y�>��Ѥ�)��%`����a�B����o��w{_/�
էY�%N�5 @	`��{c���؎�z��n�u���G/�������^'��Z�9�a/��&�'�&3���q��~oJ��!(���U��+�+�N�7�w���
ɚ�f�,���S�Θ$�o[�`z ǟ��$8�R�o�!	��'�z{{_,���cijD��3tq�9I�y �be��\�2}]������F���	�o��WղB�J)s ΰ{�� 3'�:y�Yhv4*gU��+�x	��w���z]�k���g�Uoڦ��o��T�`�#Rc E�&w���$�é�^.�"S�JU̄N������:�
RN% h�E�_s@pl��&kR٪³T��k��q��E҈K�K�m����s8�l��w9���������U&�5e`ff�$cR!���2J<�E�fU=�ov:������nq�Œcb\X�fϫ�&IgR�٬e�hS��67���������#.��eՅ�I��ů9��D
��kN���6��8\׀��Zۉ�9ċ��`4:�	���n�;鷬�W�f�X��2�7���,�MtLe?N*�xr:�2���3eIő�8H�TzB/�$y�"W��n�H�r��?(z�.�d���|r�N���-oW�ԟ\\������h�`� �i�I�H`k��Q��av������Yz5�\����+e����`,a,��|ړG��Z��k�Sɶ?�(��;�����q��A�͚@QX !\O�9IϔyU��9wZ�wж���C�U�z��5 P���I\`�$��z��$8������NO�>�Aڹ��/�
���sr��I�W*1��9�`q ��>`����Р:Ά��dh�YƓGeN�=�%�VLF�v�)D�zQy{/ӈ.�1�3Lot��I%Z��r�1r+��1�$[��ը���k���~��].,``rO�ɚ$��Pr��-,j
�W]�a��ӛ��޸7��j�⸉'�1���H�RMܕ���oY��%�K-x W�@� �;�f0���榪p'C;K��R��A+�8v<e�$yʘ�Q 6+�:���:�4�z�A�uo:�:��nv���PIU�'S ��pR,v���I:�tۯ�f���.%�����	�I�����Ȝ�U��Q'Y���7H&So�����W����.�a��R��� ? á�����ٹm�ٓ��3W�$����I�O�� �F�H"���2���,q��9� �ǝ��b�7��Ln�D[�X&QQ�9@uN`͞$���c�[�qb��3� �6IxY9s��5Ip!���D���@g��=��NǓW���R$~Z�jD��S��|�I��I
���-GS�N����`�Β��_��
�����]{����e�c�@�*�k���
�g�t�-��.m���-�� +_n��G�`�G��2k 	�f�nL*t'��ɨ�qS�
����U��n`��5�*'!��,N���D��듶&���x��l�u9
������h��t�����t�x�'�E"|��[�s�W;�9���TW"K% fp@݂�"Ԝ$�(���a�l�Y���:���.��6%!��fb2f��.���c�<=��3 P]ϔ�פ1�D�4��n���z�쪒�(�#�6�1k �k$w�9I����"�]�.�u�@�R&n��>]B�[�X��Z<J��]�9�/�g���uz�u�dYp���;�}���N��fp 4ϥ�>	� �����ݰ�9Ir7�xo#�	����~}vWw�U]��S�V�@XI��Rt Xi*0��u 4�$�C��=��F��Y,x�K��ߪ#=X�(J��a4��d�@b៻@sRyH�[p�IS!qu_����[�\�F���`��t0�`p�	2Ģ$Ʋ3��@�����kR�#�.X<�`�^m��-�'sl�c�CB�����զ;ҩ��}�c�61�D����l��������5'I>;U߸vytJb�N��"�5	F�m܌U'�yۚ���`8|=���nvA����h`����L�܅[��R>	���ދ|�$��w���C���J8�@"g�V>[�>�Ü��΀��k�^A�B�	c�rk �^�.?�5��W��hs��v���2m 4J/�4bL	�D��I����`S�z��j�Y�t2��}�p8WiE���>35@_�!E�g�=I�KAd9�k��_W�b+(��CF�_
�*�Y�&4�����ˎcN�q��s����^���<��R�%�E�H�c�}��$y���uƭ�[�y���O�@�5�5R~��ﲐ��5���%ǯoN���&p��e�\���)�y��ఖ�]������aI�1�0����&�'�#�b�?��@۷�{�v�2�B��@o�آ$�$��;1E��{��i�n2kE�F�9�x� �I2
�/\� L�c��W�t2��⣛�t��������$41@�8b`!X`&�Iܲ'q��/���\,�rM;�g�B���`�w}ܢf��r����Ԁ���uղ9����UTq���UyO]Ot��s�Ë��!�:��aH'�mPu��D�I�3��_-�
�C��܌D�1 w=̤�J�Iz��@���|˂�fQ5��p. �!��PS���V�nޜ$M�Z���Q�ZΈ�y^�civ�0�bA>YL���Q/x3��>@�~�D�8�$�6��@�iO�9����eQ�r{����JS�5yk��!�m2�����@!c`�3s�4�I�� ��Er���"���\cj�Oظ�]]"��@&�g��[�x�KskM�a&�+�E��8��ջ���]�PA����L�n���Rzy��'�T�[Hd���[ε��1�Sz��S!�v&`As E�؉�[�t���`,J&��Z���wϴҌ����� �(�<��$i�X:�4XA�V�^�<�b�7�cntխ��ؕ�}�p���G�M��&�z��4r�R+smn�Ca�L���g�5 
�b��5&�}�0�%��ҡo��YN���#h��4'�Pc_a}�^�Lu|6��޿*S�Ơ
y����`�sR�Kx������^R�&;��\�{_���Ix�&+�� SR�{ƚ$����Ҩ�����	\����8L�EP������"f.��9�Џ������V��Y���9���C$�20[А�e1&���9�����t|����{��tr�u���Hhl.��iH����naNp=�`~�`���&oJ�`c@��ד#bL*P9\�L���Y���T���pѷ0Qnnd���k@���QFs�\��_��K&��b�?�ٕ*bSj����րĚh�L5'i���Uf�*Ϫ%�iW�B�ɘ8����T�)���n�`O'�a����hf�~ �    d�N ��B0�2����V�ls��J�gdl+�8��;jh�e@*ޘ���`�900�n��s�'q]p��+���^#��rQ|����p4�� ҈�D<&3���D�̑nٗ9IR��˄�j��3�R�=ʔ^�1 �!:�5��B��cze)E"��g���S]�5,6�v9߁����hh��@,�`�k^�J"����r�)>��{�T��zm	�Ms@��؎��'qI2a�W��?Y�Z�u�⹊��֢q*"dog� |�<3֤� xޫ��uȖ���ɖ�NF��>H�a0l��AY�
�WX�|�:�A��Kuq��f�\j`Í(
]ThN^�\CM����V�v%~�j������<�u�$��WJ.�ģvT���N�:%�I��Q���k���}�L5՗A��ɮ^*bؕ��T#�և��dw��#W���w�,91�+0�5 /7枂1sR�_�Y��br�/�6m���<�Ml?Kt�8�bdtԛhفr+ȍIZo�	�J������w8%	lH��1���nE2N ���Ĉ���B7�A�tLK� `�0������`�ą��a;4�f+h�r�<�qhd���&I�zp0 坋}�Z�HmD4���5V�xjo�IR��v�X(�.���Qu\V����	e �WL�_�@��^nɹ5I��G�	�ϧE��q�����ՠw�hS�:N��8�X�	�)�/��Ş�ٍ��X M�Ũ��_����j_FŜ<�޻� |O�=:sR٬�#�b�^��Z�f�Z�߰��D�'�>�NFW����L��X�����a�7zhNҺ��)t��Yu_.�Y���Ʀ��5�a琖=�M����U����q�
k �~e�[cR]_��Pv�Z��=Z�h��m�#�%��b�Ԉ�SaL��L�(��TC'뺼���u0�5��a�܄��v6�qk@����ə��ƺ'�0��[�s�)�N Mφ{_�L���i�A���S�-1&��nwQ��E;���o�Pn_��b{�4�g���h�K�dL�o;tkY%l fb�JXh^d� ������&����%f�S4�8�`�C��M�r=�I�3�x�¾XS#w6a� ����e�n&�tu�D�B[����X�+�w��CA���������p|~(5N�W��D�&� ��=m��Iz��~g��s>R���au2�*��lU~�ʹE$Sdg�րLo�Ɯ$�Fzth�:u�ÙQ�~�|�D��!�@~F� ���]cL*��S���u'�	�¬���G��|Ǎ:��np�]��D��$�r��!���';���TK(��+)���Y��ʟ���ړ$�=�Pr���U��%T����L��� �X��Ml�&dl`SI�q\�c�S��"k͙�r� ;��Xn�c�Y��]w,�����[��^P���yu�8"&�V��i����\cRy&<�����6�'��	/��^}�怒˜#s,�Ck ڥ�0'I|%�!t9~�&�m�&�O��	d/�y]��N'�����U�q��rdPW�k�0��p8ٓ�����RG8j6�������� �`�f�)40)9e���1Ij���U����E�������Y���|,~(A��`�{M�|�SVHEd~�[2C߃�2'�����j���m�V^7T]`f�B���`����>�c���5hcfp��ݤDs�v����Vo80�����/��v�`����~(�� i�e�)A)����I�` Jg���E�����o7[������:�����P��h�[8�돍����܎��$r*'����\���p��=0|/� ��
v�.��L����r�N^�=����g)-�5�F�kx��|3�F���U� +��P/�@l�*���,r��9I�և�e�C`�{���x�7�?�Q�T���1�BTr�塗������r���j�����Q�rD���r]��=�|>������r�(�<S���m\� A�b�IP�Ң��}�E�$�"���U���q7S&�u�n�&���2xUmjr���:6P�@��b�v-S�n<�(�H� g@m����$���Of�z����ŬĐ�Y~[o>n��Z��!��L����2�Z\���&��$u�q�f�N�zWֹKw�� ��o���� u�J
��HיY�r��sRy,bϵ�G���9>.�պ\S����h:�p��1Q�d�&���,>��vs�|�`G�=�8��F����j���2��%��uL��IƳ'IsF���F�k�;�\��F��ʈ��Y$�9���X<헌I��ؐD��y��_�x:-����q�UNF�P2idȄ���$�'� ��y�%�G�i����t�(�WXB�Md�25@_�/�\x��fO*,!]F�g/��CWoЯ{����ǁa�[c`�da�jc pg����1I+�n�@�^ZF�y8��Ǘì�t�D鞵��\��;e��$i�Y�]�-~��(W�[l9?�כz]o�[�k�ݽ�Qo|�|M��V F�5 k@�z���N��X�wX��@Q�4�ѐ���A�Uf%G��ױ23�(k�gh�8���^�U���4�H��pGyv���2����gX%e�����΅�$���5e�51��X��<�@ੀ�3eߵ|`*�e1�p�5 (Azr��I��]̣�-�f2+�ek�Ж���Ȗ1"2W�5�˖ɸ��PD�NGvW���c*���f��́$"�<�ac�Ĵ'� ��3��yqc��DF������2�IZ?(�m�a����
�e'�.���p���q�<+B��3k �a歱3&52���������z^a��U�>�L�&������֕�x���)퀄_8��i3'ICe.�ȵ&��,/�uS�e�.V��:T��Pm(�p��9 ����c5'����$9z���
��U�H�vE]-��	.6�Q�b ��$x3��|�� X
M��ʰ/+�@�O ǚ�g��.�,I�`[��!�a5�y�&IhP�	7XgMҙb��Jyt���9u����{���]w�5�������T!�QviD� �@
�Hb��9I
X��Mv�o>�Vu���+��w������g��<��J��D���Ie�G.�f۵��9VUJ�6媕F���W��`��l	k�"�	�}s �Kp_�ocR�Q��'ض�,�j���~��l�,iH~c��Xz��I�wq�l�_A�!�`�P-L��[�����ևa�RL�H�@>̓hkMj��A!�#%wTa�Uy����t�K{��X)ا��5S�bHLr��'jN�J3O�4�5��n�#�^��fە�xģ�U�w՟���rEgo��,a��Bl��SZ�t��B�����r]`!R0:��F�R͐	,�>�� !��k����\_pڥ^�V��p�W��û�.: 8�8=	e�tm���q.��7�B�1ܺI\����bU@�v'�^�:8� S���($�6���H�DN[={R�=����=Mu��{�ϝ�	�1֒�%V:��n�tI�`RHk B~Ჾ���%s/oˁ7.~z�ضh���ȴyֻ8�U4/i�&�A��)Ո9�8k�^(�8^d�P5��F#�� E�}�1��'������E�N��=I+K�v��]/L�,z�׳bQ?�U*�) l�T��s�0Pj��y���Iep����A��( �̓�Y��������<����.\U	�0M�)Q�k�H鶮�'i�¥Ȥl3w�����E�SU(��
�AL�_~Ԝ��Y[ȩ�9@ܢ.�5IȈ�5��>@�x]>T�~K�U�E�u�⧀se��� ����4{�ʶ&�q�	�����Ƙ$���NX'c]=~U�+@�w��F��6��Z��FY�R�&ӫ`4<}�� ��`G��HBk@�;��0'q���v�O+��^+XߵJ:��N������D6	�	q��ׂ�?сS�$��8uծ�����7�\�M��ʍӓ�k E��k�jL�`\:��,q�x6g��x�^��@�&�@��(n�5I�    SQ�ى[�>����)��}u��Lڳ�b:Lc y��K$gM�23��l:���:�PNA[�ut�˪+���]���䫽r[��	��0Bϓ5 Y���bN��B��l���*�w�m=x1*�U��ʸMr�U1�XO�5s���D�9�I��Yͷ�w�@���&Eݧ�@����Ԝ���|ݤ=Xq�)d���۱�׃�`| ��iȰ�T�.&k@`V�ӷȞ$%���X�Z��Z�s�]O�:�{S�V�;E�f�)���Հ�Zb.b���Ƥ6q�}�`+G��0�>�X�bW:b-��L'��F�Uot��.0��$�
Jq	!�ΙX�����:�,ro4�G�U���DKѻ��;˻�)�C���:�6�A)�i���Wĭ�ɿ�Td�x���-r��.��_�֛u�ң�p�ꢷ����L�e"��cUp5��ΰ�|�Ɇ2'	{�1�2��W~����px��8�*p�ظ4 ���5F�� ؖ��$�
�T������\���=o��N�,t��f�l�1d�A)WϘ�
>8%�2����5FE��&������'W�驜�,�ؚ���)��)��'iّ��aټ���b������;r&7BX'A����AХD-CK�#��@�Y�n|Қ�+	'���hb\=�+��w4 �8�@4�r!�B�NM+�_��A�R'sڜ�����1�x_]������5��+�&�$�̜aj�(�򫙓t|a��1�g��˲"nD��˫&S0\��Huy���\pk y�����9I�(I��s�&0��ŏ��#��{$�lz3>��N{��O�]Lg��g0d�r덬I��I��@�C:X��R�W�ƄDDb�������z4h*D���b2��1 b+�=�ԺI\�۞
�������b�c��1���'ʍx���%h����q���dzFl" =bB3�rl�b�1�.����ȜT^e��vAq�!��3��Y�a��uꇶ %f����ڠ�6�d�@����hO����(��{V�;����
(�(:���7U�I���b,������ԜT��s�q�Js�1_cim� DUvc(]�j@}aYR��ړ�q��Y��)p��ˢ��;�FL�re��~�;L/Ã�K�U��(Nb��C�Ac�GQ�=���$.Q�N@ Vܒ���r�(��e������b��8�`�F�i�0�2�82�z�����b��M��ls[-7������d<�2>��y�@%�XI��zX��is�k�����W����s6�T����1��� ��JO+Ls�Lv�L^i��������&{�Rl�8�� (���$�����9�TK깨���u
Z�X<�O�ׇH��U�\¡�ǖ�@B0=T7�$���aP���|��d�M��H�� m� 4ӝ��0�����0u˛�I2D�8��)o�2�^�uٴ���'}�КT�(u}1I�+�<Ų��(��U{��d�a��1�Dbk@� {<jN�����;Y�� ��KX|N^.��EL[<�� �$'������$�>sx�`�ۛ��E�>�P>�1 �������҃���e�[}?����d0OEK���P29L��$	-����T�96�������E�XK�g� D1mn�m8֧XB�w;Y���cO<>�b�`�P���·��������˭��R�j@}�]�9w
�I�������.�3.� A�m�?�.������f��'պ&�X��5�3���y�Ƥz���U�<�7��
�7��U����{X�I��|�(�Ƚ���j��w4�n0>��Q�� I���0d)�ck@bə�O�&	�K��?�fp��j�~���p���Ħ�i���
�m� �;�Rs�����/�f��f���\���!�/W��رg`��ת��sc�Iz����]X�;�����ܻ,7v$m�k�6��fc�:q��gH&R�P HIi�A2�L��DH����a��h�n�YͲ�b���D@R�����*8#����c���x��c9x�|���Ѕ�\.��	��~ż)>aR
)�d\/A�Y}���y?�~~��!f��q5>}���@p��	VB'���"��c&��ɡb��pW� \��Q��8�����/��K��r$��I.�(t�d@�����vQ,���φ8�UX͌��+���1�x�k��;�,�vy}�m o
M��7���%����`�����-R6�P-<���BȔ�P/ez�"[[��D�P�Z���`��:�i���q�К'	�|U���>�-���_����O��d��c!-k$���ۘ��q���$��,L�Lϔ�R��z�����en�g����-��	G>r�"a�k�����9O7�O[ ȯ����z�Lʦ`	�?x�1A�Z��\����)��j����\��U���|z1+��� g�MF�9*�<���*R3�b�b��h����B�7����o�}��ԇk�ǁ��	�аa�r%L���3;{q�y�_z�ݞī�PW�Ţ�7W�j(��J�	k�}R	Ӈ|y�j�xwű���l�h�lm3�h5N%�]�+f�dE�"V���� ���nw�P��%�w�`���"6���ʄ �?7��3}~�f�j;z���=4zm�6�A�t�O;��j���
�pjo�ppa!r¤+��X��.n_m�O��=�+r�1���EOA�����)�k>~�������ch�% �����"mO�K{��ן�&��r<��u ��U��1�<b��E��DE��9s��[�w���y�_��x�y�ǽxݷęi�@��p�hD`m1̓s1��1�@S��<,��E��f����ʯ('�W��
<�[��zXH���KV��b�1?g���M{1��M�h'
�{1�{<�`���1뇧�^�X-jԧ٪�E����(�=��	�
�	(LFLz�*� �����.b���z|1^u ��@����%��W��6���R*��ppwI�c]{T�k��m���f�� ����f���(,�fr��[.�@�n��~��>�k�\�ݎ_��Ӈ��7�0j����o	��/��cY���?�O�-��p�R�v������%wW�=��>���k-�B���\c�0���Z�*��K�^�J�$IS(�Lz���~JۇJ�֘����Z-��dqr�z�\u��
v�!�ob��F�3�E.lܿ8��|��˺󺗒�vd�9B���� S¤0�dH� �N^*�Un��w�v�^w�`u���psh}!v�"��e��IW���A̐�������E��	�ꛮ���RT����V3�>b&�]eh �K"���7�W�Y������רB��Y?���� ���1f���y��*���?A����fe��e��o��A�Q�*˔�P��[C�� n��c�q�Y6�`� x�C�{xyΔƒX�� P�M8f�qbQ(�Q���0D�x�@���h��q�D�CYCNUD��7�Ne̤�AT�t��������]�8m]5!�u�(���-~K�+�1�N���/�4T[z��yx�����{��0��2i�	�[���CM�2���}4��w �M�ݯ{�G�#:��g��.��4)�!8�^���"`]V�M�dO��Y��"p�=���
\s~�Q�^�?��vU����u�f�����c�3�s�$���y�%f�LN��f�3t�}����y�~>LL4��u�7?}��A?
S���9��� ��Z�����u���Ւ"���~��~�p��������O�J�>/���Zh�$�&�`|I=�s#fHF�6��!t����`��_�t�$��",���~D �e�!$L�#&/�3mE�-&��q2z���>��Lͨ��������;�E��b�W	A�j��Q1)��
U��$�x�m���ޯ�9��U�ĩ�	�AB�W�%L�{�|�"�������p�W���>�6��mWM������ d��0a��́�A4{�����,9~�o�~������n��=�-��ջ�(�Z9#����    ����Ë�d]L!�m�yW�܀̋_� �O�9�.�-D^ ���%n�V�F�$	YIB�`��6����Nn5ZL����Vy�i�����7J�B/x��!f�Vlq[�[��oЊ\���Ч��	�+��9�p��-c����w� 01�=�{�+��jϪ�-+�s�!��f��Ϻ�S��+������=�ބ6W��U]�}bU���,v�F�b2�1I�dLlvɜ�|Z������͟z��g������y�tq;����7|s3?�B2��ۆ[��IA
Ss1�D��`7�.��Ri"����Ո�a �Z�~*P�1{.�·�c&Š�PWt��7�f����ݕz��R/��r��1ǉ
��&�^e��m��| j��jm4x7��� I��̜E�`����Z��g�L:P��x�D܋-���q�d�Ќ�M�=w�nE)Jٰ�04��og��3! ��R')�򭄇b�|5�����i����z{�檗���dT�xY��M_����/��on̤���K[������^d����d6;�䔜'%��xވI����n4��Q�f{����j/+UP�1���$�7�c�hʼ���l���M�E��PZ���>9����ZU�ۄ N1���Q�<��L]ܾzJ`�_y�
^<��?�2}��뼔Rƀ�:!Hp�li�NĤ�T�G(�T���������������Kn�Xl��`dB@XTy{�$	q�(?N{J�������7�c/����2�2�E;lBP��|�,a��Q��=g�n�?l�Χ��7'��T�n��h�bB�5�p}Kݟ��� /��h� <����7��E2z[����������w�$Vpc�b��h��I���<�>E3k?�>�?,Dsaǫ>�upS��K��F�X�-�15L�.�m�ߴ�x]�Kt�1qg��b>Y��/��|$���E���Ua�r�$���*���G��~_E0�E?6XQ_��-9/+����b+o1&h��wj�L�v(���{C�ۏ���/�*$ �x���R�.&��q�� ڸ4��0I?	��^ �����W��~�-b����U��{Gׄm��U%�r�%���8Q�6�W��	�"�ow�����b~9Z�z��lؿ=�Ak�g�n��%eq�/���t�.,������|޴��p��.=T8��l������1΅S0)S�ۨ&ʉK
3��.BЈ]�%�"@�?a��_i\���,1���|}q�D�T�������}
���u>�;''���?�oǣ"���J���l*��4�G�}#���C�1e�q+�{W*�_�XF�+��7?�ҹ_S�p��a�0"��b�<G����P�tpq���ttl>Õn��uY�R���A�[��]l���19� ��5y��Ҡ2�����n*�!�Lpu���I�I�F3Ieڵ������q��a�2�B���4.P��%^ ���er��H��c�7L6I����G�m�#����hx5Z���:,�P�`��� ��3"�Ԉ�>P*�_���=N���6Qol�p˧��*T�����|,_y�o�Nq��8e�!Õ>,�)�0��_ׄ8Й�T���;� �
����d���S&�]���p��O֟�;m�}~�>�>��f6..�z��h[���	AA$P�s��������a�_J~S����������w��7���YB8a�S��5W�(��m}����o�K��oF��ӿ�zyd1,��L'-��0~1��\>����������G��#�	�>F+����$`�qQ<��22!0��@�S&=K��\��G��j�G�f^�[�B��Ʉ�I���`���U9^6�U�S��a_o�������������XB�������e�!?܇��/��Cmv�/w�7O�$`ټW<K*�ͧ�՛����q����K|kaCP�_��̤L��t��n�7�<�%��.��'��O����(��܁R��'�ol��cY/O���3��@�-���j���w�C��hW�WF��{Wsп]�#lX|8N4�1BP�J/Ć�\�ha��|�_?�0._��%B�v�[����%��B&�4/$�&��"_� ���u�Gg�Ùw������`R	�!4d��'L��-�8�Yt�L�.|ul�<������7��l����^U�����p�t1qL@�| .b��ϣ������4�pw�����K^�#mk��jMK"�A�)�L��������Z��`k��u�P��6�c����>��W]��z�ةV��`8a�r1-�t�Y.F0�������9j���M	�饳MM����U�	����A���Zf�Q˕sQ������4��Kg��3�IT���	;eY�F�LJ��~ز#[��(k���}�'�Z�Ơ
!�+��Ŕj�JGLJW؂��:+���jf��r՟��k4��u�d�$^����s91Ӈ�9� �3c���������C�P]mz�����!��8MƋ�ʹ���ONa��Y��� ����3�)s��f7��~�����{W���7ܯx:b��Rd��T1���k���`�X��vK^�T���c���B�X�ܼ��r��O؆�~���	��wt��2I�CFV��"Z�ٺc5��%�]��i�4� 4��iC�P�I��U$2o��t�E>#�.M�<ߣ��+�ת���� �V	\�ύ�L���ŤB����7����ƫ�.��2��+p�VeԜ.,Tz���TBP�g�f��I�^���5(,����WAaO��l E�W���	�)��ᯄ���V�u6_/gk��|�iT�ߥ�!�vG^�d�63I�)�����	:����/[�g6��-S����I��0"u�S	���8X�8�w��|��v�b׈����N�#B/]' ��� փppl���Y)a��iXKյ�HB\�����h�
N�U2�ww4x��*%��J��`����>���!-<e��d��|��V�:z�}z���M��~�uP͉������9f�@Fd�Ck�/��v���-�����c��7�_�a;^�����$�~�~�����I��#yC
(���$!�3�[<�0�� ��'�qe5B�����mn¤�+��(�"��� p_�u#LW#��C܈�S�N�¸u�$�+M!����4����@d�+ڿ��N�k1�W�<J�&�ԸĊ�W�7����N_����7�8�.�;Dù	��R�8a�p9eoV�tMk�c�b�_�^+�*�ו�T{/!`}���c&�-k��4MՔ���ha���L�������2�	#4��ԨI�}X��(e���b@�
��t�����D���È�TK=�Wո����4�uV'��|KF���B@d�$����Z��������j(D��S������Cު^X$�?iiLp^g�<�0}X�������_Ex~�겮�q����ND��U�6fҁC$��k�^~��v?��߅y{Fw���l������q�dbw��Y�����"&�WF�R�=.�|^�����v��Qx�j�.�>�ᅄ�iza'bRlP���@��k��u0-����d��9�U%t.EB�M�V����Ph�oi��^���%�;��� !��]!��Mr-AT�U�̵X���{�0fhJp�O�7��zv]�]���_���~e��e1�0��&=m^菱4D��1�������m�~�K�4\M��n�4��Tf�	�<��T���^��Z�­[0�cRsB��A���(a���9X�p�z�z���}��p�
^��z�࿥_ɛum%Lz��O��"��'PG~�iZ=x�G��]��O0X?�_]B�B`�-��"&�jt>j^��B'�� ����[��jk+�>:!���
�9bzg*o�E:/#Q(��!�_���d(y��$-��	���P&�9
SV�_Վ�����=�نv��=Ν������'n�_p#�*�W��=�j[V"�MO��ޮb���    �;��s�(㠵tB�u�A�f�&�\%��+Y�梛�ד���j�Ϝ�ϪI>�_΀.&�vrX.�X�1����~w.�V�f@�pD����'a^�=l�ɮ+k[mW���N��U��f�y�V�E��i
^/��Fw�ȇ�"&�����B��u�`}����i�����_�-
�Ka�	�zEsE3���<�L�3��<��`�AS��:w���s�*�@1�T�I���Û�Zd]X����d<�{��J��I�0/�K޺o6?l�}�}||���{���Ҧͻ��L���\G\R�h�*!h�1�ZH��L>r�Y�~��B��l��(���� a�pc����	�U
l{^'����p9� F	�b��㠸�d��a�{3�˫zMQ�YF�$q��$m1�T�珘�1�g:$���ʓ�v�Bל�Mj���w��7��&&��N���+O$o�察��O������ƌ��Y,W��xW�Sp���,���(N'�p�Ri�D��z�t�u|�=ݻy�~X�<v��9XE{࿵?�l;a�����2֐ym6-I�����O�}O�'�z*����Ȅ F7�I��'�J��xn�PP^������	9f9��T�;a�%"��tP9��(��/.�WK!� /�u�'�i����f+�a�B8&p��-xJ1�T�ʓ3R�X����ӟ�{���I?٪p�C�8���eۄI�hɲHq�Gj��>=<l7�o��?b:����qx�a�����ƣ޷��ףū��n�iF(Di�%��
Y��S����������-������墿�9��d=�`����4@���g�Rfȟ䇩x�F,����~�%L(?�k �Rp�<�����1��wc&ɤ
�A$<�fg�ݧ�.n��4�����M������>,�h'hĘ 7ι�N��C�B%F��n���܂�mO�ݎ'�>5�����Ҿ�IpD�0�YO��f&ߙ3I��YW*� x^�0��蚫�b�����I�?����G�Da+$4K�H�-]���h<�SͰP�$!`L	?*f�)"#���%�1V����+�N�Y��b`G
m��;@����-��r�q����k��X���B3���|盉�[zl�<�3Ip��xҰ?����Ƴ�|:.n�}�$���FWw/DV��+��EL�ؼ��~�C}�y�%��~���h%�56xLVY�xB�mкp�c&����4銉���M�?TU�E�z<xs�L�q����309	A��P@�H�t�U�	������3.�nϻj���u�)��MN���JfC�)��-�*ˤ��=FY��6�����i�c���J]� 3�X��?lCk���;�������oh.�����������z�l=��a0��ZT��i̼�{y�P�v���v�����"y`� �Mc����
�u�=ڵq��@D@�e'�x3!H�+`��L/~!�dm�iͣ�dw�+ؗf"��V&!`Z�C0eR:\�@ `�b}��|�	��F�E�̻c��L����:!H^��W��>Y!jr�t��� ������+r@OW���u\0�?��I�N�ͩFaj5L?|��~׫����.���b<��nG�����䚽E�
ˑ�p8W*��8r�O��L��2��_�@~����E)Goɻ��	�W���/c�"4��(fzY��#,z�X~��0ŵP 뻛��G���������,ny͢�I�*U�E�z}��o�^=>nw8 �n�@| E���@"�!��XU���*_o�<���6�������I�0T���ApB��g<_+�0Cz'SUZ��P��n�ĭ�A=O��v�u"<b39��1��e��^�L:h�/nQ����7(�tVPP_�@?����Q���N�4N���&%�
�=Z�^����ڭ���1Z��r���%�`��cn�b-X�j�����/-_�6���X�?Q��bp��V���� a��:�m)�(�'�oZ<c!_�ޗ��]>Յ6 w�d��L�-8�[�!1�{-&i+�3K�ڦ��z���#�ғ=5x�q��� n��C�B�����|��b͂M����P�r�x=��?}Z�
S~Y�����r0���bf����)X�鍰'�Lے���4���$-ݯ��7b�k(�.���?���m��~����>|X�q���d>��(��s�8�	��~y�S���'�T�����j�?� sLؘ��i�
���I�k�W�/�Yn����}|��#�0���%�K+�O�'L\�,�x:>��������f#w�u4@��x,e��o���dV¤��v>J���H��#��d|yz����
^������}�6ۀ�2�Fbu$�<یfշ�f6�Y,�W]���w=qY�� ���*��I:����fg���	�r�������"2�J߄`�!��O����YYq{��6�!H��V��77���LX�ɤ�h[mB�����y�8b�muyJI��_)i�RP�[0������8���Vڕ:�"�O'���0tGX��������V�f\��A<&@0  �ɛc&=����_����&��I'�n,S'�ɛ�Dh���0V��I8�㲾����:��FS�5��p��[�T?��1<��F��a���$	AaGN�t�0�O���L��2?��.�_s�y�Q��Ϗ	��U��I��*/ !����m�L��	y0�JY�
������F����n�{����p;7������b:w�w��B1�y�;��[xT�A>az�3�T�z����W̆N¤A`����`���r��<��T�����0���x�w�5a�M���j�A�JX�]�T������&ik�r�|%u-(G! <���z��`ߵGG�$W�X�[Zf���M�te�U�����t�8-��D��K�	�����|ml̤���Y+�Y�Y��HhԢ!b�F��M��?3:���c�kT�8�~`L��W6[c�2��,��y�`J>�oh_�����o�~\���fԃ��:x���}-ޥ�Z˄ ��f�'S���؂�ZX��#��v�v���h<xsٿ�v>�f�|�  ��/���j{�.�L�I"�j�җ�giJ������q��hɣ�x2�b3.�!fZA�'yLP�`��*fR�C彑�.�t���O;\R��O��D:�Ƅ]p���UI 0��␋�X��,,���"GLЉB�+��=2�W��:c��� ة�[p���`�˖�]�,��єV	 I��+d���.`J]h�����lQ2f��R� d>��t�C���ɬhH3"0�pklyH30��)S�9t�����t�$BO,N���,XB�w9ҙ�T�-�"�֫���qg�^��Ct��7��������m�.&�2�Q��7N�AX���L���iʊtsX���؀� �j8��� _\�<���^@���҆��[\}7x��n�T�˅UH��a\s\�<�[�$b�A.Lm*���,����	�N�0�����C6�a�$%W�Z��^���w���ᶴ�O\{�vL��dBLp�\%�'L��+�$��ʸ^?߯�,��#��?�7[��
�v�����x���)�Mp��~�EL��
}d�*Ԉ;���5.� ��^+�
#*ӧ�K����������֠�\Ʉ���-��b��J�9�gx����Y�o&�"K�*��3��B3I;W��?0.�#}�]�^o7���~�}�����vP�MY�a�XL L��u���O3��x���+�a\��6�1��b0�t�Ш�.3:!(D��a'�?�<]�+Y(�$���׾�.e��'�"Z��-!`E�0A�0}��W�ue�����iV��V��z�t7T �NCAhiܱ���I�,<�� O�bէͶ���Q�' J1�����@8��M̤ô���#L�����l��}ww?�˛ᷣ���G�N0D����7c7�	R&9Ey�M��76z���y����o�u���>MLF�o��ŤP�Fpl�&!��A��    ���I)�¼�f��=�I�#�w=�<��l8� �h�t��cJ8�	�[C�&mց�2�+��G��]P����|}�O��BH�愀�-,_��0I'��4��5!�f�z��|��T�A��*�M��1�[���ψI�q�N0��������Coy�{��t��x2���I��e��������)�	���0\�ER��9]���$]�*��fU#<[�3>:&��Ү�3�.�|��.��~"�FwK���I
���_tʂ������R3Iu��N��N��������SwM&U�S���$"h!�9��d�$3�c �Z=����T���{ף��j���6~���3��+!"0��p��1�gm�I�R*�������y�#��[��� �?���phh<�V7��G��X ��!�mhL���c�Մ1��:7�5b�^��~��k��E�SM��V�N@=����	1��	�'d	<%b���� �$N�=oW1���AF����T�3�n��r�2wQ/s�h�N���s���t�*���TpN��KBƲ�[��j9O)b�*/��)^�������(E�FV �������\�����Z[�V�D�.1����DN�0W�v)-w�=Uh�O�Z�0�'dŰB�	�C��d~u�<�w�U�r��a��>�������E���|��b�^����o\�"e�խ
��la맻P�{��^��yCp>�{9����=�,�����/��`>���No~���J"�q	w�Ɂbf0��!�dx����C�s1�O���&푺�$��\B0��s���I @t
�����_���(����g�TS��|}/�b��_�+xZ������OO�)��fp�oC�8�ѕ®�G��E�
�&�����y%,b�����:Fb��0�Ç_��2�H������5oC��ZCD�TNȋc1ӿ�6�������q��������o����Az�����хP�N2@�ps���~	�$��׬m�t�ݕ�l>&ͮr�M�W���\j�7Z%̣9xâ<ق�z������v_]�c���a!�%�g���x�OWVʢ��Q"�(�[vJ����va����4���d������q������U���(�ƕ&�01bҡ�6�Ltu���|��-<F�(�����-���a��1�l��MD�Q��;f�'�Cic�6xs�6xpN|��[9b�_e�E�D�la]��6�'tSl,'�5�g����f`��8.�p"�4�3�E��ϴ���T9mz����:Pa�!ɡ��s�.(l猙^k���ˠ���>�f��>`�v��+����p	S��/���ű��7�uM7��݃V��4��5X�5vu8��}��Bf5vLE\XR�U��I� 8M�F��?�1m��1���֬z&��˕�F��w�5�b�WP�ƷL�@���8q��B����k\+E�1��;U�I��IWY�.X�p�����;�{%l*_
��^]B����H&)�Bk;�F6H�Զ��G\ ���0��PG�$��	a�aq���N���,fR�r�¥Ô�`�+��cw�A��&���ˈ�9��e�c)��2��g*�g7����g�m:���E��_�ϮknsLlD��*��D�I�3�-6��6��8����i�\�Ǔ���v�X���Kʨ��U!��h1c���ש<y3Q(D��eT�Z�����b�z{��e.�+��S9,d�$��e��2�Mr��x��g�_�^yIY���*8k�h��%h8a�3�0IVf3p}S��FM�5�9�E��kb/)m��E�1B�b1�V���0�Lz�"G�6�jNvG���m��Y�of�#�����U�)hr"�!� 獙�����`�3�s(H/)��K�L�����F�)a�WXX2o��;��q�qhjV���4��h8��/qr�M��FXp��3&p<��mJ�$3/�L���?����´�81�{�����l�|s�Ip��r���	������)��s��q���`������W7�	B٬a�j��:]$r���߸}���&r�ୠ�� ����i{��
|��_�w$-���(����"��o�/�%	����/,�3_�GX��~8�x��j��ڔ�Dt\w�E���Z!����";Q���� `W��s��{��jѿ\���VC홵��N�����)�w3�-�3�7�S���Q0��j�"|R�o�>J���$g�T��-O$	[��a%1G�%i��(d�(�w[��ۣ���叏0�j�����Qu��ş������k��o�����);��I��|�~�+՛��>�L��@�� Q����K�\�������Y��w�y������;���  8Y����������O_t�TA��a[���cmz�����y�/�����h��8�y�/W<��7.���(Z���d3I��*�W��J	�vE�Ʒ����r>��V������o�-L;��!���H��J`� �r:^��_�ƃQ�j1�%����z���G��q�M��8��>���� ���\�g��{��t4��L~��T�:x�E��*�dQ�䳪R܅ݪR������g�1|���Z%�OB�"�����/v�u\j�[���O]����� �҉*��9,	�����r��ߎ�F�$��Z�-7��郴R�B�2��_㊙�_C��!��a1���r�骵�w3���2�.�� �:Iɶ"ՃԵ��ڝIG���@�O!��"�H�����U���o�kY��je�ϣ��$G�%i�K���� ���cQvD���jq L���*IT�6�·�^����X*���JwK¢Ġ��,�
�7qQU��g�`إ�=Y��"�s����(՟��<OE�b��OE�b�_�{�yo1Z���%M�8���t�̴����VHH������2�.�QdW�`�sD��h��.��Q�^�H��|��D�"����L����I�N�V&�IWO�4[�@\^K�����	�e.�9�3��I?�I%
���W��=���t}p�#��R⧐�Q����V{���b<�^׿|-���3}�o�%�x�y��+Ɣp��,���B�ğ��<�
�����s�T�����;r��+���P� eKr�ۅBY�<~����|W���`�<~�Z3��+{WC/�r�����%\�@{$��h4����j����ӯ�Ra����j���<�q��Sg�/ �4`��������`�5���ɲ~6��ȯ����|�Ptkݯ�_�����t�������O?[�u(�ϣ�A��|1���c��<Yl��&r
���Ė��_�s�����&�픽.���h{��#V�L���Q���<~
7�{�����S`�é��Tmز��y1����7����CH1���_ֵ�3�����Z�'9~�)J`/��w��`�zS�Z���?�6�����}��'~RxǮp�Lu�����?pZ���^�h�d��@�*pP�_�(*5�k��0XT�]]�^�1��q����(��p�O~�d<�������� <�EY �0�����Z��JW�qy���.�' ��p�����1�[�'�V)
u��GC����\kj���Ѳ�W���5��z@�L=G�"��>��y8p����o��|~�/w~U�6j���óy6��6�������u���_�S�܋)�Ǡ;W�o|�-I鍖ף��?A5y�%"6ם�H�l`�F�h���g�7F@T�xi�� ��c*��=_�������SCx�h�����
Z����l��O��b��b��s Gm�h6�0�9��L%���$�_r7���hd�/G�%�O�x��?����!��q9���1-&��0�j��y\
奸�M�̗�!\��7�9�s�J��vP���A+�k�o��g�.�{��۽a�}1>�+��_6QI�>�,��K�X-��c�q�r���j��_��4��0.��_?��?-o���`�}t��|6��䘲�u�_�J�Ǹ*���Zs;��(`��    �x#xI�`��:�
�B)�.ҧ���5N�?�gp3�g����t��W�]v���i�F�E�R��[ ���f����"�z�7��)�/�L����$J�(�N{�v \����3���r�W���2
��D
2��3@�����I68[p�pʚG�f�IQ�p�P��p1�].nV�:�g4��԰y$F[z�@�
�!&,�.����� �>�#�u.�;"�p4/Gg�W�Yk[��R ��~><�T�i؟�0�;Za��y�E��v��� ��W�rQ�Ѿ�R���j��LcCBF]��E�������/�28�h[�����ٯ?_Ȇ�e��翎�ry�˧�ə0�&��V����_�~9����_u�R�޻֣�-xG�N8nՂk�s^��kD�lR��u����}�C >r��j|Ps�kÌ"��O�"󴣪������sr߼���V�Y��~�?xߵ�G�6|��2y�@U�c�k�c�W�VW�	��̕c:���ytL斗ˋ#�\�@gR�~
��r�z9?[�iLg_(���X0�ɖ!��X�v~�*�ut��P��͂�m��kՖ=L~�^�������+V�#���_�<DP,��D���U�6�gzaR� ����+��?>�h]?cGf�u������(:��Ïlf�u���-���������/j���/
wZ�`��"H�L���A�Wp�����QB��疪N
����!��PqW�H��'��p%b���u�K'������b�6��({�����2Ypp}kh-�`��?a�9>�7�öM��/�S�7�y��o0kҟ-	��yg��,��/�* '�b�e�&7ߍ���WQ��`���P,�=+.sB�_��,Xצ�����;<ś�r�6�s� ��'��±�(���a�����/�e������9D��s�������8�Y��M�Hn�x���-��a6>[��ڕ��>��r�������޷�	x�0���|��	�V,��rW�y+\�[d16b�K�2fX4�I���e0Q�G���Hx���9�$Hc�k<b���9_��Y�l��&l��l��~����T�Fã��Uj��W	Y���ѢJ�X�čE^Χ�՛���l�T�g�lV<\��d���J�\��73ja�^�-ۤ~��-�s\�sy��fQ}�P9oQ�3_�,�dޛ�PP?_��v�A��;�<࿯(.Qd�(K`�/7�H+���LKIwT4	������SɣT%[K��(sXDp��o_�����������|v�˯�M����̲�7�P��OF����ۧݫ(?�!�U\	\�28��mH��TR8|�[�K�.�s�s�V,�h)�`�B������q��*e��j�(���nz����!�P\�S��j�'�1X�lB���m
�,e6E������7�MG��esn���s4��lR��sU���=��ͻ�b�����/.hX��L
mxB����{�b&9�er�dcϙ����r�Y�(순�yTN�������Vi�ۼ�������2�%$̩}p8�_NN�`e����*)O��F�{�&i�ld��؟"[�\/��r�i�ү*��+kq6&8�5��0��g��(���+;Iho�_eB�cu6��2�H��gI,T��L��~��G�;�X��Uޠpa�f
W�E�$��|�c�$a�(�M6��6���	�W����⛛�v-�������U95xg��|$"(V)�/�J��t��Lʚ�AWk�����~������9����J���ݰ1�j��)�-q�Xp��.��<lz����v��_\��f2�wk��	zV�FT&!X�8S���mI��Sj�<��G�Hm�@S�sm�oe�B���nM�B�L�6Y���U,��T���k4�����d{���a1^��ܕ��jlepWvL�� $��=f�4�*X\��_[�O��ϝ󊃌:!�sY�LM'L�/(�tp�.w������l�%�R8V�(��t:��G���<���)sf�Q`�LBp�@X�-1M��t
/j����o�6KI~����K	!���N��?'����c̤Ԝ(DER��������[����_=wf��3֒Z(&X܏WXM3��QHJ�#[��AI�o�/1�$^�
�4��&!0�¸�ኘ���l�:�إ��vP������A��Bޘ�l��J̤Pr�dp��s����`�����4���U�����!q�<����x��N����nwWO۰��b�J&���o�k��ʊ�*q�do����~����~]+��j}�7��hvb'�Y���5��1�"�<bL����?�?Y�a�z��7}���7ء�����c��wz3���V�:��\�$����	��
�q�b���Np]���[���p���q�6�e�	4���G3I<Q:��e��r��ko�{M��it�ŦJ��,�����>��J�.�T�/�vXְF%��n:�1��Rָ�B�${����?�j��=}��1�(/��y�-�7���Չ�$I�<L�V�'#��<�0�0I�lIʮ������{�����f�f!��)b���f�6�U��pB[m-KF����L��V�ʂ�����o7O�����m�o@�h!\B0�\i�{R1���6�վ�o�w�F_�������fs����%��+8g+?Z�<I3I䪐�U6�;���|�-O��򁟰N#1�,0y���t����L������D	YPU��~��mP�Yp�k��/q���ˍ		��t�~J�G��:IdM���7w������"�Nb��wn OFi����f���̣~�fG�u�W���{8Z���{� /h`Ι�l]B��*�U�1�L��,y:�Tpy���������}^?�)��.�C��ߍ����^TP��N��Ŗ`*'���m������E!\��?���>n>��W�V�M�)�	�����a�9e�X.��D)S7���ӧM�����Ç�}�RQ�����w������0"O3'L�^n�����f�y�a���uѮF��x8_�ZV���8�c���:��8f����U�s��t�ȱ&�1c�� (�)'lj&)�Rd��1�o���ռ׿AеI��ڲ:���N���$�Տ&�t��2��T���ݧu���j�?o���S����b^O��>�X��i�p����W�����^�F5�������P+��(��6�ccə��o???Fa�ט�����'R�΀��to!�m�$eU�����
�k�?���u��0D�8p�#�>�1L+��<]8�̋J�t]3H`��G����7ww�ſ����u� 7�!�@�4Ƕ�Bd1�I��Έ?k~�}�����;uN��n
8Vl�pYMUH��L�%l��_�q���K�����O��v~�8���]	�
�p�_cḌ�	N���~�+Ȼ�]o��Y��x޻]����� v�s���s�L��3�4�O\�ɺ��y�����f�8u��>�Ø[ˈ��3�X�D��|�)��GO�.��"����7Z��xx�T�UjЬ�U�x�Tj!9�2���!��
H�]�x>�V'�����Es�[bn$�Unqb&ʥ�Y'Ӧ=����zW��������e1z=?y	�c#�傡�A
!��厙t��t�r���TK�58�_���S/�C ���	AK��֙l1�1�1˓3��kG�´�
�	��5e����-h��"II�}��ݿ���^Q�z��tSZ�Tk�	XNv�HH��1[����@�7��_-�[z=-)����W��q��r������I�a;Q��'����j�n,���<�����M?�|8_��7'����a\
���[hp���S�F����w�)�k����<X�y����r��_����7��
Q�Lʮd�4(a����!��l�u��v|��w�v�<�*4���7pJ	�J��)�DLһ%�ז�,��%����u>    ��,iB�b�
B3��༲�rG�$�\%{�*�ܾk ��_����w,�g��G�O5�&��R/�;֏}���c]hN���z����
�����֥�Sˤ;����4�o����;J�#nS:J2�F�S�hYhV���	�H�T�[�c&�����6ʻȳ�v��>�{�ܵ���w!h�pH��Gk+c�QƄI�m)�siV&����l�[�ZU[N�;&�z��(����Ks%N���j��o�w����خ�|�M泫�ɯ����B�
�K�gTv���4�������O9����m�����L�Yt�xc�����J��]_�A���ȷ�_�p��a���Ic��JbSN'�C�:^̤'[��$K���,ٞ�S�*LH��A�Z��"�\^�������C	�a7����u�j����~�V;����ɩ�������&O�0.r ��IA_iV¥�`UC:q-bEw<�T,Ř�2!�	��Y�����Y��G�����h�
&!^u�'x�LƘ�c��ǋ�9����8��Oz��h::u ςL!nC�	��Vj^舉�>1����DH���_�{������m�6�jv��K��̿`�+qnEB�%P�GL:�B��F�Wx���M�v�ӹĪCd��#�C�S����W��Zw�  h�9!�C;-�'ּpm}nM����	�[3�ħYn1fR>���m��"/�^�S^�����ڽt�[%�(�z	�a���D3���+�K�N.�YT\ybZ"p�#�#�	ۘ��υ��$l�Ęr���f���wϛ}�$��'v�+����&�N�re�0�{(� O��F燺�1.��n��Bۜ+l&�X\UycH¤��о�*WG�M�갛k1~;�{��h�u�nSe�3�V3h�q�E�t3�m2y`C;7k۸��[�D���~�שG��N<+�S�W��3}>"��i5G9��Z������?v�v��+Q�
��_f�b&i�l�
��+}Z?m����@E�����+x�_]݌�����}��rͰ��e	Ai�#-�}"&�)e>1K������t��X%Gw1_�گP��=yӄE�͘��w�<����8Ϳ�� ���8����=n�`��O��hp�N�0�n��Rp~Rۂ�1�l� �Jj��班ř�\��̨�Ǽ���4:Vc&y��K�S��h5���qk��fr�\��f[�%������ÍG��1�T��d��؛.sJ�I!a f��QA�FL��6o �%&%��{ʒ]%�\�G�%�"��Q��?bһ�yŊ��&�j���	&��%�"�f�0�bF������$�T(Ȯ��/ۻOQ���ٳ0w%g��� �A���DL��.ɜ�Q^�W�����<�_sĳ�	.("��}Z������g% "�?�C�s����5^�g���rr��&��&���.O�t��	��8�'.�r��q��<w����Xv:��!�[��!��MN�LAEL/c���ٗ"�@�S��q�,����Ƅ�"���?'ɥ�ࣘIC�.�S��.�t�c�6��bGC�eN�.<����xB /m2f�*^g�x��GL�nF��d������f�Mzj1���]��ʹ��pl.�N�>�q�P����~�>�C��[v�ϮN���7����1!0k,����IW� �R���a�<��=l�F���������}��;"��{[h|���U��C���42N�
ŉKV�a���6! �8袒^n���p⏼��'S�f��yB̮���1���*��` j�C�r�S�\���A%�ιp�[��t����z���g��x2>�`k��'����U�Y �2�`UA0�ʹ�k���b|3�N�1X?OIp#,��H���[�c�LR��t=�dgG�&��p��B0�� 6_���0��3��I�]ϙ�7���},b����N �x\w�(T�'�oD��d�3f����P�Dy����iߪ�wX�yw�N����pPQ&��q��ܘI�Dj!MH��z���c�3�m�]X�l���	�[�WT�S)�n�(d�j��W,H�������xK&Ѱ*�4�#���k�53$pKj����7f��(����l�H��J<87s@���R������C��v�L[w=�hC�����-��.��I�ku~�k������[��S�o�z��Z�Sg�\�����o�S@댘>�.XS���Q�6��S���
�ޛ�byjoAU�eEImh��[�m�+�e�)ӛ��i�D��b�7��O�ǧ��6�Oݥ쯨"7�Hi,	X�<k3�K�H�z7����Ǩ�ґ����`FT�[���^�B�6b͜�e���~��{�&j�(Ď!JW%��pKi��IjH�Z7di��z��	��rs����+�+��k�=�P�vD /�	[X�1)�P�ґ�؍>�
�9 \fL�PLP�F'�1��j߲��ؘ�Z؎0*+?X�[<iD0Գ�h�$W_�`��d�C���܌�����¥�	�6g�v�**�;�����w���Ci���`�X�{���ɳ�u,�b����X\�xG��,��0I��R�w�v9�n�8ö>T4��Zr	�2#*���I���P�t�L*��'��-��q\�$3p�����d�X�R������p�Kfw�
�t�rdq�I%�?������(�҃M]�i�}�����8�N"*iLP<Z���>�Vzĉ7��bS����^l�~�?�~�U�p.F&�-kb�ű|��і���Ť��V_]��>y'!���4*#�2&H\�d�dE�$I+�x��hӈ�ټ��9�P����A�4C<���!f�k-���5���!����~w��ZT�7�~�;E���,���m/1� �<�K�dv
 D
A����yޢR�B�&����k��?! e��ONވ��)��	���7��|5a�Di�PuU�&�)�i}��/���S7~B ҄�#��J�rd��ݥ��.W�:gd>L�Iwp{э�	Z
��1�fI�h^1�/�:a�B���9/N���q���m̤S-`o�gQF��w��N^(��.ޜi��c�W�aQ1&�}��+��FLz��к\#^�bS�PZ��v�%�U���Ԙ�#ق2NᯋR��KT��o�b�Dc��F�B�~�D)]�_�G���C�0����w��O��"B�MJUQ������
��"&�[J��ϵ��ƥ��VA}�AR�k�#b���`^$e��?�oǣ�g��}��ъS�����L�sJ�	s��	��	{�?lх�JU���;)�q�Vh��c�*g-)ӟ(�]��:��UX�d���e1>u�~Ve�Q�r�	F����3驖R2&~���Oۇmo��ƻIQ�И/q��Ǆ��u��B��>EQ:�C�����������)^������`>�N�����P85��:�
	��I���^� حn�(x���~"�Q�LB�`o�ȣ��yq�|U�\7��� v��o��z�stY_P�~D�F�ܦ�InSQjUh'�`�����YTPA�⶘�8��)���Lz���AL�����7�w��.�&vC]��R�l>�3�_�p��~���\��u�N:ƨ����:�w�&L��C<�/�L��.n�l7�د�?o�!ֻ�D���h�z3���]O�몄��b�3�#�t#&)��I�]/��Q\D@4L?��L/�}Xv���L���Z$p;���ң�y�U>� �ݩ�������(�U���<Z+���A��	����mW�D�Ma�����$�e�3J��d�_>C�t��by3}�_�O@��B�7���0�͑�a'�bx��?�,D<T8�P��%�w�
���w�Y�8��o���]�8���˥j�:z�UI��3)Jd�j�M�c�P�m#`����	A8pW�1Ɏ�t�����Xn?�ݚ��a龓��}K��N�I��-�#l��9+�m�i    Z��p��w��N�F��B W�RUMB�@��^I�$�,KZ9IW�ks2/���$֎"��9A��Q���ǭ���w�?m��_{�O���U������h�z>�X>�CmVXp$w	�H�D��1�YV�t��P]�~�7���*tR�[�h̘ !v�p[&=����X����������K�A5��]��h��A<׈�Kքˇ@b�~��������;�,`���4ǝ�UB��`�1�h �
`�'�m%m~�fv���P���X��	�k�/y>#b��Z^JQ����'0&5R��}}���(1�D����b|�0 d�?��<:��М�)��I�\�T;@o�����>w�L[q_��1����­
��I�O�JI�|������ՕP��;	�1PW�n��Iw�����9���;I� e5~U�*��D�ߜ�\������@��{��i�]�Ĭ?��C�4����Aw���=&�帊��]$#�����ƖI��(8��\�;��h��f�����CQS&)%[h1���[�7�0�ϑ5oo&�k�6�&A��k�p�*4&�L��0��S���&�l.��X�L`�<!�m�P��I�?��V#DxRV���
��S�V��
�R�������C���y'��x�T��\�?�C}}�wb;�g��u�U6!���rGL����[ڜq�ݎnnG��d<����c��C41e���Ʊ��p���	ӿ�BG��������o���^�Ww�mGxn����铿.��$N1�S��2��Y��In�-���N�C�۟��S��J�ĕq�s�1��O��L�����	� ��,�u�)r�T��w��[hM�ŗ2��-�S��Zg���Ӝ�`�Z��7��;]�r��S-N��/{�����3�څz��5��%V�y����e(D+�Jf��
���vtЍN�k�ּ��c��b��3~xܢ�9�5?R
-,�!��� ��А3C�3c4K+Am>\�F��x8?�G����!�<�Ý8ɛ願IgY���,���&1]xl\��9,F�9�̓�O��V�z��z�f1AК�|)U��Z02Lˇf���I��Pq2��p�ƔeB�(A��N��
������<]�-���W���_]�W��Ӈ�|Z��������gp��k�j&J�#���*o�se(��Ъ�*�Go$�I�0-�a/���ϧ���!���6�nۥǷ���_=���|S*!8��Ki���C�<�	a\�4��o7� ��~{���h)L��x0Xl����`Z�<������N��A��7}�%�xw��QN�Rk�.� �c�*!�.���6a��T�u]C~����t��1@7UT#���E�FӺps#&9���jA��Ѻ䨙��Ј�v�}��@93^س3}��svĥ�(����8Ԅ�"�l���&C�Ra�Z�$�]���b����g���ۄ��F�8Щ��3��z�J�*�@Sb&��Uaf]�P��N�ȝ-��D�1+��	�3�u/��EL:�B륮q���W��co�v��1�G���%*Lb'�~�l1�+����\��(��r��Ga�����~�<k1ɏ,E�5&x�Gz�r$��1k:s!�_eOр����b�Ad�"f�$��0�y�"�B������\a;DL���P�
��^;�N�����ں�����V~)X�༸L�ꊅ�8��b͓$Ta�\M�چ�"c�)uB��+
IƈIn�)��5:xq(��w�x5Q�ǉ]��RA��-���%pc�6�r�L��,/�k�RT�Q�;4+��J U�Ь,��%Ve�ER��;�B��g�F�Sgc����Q��a����r1���R�X��K>�{������su׺��$���%�*��$L:��<��Y�E�����	Δ�� ����1�[�҉�)=�&��5�Pv����T/�
ׂH�C��\�$L��J-��w�6��C��@�T��+l]��dAKN�H���+�=��N���KUݙbJKb�!8N�;���2���b9-��r�7x���$W�w��ݪ�x�@��oPXl$�	��ˍ�5�"Vp�s��(��^|s3��|1^�'v��oć�������q���Ҧ̋��;�<<���ތ.'~n9�t��_p�	S\����d;�S&�mJr'��Wۏ������� �t
n�hÒ�X�:OJ(
�$g�9�i�$�����q���P������y��Oς��[�a�[Kp�؃�OA��`�
ҧ�q��w�S��.��.8�vP	A����)a�ȅ�V� b�z�G��h-|�� �~���RB�8��k���B)O����?|�r��_��Z椰:!(�����I�aّ����l�χ�;æ�����."h�[��r{�$���N���L���U��6,f=F�����g�\]vv�r�EB��%^�ߋ��f�#���q�� |.;�iF |��^n�c&���F(-m���q��}����@�������]N�G��)x:uv���_�9nTv�-'!Z���x�L�J�QUMm����3=�u��^��y�ߍ����ѝ���ח������e��4_��0��$r�Lۄ��w����}MY!�a�J��/
-�1%��wu W���v<;�~6\{	�Mf�qL��O�$�*
�O�&�|��/{��"��%�ˈ@��x�5����rL*�����2��u�h#G��-��-N�q/k&�i�R��}��٩��J��e��a�&߅��	ӻ
��ѫ�Z�p�y�ƥk�Y[����FF���y�$_�*�C��J�b�QK;#�G�d
�.8����y15f�Sk
�4�8?������O`G6����Z^n����Ԏ�oł)^���8�UH>DL~�Bˋr%:]�����>��>B���l��`�A���5����:! ,�-L3�L����vѥ,[o����-���z��u��F��b������O}�'�|X\�p&9��2��.h�H=�N��{���_����>�����w��2��2"h��,4�DL��8ךIX/���&ʮM֏��n�~�*����NPWb����P�b�Ѭq��~�����C��4��/Q&���a���V���*`��_�+��!��������(�v�O��@<A~Fm������I��x������x�ďۨ�m���Δf�+��LB��^��b&=�^�>�G�����j��f���u�wP����I�}1s�`WJR6LR��0���.����Y�Ԩæ
�o6�c.&`v��o�$���F�M�V#����^�^iT�������N�9��I�(ϔ�L˕�uy%�k�Qv�Uj��+���0	yW��1���n��1у�-���?�o>�}�����ݑ)�{4"(��wVڢ#&��R�����y�6?��k����	A�J������]!�f��:��=D��=ϱ1]���;��}���'�������J�`�)���E]x�5J�l���4����hb���s���#�����l7��k�S`�}�
w����A�H&�@��,Um�$��H�dIU�0�y�Y����o0z�13� ����=����JE3�DO�p��Ͼ/�La.����IO��r-g���!�{\�?�L2k�559{5�D�k&&�:�b��"#3�@� �ŝ#
���eIߩ��n�v���ٰ{��$چs����$3xD��.�<����o�2Ô���;6��憺rp�!\bN:��P G*�7Y吖xr3�.ǧ�٢�G5�����2��� y��&g�"I���]xfXyw��ǧ?�f��
>��碸O��8�����h/��eN
-$�^ˈ��pxDq9ϧ��t9ET�0Nj�p^R	r��yty-�9��6\� ���0h�r�U'f�(SP�ldΓc�V��Q	 ��=��޳�i��Q�X��17��e�TKA��/�Ra����ʸg�������� /
�D�s�M��^j�-V���w�    >l�]�_^Mλ�įe��!���(A)sR<XI&@�y���J"PUˆ�k�+H|���]��#�TV
�r6�"2���y׼>�JɌo��q�f���Q��	!�󇝺s����[3������1.1еu�$p&d���
�|k��)p�ۜ����~���l��oF���cB
p�I�����n T,#^�E
���{��o>ܯ0������]���#(A5�mf���T#���#3�o�9|�]Y;����8A�ٺni1�FP�.�r��%7geKw�f���s:>�e�<���_�}:�qv3F|���TMt.c�e]��gʝ�
IL���Z��v|a�(�|H\�0r�J��j� �ks�s�[����ľ�����kj�ڦY��F�N�g�JE���I+s[H�l�>�5������f㜮��������0�l�4ѫ�$��
�=r#��E��|"�̠h���3�τ
a�98=��ŏ��&l!��5V)�\hT(C��IY��m8����T�i����J3�(6�H��<J�Iw�+տ�D�yr:�.���7�\����M�;�fKg47 ^48/�0'�%F ��!&l^	{�넗mໃ�������2X�Σ՗��iϖQ�\���U	O�I&^n0�p���X�誣1��4���9����3غ�@bĝt%W�vUޭC~q�u|v=�M����	�Vc���>7�j0++L�Ioy�!ד�ƾ��7o �ojaq���s�D�Q��H��)�@�]e�U�+=�}�G�"�[�z�&
	f���e���ݔ��\%�GdaS;��O��AzejT�6Mf��z�-#�<9ҠrU>���l��z�$���{�ve�l<��A8���w�w��v�>o��y��yk;:և��Z��i�3.��AU��b�3w��F��,@�Z³�J/����Uo"�%%uX�6������a�#K��!��^:owY��k��%R$�����	-�75s�ʷ0����� ۮenOl�m�@���̀Ub'a�3��{8���V��؈�j�;��P{ԕ���IǴ��NU�n���~��2������ط�X $d����@���M��� ˺w����ń�hޫ
�����6�j� z�N
���Ii�*���o^�c�0b���9\m��x!"���63�����3���(R�z�߻6dl��#�!rC�;p�̉�rRʣ�\��Gb��u���UЙ�a��9"���q}ܒ��ڮ~G���]�*+��2o 4��א��\ʙ�
�R��\������O4i���uB̪����2 �m��N��f�r.��o�O���#\·��P���R�l���*3X�)A[���D����b���z����]�����G�3��$�iI�t
����Ҩ˩�#Y��)�����v*��k�pp,3X�+A��9�V�r�P	��Z����y�S�:�����c�s��9HW#���Nz3��y��|`��]���f6/:G��UZJ�w֖�zTwΝ�/ݼ�H���U�Ⴀ����U���ʘ�q�؟|���Z>��3�	�)�"y��z�䨞�a�okcU��MhP|bo��!Zl	?�sR9"�4�������kO�g��jj�u�)��Ά�D���<D�Ĝ9c�T:�)2���x��	�y���N�WFt�lเ/5����C�3ju!�g�1gN:�����滫�7a���6%���%����Y"���x��%{��/�Hg���#���	̮޿��:�XS�M!n$��A�d�i裸����I9��_?/���+�^�^��Df�f*eٛ;)LTu	mq���K���K���\C�03`)BK@Y�<z	��R�}�A�G�7�r$�Zf�9��#w�r�pn������r�yA��X��򹪵�
i,�*s�*�\]oo����k���P��&���U�p ��_uC��s@�l9�z1���y�C7I�.��.�̀��Q��r'UY�"���ô�[WU�-��k$�l=�f���_��5FHvLֽ�?-�l����! �b��H���̀ػZ��N���0{����v�~D��W�Iע):q̚��r�k�RY;s�ڍ?V�gZG����u��в΢r��V3 -g%	�1'iT�-לע��.QYd��nW(`�Af�����aW��Qkd�#�]���w�F�74�і�r���\ʈr�t��ӗ�z�,�&uf��!�#%(�9�>e�F'���+�EV<�^�n�N����r26��N�9�f?uY�oO���A�ɧ3C�y������:�\N��ē:�����pz:���]�R$�-T�C��������
�E�����,篩_�����)�dCB�ys��@���<�wvAD_"kBT�6Gfh �qA�y��6R��tu�R�j�O��]��f����j>��S%� � ڻ�8� 0Bc}鷺�x��d�K�7y�v��lH^�H�JP��N*.
@iwH .���1��lw�}� b�H�,�@i���2��
�w�!o��[�R����8~������!$<3Xk�P�ɜ������F}s{�Em�a�([��gHx�gW\r�ś.?}�>?R������]֗��hr�1����VEB�����@ �2�Ȝ�q�a��~XnoW�������ka"�r6�j+�|fPȴV��2'e@���O��ᱞ?�I�a��9�]�;W�r1u'�g��bJ��I��<��3Y�N~�9�:�%!	��($�!4����[A���t����;$���:��Ë�b�~���ꧮC�x!5��=l7��
�
�B�`��(>,̼b���\���3(ll��Hs'm��j�өA"x��v�q�L>>�����uP�7p/w���zV�6(�h��e�5��̝�L)�h|�#�vJHo�~�1��"��n<���W!܀}J#�rg��Kr�r��É+d�ܶe�ވ>k�(=}rr-4J&�l�@��"kx�����׷듫7�;�
�r���a�t�� ���V��1�I��*W����F�?� ���� -4ʛf�� 5Ħ��vS	폖<��qC��
������s�4���Q�:2��N��%w�%dK�xג��.!����NkUSg��=3�
B�Ɩ9�"�<H��Lp�8��/��3��-6Ax"�`�XQF	���IѾ5؜޲M�NWi��x�g�N�@��D��ހٸ5�;wR�$e9֊)l;���ß�D��F|m���J�I�Sj�p�� �"����I7s%�9���Z�5���{�'V����w���&�#�>k�c�Ղ6,wRh!!lNZpx�'��[��nᩰ�ި��6�����)!m	����)|����cV����h[��?�`oG�]�iC\ ��6�
�{�ŭ����Q�KuW���"���ɭ`�=�>��<�c�5ķ�И�8�u�;c\e��;��UQ-3Be�*�|r:똖�Ǚ��*��T���8c��n����ȹ�i���)�I�k�l�	�)J���Io�Tw�=���'�1v�o����iL�4�6��{�g�4���m�3�0�k�	(�>�8,:A�r�f�>(_�̠+��)U�9�}+-�k���;/��ruǨF÷3�$��m��AM�"� �3`>s�~�B�z+��St1]F��5�F�i�M-�Fq���r6BB�ϗ9O�5���pP����ܟ��Yr1>�!�XJ�I3�y�U�Y1cax�X�g���il����ƙw��Vc�������[i�{��7m.O��h	��ӛ������S��o�D����K�$DC�:�v�lw�G+p$:���]����z<�4�M��7�Cj���!nK��wN
+a�ЫC	������ՠ�b��)TBQ:]AV��"d���SI���&��C��\ƳX|נ�f6p9��3C�p	i��9cN+����z4Z>����n=�	���S��Ŕ9i�%,jN~�|���n��ϛ��m�    �3\��u��y�©l�2�Ŋ�P�Nza%�qK>]�n��C��<7����k�*�. �y4ğ����ZΣ1gzQ�A�P�ٝ�ws�t��8���j�g����+!��Nz;�P��	V1G��3���8�kbI��yPk57X���],k��I���ww�s�Gd�w��V�\-q>���{���%V1l�"k��:�0`�+Fp��V<�Z�α�W㟺F�5)�u:�2p��j�"�@�7C%p�߯	�{D�%�738.^xY���нwh��#�m��`n ��+��9c�A8�9�w��#)�ό������O $�g��
ↀ�6˝1\��p@CԎ�M��7�O�{�+�_�A��& '�V63����ý�k��ٲ�ǯu3��gO�i������j��Q��L�F@8���6��r�(s��S <�T��V*`���U�9O��>34X���/�;��URg5��CD-��R8����E!6"�}�V�љ"9���D椈�]K~(����i}�s��"
b�����%�8��`�j�V��9���	w��ꤱ�-��|-�Y���,)a�2o6�;g�1I��qQ��Ž�/<>ҟ��I_�we����/��o����z���j�W�֌��]�N7i>�!��̠Q0�,�fθ��Ƿ����[���|��nt�����2d,$'4T��>bSVW|K	~���j��}p��m0�}��v���y��g?�����ZJ;�[#8<(��fׅ��;c��Lt|�M�s�+���j<��/�T��*�Й����r�����v���c�˻~�L�4,D+d�P#[�$�Ɯ���ʉ^_e��(yڶiX��ak\zp�"��&3��m(g�2g��2��U�dH%�i�[��5|v��do�j-H�rg�_��V*"�����yZ��I�b����AAlє"]����Ս���ݨ`)=�#���*����3���C[h�2'=9F�W_��;���M泞1ZM<Ӑ��ZC@� ��^��e�c�(�����~��0G8�NF�|�㫮a6�y�RZg#�7/g���,�k{���2/\n׿"��a������v�g@�nP�6A�����2e��[�m	^�/3�b�l�쒾��M������Nz��Q����k�&�-	6������w�<��I�,}�Gx��G;R�P�k�q��8��6B��t̜�J'h�A4zdј$��n���~?����nZU��61����9O�$�G�:Z�b�E��:�(1hr��Upe��<�F�-Tn�>��y�3[�~f�����1'�6�j�2���v��~5�iv_�Q���+�7s�"��r��;S,}�r��v��[-���˒7�w�b4锅_;@���[�0kX!%T�t]&�e�
wQ�P?�ƃ�;��`�
�FA��9�~�9�8|�O������y��~Zޯ���l<�O���� ��#��P�;a�"md?-#k��J ������hG�G��.�I���W)v{+��2�&q�j����IG���@`E:����.��X��P	���#������KH�N��P^�\da�a����-�{�l�t���l1ܼ�\k6A�TE�).3X�t��3��B���(O����5��鞫a�}��	pe�W���:��� �;�&���6j�y���~�� ~��r0z�=@�&�Q"Ru�3�ð�r���"aN�#]9c�{�H�ӛ����ϛ��z�����Y�5i�Įkh683X�h����NJ��~��_×]�~��U�3�4�˙�h�CY�̜1�b�<LQ*�=�3��iH�I|�d�F�`NZ��L�[
�F:D7,����4���+Ȗ�g�]W�R�A[�Ѐ���Z�/w҂��F�0�X�F���Q?,���S#Ǻ��#,Eh�1']�^(՛#�/�N��_R�j�Ai���j��Q��̜���6o ެ g�K��O~�:�rU������leW�(w�r��
�[����)�$'<>�a6;�����=3�T�S.8�-���Z@�q'd�a��v���v������c���x18��Ӯ�ƷBFf�tf�=�u�t�Θ4��S�q��>�-�ǹ7ڋ���W�%�W�3���52')��q���Ky<�npF̲������i�L]@.v�8p�A���U{��J��L.�w���%>G�4��C �hS�!3�� id�����4�׾F}�b��[;���F'��<����S�%�̉��ۛ}H��mB|��dJ�у�>�E#�����I�P��,�g��@��N��q��G�5i?�/�l��e�����χ?��i��:��Z�UD������i� 
�;�rxs}�©V�v�����O��稫$�|�jY����λ2.�N�U%|�uV�j�Z��~e�v�"���������ǝt��%Ƀ�y˩����-�T��0�T�>v��/��=lE��� ������Xe"���"��nn?�$�k��tKəAI��ٱw�*�������8�=x��d�j����pk^~z���@�ϻ�"���|E�v̀C�芼v���*Я��D�m��X�'h�l{(�G��$�}��1(G��u��S��̙>Va�_-Em>��z��l�c��f5�|��!��xW">�9�eZ��������$2�ڰ��[�]����d�/f�3'����g��%���|r}1�0�(���c���glky]�P持������O�Rnr5\��杫Ϸ=���!8��#Ej��ʉ ߨ#WṊ\t�.�](�Q�e�!Xgn���1�m�������
b��H�qo�U��܉���_��C�̴��X�tx��l:������� ���2����O�;i�Jx9r��6EI��K�#��v�X�x����T�f�TZ�"`N�7+!k;p��OK��O������h�O�lz}�v2�
���
!�X��XY�<���}#(	s�ɟd:3�H�t!@HP������/�E�TB��$ b��V���o�Q�˱�,�/�O�5'��,p��:W��&�t�`�c3<����dN\�����xj��Q�����&cx>PT&d�6�+�2'�9Zza�Zu9_�-'��kT&�dMg�RI�9i��R[�[x\*��'��F&@0k���PY�r����'��a�N�������?b�~u�����(o"�Q������?P���I4)b����H�,3.�g׃�i��G�k*nL/�������Y�h��n�Sﱩ�2FrAn�U���Ȝ���r�����Z��Q=A�U����F��`|�%�)s�:%8�="�ǚ��M^�λ.�U�x�B+�n��lV�0�Θ�H�bzN�al2��Z���W�GmH�aQ�2��8\�t�y�;)Y��յ��y�]�>�~�yx~���_�ߟ\�/�ͦ�]3��x��3��3ܶʔDQ���-������Q:��9�ீ�f��9+��W��o��	��O*
�Gc*c2C��w�@A��TT:Bz�cw=|�U�j ��"X<7`���o���)+������zұ<�+~Ua��v�VeЗ9��C���dZ���v�||��8�P��Z�n�7ҕ�f�9�����3�� O����Z5��v3�g�JpwR$��f<P_�`��5��T�H���3��)���tn�a��P���CH���6E�#��(���Go��G�:�����uc3�X",�2sҭ$��ZJ���w���~\����$���*�po��
��I�Y�J҈���=F4�8Nqn�~��e��BY�O�73��63X�!�&
��[	����D��AOD�mbs�ԙ'Nj�e���s�B��|��c6����
:34�rf2sRQ�"L��?�n�yxZm�=�A��r�_��s�Z�0b��	p��p���X �^u��4�y���^�%Pn2'}��p�[�q�	�m> ���aͺZ��Γ�<1�AZ7�<�.�lnp'-�	u3�e� �	���%�ٕ,�nh2�    �
ys��y���J�c.�t�v���&�C�̀�~cJlwR쌷_����`�iy��m�U�O��vK)����� *7�Pk#�|��ng����g�T��HE<���*�*wR��2��1ܻ�K���OC��%<\.��q]�*�%�Emi���TH�mW뿯���ť��C�S9�8bKeą@�(_Z'�$B�rV���LX!����:2f:�SȮ��!�т��-x�3��d d5�8�ނ&X��dX��$q�\�8:7��+�o2g,�Z���NI-���}�hl��E4ğ<���cN���:�s��-��۟�1D4Ogg�΁���y�����,Dy�$�˜�g��;�6�b��̒���&�t|.��	N$�7̀
2J���θ�B�4ԝ����{��_�6�oߞ��뤃��8�Xya���u�7�3^CB�%g oǄDO_#Qn7+�D���o�ZB�1'm��mIȏ�XT�Y�:�@����*3 ��%��9i���b�AJ�<����q���8��8�'hdN\�8��ҏ���-� X�0����C�n�
�����҈��3�3�g-�����o+J���9<��
��అ�j�j�BlϜ4�R�-����H�6�o�N�L?`h�h4ğ!á�&��iv�P�c!�����_�'��Z��\�&� �l�0f��T��;)(Bu\��7��
byE]t>�@�QUS�P���EK�/�Yi��W�l����b9��lv�L��*V��ƛ
�t��n��Wh�;��J
���[�6J����G2!fKU/H�M]5���0�ɝ���P5�s2]~���·=��#�4*��ӢU�H�	!�P%�;iK�(7�⻯��q�m?�9]�~*���
�3Cc!zx���.Y���CQ�,�Km�^4A�fS������ g�T��-w��U���N���l��@�h�'g]�N�Nq;�Z����`qPS��fNzO\�JU`���ۧ�v0��y����|�ʦm��zu���+Ⱥ<����e��9)��҂�Pz�����U��oӨz��5��1���X�󶙓����Z𫧖��j��������{��Ż�0�W^�{vNʲ�֪�I�&��-�f�iE�x�:d�j���Yת���1o��lN�f�~���v�K9
�pC�0�Pc�-��s'-O��G���
����n�$�Y� Nf�/�H�f܉m�zQPͱT�ϑTc[� <, �� ��<! �;qE`.(δ�}�z�e��x���e�qw��W��;~��8� "�]oN.��x4�Z33��"�x]�E��!�O Vrg���ZIh���Qo��t��5LiT�x<�� ��%�w�5+i#�P���Fᆗ����h6�/.oF��cuZ�C5�nP��2�N��B�9���j{�]Ct
�VO��ۏ��v��C���C�FU�xI,�{'�gV�9i��&�ܗ���lz�:��Ɏ1�A:n���Rs�8�*�Y}L�n���n9�z3x�"�7�;~Xb��a���������N�Oif<�	��Mca��9W�478d��e�;O�t���Wt�|Ze����F�;�w`���GHxH����X׃n����v��K�8�8������������
���b�W|�Mpl��U����W(E\�8���
�P8���<����U*��M@�zaq�矐_��Q��NC��
u�K���I�M�4�3mG����-[��r"J-���m�X��2�7�[6ʸ�2�X����������gSw���(p$̦�Ը3���L$��o�P,�}�߬��K7�]������.3@�%�9��0p!��>(kB�2_͈��||q:���3\�Q�҇�UC��(W�B�:��7���D�\Mx�o6��Y҄c�6VdM��<& ���,uI��pz)�n��m���Y*"0n��bw��R"�
-w��c�ܮ�5�M��>M�s�"/ypu�7ߐ E�:UY�̜tpō�`D��o�(t��2§�d��p�v6�+�/��&bQK�@�ޠa1�2w�:])��=�-]B��F���O�����pz:���R���+��89��� q*��
!���r'ݵ�P�2Y�X�cZ�~\<Zgb��1|�����%L��+|��@d?e?0s�ݣ���HͲ���������ۊ~/��FJ�X�¢3��GU�Lr']K^j��X�#�/��*]���V��3�� ˛�;iW��fK����'��������� ���\/y�#3�F-zx`\�j��ja���r:: 36Fʻ��.��^��*D��Y#3 �&(��n"�^R�Z�`�\�K��
v ૘�n�!p�$����*���ip�Yo�n����TG&�*(�y�J2j���˝qs����"��8<����g^弙���ƚ��3�x�E������nc�l#s��0P�,Fz�Z>�es�\?Ζ����׵�^�dQ��"m/fPՎ$񜽓�[�M˞�� ����0����KU�%M�n*f�<����9�55�S�ϡr6��������3	����tx���m�'��#�TcQ�\B��Td/()fb�db>E6]܇�_�(���q�I��!�/f���%L�2g�u�����IpI���b4L���b;?9�:�J��Hg0 ��b��s'����x������2E�?��OKp|^�`z��?��(��d8� �8�_p�3�v�"��0g,B	�H���y�����, ���b�?���]O;��|��*���>d�{����p	��|��:q�Jhj0jG��^�y��n���bA$;4r�nxO�����k�ȗ<�1���EO��P��*e͸�ޮ �a�#���a��&�
�\*�`]�(�"[$'��k��4'�?vj�%|��t?��ߝ����l0�-?ξN���F����V��P̤fΣW#��_�rh�p���R~��^!���Ci$V�ketfh,j�
d̉k���N��������O��"�#��k������J%%��ԡl|ޡ�Œ�b����^ß����Ia���xH�A��5�3'�Q��͗JT�8���g6�&i�A������ĸ��
����Sգ��#�a)�@�;$�}f���l~1�F_rKc��$X��2�uVo˝9I�o��͊q1e:�`B��ۊ#�G���l0z?��㻸1��T�S��j����2'%	�z������0�K�KiF
���V�𴸦�̜��V��T��Ĭ߲�|�_��I[����t]��hy�fT�7ޑƾ[?�'=�����n}�|��0��k���P[��0�<~�%��o)zɚG�cq$;dH���k��3wR�+n��ªo,z�(Q�F���<�e�:e���J�k�kp�|�������&u��ΐ�=7��i\Tk挥Z�X�q�<�
�~^m�?�z��7J�+�^Ԣd�=�%j*sƷYZi8 *\n�o��v��������.xƿ����:���:�憺���_B����.i���sJ�#��C��ݻ�>T�Pk�h�挹�p��pu�E���׶��6xr���x���&�v�������M�)�s��J��	<+�6��H���v*Dj뵁�� ��7�t!w��K�з,�e��>���勮4��,�B�������9)��B��e1���\�z����ꥱ�V���U�+�P?��QȜ��.��c����I,���*ɷF�w�����I�W��:3@ʬ���ϝ�H��N��2u�oJWy�1�����qw8`��4
�g���帓6�ŻCr��#�U��n�v���̠�Y�	gNZ�T�r_b)���K-�3��Xf0�B�����9im�=�fY��O�4$�22�`ߤ�@��I�T�Z��3���M�T�ʜT����R����m�{����%�6ձj�T�{fh�m\UR�rg|x���Gy�/�/� ��b[�Y�� ƀ��(�\�S}���R��+�0�!�=�������)PB    rN�^��dC,��@�$r|�d:ō^�aQI��Vo�&�`n[挹��]���iu��>��s4�Ӕx�}����HI�+I���âj(����B/�c���~���8��"�fk��fN:�R��S{Oa�x��7����x:�xG�NmwW醴R���Fh�p'�~R�g���O���:�T�l~m5��3�WΟ��fNz5��\�~\6��%���$̟&�`o3�1�$�ۇ9�J��{H9)#�|�R���*�q:"�d�|���;i5V�a
<��;@���"���0"c�¦��E��։KFؿ�ědc���)�?��O��S�[FUuEr�{AA�~w�C"���ީ��Ʋ���'�{����Z���m�܀lw���N��*U�2��He[����6�t��P)��u/$�����4���!H\D,Vv/�������bc�G��͜1>�n�~&&)6]o��r�\Zl:�w�V	�[�����k�*��Tʽ�A�n���=쉩���gs���drq*�q��������a��;U�pMsgʾ��NR#��؂��R�}�Wv Ԋ�܀#��TfN\�������h�k��8�@��HT�G�B�2C�U��ΣŅ����[���U\hIֈ�̀O�v�r�J/���������#^���]w�"Wi]�l���pihd��H��:N�Ev˼��F��b6���o|⍩m�1���/�H�I�\b�`�� �Y�>�i��UPo.iբ`�Jr�����p`�����\�[|Z>�0�b;~3��m����ݮ� ��F�@n�F;���;O�,���k�]��<��oZ!�W�
ױ𭌁=
�������3'.S�J�m{��߿����b�/y�J�i�������j�s͝�	�a/��Mx��F~l�w_�C�̀De�P�����u09Y崜zN.�N��>�Bf�:3 &�9�j�T!lޏC�����[��?������o�cq�d\I�K�/�p��๓b���=ڨ;\�cȎ~\'�5�X=�ڠZx��M��2f��+�Ֆ�*u�����,����p	�Asf�g) �3o��Je@��#���ĶW�&ŋN����txT���!���4������/�)8�f+i�8<�>)����[�@�W6��R�P��a��`~�r��|L�7f�c畸*M�ho-*��̀B{��Ϝ��CdU.2��}��u�e��_�j��Ū�.����zLx��p4�_R'T��pD�P[D(+gN��J"Xv#eʭ��OWi���`sq:<�R��a�<o:Iaֵ������+�g,�ϝ�RU6ea�)�:$�y\��P��K�{I���R�6���r']ƍ�Bǿ^���K�\ψ����d$��5^�Ȯ�42���ɜ�b��uذ[|^n�_?|l�y��GN�(�M�e���:3�~��D�d����:����o1Ό�V{x1�|l�n�Wp@"�̠��w�LF�r2�=�nh�_�:kwg�$7 �$�˝��M<Xhm�?�����&���x�����:xxX��O�d	͝�^�
�J�QN���c�~�O;.�U���n��Uf�,�2'�W����)��B~>YLf1b��/�:NQ]A2$zX�*3�!5J ��NzM���>�ӄ(�i�����΁߾%�!�Xgf��P]*�gN�N��+Xe��"QEE���桄�Ҁ�S�ؐ��U��=�Цd���J�Ҭ���'w1}�9mX[�Pk34�J;ʜ��$�h�� �=_#ny�j��x;�̻���jsQ�CZ��AWv���9��-iq`�_���8O'�~F"mҤ#&�q��<�c��;�6�h;�*C���V��Ť�:�]/3Q����fP�U��R�9�za����)�����z_똢 �"����g)Q�܉�^HQrZqݾ[ޱ��r8�~LgӞ��l��'�&D�e�
 ��Io�����1ؽZ}��EzgK��<��8bKa����hk��+�L&���3��f91�8�e�m	�L"���[qO[���~���/�� 1]�@�2���'�<�KMT��yrDf�B~$�̽�b@/�[�qI��d�����������R����:�qȜ���Q����v���8ɇt`�B�m�(�P�2��N��r�V�5ʁ�������Pr���.�C�c�r�Kp�F��$��N��Jb�B�'�N� ��^�����x�3< �0��I��֙!�Z/�ΝU��������>������>�(Q0�FV��;S�\v]}�C�����`
��3?��$u,� �n��RV�-dN
?J~EX|s��ۇ���Lp���6
kV!3�j��,s�*��ʃ�]�?-hB_e^;֣h�Ҽ638�(R��h�&�/�����ivѵ^�K��T�i2|�UcJ������Ծ��+��TާV&q��A�WS~���b��!����A�!��Hf�8�X��2ḡ��z]F[���-��v�V��Z�qԱ��H���l����=�;iKk��ªC9ܞ�õoŷ-
�;��3�*L��֩��{ؔ��f��Y��#Vlj��n�ʻO���������/
�\��\mf�����2��|�>�"l�t��5Կ$����C��_ۡZ޵� �h�3'�F
���������~}�iY����Cx��̇�cs@U��2-�*_[��u�E�m!�Qi��۪4�l����pW� hvr��W��Eb���v�O'��`<?w�s���a�3��tf�5����;i�%TEsa�P&#&����a�mY!�'d�MU���;i�涩���p?��NIr74����X湓*=b_��&(����t��aO�:3Xd�W�y͜�����N���K]�8��9��z�"�ѱ��/T|w���*H���IK��rdN9�(1Q�	2ןX�tvY�yוI��y�Ӧr�Sf�>@�P�縓٪�.���colV��x�r���M�]߰.I�6�AZZ�`�A�м̉k%�,5���P2���vp�D��+�f\��Ĩq63h��*��3']FJ�H��
RG�
�H���'���&i#��=<>.3���%�9�x�
_�����\��p8R��u\���(b����2N�W����J����G�^Gvط���k�f����f�<Zx���S������Hh?���u�A#34H�V�,gN*t�\:��R�������f�
!��ǸQ��`HDBT�t��[�Ӗ����,u*��%ww��ko��t,ҕ�sR RR!���HF�M�˻~9��n\ 46�����*�Ж��N����T��d,������`�}����Պg��v]�3S�2!��'3 ��eITb�!�tA�2IP������j�O��><�'���f����:��=1���!���\���^�U.�r��������\�qP���ZC�������V����<��[�U�7_K[���U&34�Q7�����b-%�sb����>
>��ì���ͯ�懪E���Q����������ϰP�pYO�j�������jE����/�P|�#3���k�[��8N�[7܀���	�@� K	I���?�g�W�� ���`�g]�(B��b5���Trj	�B����:YE�0���z4��v}��T�
:� ��pӠ���RȜ��*��u��eNfq��&���^=���U@��{�IywҮ�rG��A�SvqA��WV�K��2#�Z(wS�����AÿɃ��I�c�9�Ӿ�g�HZoSǱ�Ls�M3���b�����H/��sr������z��R�:M[��d����k��2sR�T�m�_t�2܏5���=�5���&N�q~��"y�19i�� �4�k�<G���;�x*�>eJ�`)�d���V+��-I9�=�ø�͔~h�Cd9T�x��s��eTe_�;�Jv�#,R@�c��f���zwT���Iν��T\]��2g�Ny/�s:ݾf�~���L    #38$����3E��Lc�N~�:��������?5���`-�K<w-B��b�n�
[)��6I�Y&��pC���4���wR�#a��=:Q��ט(�0OjH����$�|��N�l��ji�c5*� �cL�m�#3
gh�u,��ј�������}�4D��E�A܁��W�)�������K��7k��ד\�{�nM^fh�{Dr)9c�B�SU��� �=�"d��A�u<��r'�J9����?���������f����X�%��[�
�Y&	c<�b� K�xRr�LU�BF�7�.N9��'�PO���y��_�ju��1A��� �KP%�E�|4_�6��)�����=�OЏ�'l��@���t��T�����=�Ϙ]�6�'�ˆw��7��N��w���|_�2]5�6�fpCM>���9邒��˴NW,��rA�ڀ:g��@�Y*�p'�F�`=^E�ϛ�m�jp����o'7��ا㳮�\�N���A��m2����;)�l��T���r0���Ň]�Di�2*� �T4�9����߼�pp��~q{�KE�fP�\�<d�cy�:` ?\m�wk�.�+r���)��Ī���w�������+��Z�3��췩�k���0�_P��W��"����`�3��� HUF�rK �&&�5D�lg���̀񪔆͜�8'ܲ�:�ƣ�o���EB=�4ICS�������r']�U���
�'o7�ky������6�@d;�a�5�����nTU5��ni~%sR�bauE(0|�ˆI �7����ٚj���T�'2b�@�*���AӯQ��SA��(�HhJ�p�e���AUYYk�,�8���!3	�#�)f�+ҧ�s�s"�����˕��v��S�:�Pi"���|��]�����[���;邭�ʭjɴ���[%��.]�J���+$!����X%S��Ǥ^i�����k9�:2��aeC��� ��ґ���r�*�t�RgE�B��z<��^'�	8mH
hBfp>;�w�9���a]$+t��k��v�}���j3X��k�ڵs��� V9{v���
A��٫׃ܮ��փ��X���y��T� �������+��<��}�
�t�tf0,��2g<��R�<��jqږ��B�X�78lE	���I�\���W�W����eM�7h��˪_�<V�V*|#@��[�U��{����fj�<z��܇݊r�r�W�k��=�5\զGΜ�/�fJ��O��F�l�qd�Hd�r8Ze�4�(+Pr����Wi�k���|Z-������5"'WO�"OU��=U��a��0�Ý�=,��v�[��A�`T��фh�?�
��T�oQ�����E���t�i�E��\�$�}�v7�b2����<�nb�G�X���*�ߙ��X)�h�GϿ�V���D���+n��h�̠�o�J�9i�VZ�����lv�,��y�(+��s'i��_s�z�����	�Gy��I_����d��y��\�n����������xt5<�@������:X�����iU��G�Vuyl�3^O¢Lu�X��3��0;�}y�����d1�xQ��5@9��.���ںT2ϝTv�V���0�e0���E�ܮ>��?�s �(�����5=��Ǔ���E���W_�x�jl�8I��.2'E��r���j���5��;������s+���M·� ���Mf��5�]�jU�[�a��g��'����r��d��pE�߿�i��*H8��Uc3��gTt͜1���S��z��E\�p������������ܮ��@1�_�&�=��^y�(GJ�PkT�a�FArW����"����N��x�B��r�]�y9�Y�mכ8���&�����^�N�<(��W���a=�gN���H�N�.!Z�\n��ܢ��w��p������/������x$�5nf���������R���3?��!�\��/Ȝ��U�W��;Y|Zo6����j0}����T����ݻ��5RYa�*(��62ğ> IK�dNZ�N��x�x��<@�w2��gE.��Ks����e�|�j�b��Z�N:��.WN~�y���o��l~~xX�[����>�?��4�	E�n�?�ʎ���_\Lƃ�����7ݮ�4aW��T��d��?���� �+�y���������9Φ������6�.��� }f��6'�Kq'��I�"�md��(v\GEh1[�������n�m��$�Qh�(H�֝9�f
��+3|xZo�������T/M�{XG/3xzL^#�֗C�6�����	y՟���a������9,v�q�҃���6����Ե��N
�T��w�V���f�~���3�(z�����6�w�I�E"�����`�*@ (Q�읔+us2�<���3Nֿ���K��\�Ʈ�/�E॓W�]�6�Յ�P��sⒼ�5@f���/����'����;�rb����i2ܢ��湓�S#��t}9�������+$�~��u�&W�����O�O��*�Ǆ�;7�O�)���:�_n��?/S�]�o>.��Tȸ���h�q4�">�����
�.Ly�fN�wj+M�����	�v4��m��jx9�g�u|�T;E��B��'fhj�#�+����	�C����9_��9[~(��w�����b'^��B��de�e��u�Ea�Q!�4�=oW���~���h14>�ތO�������P1�������a�NZ��j���7��>��[���쪘z����+�	¼Cf�����;1'}��p0E�{�>NN,u>�N�N�T>;�����̀������D椈O`�R�����+�xn���SD�����Z`��NZ���4�I*������l� ��<?�[,�&���c��vb��(4b8�p�	���*��*���p�]#�)�x%���������B��Uȸ�˅��L�\<%�e�J�
V�rK_n7���[���
�8B=~�K8~�Q;��1nPQX�p�;�E%m�o��b��fx5���+8��9x4$d&3`h���O�+ky����Z��ڮ?��G��^��I�&젇 ����+*T���>K'\�vߚZ<CZ6X@t�u�|Z��0���/:nG�Fn)��M���-�:���C�Sj�	ܥ��F/n��r��ߖ�w��~�� �n��b�j�Ya,��?�?���,w�T�R�9���q������B������N>��$<�E��n����I�ǖ9��T������t����}f��p��fΓcExۜ �&҆1Xl�Y��ǟ�gדyׁ���B8Uy��mfp^F�I7�@��r�c6��V����lx5\�Ϻ.���*�<N��uc�iJ:�<���HRl�v~�K��0֍���*3(���e�͝x��В����,�1l���d8�v5&�� �HS���u8 /q;�1X�^�pq§�ˏ�/#0�5�L�א�\���x>�t��$�	O��A�:3x�jWJfN
�'�#ST�@x}�c�ߪ�)P����7����
ʟ{'}�ZPhRN�n޽�%�\1S��̋��bji�F�q2�V](�k��o��Z*�:�h� �����7O�ϑ����M�__A�hn@*vJZ��I+�p�9���%��\F�*j���uy\����`����rַ!d(��̙���%���_Q����BFQ	��j��IE/ �-����F��fN�������'��+�����x�u�W�6z�-����tS!͊N���h������pb�n����j*L��>��I"����U��a�M�y��x��-כ§�����s2>�L'���K�����75��:��^U���p�C����.�a#sm�3�8}<���FD{g�����#[~���g���?��ʝ��J��˛J�k� OW𚮣&����Q ��G�������boԩ��A+���ʜ� �  � 1Z�ē��5E�_����~�X){Î�d2�����3�xy�}NLêf��fy����&���γ��}�B�QW����Ho���6�d����c��/��n�IFS��Ff���dږ�II���iN�"f��ݐ��|��pZ���ιV�>X�j2�GL�DϜ������!RR��3ݞ���7���5�ԗ����V�qk�2C���B�N�Ni���J�>�~���/��&(������	Z5�I��T��v���^�o���W��5	� +�6d�Z@l�	d��W� ��o���Z��ʨ̠�Z�!2�ɱ^��';k��-t5Y�Ghp
%M6�>��=\�X�5��� M/�����D)0��Iw��� >D����c���A��pM���D�������:3�!uU�ƛ9��&�y�[a�SZ���ϛm��{>���w=�t���(K�uY0wR�PI�hNh��竇�dovJ�%]�Ȇ��Y�n�B�1����梸��W�|��r��)^�Ϯ����/đ6� ц$�e��ԥ^v�U�����B���Z�K_�IS�#��uuf A�R�,s҉�"�c�'=��	�c����'���Ȼ�JS>��I��We����6*A?-��'������
~�Ԅ�H���F��$��Y���т;��<|��*�������H����g�z��{�/S��%�:P��L��Kt3_���Tg�]�� +2J�8���I��J�H�Ԅ�D���zJ�b��,��.���kkH?�a��IOE%�<"U��N�N����5�)GkdI�_�em��+��̙"���;6ϽNW�փ���X�U[�Y+d����v5w+V떭���飲ĺW��O�A�q��36�Ru%s���u�S/�1�~���/�Yq~	2��x�y��J�,잮q>����,s�b!��nN�˿��n��u
^�����b�i$�O�����׶!q'.E������o�O�!���B��6Z3�ǾЫ!2�+S��@����U�**s�����Br2�DձgX��a���S=iZ����8W�̀=3-�H���k]���YF�H��mo��� )����e��9���yD4�� ��YQ����\F�����h�^�`���*'�eN��tYӕ$uu���nr1���x������Jp*�qXcp�(�Uk�-~���Ȅ/@q�eA��S[�	&���q����ӗ�F�y,S�-as[�GP�
;�W����]7���7kPDy�d8ž�w��G-�*Ǖ����O��	Wk����(�\�|N���n�7�mnwķ�Q������iם�S_�TN�lf0�B\ϜTR�\�=���f�	�Ag4�~��tv������a��ױ����=���;�U�Z^�̼o���v|1,4�^�b��"��6ܠ]��r-s�O�̯�Dּ�!�F��n��}@��p4��rj	}jx+İ�<jIԟ�����iku�]��&
?��W_!
�Pѣp��IEOA?]�t�m;�g�����~"fF=pěgT̶Bs�;)�:�U�2W?#4���/����N�ޏS���Z��u]$k�Tp��Q���m�q%��;�()-�78�W��'B���j����7��]�U.$�c4��܀w�/c��Iw�:\���ۿ���te�      F   {  x�e�k�c����\�~�����rz'�H�R��llc`�W}���!�W����4��j���~5��*�7�΁i�����~c���jgMC*�Ew#R�K^9�rDԢ߁T3������Լ�j.�54�*}Wf��o�*�Z��ʯ��]�ѕF̆��S\R�ͪiS�"��9�v0L鞸0u5���L��b0�1u:-�-�[�i(oL�D���Ф�d����f��bf��cLc�Ms0aO�\�c��N�L�_�ڙ��r�zl�s`�(�L�Z i�蛥����f���SOq>���(%i3�D mVW��$z9'v��@��W ������>Y��1m�*6�11藓�l-�+�ڧ�<�y{w�g�י�G���%�fe�@:L�67���ݥ6���a��0L�<B�����a�c�w�8�X
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
�0E��)�@7E�U<��tlb'Skoo�v�����$�Z/����$6.�����K#�Ҳ]-�iDް��	��ӌ�}fL��Y�{���[m@�Sy�g�Bñ�w�1�j�;�`����^=���l8�      M      x������ � �      N   �  x�mV[��J���b60-��E��ﻂ��36�)��h���c��C�#�M���F�W�i���s_a�����k5��6�f���3 �ߘ�i������t'�e��7��u7<%|]"��3��G,[�:��R7M�M���rg1׼�S��0�k[Z���6O\�pY� r'��)*�B��{U�{6$J�AD\vO܀	"ה�̠�x-Һ9�Kc.%�����]cЭ� �R�&��>��w'��$�f.^e�e��M�|��oȻ�^�]�ۮhB1�l��v�=� i���UU9u-�����y�ό�ѧ��
��]r�E���p�������;��b,�t�><�=�����Cq����p��{��@�4�W|���F���\���3������Ѝ4Q��	��q�h4������@���gx"駱�{�=� ����!�Fd�"�����`�l �K���+@O�� �
��yO;JP���P����Dս �{���i��Z���� ~
�Ĭ�g���z��/��̡AS_׵:'*�o�X��+1����@o�$�@1I����+�� %Y:�ߪ%\)����R/^Q��i�F:F6Yގ��NX��~F?�-�~����/��IV�bн� B_Uc�����a����`b N�Kݤ�פfd�jUi`>�sPgA���&� �p�`���O{n4�9�d^��j���{鴬�Z�������/��m4>�*� с���NT���F�i��� 2j7	"�����Pi�7`�����9�g��������@��O�T�+��Z�,�����&��j�f�B�b[��Չ��҅��i�V�ٲD�pmt���#?��zs�`����m�p��4��tTg�h�ix�Ā����fm;|�����X&��+mvZ=<� Zo�P�K^NynE�NZUKh�=���c]�[��0�3������?_      P   t  x���O�� ���]ug�8T�FьԪM��H��`2����G�yz�\���3��*�'��}��Χ�
�
<��B�Q^�B&�X��
��mh>t��R�޾Yg����=U*P�9_7�As���~;"�KS+�t�z���{�ZSkټ]Xyh�`�3QI��G�ʺ`�|�$�ᔒi���-
>������:-c4��4J�Pn��!W�nMݦ�5�-��	7*߅���l��fh)cWU�&��� ����)��J�?���5$�U�*�����97��*g;nW�� Zf���O˦���\$͙`|��ٿ�)!|�)mQ��z�����Ume>4�����?�W�f _[ʷ����*�p�b�gY�H�ѡ      V   H   x��K
�0�u�a?�4nBRh�$��_g5��TS�r�a����㭫e6$yYF��]L�_��8& l�      R   !  x��U�r�6=����v�@�nV<��Ld�J.��LgEC4$���/�!=��c]�JJ�5�t ���݇ݷ��;t�#��u�i�m�K�Z�h��ڷpkc4
�px0+웎V���8�!�R�BW���
�c��Э�mݲ��rY�B���W�j���t�3�~���ȟ�f�����K��5��+�t����8�q}��ݗ�_a���v���U^���z��i��뼳�3H.��D�LOG��tw�vv{3�J)+�%� O<����5��)���i����C0�v�y�s8�������[�� )��ڄ��7�t`q{��J������Ȍ��/�̠(+ɹN�r��:��u��y�aG���"���wSe�)d^��X�y��Ê�g:G��0巐R~MJ�&_���z�B1Z�_�Q�q?ŔVJ�$?��ip3������?]��}X���<�1{IJ�Mcw&��w�yh>��_��ϙ`e�4��<6' u簤U4aok�G�C3>	�%,p����y a���v�u>P#�p������p��6��%=��� +�8tλ��c�?����Poz�ÓpeC�kv>���[2�`e��CN��J0��.ujV!httؐ��}H������,��wkϵ�S�L��G�%�I9d�â��1������m�~�;����,�e�h*�Z���ý?�t��{��Z��Ѫϕ'}J�XL�"h�)ͪ"9��+�!�����I�R;��~�Nm�kz�	���Z��裤��Ssָ�X���{M�`�)��.9Ӭ$�_./..���]�      S   P  x���=O�0���W��9��|�ǈ������RH[�������"��5�{�>grr��*nC�m��e�_�p�P[^(Kʣ?W�¢��u<�$��H)Z]�1G�*�}���]�YV̢i�4������'��L֧����"�l�I�4�@��v�0���OgIIl��9i�?�����@����:�y�$v�q��!v�''�<ò[}�w[x2L,��@>�vJ
�]���&FTZ,)�Q��M����Y��<�+l�0��Yb�ٞ.!hS;O���(CŲ�$�{�������&-v��հb���bq������ЗEY��GlT�      Z   i   x�3�6*�rJ�Jw	�2��pO��1�rq�2��t5�3pMq��O�-N�t��.�t�,1�I��2���36�4�5�*�)���5�r-L	)*��N����� ���     