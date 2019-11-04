const item_list = {
    data: function () {
        return {
            // id de la lista actual
            currentListId: 0,
            // Listas del usuario
            userItemList: [],
            // Listas compartidas con el usuario
            userItemListShared: [],
            // Lista de productos agregados a la lista actual
            currentList: {
                idLista: 0,
                nombre: "",
                productos: []
            },
        };
    },
    created: function () {

    },
    mounted() {
        this.getUserItemList();
        this.getUserItemListShared();
    },
    computed: {
        validaCurrentList: function () {
            return this.currentList.nombre.length && this.currentList.productos.length >= 0;
        }
    },
    methods: {
        // Método que agrega un producto a la lista actual
        addToList: function (product) {
            //console.log( product );
            const record = this.currentList.productos.find(item => item.id === product.id.productoIdproducto);
            /* Agrega el item, en caso de que ya este agregado se aumenta la cantidad*/
            if (!record) {
//        console.log( product.id.productoIdproducto );
                this.currentList.productos.push({
                    id: product.id.productoIdproducto,
                    nombre: product.producto.nombre,
                    direccionImagen: product.producto.direccionImagen,
                    quantity: product.quantity
                });
                toastr["success"]("<b>" + product.producto.nombre + "</b>" + " ha sido agregado a la lista.");
            } else {
                record.quantity += product.quantity;
                if (record.quantity > 20) {
                    record.quantity = 20;
                }
            }

            var lista_str = JSON.stringify(this.currentList);
            setCookie('prodBaratoApp', lista_str,365);

        },
        // Método que elimina un producto de la lista actual
        removeFromList: function (item) {
            this.clearShopList();
            const index = this.currentList.productos.findIndex(
                itemInList => itemInList === item
            );
            this.currentList.productos.splice(index, 1);
            toastr["warning"]("<b>" + item.nombre + "</b>" + " ha sido eliminado de la lista.");
        },
        //Método que crea una nueva lista
        createList: function () {
            var newList = {
                idLista: 0,
                nombre: "Lista nueva",
                productos: []
            };

            toastr["success"]("Se ha cambiado a una lista nueva.");
            this.currentList = newList;
            /*if (this.validaCurrentList) {
              this.saveList();
            }*/
        },
        // Método que consultas las listas del usuario
        getUserItemList: function () {
            loading = true;
            //Se conecta con el correo
            const emailUser = this.$refs.userEmailGlobal.value;

            var url = direccionserver+'getListasUsuario?emailUser=' + emailUser;
            axios.get(url, config).then(response => {
                this.userItemList = [];
                for (let index = 0; index < Object.keys(response.data).length; index++) {
                    //console.log( Object.values(response.data)[index] ) ;
                    this.userItemList.push(Object.values(response.data)[index]);
                    //this.$set(this.userItemList[index], "nombre", Object.keys(response.data)[index]['nombrelista']);
                    this.$set(this.userItemList[index], "nombre", Object.values(response.data)[index]['nombrelista']);

                }
                loading = false;

            }).catch(error => {
                alert("Ha ocurrido un error al momento de cargar la lista del usuario.");
                console.log(error);
                loading = false;
            });
        },// Método que consultas las listas del usuario que han sido compartidas con el
        getUserItemListShared: function () {

            const emailUser = this.$refs.userEmailGlobal.value;

            loading = true;
            var url = direccionserver+'getListSharedUser?emailUser=' + emailUser;

            axios.get(url,config).then(response => {
                this.userItemListShared = [];
                for (let index = 0; index < Object.keys(response.data).length; index++) {
                    //console.log( Object.values(response.data)[index] ) ;
                    this.userItemListShared.push(Object.values(response.data)[index]);
                    //this.$set(this.userItemList[index], "nombre", Object.keys(response.data)[index]['nombrelista']);
                    this.$set(this.userItemListShared[index], "nombre", Object.values(response.data)[index]['nombrelista']);
                }
                loading = false;
            }).catch(error => {
                alert("Ha ocurrido un error al momento de cargar las listas compartidasdel usuario.");
                console.log(error);
                loading = false;
            });
        },
        // Método que cambia la lista actual a la seleccionada.
        changeCurrentList: function (selectedList) {

            if (this.validaCurrentList) {
                this.saveList();
            }
            this.currentList = {
                idLista: 0,
                nombre: "",
                productos: []
            };
//      console.log( selectedList );

            this.currentList.idLista = selectedList.idlista;
            this.currentList.nombre = selectedList.nombre;
            //this.currentList.productos=selectedList.productos;

            Object.values(selectedList.productos).forEach(item => {

                //console.log( item );
                this.currentList.productos.push({
                    'nombre': item.nombreproducto,
                    'direccionImagen': item.url,
                    //'id': item.idlistaproducto,
                    'id': item.producto_idproducto,
                    'quantity': 1
                })
            });
            toastr["success"]("Ha cambiado a la lista " + "<b>" + selectedList.nombre + "</b>.");

            var lista_str = JSON.stringify(this.currentList);
            setCookie('prodBaratoApp', lista_str,365);

        },
        // Método que guarda la lista actual en la base de datos a través del API.
        saveList: function () {
            if (this.validaCurrentList) {
                var listProductoId = [];
                this.currentList.productos.forEach(item => {
                    listProductoId.push(item.id);
                });
                //Se conecta con el correo
                const emailUser = this.$refs.userEmailGlobal.value;
                //var idUsuario = 27;
                var nombreLista = this.currentList.nombre;
                var idLista = this.currentList.idLista;


                var url = direccionserver+'setListasProductosxUsuario';
                if (this.currentList.idLista !== 0) {
                    url = direccionserver+'setActualizarListasProductosxUsuario';
                }

                loading = true;
                axios.post(url, {
                    'idLista': idLista,
                    'listProductoId': listProductoId.toString(),
                    'nombreLista': nombreLista,
                    'emailUser': emailUser
                }, config).then(response => {
                    var resultado = response.data.guardado;
                    if (response.data.guardado != undefined) {
                        var resultado = response.data.guardado;
                    } else var resultado = response.data;
                    this.getUserItemList();
                    loading = false;
                    toastr["success"]("La lista " + "<b>" + this.currentList.nombre + "</b>" + " ha sido guardada exitosamente.");
                }).catch(error => {
                    alert(error)
                    console.log(error);
                    loading = false;
                });
            } else {
                //alert("Para guardar una lista, la misma debe tener nombre y no puede estar vacia.")
            }
        },

        // Método que envia comentarios.
        enviarComentario: function () {
                var url = direccionserver+'setComentario';
                loading = true;
                var comentario = document.getElementById('comenttext').value;

                var calificac = $('#valstars').val();
                if (comentario.trim()==='') {
                    alert('Ingrese una Comentario.');
                    document.getElementById('comenttext').focus();
                }
                else if (calificac.trim() ==='0' || calificac.trim() ==='') {
                    calificac='';
                    alert('Ingrese una Calificación.');
                }

            if ((comentario.trim()!=='') && (calificac.trim() !=='')) {
                axios.post(url, {
                    'coment': comentario,
                    'calif': calificac,
                    'email': UserEmail
                }, config).then(response => {
                    loading = false;
                    toastr["success"]("Mensaje enviado.");

                    $('#commentModal').modal('hide');
                    // toastr["success"]("Mensaje enviado.");
                    document.getElementById('comenttext').value = '';
                    $('#valstars').val('0');
                    $('#ratingb').rateYo('rating', 0);

                }).catch(error => {
                    alert("Ocurrió un Error al Enviar el Mensaje")
                    loading = false;
                });
            }

        },


    }
};


