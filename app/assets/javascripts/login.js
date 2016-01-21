/**
 * Created by Su Khai Koh on 11/4/15.
 */

var INSTANCE_URL = "http://team-b.herokuapp.com";
var THUMBNAIL_COUNT = 6;
var IMAGES_PATH =
    [
        "btn_arrow.png",
        "btn_arrow_hover.png",
        "btn_arrow_right.png",
        "btn_arrow_right_hover.png",
        "map_0.jpg",
        "map_1.jpg",
        "map_2.jpg",
        "anim_loading_screen.gif",
        "profile_raymond.png",
        "profile_steven.png",
        "profile_suhan.png",
        "profile_sukhai.png"
    ];

var selectedThumbnail = 0;

function preloadImages() {

    var imageObject = new Image();

    // Load all the thumbnail images
    for (var i = 0; i < THUMBNAIL_COUNT; i++) {
        imageObject.src = INSTANCE_URL + "/assets/img_thumbnail_" + i + ".png";
    }

    // Load all the remaining images
    for (var i = 0; i < IMAGES_PATH.length; i++) {
        imageObject.src = INSTANCE_URL + "/assets/" + IMAGES_PATH[i];
    }
}

$("#btn-forgot-password").click(function() {
    location.href = INSTANCE_URL + "/users/password/new";
});

function btnClicked() {

    selectedThumbnail++;

    if (selectedThumbnail >= THUMBNAIL_COUNT) {
        selectedThumbnail = 0;
    }

    // Change the image to display to user
    $("#img-thumbnail").attr("src", INSTANCE_URL + "/assets/img_thumbnail_" + selectedThumbnail + ".png");

    // Change the value that will be written to the User database
    $("#image-path").attr("value", INSTANCE_URL + "/assets/img_thumbnail_" + selectedThumbnail + ".png");
}