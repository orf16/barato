SELECT idtienda, nombre, detalle, lugar, lat, lng, place_id, imagen, url_web, scr_id
	FROM public.tienda;
	
	INSERT INTO public.tienda(
	 nombre, detalle, lugar, lat, lng, url_web)
	VALUES ('Merqueo', 'Merqueo', '190', 0, 0, 'https://merqueo.com/bogota/licores');