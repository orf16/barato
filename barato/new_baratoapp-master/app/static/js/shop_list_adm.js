var idtienda;
var idtiendasel;
function passwordCheck(){
    var password = prompt("Ingrese La Contraseña.");
    if (password!=="Barato01&"){
        while(password !=="Barato01&"){
            password = prompt("Ingrese La Contraseña.");
        }

    }
}
const shop_list = {
    data: function () {
        return {
            // Lista de tiendas mas barato
            shopList: [],
            shopListMap: [],
            shopListMapsin: [],
            //map: Object,
            markersMap: [],
            circlesMap: [],
            nameSearchMap: [],
            autocompleteMap: Object,
            km: 1000,
            positionCenter: Object,
            userList: [],
            checkedEmailUser: [],
            cardMap: Object,
            divMap: Object,
            searchMap: Object
        };
    },
    created: function () {
        this.getShopListMap();
    },
    mounted() {
        this.car_sidebar = $


        passwordCheck;


    },
    watch: {},
    computed: {
        // Maximo precio de la lista consultada.
        maxShopPrice: function () {
            var valor = 0;
            this.shopList.forEach(shop => {
                if (shop.valor > valor) {
                    valor = shop.valor;
                }
            });
            return valor;
        },
    },
    methods: {
        // Método que determina los productos no encontrados.
        itemsNotFound: function () {
            var itemNotFoundList;
            this.shopList.forEach(shop => {
                itemNotFoundList = [];
                this.currentList.productos.forEach(item => {
                    const result = shop.listaProductos.find(
                        productShop => productShop.idproducto === item.id
                    );
                    if (!result) {
                        itemNotFoundList.push(item);
                    }
                });
                this.$set(this.shopList[this.shopList.indexOf(shop)], "itemNotFoundList", itemNotFoundList);
            });
        },
        // Método que retorna la cantidad de un producto en la lista actual
        itemQuantity: function (itemId) {
            const record = this.currentList.productos.find(
                item => item.id === itemId
            );
            return record.quantity;
        },
        hasSaving: function (totalShopAmount) {
            return totalShopAmount != this.maxShopPrice;
        },
        savingPercentage: function (totalShopAmount) {
            const result = (1 - totalShopAmount / this.maxShopPrice) * 100;
            return result.toFixed(2);
        },
        buyShop: function () {
        },
        // Método que restablece la lista de tiendas mas barato
        clearShopList: function () {
            this.shopList = [];
        },
        // Método que consulta la lista de tiendas mas barato a través del API
        getShopList: function () {
            var itemId = [];
            this.currentList.productos.forEach(item => {
                itemId.push(item.id);
            });
            var url = direccionserver + 'getProductosTiendaUtil?listProductoId=' + itemId.toString() + '&orden=1&maximo=100';
            loading = true;

            axios
                .get(url, config)
                .then(response => {
                    var result = response.data;
                    if (result) {
                        this.shopList = result;
                        this.shopList.forEach(shop => {
                            var valor = 0;
                            shop.listaProductos.forEach(product => {

                                valor += product.valor * this.itemQuantity(product.idproducto);
                                product.valorstr = product.valor.toLocaleString('en-US');
                                product.valorcant = product.valor * this.itemQuantity(product.idproducto);
                                product.valorcantstr =  product.valorcant.toLocaleString('en-US');
                            });
                            shop.valor = valor;
                            shop.valorstr = valor.toLocaleString('en-US');
                        });
                        this.itemsNotFound();
                    }
                    loading = false;
                })
                .catch(error => {
                    alert("Ha ocurrido un error al momento de cargar la lista de tiendas más barato.");
                    loading = false;
                    console.log(error);
                });
        }
        ,
        // Método que consulta la lista de tiendas mas barato a través del API
        getUserListShared: function () {

            var url = '/users';
            loading = true;

            axios.get(url, config)
                .then(response => {
                    var result = response.data;
                    if (result) {
                        this.userList = result;
                    }
                    loading = false;
                })
                .catch(error => {
                    alert("Ha ocurrido un error al momento de cargar la lista de tiendas más barato.");
                    loading = false;
                    console.log(error);
                });
        },
        // Metodo para compartir la lista con usuarios determinados
        sharedList: function () {
            if (this.checkedEmailUser.length > 0) {

                var url = direccionserver+'compartirLista';
                loading = true;
                const emailUser = this.$refs.userEmailGlobal.value;
                //var idUsuario = 27;
                axios.post(url, {
                    'emailUser': emailUser,
                    'emailsUser': this.checkedEmailUser.toString(),
                    idLista: this.currentList.idLista
                }, {headers: {'Content-Type': 'application/json'}}).then(response => {
                    var resultado = response.data.guardado;
                    if (response.data.guardado != undefined) {
                        var resultado = response.data.guardado;
                    } else var resultado = response.data;
                    this.getUserItemList();
                    loading = false;
                    if (response.data === false)
                        toastr["error"]("La lista " + "<b>" + this.currentList.nombre + "</b>" + " no se pudo compartir. Por favor contacte con el administrador.");
                    else
                        toastr["success"]("La lista " + "<b>" + this.currentList.nombre + "</b>" + " se ha compartido con éxito.");
                }).catch(error => {
                    alert(error)
                    console.log(error);
                    loading = false;
                });

            } else {
                alert("Para compartir la lista debe seleccionar por lo menos un usuario de la lista.")
            }
        },
        // Metodo para eliminar la lista seleccionada por el usuario
        deleteList: function () {

            if (this.currentList.idLista != undefined) {
                var url = direccionserver+'eliminarLista';
                loading = true;

                axios.post(url, {idLista: this.currentList.idLista},config).then(response => {
                    if (response.data == false)
                        alert("Error: No se pudo eliminar la lista.")
                    else {
                        toastr["success"]("La lista " + "<b>" + this.currentList.nombre + "</b>" + " se ha eliminado correctamente.");
                        var dismiss = this.$refs.dismiss;
                        this.currentList.nombre = "";
                        this.currentList.productos = [];
                        dismiss.click()
                        this.getUserItemList();
                        this.getUserItemListShared();
                    }
                    loading = false;

                }).catch(error => {
                    alert(error)
                    console.log(error);
                    loading = false;
                });

            } else {
                console.log("Para eliminar la lista debe existir una lista actual")
            }
        },
        // Método que consulta la lista de tiendas mas barato a través del API
        getShopListMap: function () {

            var itemId = [];
            this.currentList.productos.forEach(item => {
                itemId.push(item.id);
            });
            var url = direccionserver+'getTiendas?listProduc=1,2';
            loading = true;
            axios
                .get(url, config)
                .then(response => {
                    var result = response.data;
                    if (result) {
                        this.shopListMap = result;
                    }
                    loading = false;
                })
                .catch(error => {
                    alert("Ha ocurrido un error al momento de cargar la lista de tiendas más barato.");
                    loading = false;
                    console.log(error);
                });
        },

        //Metodo cuando le presionan clic en la lista superior de tiendas puede visualizar las ubicacion de las tiendas actuales registradas
        cambiarTiendAd: function (currentShop) {

            idtienda=currentShop[0].idtienda;

            this.shopListMapsin= JSON.parse(JSON.stringify(  this.shopListMap ));

            var i =  this.shopListMapsin.findIndex(x => x.idtienda === idtienda);
            if(i != -1) {
                this.shopListMapsin.splice(i, 1);
            }


            document.getElementById('tiend').innerHTML="Tienda : ";
            document.getElementById('tiendsel').innerHTML=currentShop[0].nombre;

            document.getElementById('listatienda').style='display:none;';
            this.verCat();
        },



        //Metodo que ocurre al seleccionar tienda similar
        seleccioProducSim: function (currentShop) {
            this.productSList=[];
            idtiendasel=currentShop[0].idtienda;
            $('#nombTiendSimil').html(currentShop[0].nombre);
            $('#similTiendaModal').modal('show');
            var idcat=document.getElementById('idcatact').value;
            this.getProductSimList(idtiendasel,idcat);

        },

        // Método que consulta productos similares
        getProductSimList: function (idtiendasel,idcat) {
            var url = direccionserver+'getProductosTareaCat';
            var nombreprod=document.getElementById('nombreprodsel').innerHTML;
            var descprod=document.getElementById('descprodsel').innerHTML;
            var codtiend=document.getElementById('codtiendsel').innerHTML;
            var precio=document.getElementById('precioprodsel').innerHTML;

            url=url+'?idtienda='+idtiendasel+'&idcategoria=' + idcat+'&precio='+precio.trim()+'&codigotienda='+codtiend.trim()+'&nombreprod='+nombreprod.toLowerCase().trim()+' '+descprod.toLowerCase().trim();

            loading = true;

            axios.get(url, config).then(response => {

                this.productSList = response.data;
                this.productSList.forEach(product => {
                        product.preciostr = product.precio.toLocaleString('en-US');
                });

                if (this.productSList.length>0) {
                    document.getElementById('sinresulsel').style = 'display:none;';
                }
                else
                {
                    document.getElementById('sinresulsel').style='display:block;';
                }



                loading = false;
            }).catch(error => {
                loading = false;
                console.log(error);
                alert("Ha ocurrido un error al momento de cargar la lista de productos.");
            });

        },




        //Metodo Cambiar Categorias
        cambiarCatAdm: function (idcat) {
            document.getElementById('idcatact').value=idcat;
            this.productTempList = [];
            document.getElementById('paginac').style = 'display:none;';
            this.getProductList(idcat,-1);
            document.getElementById('listacateg').style='display:none;';
            document.getElementById('listaproduc').style='display:block;';

            document.getElementById('catsel').textContent=this.catList[idcat-1].nombre.toUpperCase();
            window.scrollTo(0, 0);
        },
        //Metodo cuando le presionan clic en la lista superior de tiendas puede visualizar las ubicacion de las tiendas actuales registradas
        changeCurrentShop: function (currentShop) {
            this.mapa = true;
            document.getElementById('listacateg').style='display:none;';
            document.getElementById('listaproduc').style='display:none;';
            this.cardMap.style.display = "block";
            this.divMap.style.display = "block";
            this.searchMap.style.display = "block";
            this.autocpleteMap();

            var zoom = 8;
            if (currentShop.length > 1) zoom = 12;

            this.deleteMarkerMap(map);

            var infowindow = [];
            var marker, contentString;

            for (var shop in currentShop) {

                if (currentShop[shop].lat !== undefined) {

                    contentString = '<div id="content">' +
                        '<img width="50" height="50" center="true" src="' + currentShop[shop].imagen + '"/>' +
                        '<h6 id="firstHeading" class="firstHeading">' + currentShop[shop].nombre + '</h6>' +
                        '<div id="bodyContent">' +
                        '<p><b>Dirección : </b>' + currentShop[shop].lugar + '<br>' +
                        '<b>Descripción : </b>' + currentShop[shop].detalle + '<br>' +
                        '<b>Web : </b><a target="_blank" href="' + currentShop[shop].urlWeb + '">' + currentShop[shop].urlWeb + '</a> </p>' +
                        '<button title="Ir en carro" onclick="getRouteTienda( ' + currentShop[shop].lat + ',' + currentShop[shop].lng + ', \'DRIVING\' )"  ref="buttonRoute" type="button" class="btn btn-success"><i class="fa fa-car"></i></button>' +
                        '<button title="Ir caminando" onclick="getRouteTienda( ' + currentShop[shop].lat + ',' + currentShop[shop].lng + ', \'WALKING\' )"  ref="buttonRoute" type="button" class="btn btn-primary"><i class="fa fa-male"></i></button>' +
                        ' </div>';

                    var image = {
                        url: '/static/images/map/supermarket.png',
                        anchor: new google.maps.Point(17, 34),
                        scaledSize: new google.maps.Size(50, 50)
                    };

                    infowindow.push(new google.maps.InfoWindow());
                    marker = new google.maps.Marker(
                        {
                            position: {lat: currentShop[shop].lat, lng: currentShop[shop].lng},
                            map: map,
                            icon: image,
                            title: currentShop[shop].nombre
                        });

                    var pos = new google.maps.LatLng(currentShop[shop].lat, currentShop[shop].lng);
                    map.setCenter(pos);

                    infowindow[shop].open(map, marker)
                    infowindow[shop].setContent(contentString);

                    google.maps.event.addListener(marker, 'click', (function (marker, shop) {
                        return function () {

                            infowindow[shop].open(map, marker);
                        }
                    })(marker, shop));
                    this.markersMap.push(marker)
                }
            }
        },
        createMap() {

            //Inicializacion del mapa
            this.divMap = this.$refs.map;
            this.cardMap = this.$refs.controlDirection;
            this.searchMap = this.$refs.searchMap;

            //console.log( map );
            map = new google.maps.Map(this.divMap, {
                center: {lat: 4.648594, lng: -74.104466},
                zoom: 15
            });

            map.controls[google.maps.ControlPosition.LEFT_TOP].push(this.cardMap);
        },
        //Metodo para buscar cualquier direccion y buscar las tiendas registradas
        viewSearchPositions: function () {
            this.mapa = true;
            document.getElementById('listacateg').style='display:none;';
            document.getElementById('listaproduc').style='display:none;';
            this.cardMap.style.display = "block";
            this.divMap.style.display = "block";
            this.searchMap.style.display = "block";

            //Inicializar la posicion
            this.getPositionGps();
            //Autocompletar en el mapa
            this.autocpleteMap();
        }
        ,
        autocpleteMap: function () {
            //Busqueda de direcciones
            this.autocompleteMap = new google.maps.places.Autocomplete(
                (this.searchMap),
                {types: ['geocode']}
            );
            this.autocompleteMap.setComponentRestrictions(
                {'country': ['co']});
            var componentForm = {
                street_number: 'short_name',
                route: 'long_name',
                locality: 'long_name',
                administrative_area_level_1: 'short_name',
                country: 'long_name',
                postal_code: 'short_name'
            }
            this.autocompleteMap.bindTo('bounds', map);
            this.autocompleteMap.addListener('place_changed', this.googleFillInAddress);
        },
        googleFillInAddress: function () {

            this.deleteMarkerMap();

            var contentString = "<b>Descripción</b><br>";
            var place = this.autocompleteMap.getPlace();
            if (place.geometry === undefined || place.geometry === null) {
                return;
            }
            for (var i = 0; i < place.address_components.length; i++) {
                var valant = "";
                if (i > 0) {
                    valant = place.address_components[i - 1]['long_name'];
                }
                var val = place.address_components[i]['long_name'];
                if (valant !== val)
                    contentString += val + ", ";
            }

            var pos = new google.maps.LatLng(place.geometry.location.lat(), place.geometry.location.lng());
            var infowindow = new google.maps.InfoWindow({
                content: contentString
            });

            this.positionCenter = new google.maps.LatLng(place.geometry.location.lat(), place.geometry.location.lng());
            var marker = new google.maps.Marker({
                position: {lat: place.geometry.location.lat(), lng: place.geometry.location.lng()},
                map: map,
                title: 'Ubicación'
            });

            map.setCenter(pos);
            marker.addListener('click', function () {
                infowindow.open(map, marker);
            });
            new google.maps.event.trigger(marker, 'click');
            this.markersMap.push(marker);

            //Dibujar radio de busqueda
            this.paintCirculo();

            //Buscar los nombres que serán buscados en el buffer de 500 mts a la redonda
            for (var index in this.shopListMap) {
                if (this.shopListMap[index].lat !== undefined)
                    this.geocodeLatLng(this.shopListMap[index].lat, this.shopListMap[index].lng)
            }

        },
        getPositionGps: function () {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(this.getCurrentPosition);
            } else {
                // Browser doesn't support Geolocation
                alert('Error: The Geolocation service failed.' +
                    'Error: Your browser doesn\'t support geolocation.');
            }
        },
        getCurrentPosition: function (position) {
            this.deleteMarkerMap();
            var infoWindow = new google.maps.InfoWindow;
            var pos = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
            var image = {
                url: '/static/images/map/gps.png',
                anchor: new google.maps.Point(17, 34),
                scaledSize: new google.maps.Size(50, 50)
            };

            var marker = new google.maps.Marker({
                position: pos,
                icon: image,
                map: map,
                title: "Ubicación actual"
            });

            this.positionCenter = pos;
            marker.addListener('click', function () {
                infoWindow.open(map, marker);
            });
            infoWindow.setPosition(pos);
            infoWindow.setContent('Estás aquí');
            infoWindow.open(map, marker);
            map.setCenter(pos);
            //Dibujar radio de busqueda
            this.paintCirculo();

            this.markersMap.push(marker);

            //Buscar los nombres que serán buscados en el buffer de 500 mts a la redonda
            for (var index in this.shopListMap) {
                //console.log( this.shopListMap[index].lat +"<-->");
                var that = this;
                setTimeout(function () {
                    if (that.shopListMap[index].lat !== undefined)
                        that.geocodeLatLng(that.shopListMap[index].lat, that.shopListMap[index].lng)
                }, 1000);

            }
        },

        deleteMarkerMap: function (map) {
            for (var i = 0; i < this.markersMap.length; i++) {
                if (this.markersMap[i] != undefined) {
                    this.markersMap[i].setMap(null);
                }
                if (this.circlesMap[i] != undefined) {
                    this.circlesMap[i].setMap(null);
                }
            }

            if (directionsDisplay != null) {
                directionsDisplay.setMap(null);
                directionsDisplay = null;
            }
        },
        paintCirculo: function () {

            var circle = new google.maps.Circle({
                strokeColor: '#FF0000',
                strokeOpacity: 0.8,
                strokeWeight: 2,
                fillColor: '#F7E0E0',
                fillOpacity: 0.35,
                map: map,
                center: map.center,
                radius: this.km
            });

            this.circlesMap.push(circle);
        },
        geocodeLatLng: function (lat, lng) {
            var geocoder = new google.maps.Geocoder;
            var latlng = {lat: lat, lng: lng};
            var geocoderFunction = geocoder.geocode({'location': latlng}, this.getGeocoder);
        },
        getGeocoder: function (results, status) {
            var namePlace = "";
            if (status === 'OK') {

                //console.log( results);

                if (results[0]) {
                    this.searchNerby(this.positionCenter, results[0].formatted_address);
                    //this.nameSearchMap.push( results[0].formatted_address );
                    //console.log( results[0].formatted_address );
                } else {
                    console.log('No results found');
                    //alert('No results found');
                }
            } else {
                console.log('Geocoder failed due to: ' + status);
                //alert('Geocoder failed due to: ' + status);
            }
        },
        searchNerby(position, query) {
            var request = {
                location: position,
                radius: this.km,
                keyword: query
            };
            var service = new google.maps.places.PlacesService(map);
            service.nearbySearch(request, this.createMarkersNerby);
        }
        ,
        createMarkersNerby: function (places) {

            for (var i = 0, place; place = places[i]; i++) {
                //console.log( place.name );
                //var indexData = this.nameSearchMap.indexOf( place.name+", Bogotá, Colombia" );

                var image = {
                    url: '/static/images/map/supermarket.png',
                    anchor: new google.maps.Point(17, 34),
                    scaledSize: new google.maps.Size(50, 50)
                };
                var marker = new google.maps.Marker({
                    map: map,
                    icon: image,
                    title: place.name,
                    position: place.geometry.location
                });

                var infoWindow = new google.maps.InfoWindow;
                infoWindow.setPosition(place.geometry.location);
                infoWindow.setContent(place.name);
                marker.addListener('click', function () {
                    infoWindow.open(map, marker);
                });
            }
            this.markersMap.push(marker);
        },
        atrasMapa() {
            this.mapa = false;
            //var card = document.getElementById('controlDirection');
            this.cardMap.style.display = "none";
            //var divMap = document.getElementById('map');
            this.divMap.style.display = "none";
            this.searchMap.style.display = "none";
            document.getElementById('right-panel').style.display = "none";
        }
    }
};


