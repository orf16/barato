(function($) {
  "use strict"; // Start of use strict
  // Configure tooltips for collapsed side navigation
  $('.navbar-sidenav [data-toggle="tooltip"]').tooltip({
    template: '<div class="tooltip navbar-sidenav-tooltip" role="tooltip" style="pointer-events: none;"><div class="arrow"></div><div class="tooltip-inner"></div></div>'
  })
  // Toggle the side navigation
  $("#sidenavToggler").click(function(e) {
    e.preventDefault();
    $("body").toggleClass("sidenav-toggled");
    $(".navbar-sidenav .nav-link-collapse").addClass("collapsed");
    $(".navbar-sidenav .sidenav-second-level, .navbar-sidenav .sidenav-third-level").removeClass("show");
  });
  // Force the toggled class to be removed when a collapsible nav link is clicked
  $(".navbar-sidenav .nav-link-collapse").click(function(e) {
    e.preventDefault();
    $("body").removeClass("sidenav-toggled");
  });
  // Prevent the content wrapper from scrolling when the fixed side navigation hovered over
  $('body.fixed-nav .navbar-sidenav, body.fixed-nav .sidenav-toggler, .cart_sidebar').on('mousewheel DOMMouseScroll', function(e) {
    var e0 = e.originalEvent,
      delta = e0.wheelDelta || -e0.detail;
    this.scrollTop += (delta < 0 ? 1 : -1) * 30;
    e.preventDefault();
  });
  // Scroll to top button appear
  $(document).scroll(function() {
    var scrollDistance = $(this).scrollTop();
    if (scrollDistance > 100) {
      $('.scroll-to-top').fadeIn();
    } else {
      $('.scroll-to-top').fadeOut();
    }
  });

  $('#cart_sidebar').scroll(function() {
    var scrollDistance = $(this).scrollTop();
    if (scrollDistance > 100) {
      $('.scroll-to-top').fadeIn();
    } else {
      $('.scroll-to-top').fadeOut();
    }
  });
  
  // Configure tooltips globally
  $('[data-toggle="tooltip"]').tooltip()
  // Smooth scrolling using jQuery easing
  $(document).on('click', 'a.scroll-to-top', function(event) {
    var $anchor = $(this);
    $('html, body').stop().animate({
      scrollTop: ($($anchor.attr('href')).offset().top)
    }, 1000, 'easeInOutExpo');
    event.preventDefault();
  });

  $(document).ready(function () {
    $("#cart_sidebar").mCustomScrollbar({
        theme: "minimal"
    });

    $('#dismiss, .overlay').on('click', function () {
        $('#cart_sidebar').removeClass('active');
        $('.overlay').fadeOut();
    });

    $('#cart, #currentList').on('click', function (e) {
      e.preventDefault();
        $('#cart_sidebar').addClass('active');
        $('.overlay').fadeIn();
        $('a[aria-expanded=true]').attr('aria-expanded', 'false');
    });
    $('#cart2').on('click', function () {
        $('#cart_sidebar2').addClass('active');
        $('.overlay').fadeIn();
        $('.collapse.in').toggleClass('in');
        $('a[aria-expanded=true]').attr('aria-expanded', 'false');
    });
    
    
    $('#list').click(function(event) {
      event.preventDefault();
      $('#products').removeClass('grid-view').addClass('list-view');
      $('#products .card').addClass('row').parent().removeClass().addClass('col-12');
      $('#products .card-img-top').addClass('card-img-left col-md-4').removeClass('card-img-top');
      $('#products .card-block').addClass('col-md-8');
    });
    $('#grid').click(function(event) {
      event.preventDefault();
      $('#products').removeClass('list-view').addClass('grid-view');
      $('#products .card').removeClass('row').parent().removeClass('col-12').addClass('col-md-4');
      $('#products .card-img-left').addClass('card-img-top').removeClass('card-img-left col-md-4');
      $('#products .card-block').removeClass('col-md-8');
    });

  Array.prototype.unique=function(a){
    return function(){return this.filter(a)}}(function(a,b,c){return c.indexOf(a,b+1)<0
  });
});

})(jQuery); // End of use strict

