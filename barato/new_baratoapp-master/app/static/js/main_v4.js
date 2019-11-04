toastr.options = {
  "closeButton": true,
  "debug": false,
  "newestOnTop": true,
  "progressBar": true,
  "positionClass": "toast-bottom-right",
  "preventDuplicates": false,
  "onclick": null,
  "showDuration": "300",
  "hideDuration": "1000",
  "timeOut": "5000",
  "extendedTimeOut": "1000",
  "showEasing": "swing",
  "hideEasing": "linear",
  "showMethod": "fadeIn",
  "hideMethod": "fadeOut"
}

vm=new Vue({
  el: "#main",
  // Se importan propiedades y métodos de cada uno de los módulos.
  mixins:[product_list,product_temp_list,cat_list,num_pag,num_pag_tot,item_list,shop_list],

  // Define los delimitadores para usar las propiedades en html.
  delimiters: ["${", "}"],
  
  data: {
    // Bandera para el manejo de la visualizacion en tienpo de carga.
    loading: false,

    // Bandera para el manejo de la visualizacion del mapa.
    mapa: false,

    // Variable enlazada al campo de busqueda de productos.
    searchBar:"",

    // Variable para el control de visualizacion grid / list.
    displayList:true,
  },
  watch:{
    /* Cada vez que halla un cambio en searchBar, se verifica si esta vacia.
     En tal caso, se consulta de nuevo la lista de productos.*/
    searchBar:function (val) {
        this.getProductList(-1,1);
    }
  },
  mounted () {
    this.aleatorioPublicidad();
  },
  methods: {
    // Método para el control de visualizacion grid / list.
    changeDisplay(isList) {
      this.displayList = isList;
    },
      publicidad: function(){
        alert("Presionaste click sobre un anuncio, para ser redireccionado al establecimiento o producto este debe tener un contrato publicitario con BARATOAPP.CO");
      },
      aleatorioPublicidad : function(){
        var publicidad = this.$refs.publicidad;
        var that = this;
        setTimeout(function(){
          var num = parseInt(Math.random() * (5 - 1) + 1);
          //console.log( num, "<-->" );
          if (publicidad)
          publicidad.src = "/static/images/publicidad/ejemplo_"+num+".gif";
          that.aleatorioPublicidad();
        },3000);
      }
  }
});