var nameOriginDestinantion = [], directionsService, directionsDisplay, destination;

//Calcular ruta desde el gps hasta la tienda
function getRouteTienda(shopLat, shopLng, travelMode) {

    nameOriginDestinantion = [];
    if (directionsDisplay != null) {
        directionsDisplay.setMap(null);
        directionsDisplay = null;
    }
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function (position) {

            var geocoder = new google.maps.Geocoder;
            if (travelMode == "WALKING") {

                var walkingLineSymbol = {
                    path: google.maps.SymbolPath.CIRCLE,
                    fillOpacity: 1,
                    scale: 4
                };

                var polylineOptionsActual = new google.maps.Polyline({
                    strokeColor: '#0eb7f6',
                    strokeOpacity: 0,
                    fillOpacity: 0,
                    icons: [{
                        icon: walkingLineSymbol,
                        offset: '0',
                        repeat: '10px'
                    }],
                });
            } else {
                var polylineOptionsActual = {strokeColor: "#28a745"};
            }

            directionsService = new google.maps.DirectionsService;
            directionsDisplay = new google.maps.DirectionsRenderer({
                polylineOptions: polylineOptionsActual,
                suppressMarkers: true,
                preserveViewport: true
            });
            destination = new google.maps.LatLng(shopLat, shopLng);
            var origin = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);

            var image = {
                url: '/static/images/map/gps.png',
                anchor: new google.maps.Point(17, 34),
                scaledSize: new google.maps.Size(50, 50)
            };

            var marker = new google.maps.Marker({
                position: origin,
                icon: image,
                map: map,
                title: "Ubicación actual"
            });

            geocoder.geocode({'latLng': origin}, geoCoderGlobal);
            geocoder.geocode({'latLng': destination}, geoCoderGlobal);


            directionsDisplay.setMap(map);
            document.getElementById("right-panel").innerHTML = "";
            document.getElementById('right-panel').style.display = "none";
            directionsDisplay.setPanel(document.getElementById('right-panel'));

            //Se espera medio segundo a que se capture el valor del GPS
            setTimeout(function () {
                calculateAndDisplayRoute(directionsService, directionsDisplay, travelMode);
            }, 500);

        });
    } else {
        // Browser doesn't support Geolocation
        alert('Error: The Geolocation service failed.' +
            'Error: Your browser doesn\'t support geolocation.');
    }

}

function geoCoderGlobal(results, status) {

    if (status === 'OK') {
        if (results[0]) {
            nameOriginDestinantion.push(results[0].formatted_address);
        } else {
            alert('No results found');
        }
    } else {
        alert('Geocoder failed due to: ' + status);
    }
}

function calculateAndDisplayRoute(directionsService, directionsDisplay, travelMode) {

    directionsService.route({
        origin: nameOriginDestinantion[0].toString(),
        destination: nameOriginDestinantion[1].toString(),
        //travelMode: 'DRIVING',
        travelMode: travelMode,
        provideRouteAlternatives: true,
        drivingOptions: {
            departureTime: new Date(/* now, or future date */),
            trafficModel: 'optimistic'
        },
        unitSystem: google.maps.UnitSystem.IMPERIAL
    }, function (response, status) {
        console.log("Resultados", status, response);
        console.log(response)
        if (status === 'OK') {
            map.setZoom(13);
            map.setCenter(destination);
            document.getElementById('right-panel').style.display = "block";
            directionsDisplay.setDirections(response);
        } else {
            window.alert('Directions request failed due to ' + status);
        }
    });
}


