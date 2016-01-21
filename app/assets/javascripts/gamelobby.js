/**
 * Created by Su Khai Koh on 10/31/15.
 */

$.fx.speeds.xfast = 175;        // Redefine the fading speed to 0.175 second

var socketId;
var pusher;
var selectedMapId;
var userId;
var channelName;
var lobbyMusic;

var EXIT_THIS_PAGE = "exit";
var GAMELOBBY = "gamelobbies";
var LOBBY_ID = "lobbyId";
var CURRENT_VIEW = "currentView";
var CONTAINER_DIV = "#game-lobbies";
var GAME_LOBBIES_DIV = "#game-lobbies-content";
var GAME_ROOM_DIV = "#game-room";
var LEADERBOARD_DIV = "#leaderboard-container";

// List of Public Channels
var GAME_LOBBIES_CHANNEL = "game_lobbies_channel";
var PUBLIC_CHAT_CHANNEL = "public_chat_channel";

// List of Events
var LOBBIES_UPDATED_EVENT = "lobbies_updated_event";
var GAME_ROOM_UPDATED_EVENT = "game_room_updated_event";
var GAME_STARTED_EVENT = "game_started_event";
var CHAT_MSG_RECEIVED_EVENT = "chat_msg_received_event";

$(document).ready(function() {

    // Subscribe the user to the public channel to receives update of
    // the game lobbies (new lobby, new users, etc)
    pusher = new Pusher('insert pusher key here');

    // Set a socket ID for the user
    pusher.connection.bind('connected', function() {
        socketId = pusher.connection.socket_id
    });

    // Check the current location
    var pathName = window.location.pathname;
    var controllerName = pathName.substring(1, pathName.length);
    var index = controllerName.indexOf('/');

    if (index > 0) {
        controllerName = controllerName.substring(0, index);
    }

    if (controllerName === GAMELOBBY || controllerName === "") {
        setupGameLobby();
    }

    window.localStorage.setItem(EXIT_THIS_PAGE, false);

});

$(window).bind('beforeunload', function() {

    // Leave the game lobby if this user is in a game lobby
    var lobbyId = window.localStorage.getItem(LOBBY_ID);

    if (lobbyId !== "null") {
        leaveGameLobby(lobbyId, false);
    }

    pusher.unsubscribe(PUBLIC_CHAT_CHANNEL);
    pusher.unsubscribe(GAME_LOBBIES_CHANNEL);

    // Disconnect pusher
    pusher.disconnect();
});

function setupGameLobby() {
    createChatBox("CHAT", PUBLIC_CHAT_CHANNEL);

    var channel = pusher.subscribe(PUBLIC_CHAT_CHANNEL);
    channel.bind(CHAT_MSG_RECEIVED_EVENT, function(data) {
        $("#chat-div").chatbox("option", "boxManager").addMsg(data["name"], data["message"]);

        // Get the current user's ID
        var userId = $("#current-user").data("user-id");

        // Only notify response if this receiver is not the sender
        if (userId !== data["sender_id"]) {
            notifyChatReceiver();
        }
    });

    if (window.localStorage.getItem(LOBBY_ID) !== "null") {
        // Show the game lobby if it has cached
        showGameLobby(window.localStorage.getItem(LOBBY_ID), false);

    } else {
        // Set the default value
        window.localStorage.setItem(LOBBY_ID, null);
        window.localStorage.setItem(CURRENT_VIEW, GAME_LOBBIES_DIV);

        // Subscribe to the public game lobbies channel and event
        channel = pusher.subscribe(GAME_LOBBIES_CHANNEL);
        channel.bind(LOBBIES_UPDATED_EVENT, function() {
            showGameLobbyList(null, false);
        });
    }

    // Default to use first map
    selectedMapId = "0";

    // Play background music
    lobbyMusic = new Audio(INSTANCE_URL + '/assets/lobbybgmusic.mp3');
    lobbyMusic.loop = true;
    lobbyMusic.volume = 0.1;
    lobbyMusic.play();

    // If the element has the lobby ID, then use it and show the game room
    // This is the ID sent from controller, which caused by joining the room with link
    var id = $("#show-lobby").text();
    if (id.length > 0) {
        $("#show-lobby").text("");
        joinGameLobby(id, false);
    }
}

