const product_temp_list = {
    data: function () {
        return {
            productTempList: []
        };
    }
};


const cat_list = {
    data: function () {
        return {
            catList: []
        };
    },
    created: function () {
        // Carga inicial de Categorias
        this.getCatList();


        var lista_str = getCookie('prodBaratoApp');
        if (lista_str.trim()!=='')
            this.currentList = JSON.parse(lista_str);

    },
    methods: {
        cambiarCat: function (idcat) {
            document.getElementById('idcatact').value=idcat;
            this.productTempList = [];
            document.getElementById('paginac').style = 'display:none;';
            this.getProductList(idcat,-1);
            document.getElementById('listacateg').style='display:none;';
            document.getElementById('listaproduc').style='display:block;';

            document.getElementById('catsel').textContent=this.catList[idcat-1].nombre.toUpperCase();
            window.scrollTo(0, 0);
        },
        verCat: function () {
            document.getElementById('listaproduc').style='display:none;';
            document.getElementById('listacateg').style='display:block;';
            window.scrollTo(0, 0);
        },
        // Método que consulta todos las categorias a través del API
        getCatList: function () {
            var url = direccionserver+'getCategorias';
            loading = true;

            axios.get(url, config).then(response => {

                this.catList = response.data;
                loading = false;
            }).catch(error => {
                loading = false;
                console.log(error);
                alert("Ha ocurrido un error al momento de cargar la lista de categorias.");
            });
        }

    }
};


const num_pag = {
    data: function () {
        return {
            numpag: 1
        };
    }
};
const num_pag_tot = {
    data: function () {
        return {
            numpagtot: 1
        };
    }
};
const product_list = {
    data: function () {
        return {
            // Lista de productos a mostrar
            productList: []
        };
    },
    created: function () {

    },
    computed: {},
    methods: {
        getPaginaUno: function () {
            this.numpag = 1;
            this.numpagtot = Math.ceil(this.productList.length / 21);
            var num = this.numpag * 21;
            this.productTempList = this.productList.slice(num - 21, num);
            document.getElementById('ant').style = 'display:none';
            document.getElementById('sig').style = 'display:block';
            window.scrollTo(0, 0);
        },
        getPaginaAnt: function () {
            if (this.numpag > 1) {
                this.numpag = this.numpag - 1;
                var num = this.numpag * 21;
                this.productTempList = this.productList.slice(num - 21, num);
                if (this.numpag === 1) {
                    document.getElementById('ant').style = 'display:none';
                }
                document.getElementById('sig').style = 'display:block';
            }
            window.scrollTo(0, 0);
        },
        getPaginaSig: function () {
            if (this.numpag < this.numpagtot) {
                this.numpag = this.numpag + 1;
                var num = this.numpag * 21;
                this.productTempList = this.productList.slice(num - 21, num);
                document.getElementById('ant').style = 'display:block';
                if (this.numpag === this.numpagtot) {
                    document.getElementById('sig').style = 'display:none';
                }
            }
            window.scrollTo(0, 0);
        },

        getPaginaUlt: function () {
            this.numpag = this.numpagtot;
            var num = this.numpag * 21;
            this.productTempList = this.productList.slice(num - 21, num);
            document.getElementById('ant').style = 'display:block';
            document.getElementById('sig').style = 'display:none';
            window.scrollTo(0, 0);
        },

        // Método que consulta todos los productos a través del API
        getProductList: function (idcat,buscarnombre) {
            var url = direccionserver+'getProductosxcategoriaxNombre';

            if (idcat===-1)
                idcat=document.getElementById('idcatact').value;
            var nombre="";
            if (buscarnombre===1)
                nombre=this.searchBar;
            url=url+'?nombre=' +nombre+ '&idcat=' + idcat;

            loading = true;

            axios.get(url, config).then(response => {

                this.productList = response.data;
                this.getPaginaUno();

                for (i in this.productList) {
                    this.$set(this.productList[i], "quantity", 1);
                }


                if (this.productList.length>0) {
                    document.getElementById('sinresul').style = 'display:none;';
                    document.getElementById('paginac').style = 'display:block;';
                    if (this.productList.length<=20)
                        document.getElementById('sig').style = 'display:none';
                    else
                        document.getElementById('sig').style = 'display:block';
                }
                else
                {
                    document.getElementById('sinresul').style='display:block;';
                    document.getElementById('paginac').style = 'display:none;';

                }



                loading = false;
            }).catch(error => {
                loading = false;
                console.log(error);
                alert("Ha ocurrido un error al momento de cargar la lista de productos.");
            });


        },

    }
};
