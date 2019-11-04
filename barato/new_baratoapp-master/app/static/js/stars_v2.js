$(function () {

    var rating = 0;

    $(".counter").text(rating);


    $(".rateyo").rateYo({

        rating: rating,
        numStars: 5,
        precision: 2,
        minValue: 1,
        maxValue: 5
    }).on("rateyo.change", function (e, data) {
        $('#valstars').val(data.rating);
    });
});