function createGameLobby() {
    // Get the data from the form the user filled
    var roomName = document.getElementById('create-game-room-name').value;
    var publicPrivate = document.getElementById('create-game-public-private').value;

    // Make an HTTP POST to the server to create a game lobby
    $.ajax({
        type:"POST",
        url:"/gamelobbies",
        dataType:"json",
        contentType:"application/json",
        data: JSON.stringify(
            {
                "name": roomName,
                "public": publicPrivate === "public",
                "socket_id": socketId
            }
        ),
        success: function(data, textStatus, xhr) {
            // Hide the create game modal
            $('#create-game-modal').modal('hide');

            // Store data received
            var userList = data["user_list"];
            userId = userList[0];
            channelName = data["lobby_id"];

            subscribeLobby(data["id"], data["lobby_id"]);

            showGameLobby(data["id"], true);
        }
    });
}

function joinGameLobby(lobbyId, animate) {
    console.log("called j");
    // Make a POST to try to join the lobby
    $.ajax({
        type: "POST",
        url: "/gamelobbies/join",
        dataType: "json",
        contentType: "application/json",
        data: JSON.stringify(
            {
                "id": lobbyId,
                "socket_id": socketId
            }
        ),
        success: function(data, textStatus, xhr) {

            // Store data received
            userId = data["current_user_id"];
            channelName = data["channel_name"];

            // Show the game lobby
            showGameLobby(lobbyId, animate);
        }
    });
}

// @Deprecated
function rejoinGameLobby(lobbyId) {
    // Cache the lobby ID in the local web browser
    window.localStorage.setItem(LOBBY_ID, lobbyId);
}

function leaveGameLobby(lobbyId, animate, callback) {
    // Unsubscribe all the channels that are related to the game lobby
    unsubscribeLobby(lobbyId);

    // Make a POST and try to leave the lobby
    $.ajax({
        type: "POST",
        url: "/gamelobbies/leave",
        dataType: "json",
        contentType: "application/json",
        data: JSON.stringify(
            {
                "id": lobbyId,
                "socket_id": socketId
            }
        ),
        complete: function(data, testStatus, xhr) {
            // Delete the lobby ID from the cache if there is any
            window.localStorage.setItem(LOBBY_ID, "null");

            if (callback && typeof(callback) === "function") {
                callback();
            } else {
                // Show the game lobbies page
                showGameLobbyList(null, animate);
            }
        }
    });
}

function startGame(lobbyId) {
    lobbyMusic.pause();
    lobbyMusic.currentTime = 0;

    // Load the loading screen
    $("#gl-header").css("display", "none");
    $("#loading-screen").css("display", "block");

    // Make a POST and start the game
    $.ajax({
        type: "POST",
        url: "/gamelobbies/start/" + lobbyId,
        success: function(data, testStatus, xhr) {

            // Create a new record in game table
            $.ajax({
                type: "POST",
                url: "/bombermen/",
                dataType: "json",
                contentType: "application/json",
                data: JSON.stringify(
                    {
                        "lobby_id": data["lobby_id"],
                        "game_name": data["game_name"],
                        "channel_name": data["channel_name"],
                        "selected_map": data["selected_map"],
                        "user_list": data["user_list"]
                    }
                ),
                error: function() {
                    lobbyMusic.play();

                    // Hide the loading screen
                    $("#gl-header").css("display", "block");
                    $("#loading-screen").css("display", "none");
                }
            });
        }
    });
}

