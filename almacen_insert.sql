SELECT idalmacen, idtienda, nombre, idmunicipio
	FROM public.almacen;

INSERT INTO public.almacen(idalmacen,
	 idtienda, nombre, idmunicipio)
	VALUES (25, 7, 'n-a', 150);