
var MAIN_CONTAINER = "#dynamic-container";
var DEVELOPERS_CONTAINER = "#about-main-container";
var DISCLAIMER_CONTAINER = "#disclaimer-main-container";

function showDevelopers() {

    var htmlContainer = MAIN_CONTAINER;

    $(htmlContainer).fadeOut('xfast', function() {
        $(htmlContainer).hide();

        $(DISCLAIMER_CONTAINER).css("display", "none");

        $(htmlContainer).load("/about " + DEVELOPERS_CONTAINER, function() {

            $(DEVELOPERS_CONTAINER).css("display", "block");

            $(htmlContainer).fadeIn('xfast');
        });
    });
}

function showDisclaimer() {

    var htmlContainer = MAIN_CONTAINER;

    $(htmlContainer).fadeOut('xfast', function() {
        $(htmlContainer).hide();

        $(DEVELOPERS_CONTAINER).css("display", "none");

        $(htmlContainer).load("/about " + DISCLAIMER_CONTAINER, function() {

            $(DISCLAIMER_CONTAINER).css("display", "block");

            $(htmlContainer).fadeIn('xfast');
        });
    });
}