function showLeaderboard(animate) {

    if (window.localStorage.getItem(CURRENT_VIEW) === GAME_ROOM_DIV &&
        window.localStorage.getItem(LOBBY_ID) !== "null") {

        leaveGameLobby(window.localStorage.getItem(LOBBY_ID), true, function() {
            // Cache the current view in the local web browser
            window.localStorage.setItem(CURRENT_VIEW, LEADERBOARD_DIV);

            var htmlContainer = CONTAINER_DIV;
            if (animate) {
                // Fade out the content of the container
                $(htmlContainer).fadeOut('xfast', function () {
                    $(htmlContainer).hide();

                    // Load the content we want then fade the content into the container
                    $(htmlContainer).load("leaderboard/index " + LEADERBOARD_DIV, function (response, status, xhr) {
                        if (status == "error") {
                            window.localStorage.setItem(LOBBY_ID, "null");
                        } else {
                            $(htmlContainer).fadeIn('xfast');
                        }
                    });
                });
            } else {
                $(htmlContainer).load("leaderboard/index " + LEADERBOARD_DIV, function(response, status, xhr) {
                    if (status == "error") {
                        window.localStorage.setItem(LOBBY_ID, "null");
                    }
                });
            }
        });

        return;
    }

    // Cache the current view in the local web browser
    window.localStorage.setItem(CURRENT_VIEW, LEADERBOARD_DIV);

    var htmlContainer = CONTAINER_DIV;
    if (animate) {
        // Fade out the content of the container
        $(htmlContainer).fadeOut('xfast', function () {
            $(htmlContainer).hide();

            // Load the content we want then fade the content into the container
            $(htmlContainer).load("leaderboard/index " + LEADERBOARD_DIV, function (response, status, xhr) {
                if (status == "error") {
                    window.localStorage.setItem(LOBBY_ID, "null");
                } else {
                    $(htmlContainer).fadeIn('xfast');
                }
            });
        });
    } else {
        $(htmlContainer).load("leaderboard/index " + LEADERBOARD_DIV, function(response, status, xhr) {
            if (status == "error") {
                window.localStorage.setItem(LOBBY_ID, "null");
            }
        });
    }
}

function showGame(data) {

    // Make a request to show the actual game
    $.ajax({
        type: "GET",
        url: "/bombermen/show/" + data["game_id"],
        success: function(result, testStatus, xhr) {

            // Unsubsribe the player from public chat channel
            pusher.unsubscribe(PUBLIC_CHAT_CHANNEL);

            window.localStorage.setItem(LOBBY_ID, "null");

            // Redirect to the game page
            window.location = "bombermen/show/" + data["game_id"];
        }
    });
}

function showGameLobby(lobbyId, animate) {

    if (window.localStorage.getItem(CURRENT_VIEW) !== GAME_ROOM_DIV) {
        // Unsubscribe to the public game lobbies channel
        pusher.unsubscribe(GAME_LOBBIES_CHANNEL);

        // Get the channel name based on the given lobby ID
        $.ajax({
            type: "GET",
            url: "/gamelobbies/channelname/" + lobbyId,
            success: function(data, testStatus, xhr) {
                // Get the real lobby ID and use it as the channel name
                var channelId = data["channel_name"];

                // Subscribe to the lobby
                subscribeLobby(lobbyId, channelId);
            }
        });
    }

    // Cache the current view in the local web browser
    window.localStorage.setItem(CURRENT_VIEW, GAME_ROOM_DIV);
    window.localStorage.setItem(LOBBY_ID, lobbyId);

    var htmlContainer = CONTAINER_DIV;
    if (animate) {
        // Fade out the content of the container
        $(htmlContainer).fadeOut('xfast', function () {
            $(htmlContainer).hide();

            // Load the content we want then fade the content into the container
            $(htmlContainer).load("/gamelobbies/" + lobbyId + " " + GAME_ROOM_DIV, function (response, status, xhr) {
                if (status == "error") {
                    window.localStorage.setItem(LOBBY_ID, "null");
                } else {
                    $(htmlContainer).fadeIn('xfast');
                }
            });
        });
    } else {
        $(htmlContainer).load("/gamelobbies/" + lobbyId + " " + GAME_ROOM_DIV, function(response, status, xhr) {
            if (status == "error") {
                window.localStorage.setItem(LOBBY_ID, "null");
            }
        });
    }
}

