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
function myFunction2() {
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
                var productos = response.data;
                document.getElementById("numRes").textContent='Número de resultados: '+productos.length.toString();





                $.each(productos  , function(i, star) {
                    //$('#results_tb tbody').append('<tr>'+'<td>' + star.idproducto+ '</td>'+'<td>' + star.nombre + '</td>'+'<td>' + star.detalle + '</td>'+'<td>' + star.codigotienda + '</td>'+'<td>' + star.precio + '</td>'+'<td>' + star.tiendaNom + '</td>'+'<td><button onclick="myFunction3('+star.idproducto+')" name="'+star.idproducto+'" type="button" title="Buscar Producto" data-toggle="modal" data-target=".modal-shop-list" class="btn btn-success btn-sm">Buscar</button></td>'+ '</td>'+'<td><button onclick="myFunction7('+star.idproducto+')" name="'+star.idproducto+'" type="button" title="Buscar Producto" data-toggle="modal" data-target=".modal-shop-list" class="btn btn-success btn-sm">eliminar</button></td>'+'</tr>');
                    var relacion_front='<td><button id="modal1"  onclick="myFunction2b(\''+star.relacion+'\')" name="'+star.idproducto+'" type="button" title="Buscar Producto" data-toggle="modal" data-target="#commentModal1" class="relacion_class btn btn-success btn-sm">Buscar ('+star.num_relacion+')</button></td>';
                    if(star.relacion==null){
                        relacion_front='<td>SIN</td>';
                    }
                    var imagen='<img border="0" alt="Sin Imagen" src="'+star.direccionImagen+'" width="100" height="100">';
                    //var relacionar='<td><button onclick="myFunction7('+star.idproducto+')" name="'+star.idproducto+'" type="button" title="Buscar Producto" data-toggle="modal" data-target=".modal-shop-list" class="btn btn-success btn-sm">Relacionar</button></td>';
                    var relacionar='<td><button data-toggle="modal" onclick="myFunction2d('+star.idproducto+',\''+star.nombre+'\')" data-target="#commentModal"  name="'+star.idproducto+'" type="button" title="Buscar Producto" class="btn btn-success btn-sm">Relacionar</button></td>';

                    $('#results_tb tbody').append('<tr>'+'<td>' + star.idproducto+ '</td>'+'<td>' + star.nombre + '</td>'+'<td>' + star.detalle + '</td>'+'<td>' + star.codigotienda + '</td>'+'<td>' + star.precio + '</td>'+'<td>' + star.tiendaNom + '</td>'+relacion_front+ '</td>'+relacionar+'</td>'+'<td>'+imagen+'</td>'+'</tr>');

                });
            }).catch(error => {
                console.log(error);
                alert("Ha ocurrido un error al momento de cargar la lista de productos.");
            });
}


