    //var direccionserver = 'https://servicio.baratoapp.co/barato/';
    //var direccionserver = 'http://ec2-54-164-83-211.compute-1.amazonaws.com:8080/barato-1.0/';
    var direccionserver = 'http://localhost:8083/barato-1.0/';
    var pass = 'gTddSgsRD!Csta5gKXZ$Dfh7jNvg?pMeS75%45A9GCje&^X^?3&$?5Z*Fj#YC47fGaNNX4Mp=syV9UqC-CcAM^^$_7rDsFT89^e+';
    var user = 'baratoUser';
    var UserEmail = document.getElementById('userEmailToken').value;
    var key = 'Prlx+q?Wov8K1%o+bnn%p=Pog+d9GpLK?2pc2znx_xk1=dddmT4X+VZh1zk9yY*BxDI#=D1X?!?RNyuc!L#s^#go47Mj!FCFy%&otu44cMYlQP';
    var token = $.base64.encode(user + '@@@' + UserEmail + '@@@' + pass + '@@@' + key);
    var config = {
        headers: {
            'Content-Type': 'application/json', 'UserEmail': UserEmail,
            'Token': token
        },
        auth: {
            username: user,
            password: pass
        }
    };

    function myFunction() {
            var url = direccionserver+'getWebScrapingTodos';
                axios.get(url, config).then(response => {
                    var hjkh = response.data;
                }).catch(error => {
                    //loading = false;
                    console.log(error);
                    alert("Ha ocurrido un error al momento de cargar la lista de categorias.");
                });
    }
    function myFunction1() {
            var url = direccionserver+'getWebScrapingTodos1';
                axios.get(url, config).then(response => {
                    var hjkh = response.data;
                }).catch(error => {
                    //loading = false;
                    console.log(error);
                    alert("Ha ocurrido un error al momento de cargar la lista de categorias.");
                });
    }
    function myFunction3(param) {
        if(localStorage.getItem("session")!=null){
            var url = direccionserver+'setLista?body='+localStorage.getItem("session")+'&producto='+param.toString();
            //var url = direccionserver+'getProductos?nombre='+nombre+'&categoria='+categoria+'&producto='+producto+'&marca='+marca+'&presentacion='+presentacion+'&volumen='+volumen+'&tienda='+tienda+'&pi='+pi+'&pf='+pf;
                axios.get(url, config).then(response => {
                    var productos = response.data;
                }).catch(error => {
                    console.log(error);
                    alert("Ha ocurrido un error al momento de cargar la lista de productos.");
                });
        }


    }
    function myFunction7(param) {
        if(localStorage.getItem("session")!=null){
            var url = direccionserver+'removefromLista?body='+localStorage.getItem("session")+'&producto='+param.toString();
            //var url = direccionserver+'getProductos?nombre='+nombre+'&categoria='+categoria+'&producto='+producto+'&marca='+marca+'&presentacion='+presentacion+'&volumen='+volumen+'&tienda='+tienda+'&pi='+pi+'&pf='+pf;
                axios.get(url, config).then(response => {
                    var productos = response.data;
                }).catch(error => {
                    console.log(error);
                    alert("Ha ocurrido un error al momento de cargar la lista de productos.");
                });
        }


    }
    function myFunction5() {
        if(localStorage.getItem("session")!=null){
            var url = direccionserver+'getListaBaratoB?body='+localStorage.getItem("session");
                axios.get(url, config).then(response => {
                    var productos = response.data;
                }).catch(error => {
                    console.log(error);
                    alert("Ha ocurrido un error al momento de cargar la lista de productos.");
                });
        }


    }
       function Categoriasws() {
       var n1=[];
       var n2=[];
       var n3=[];
       var n4=[];
       var n5=[];
       var n6=[];
       var n7=[];
       var n8=[];
            var nombre = document.getElementById("search").value;
            var categoria = '';var producto = '';var marca = '';var presentacion = '';var volumen = '';
            var url = direccionserver+'getCategoriaWord?nombre='+nombre+'&categoria='+categoria+'&producto='+producto+'&marca='+marca+'&presentacion='+presentacion+'&volumen='+volumen;
                axios.get(url, config).then(response => {
                    var productos = response.data;
                    $.each(productos  , function(i, itemb) {
                        if(itemb.idTipo==6){
                            $('#Pcategoriaddl').append(new Option(itemb.caracteristica, itemb.caracteristica));
                        }
                        if(itemb.idTipo==3){
                            $('#Pcategoriaddl1').append(new Option(itemb.caracteristica, itemb.caracteristica));
                        }
                        if(itemb.idTipo==4){
                            $('#Pcategoriaddl2').append(new Option(itemb.caracteristica, itemb.caracteristica));
                        }
                        if(itemb.idTipo==2){
                            $('#Pcategoriaddl3').append(new Option(itemb.caracteristica, itemb.caracteristica));
                        }
                        if(itemb.idTipo==5){
                            $('#Pcategoriaddl4').append(new Option(itemb.caracteristica, itemb.caracteristica));
                        }

                    });

                }).catch(error => {
                    console.log(error);
                    alert("Ha ocurrido un error al momento de cargar la lista de productos.");
                });
                console.log('ddd');
    }
    function myFunction4() {

            if(localStorage.getItem("session")==null){
             localStorage.setItem("session", makeid(30));
             var nombre = localStorage.getItem("session");
            }
            var nombre = localStorage.getItem("session");
    }
    function myFunction6() {

            localStorage.clear();
    }
    function makeid(length) {
       var result           = '';
       var characters       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
       var charactersLength = characters.length;
       for ( var i = 0; i < length; i++ ) {
          result += characters.charAt(Math.floor(Math.random() * charactersLength));
       }
       return result;
    }
    function Consulta() {
            sessionStorage.clear();
            document.getElementById("numRes").textContent='';
            $("#results_tb tbody>tr").remove();
            var nombre = document.getElementById("search").value;

            var e = document.getElementById("categoriaddl");
            var categoria = e.options[e.selectedIndex].value;

            var e1 = document.getElementById("categoriaddl1");
            var producto = e1.options[e1.selectedIndex].value;

            var e2 = document.getElementById("categoriaddl3");
            var marca = e2.options[e2.selectedIndex].value;

            var e3 = document.getElementById("categoriaddl2");
            var presentacion = e3.options[e3.selectedIndex].value;

            var e4 = document.getElementById("categoriaddl4");
            var volumen = e4.options[e4.selectedIndex].value;

            var e5 = document.getElementById("categoriaddl5");
            var tienda = e5.options[e5.selectedIndex].value;

            var e6 = document.getElementById("categoriaddl6");
            var nr = e6.options[e6.selectedIndex].value;

            var pi="1000";
            var pf="1000000";


            var url = direccionserver+'getProductos_?nombre='+nombre+'&categoria='+categoria+'&producto='+producto+'&marca='+marca+'&presentacion='+presentacion+'&volumen='+volumen+'&tienda='+tienda+'&pi='+pi+'&pf='+pf+'&nr='+nr;
                axios.get(url, config).then(response => {
                    sessionStorage.setItem("key_consulta", nombre);
                    var productos = response.data;
                    document.getElementById("numRes").textContent='Número de resultados: '+productos.length.toString();
                    $.each(productos  , function(i, itemb) {
                        var relacion_front='<td><button id="modal_b_'+itemb.idproducto+'" name1="'+itemb.num_relacion+'" onclick="modal_cons_rel(\''+itemb.relacion+'\')" name="'+itemb.idproducto+'" type="button" title="Buscar Producto" data-toggle="modal" data-target="#commentModal1" class="relacion_class btn btn-success btn-sm">Buscar ('+itemb.num_relacion+')</button></td>';
                        if(itemb.relacion==null){
                            relacion_front='<td>SIN</td>';
                        }
                        var imagen='<img border="0" alt="Sin Imagen" src="'+itemb.direccionImagen+'" width="100" height="100">';
                        var relacionar='<td><button data-toggle="modal" id="button_rel_'+itemb.idproducto+'" onclick="relacionb('+itemb.idproducto+',\''+itemb.nombre+'\',\''+itemb.tiendaNom+'\',\''+itemb.direccionImagen+'\',\''+itemb.precio+'\')" data-target="#commentModal"  name="'+itemb.idproducto+'" type="button" title="Buscar Producto" class="btn btn-success btn-sm">Relacionar</button></td>';
                        $('#results_tb tbody').append('<tr>'+'<td>' + itemb.idproducto+ '</td>'+'<td>' + itemb.nombre + '</td>'+'<td>' + itemb.detalle + '</td>'+'<td>' + itemb.codigotienda + '</td>'+'<td>' + itemb.precio + '</td>'+'<td>' + itemb.tiendaNom + '</td>'+relacion_front+ '</td>'+relacionar+'</td>'+'<td>'+imagen+'</td>'+'</tr>');

                    });
                }).catch(error => {
                    console.log(error);
                    alert("Ha ocurrido un error al momento de cargar la lista de productos.");
                });
    }
    function myFunction2a() {

            $("#Rresults_tb tbody>tr").remove();
            var nombre = document.getElementById("Rsearch").value;

            var e = document.getElementById("Rcategoriaddl");
            var categoria = e.options[e.selectedIndex].value;

            var e1 = document.getElementById("Rcategoriaddl1");
            var producto = e1.options[e1.selectedIndex].value;

            var e2 = document.getElementById("Rcategoriaddl3");
            var marca = e2.options[e2.selectedIndex].value;

            var e3 = document.getElementById("Rcategoriaddl2");
            var presentacion = e3.options[e3.selectedIndex].value;

            var e4 = document.getElementById("Rcategoriaddl4");
            var volumen = e4.options[e4.selectedIndex].value;

            var e5 = document.getElementById("Rcategoriaddl5");
            var tienda = e5.options[e5.selectedIndex].value;

            var pi="1000";
            var pf="1000000";

            var url = direccionserver+'getProductos?nombre='+nombre+'&categoria='+categoria+'&producto='+producto+'&marca='+marca+'&presentacion='+presentacion+'&volumen='+volumen+'&tienda='+tienda+'&pi='+pi+'&pf='+pf;
                axios.get(url, config).then(response => {
                    var productos = response.data;
                    //document.getElementById("numRes").textContent='Número de resultados: '+productos.length.toString();

                    $.each(productos  , function(i, itemb) {
                        //$('#results_tb tbody').append('<tr>'+'<td>' + itemb.idproducto+ '</td>'+'<td>' + itemb.nombre + '</td>'+'<td>' + itemb.detalle + '</td>'+'<td>' + itemb.codigotienda + '</td>'+'<td>' + itemb.precio + '</td>'+'<td>' + itemb.tiendaNom + '</td>'+'<td><button onclick="myFunction3('+itemb.idproducto+')" name="'+itemb.idproducto+'" type="button" title="Buscar Producto" data-toggle="modal" data-target=".modal-shop-list" class="btn btn-success btn-sm">Buscar</button></td>'+ '</td>'+'<td><button onclick="myFunction7('+itemb.idproducto+')" name="'+itemb.idproducto+'" type="button" title="Buscar Producto" data-toggle="modal" data-target=".modal-shop-list" class="btn btn-success btn-sm">eliminar</button></td>'+'</tr>');
                        var relacion_front='<td><button onclick="myFunction3('+itemb.idproducto+')" name="'+itemb.idproducto+'" type="button" title="Buscar Producto" data-toggle="modal" data-target=".modal-shop-list" class="btn btn-success btn-sm">Buscar</button></td>';
                        if(itemb.relacion==null){
                            relacion_front='<td></td>';
                        }
                        relacion_front='<td></td>';
                        //var relacionar='<td><button onclick="myFunction7('+itemb.idproducto+')" name="'+itemb.idproducto+'" type="button" title="Buscar Producto" data-toggle="modal" data-target=".modal-shop-list" class="btn btn-success btn-sm">Relacionar</button></td>';
                        var relacionar='<td><button data-toggle="modal" data-target="#commentModal"  name="'+itemb.idproducto+'" type="button" title="Buscar Producto" class="btn btn-danger btn-sm">Relacionar</button></td>';

                        $('#Rresults_tb tbody').append('<tr>'+'<td>' + itemb.idproducto+ '</td>'+'<td>' + itemb.nombre + '</td>'+'<td>' + itemb.detalle + '</td>'+'<td>' + itemb.codigotienda + '</td>'+'<td>' + itemb.precio + '</td>'+'<td>' + itemb.tiendaNom + '</td>'+relacion_front+ '</td>'+relacionar+'</tr>');

                    });
                }).catch(error => {
                    console.log(error);
                    alert("Ha ocurrido un error al momento de cargar la lista de productos.");
                });
    }
    function modal_cons_rel(rel) {


        $("#rel_name").attr('name', '');
    $("#rel_name").text('name', '');
    $("#relacionado_result").attr('name', '');


            $("#rel_name").attr('name', rel);
            $("#rel_name").text(rel.toUpperCase());
            //$("#rel_name").text(rel);
            $("#relacionado_result").attr('name', rel);


            $("#relacionado_result tbody>tr").remove();
            var nombre = rel;
            var url = direccionserver+'getRelacionados?nombre='+nombre;
                axios.get(url, config).then(response => {
                    var productos = response.data;
                    $.each(productos  , function(i, itemb) {
                        var relacion_delete='<button onclick="eliminarrel('+itemb.idproducto+')" name="'+itemb.idproducto+'" type="button" title="Eliminar de Relaciones" class="btn btn-warning btn-sm">Eliminar</button>';
                        var imagen='<img border="0" alt="Sin Imagen" src="'+itemb.direccionImagen+'" width="100" height="100">';
                        $('#relacionado_result tbody').append('<tr id="relacion_row_'+ itemb.idproducto +'" id="fff">'+'<td>' + itemb.idproducto+ '</td>'+'<td>' + itemb.nombre + '</td>'+'<td>' + itemb.detalle + '</td>'+'<td>' + itemb.codigotienda + '</td>'+'<td>' + itemb.precio + '</td>'+'<td>' + itemb.tiendaNom + '</td>'+'<td>'+imagen+'</td>'+'<td>'+relacion_delete+'</td></tr>');
                    });
                }).catch(error => {
                    console.log(error);
                    alert("Ha ocurrido un error al momento de cargar la lista de productos.");
                });
    }
    function relacionb(id, nombre, tienda, imagen, precio) {

        $('#Rcategoriaddl').find('option').remove().end();
        $('#Rcategoriaddl1').find('option').remove().end();
        $('#Rcategoriaddl2').find('option').remove().end();
        $('#Rcategoriaddl3').find('option').remove().end();
        $('#Rcategoriaddl4').find('option').remove().end();
        $('#Rcategoriaddl5').find('option').remove().end();

            $("#Rsearch").val(nombre);
            $("#rel_name_").attr('name', '');
            $("#rel_name_").text('name', 'Sin Relación');
            $("#relacionado_result_").attr('name', '');
            $("#relacionado_result_ tbody>tr").remove();
            $("#rel_id_base").attr('name1', '');
            $("#rel_id_base").attr('name1', id);

            $('#prd_tienda').text(tienda);
            $('#prd_precio').text(precio);
            $("#prd_imagen").attr('src', imagen);



            $('#prd_name').text(nombre.toUpperCase());
            $('#prd_id').text(id);
            var nombre = id;
            var url = direccionserver+'getRelacionadosRelacionar?id='+id;
                axios.get(url, config).then(response => {
                    var productos = response.data;
                    $.each(productos  , function(i, itemb) {
                        var igual=false;
                        if(itemb.idproducto==id){
                            igual=true;
                        }
                        if(igual){
                            var relacion_delete='<button onclick="eliminarrel('+itemb.idproducto+')" name="'+itemb.idproducto+'" type="button" title="Eliminar de Relaciones" class="btn btn-warning btn-sm">Eliminar</button>';
                        var imagen='<img border="0" alt="Sin Imagen" src="'+itemb.direccionImagen+'" width="100" height="100">';
                        $('#relacionado_result_ tbody').append('<tr id="relacion_row_r_'+ itemb.idproducto +'" style="background-color:#f0f0ff;">'+'<td>' + itemb.idproducto+ '</td>'+'<td>' + itemb.nombre + '</td>'+'<td>' + itemb.detalle + '</td>'+'<td>' + itemb.codigotienda + '</td>'+'<td>' + itemb.precio + '</td>'+'<td>' + itemb.tiendaNom + '</td>'+'<td>'+imagen+'</td>'+'<td>'+relacion_delete+'</td></tr>');
                        $("#rel_name_").attr('name', itemb.relacion);
                        $("#rel_name_").text(itemb.relacion.toUpperCase());
                        $("#relacionado_result_").attr('name', itemb.relacion);
                        }
                        else{
                            var relacion_delete='<button onclick="eliminarrel('+itemb.idproducto+')" name="'+itemb.idproducto+'" type="button" title="Eliminar de Relaciones" class="btn btn-warning btn-sm">Eliminar</button>';
                        var imagen='<img border="0" alt="Sin Imagen" src="'+itemb.direccionImagen+'" width="100" height="100">';
                        $('#relacionado_result_ tbody').append('<tr id="relacion_row_r_'+ itemb.idproducto +'">'+'<td>' + itemb.idproducto+ '</td>'+'<td>' + itemb.nombre + '</td>'+'<td>' + itemb.detalle + '</td>'+'<td>' + itemb.codigotienda + '</td>'+'<td>' + itemb.precio + '</td>'+'<td>' + itemb.tiendaNom + '</td>'+'<td>'+imagen+'</td>'+'<td>'+relacion_delete+'</td></tr>');
                        $("#rel_name_").attr('name', itemb.relacion);
                        $("#rel_name_").text(itemb.relacion.toUpperCase());
                        $("#relacionado_result_").attr('name', itemb.relacion);

                        }

                    });
                }).catch(error => {
                    console.log(error);
                    alert("Ha ocurrido un error al momento de cargar la lista de productos.");
                });


                var $options = $("#categoriaddl > option").clone();
                $('#Rcategoriaddl').append($options);
                var $options = $("#categoriaddl1 > option").clone();
                $('#Rcategoriaddl1').append($options);
                var $options = $("#categoriaddl2 > option").clone();
                $('#Rcategoriaddl2').append($options);
                var $options = $("#categoriaddl3 > option").clone();
                $('#Rcategoriaddl3').append($options);
                var $options = $("#categoriaddl4 > option").clone();
                $('#Rcategoriaddl4').append($options);
                var $options = $("#categoriaddl5 > option").clone();
                $('#Rcategoriaddl5').append($options);


    }
    function eliminarrel(id) {
            var url = direccionserver+'getEliminarRelacionar?idbase='+id;
                axios.get(url, config).then(response => {
                    var respuesta = response.data;
                    if(respuesta){
                        alert('La relación se ha eliminado correctamente');
                        $('#relacion_row_'+id).remove();
                        $('#relacion_row_r_'+id).remove();
                        var ult_consulta = sessionStorage.getItem("key_consulta");
                        $("#search").text(ult_consulta);
                        $("#search").val(ult_consulta);
                        $("#consulta_button").click();
                    }
                    else{
                    alert('No se ha eliminado la relación');
                    }
                }).catch(error => {
                    console.log(error);
                    alert("Ha ocurrido un error al momento de cargar la lista de productos.");
                });
    }
    function relacionar(p1,p2) {
            var url = direccionserver+'getRelacionar?idbase='+p1+'&idrel='+p2;
                axios.get(url, config).then(response => {
                    var respuesta = response.data;
                    if(respuesta){
                        alert('Los productos se han relacionado correctamente');
                        var ult_consulta = sessionStorage.getItem("key_consulta");
                        $("#search").text(ult_consulta);
                        $("#search").val(ult_consulta);
                        $("#consulta_button").click();
                        $("#button_rel_"+p1).click();

                    }
                    else{
                    alert('Los productos no se han relacionado');
                    }
                }).catch(error => {
                    console.log(error);
                    alert("Ha ocurrido un error al momento de cargar la lista de productos.");
                });
    }
    function consulta_comp() {
            document.getElementById("RnumRes").textContent='';
            $("#Rresults_tb tbody>tr").remove();
            var nombre = document.getElementById("Rsearch").value;
            var base = document.getElementById("rel_id_base");
            var idbase= $("#rel_id_base").attr('name1');;

            var e = document.getElementById("Rcategoriaddl");
            var categoria = e.options[e.selectedIndex].value;

            var e1 = document.getElementById("Rcategoriaddl1");
            var producto = e1.options[e1.selectedIndex].value;

            var e2 = document.getElementById("Rcategoriaddl3");
            var marca = e2.options[e2.selectedIndex].value;

            var e3 = document.getElementById("Rcategoriaddl2");
            var presentacion = e3.options[e3.selectedIndex].value;

            var e4 = document.getElementById("Rcategoriaddl4");
            var volumen = e4.options[e4.selectedIndex].value;

            var e5 = document.getElementById("Rcategoriaddl5");
            var tienda = e5.options[e5.selectedIndex].value;

     var nr=0;

            var pi="1000";
            var pf="1000000";



            var url = direccionserver+'getProductos_?nombre='+nombre+'&categoria='+categoria+'&producto='+producto+'&marca='+marca+'&presentacion='+presentacion+'&volumen='+volumen+'&tienda='+tienda+'&pi='+pi+'&pf='+pf+'&nr='+nr;
                axios.get(url, config).then(response => {
                    var productos = response.data;
                    document.getElementById("RnumRes").textContent='Número de resultados: '+productos.length.toString();
                    $.each(productos  , function(i, itemb) {
                        var imagen='<img border="0" alt="Sin Imagen" src="'+itemb.direccionImagen+'" width="100" height="100">';
                        var relacionar='<td><button data-toggle="modal" onclick="relacionb('+itemb.idproducto+',\''+itemb.nombre+'\',\''+itemb.tiendaNom+'\',\''+itemb.direccionImagen+'\',\''+itemb.precio+'\')" data-target="#commentModal"  name="'+itemb.idproducto+'" type="button" title="Buscar Producto" class="btn btn-success btn-sm">Relacionar</button></td>';
                        var button='<button data-toggle="modal" onclick="relacionar('+idbase+','+itemb.idproducto+')" data-target="#commentModal"  name="'+itemb.idproducto+'" type="button" title="Relacionar Producto" class="btn btn-success btn-sm">Relacionar</button>';
                        $('#Rresults_tb tbody').append('<tr>'+'<td>' + itemb.idproducto+ '</td>'+'<td>' + itemb.nombre + '</td>'+'<td>' + itemb.detalle + '</td>'+'<td>' + itemb.codigotienda + '</td>'+'<td>' + itemb.precio + '</td>'+'<td>' + itemb.tiendaNom + '</td>'+'<td>'+imagen+'</td>'+'<td>'+button+'</td>'+'</tr>');

                    });
                }).catch(error => {
                    console.log(error);
                    alert("Ha ocurrido un error al momento de cargar la lista de productos.");
                });
    }
    function myFunction2c(id) {

            $("#relacionado_result tbody>tr").remove();
            var nombre = rel;
            var url = direccionserver+'getRelacionados?nombre='+nombre;
                axios.get(url, config).then(response => {
                    var productos = response.data;
                    $.each(productos  , function(i, itemb) {

                        var relacion_delete='<button onclick="eliminarrel('+itemb.idproducto+')" name="'+itemb.idproducto+'" type="button" title="Eliminar de Relaciones"  class="btn btn-warning btn-sm">Eliminar</button>';
                        var imagen='<img border="0" alt="Sin Imagen" src="'+itemb.direccionImagen+'" width="100" height="100">';
                        $('#relacionado_result tbody').append('<tr>'+'<td>' + itemb.idproducto+ '</td>'+'<td>' + itemb.nombre + '</td>'+'<td>' + itemb.detalle + '</td>'+'<td>' + itemb.codigotienda + '</td>'+'<td>' + itemb.precio + '</td>'+'<td>' + itemb.tiendaNom + '</td>'+'<td>'+imagen+'</td>'+'<td>'+relacion_delete+'</td></tr>');
                    });
                }).catch(error => {
                    console.log(error);
                    alert("Ha ocurrido un error al momento de cargar la lista de productos.");
                });
    }
    function cargarCategoria() {
            var url = direccionserver+'getWebScrapingTodos1';
                axios.get(url, config).then(response => {
                    var hjkh = response.data;
                }).catch(error => {
                    //loading = false;
                    console.log(error);
                    alert("Ha ocurrido un error al momento de cargar la lista de categorias.");
                });
    }
    function setCookie(cname, cvalue, exdays) {
        var d = new Date();
        d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
        var expires = "expires="+d.toUTCString();
        document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
    }
    function getCookie(cname) {
        var name = cname + "=";
        var ca = document.cookie.split(';');
        for(var i = 0; i < ca.length; i++) {
            var c = ca[i];
            while (c.charAt(0) == ' ') {
                c = c.substring(1);
            }
            if (c.indexOf(name) == 0) {
                return c.substring(name.length, c.length);
            }
        }
        return "";
    }