function showGameLobbyList(lobbyId, animate) {

    if (window.localStorage.getItem(CURRENT_VIEW) !== GAME_LOBBIES_DIV) {
        // Subscribe to the public game lobbies channel and event
        var channel = pusher.subscribe(GAME_LOBBIES_CHANNEL);
        channel.bind('pusher:subscription_succeeded', function() {
            console.log("Subscription to public game lobbies channel succeed");
        });
        channel.bind(LOBBIES_UPDATED_EVENT, function() {
            showGameLobbyList(null, false)
        });

        // Cache the current view in the local web browser
        window.localStorage.setItem(CURRENT_VIEW, GAME_LOBBIES_DIV);

        if (lobbyId !== null || window.localStorage.getItem(LOBBY_ID) !== "null") {

            leaveGameLobby(window.localStorage.getItem(LOBBY_ID), animate);

            return;
        }
    }

    // Cache the current view in the local web browser
    window.localStorage.setItem(CURRENT_VIEW, GAME_LOBBIES_DIV);
    window.localStorage.setItem(LOBBY_ID, "null");

    var htmlContainer = CONTAINER_DIV;
    if (animate) {
        // Fade out the content of the container
        $(htmlContainer).fadeOut('xfast', function () {
            $(htmlContainer).hide();

            // Load the content we want then fade the content into the container
            $(htmlContainer).load("/gamelobbies/ " + GAME_LOBBIES_DIV, function () {
                $(htmlContainer).fadeIn('xfast');
            });
        });
    } else {
        $(htmlContainer).load("/gamelobbies/ " + GAME_LOBBIES_DIV);
    }

    // Unregister any window events
    window.onbeforeunload = null;
}

function showErrorModal(errorThrown) {
    // Hide the other modal if it is shown
    $('#create-game-modal').modal('hide');

    // Write the message to the modal content
    $('#error-message-data').load('Unable to create game\nError: ' + errorThrown);
    $('#error-message-modal').modal('show');
}

function subscribeLobby(lobbyId, lobbyChannel) {
    if (typeof lobbyId === "undefined" || lobbyId === null ||
        typeof lobbyChannel === "undefined" || lobbyChannel === null) {
        return;
    }

    // Subscribe to game lobby channel events
    var channel = pusher.subscribe(lobbyChannel);
    channel.bind(GAME_ROOM_UPDATED_EVENT, function(data) {

        currentUserId = data["current_user_id"];

        // Only process if we receive updates about other players
        if (currentUserId !== undefined && currentUserId !== "null" &&
            currentUserId !== "nil" && currentUserId !== userId) {
            showGameLobby(lobbyId, false);
        }
    });
    channel.bind(GAME_STARTED_EVENT, function(data) {
        showGame(data);
    });
}

function unsubscribeLobby(lobbyId) {
    if (typeof lobbyId === "undefined" || lobbyId === null) {
        return;
    }

    // Get the channel name based on the given lobby ID
    $.ajax({
        type: "GET",
        url: "/gamelobbies/channelname/" + lobbyId,
        success: function(data, testStatus, xhr) {
            // Unsubscribe the lobby channel
            pusher.unsubscribe(data["channel_name"]);
        }
    });
}

function nextThumbnail() {

    var currentThumbnail = $("#img-thumbnail").attr("src").split("\\.")[0];
    var currentThumbnailIndex = parseInt(currentThumbnail.substring(currentThumbnail.lastIndexOf("_") + 1, currentThumbnail.length));

    currentThumbnailIndex = isNaN(currentThumbnailIndex) ? -1 : currentThumbnailIndex;

    var selectedThumbnail = currentThumbnailIndex + 1;

    if (selectedThumbnail >= THUMBNAIL_COUNT) {
        selectedThumbnail = 0;
    }

    // Change the image to display to user
    $("#img-thumbnail").attr("src", INSTANCE_URL + "/assets/img_thumbnail_" + selectedThumbnail + ".png");

    $.ajax({
        type: "POST",
        url: "/gamelobbies/changethumbnail",
        dataType: "json",
        contentType: "application/json",
        data: JSON.stringify(
            {
                "user_id": userId,
                "channel_name": channelName,
                "image": INSTANCE_URL + "/assets/img_thumbnail_" + selectedThumbnail + ".png"
            }
        )
    });
}

function selectedMap(mapId) {
    // Remove any selection from all the maps
    $("#map-content").find('img').removeClass("checked-map");

    // Add checked-map css to this selected map
    $(this).parent().find('img').addClass("checked-map");

    var gamelobbyId = $("#gamelobby").data("id");

    selectedMapId = mapId;

    // Update the table
    $.ajax({
        type: "POST",
        url: "/gamelobbies/updatemap",
        dataType: "json",
        contentType: "application/json",
        data: JSON.stringify(
            {
                "id": gamelobbyId,
                "user_id": userId,
                "channel_name": channelName,
                "selected_map": selectedMapId
            }
        )
    });
}