function myFunction2a() {
        //document.getElementById("numRes").textContent='';
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





                $.each(productos  , function(i, star) {
                    //$('#results_tb tbody').append('<tr>'+'<td>' + star.idproducto+ '</td>'+'<td>' + star.nombre + '</td>'+'<td>' + star.detalle + '</td>'+'<td>' + star.codigotienda + '</td>'+'<td>' + star.precio + '</td>'+'<td>' + star.tiendaNom + '</td>'+'<td><button onclick="myFunction3('+star.idproducto+')" name="'+star.idproducto+'" type="button" title="Buscar Producto" data-toggle="modal" data-target=".modal-shop-list" class="btn btn-success btn-sm">Buscar</button></td>'+ '</td>'+'<td><button onclick="myFunction7('+star.idproducto+')" name="'+star.idproducto+'" type="button" title="Buscar Producto" data-toggle="modal" data-target=".modal-shop-list" class="btn btn-success btn-sm">eliminar</button></td>'+'</tr>');
                    var relacion_front='<td><button onclick="myFunction3('+star.idproducto+')" name="'+star.idproducto+'" type="button" title="Buscar Producto" data-toggle="modal" data-target=".modal-shop-list" class="btn btn-success btn-sm">Buscar</button></td>';
                    if(star.relacion==null){
                        relacion_front='<td></td>';
                    }
                    relacion_front='<td></td>';
                    //var relacionar='<td><button onclick="myFunction7('+star.idproducto+')" name="'+star.idproducto+'" type="button" title="Buscar Producto" data-toggle="modal" data-target=".modal-shop-list" class="btn btn-success btn-sm">Relacionar</button></td>';
                    var relacionar='<td><button data-toggle="modal" data-target="#commentModal"  name="'+star.idproducto+'" type="button" title="Buscar Producto" class="btn btn-danger btn-sm">Relacionar</button></td>';

                    $('#Rresults_tb tbody').append('<tr>'+'<td>' + star.idproducto+ '</td>'+'<td>' + star.nombre + '</td>'+'<td>' + star.detalle + '</td>'+'<td>' + star.codigotienda + '</td>'+'<td>' + star.precio + '</td>'+'<td>' + star.tiendaNom + '</td>'+relacion_front+ '</td>'+relacionar+'</tr>');

                });
            }).catch(error => {
                console.log(error);
                alert("Ha ocurrido un error al momento de cargar la lista de productos.");
            });
}
function myFunction2b(rel) {


    $("#rel_name").attr('name', '');
$("#rel_name").text('name', '');
$("#relacionado_result").attr('name', '');


        $("#rel_name").attr('name', rel);
        $("#rel_name").text(rel);
        //$("#rel_name").text(rel);
        $("#relacionado_result").attr('name', rel);


        $("#relacionado_result tbody>tr").remove();
        var nombre = rel;
        var url = direccionserver+'getRelacionados?nombre='+nombre;
            axios.get(url, config).then(response => {
                var productos = response.data;
                $.each(productos  , function(i, star) {
                    var relacion_delete='<button onclick="myFunction2c('+star.idproducto+')" name="'+star.idproducto+'" type="button" title="Eliminar de Relaciones" class="btn btn-warning btn-sm">Eliminar</button>';
                    var imagen='<img border="0" alt="Sin Imagen" src="'+star.direccionImagen+'" width="100" height="100">';
                    $('#relacionado_result tbody').append('<tr>'+'<td>' + star.idproducto+ '</td>'+'<td>' + star.nombre + '</td>'+'<td>' + star.detalle + '</td>'+'<td>' + star.codigotienda + '</td>'+'<td>' + star.precio + '</td>'+'<td>' + star.tiendaNom + '</td>'+'<td>'+imagen+'</td>'+'<td>'+relacion_delete+'</td></tr>');
                });
            }).catch(error => {
                console.log(error);
                alert("Ha ocurrido un error al momento de cargar la lista de productos.");
            });
}

