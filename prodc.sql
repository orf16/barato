INSERT INTO public.producto_twebscr_hist(
	idproducto, nombre, detalle, fecha, hora, fechahora, idtarea, direccion_imagen,
	idcategoria, codigotienda, descripcion, precio, url, relacion, activo, tienda_nom)
	VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
	
	SELECT idproducto, nombre, detalle, fecha, hora, fechahora, idtarea, direccion_imagen, idcategoria, codigotienda, descripcion, precio, url, relacion, activo, tienda_nom
	FROM public.producto_twebscr_hist where idproducto>106555 order by  idproducto desc;
	
	delete from  public.producto_twebscr_hist where idproducto>106555