function myFunction2d(id, nombre) {

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
        var nombre = id;
        var url = direccionserver+'getRelacionadosRelacionar?id='+id;
            axios.get(url, config).then(response => {
                var productos = response.data;
                $.each(productos  , function(i, star) {
                    var igual=false;
                    if(star.idproducto==id){
                        igual=true;
                    }
                    if(igual){
                        var relacion_delete='<button onclick="myFunction2c('+star.idproducto+')" name="'+star.idproducto+'" type="button" title="Eliminar de Relaciones" class="btn btn-warning btn-sm">Eliminar</button>';
                    var imagen='<img border="0" alt="Sin Imagen" src="'+star.direccionImagen+'" width="100" height="100">';
                    $('#relacionado_result_ tbody').append('<tr style="background-color:#f0f0ff;">'+'<td>' + star.idproducto+ '</td>'+'<td>' + star.nombre + '</td>'+'<td>' + star.detalle + '</td>'+'<td>' + star.codigotienda + '</td>'+'<td>' + star.precio + '</td>'+'<td>' + star.tiendaNom + '</td>'+'<td>'+imagen+'</td>'+'<td>'+relacion_delete+'</td></tr>');
                    $("#rel_name_").attr('name', star.relacion);
                    $("#rel_name_").text(star.relacion);
                    $("#relacionado_result_").attr('name', star.relacion);

                    }
                    else{
                        var relacion_delete='<button onclick="myFunction2c('+star.idproducto+')" name="'+star.idproducto+'" type="button" title="Eliminar de Relaciones" class="btn btn-warning btn-sm">Eliminar</button>';
                    var imagen='<img border="0" alt="Sin Imagen" src="'+star.direccionImagen+'" width="100" height="100">';
                    $('#relacionado_result_ tbody').append('<tr>'+'<td>' + star.idproducto+ '</td>'+'<td>' + star.nombre + '</td>'+'<td>' + star.detalle + '</td>'+'<td>' + star.codigotienda + '</td>'+'<td>' + star.precio + '</td>'+'<td>' + star.tiendaNom + '</td>'+'<td>'+imagen+'</td>'+'<td>'+relacion_delete+'</td></tr>');
                    $("#rel_name_").attr('name', star.relacion);
                    $("#rel_name_").text(star.relacion);
                    $("#relacionado_result_").attr('name', star.relacion);
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

function myFunction2e() {
        document.getElementById("RnumRes").textContent='';
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

 var nr=0;

        var pi="1000";
        var pf="1000000";



        var url = direccionserver+'getProductos_?nombre='+nombre+'&categoria='+categoria+'&producto='+producto+'&marca='+marca+'&presentacion='+presentacion+'&volumen='+volumen+'&tienda='+tienda+'&pi='+pi+'&pf='+pf+'&nr='+nr;
            axios.get(url, config).then(response => {
                var productos = response.data;
                document.getElementById("RnumRes").textContent='Número de resultados: '+productos.length.toString();
                $.each(productos  , function(i, star) {
                    var imagen='<img border="0" alt="Sin Imagen" src="'+star.direccionImagen+'" width="100" height="100">';
                    var relacionar='<td><button data-toggle="modal" onclick="myFunction2d('+star.idproducto+','+star.nombre+')" data-target="#commentModal"  name="'+star.idproducto+'" type="button" title="Buscar Producto" class="btn btn-success btn-sm">Relacionar</button></td>';
                    var button='<button data-toggle="modal" onclick="relacionar('+star.idproducto+')" data-target="#commentModal"  name="'+star.idproducto+'" type="button" title="Relacionar Producto" class="btn btn-success btn-sm">Relacionar</button>';
                    $('#Rresults_tb tbody').append('<tr>'+'<td>' + star.idproducto+ '</td>'+'<td>' + star.nombre + '</td>'+'<td>' + star.detalle + '</td>'+'<td>' + star.codigotienda + '</td>'+'<td>' + star.precio + '</td>'+'<td>' + star.tiendaNom + '</td>'+'<td>'+imagen+'</td>'+'<td>'+button+'</td>'+'</tr>');

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
                $.each(productos  , function(i, star) {

                    var relacion_delete='<button onclick="myFunction2c('+star.idproducto+')" name="'+star.idproducto+'" type="button" title="Eliminar de Relaciones" class="btn btn-warning btn-sm">Eliminar</button>';
                    var imagen='<img border="0" alt="Sin Imagen" src="'+star.direccionImagen+'" width="100" height="100">';
                    $('#relacionado_result tbody').append('<tr>'+'<td>' + star.idproducto+ '</td>'+'<td>' + star.nombre + '</td>'+'<td>' + star.detalle + '</td>'+'<td>' + star.codigotienda + '</td>'+'<td>' + star.precio + '</td>'+'<td>' + star.tiendaNom + '</td>'+'<td>'+imagen+'</td>'+'<td>'+relacion_delete+'</td></tr>');
                });
            }).catch(error => {
                console.log(error);
                alert("Ha ocurrido un error al momento de cargar la lista de productos.");
            });
}

        $('#commentModal1').on('show.bs.modal', function (e) {

        })

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
