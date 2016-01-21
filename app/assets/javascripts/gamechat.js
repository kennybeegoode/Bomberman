/**
 * Created by Suhan Koh on 11/8/15.
 */


var box = null;
var chatChannelName = "";
var notificationSound;

function createChatBox(chatboxTitle, chName) {

    chatChannelName = chName;

    if (box) {
        box.chatbox("option", "boxManager").toggleBox();

    } else {
        box = $("#chat-div").chatbox(
            {
                id: "chat-div",
                user: { key: "value" },
                title: chatboxTitle,
                offset: 0,
                messageSent: function(id, user, msg) {
                    $("#log").append(id + " said: " + msg + "<br/>");
                    sendMsg(user, msg, chatChannelName);
                }
            }
        )
    }

    // Move chatbox to the bottom right
    var topOffset = $("#gl-sidebar").height() - $("#ui-chatbox").height();
    $("#ui-chatbox").css("top", topOffset);

    notificationSound = new Audio(INSTANCE_URL + '/assets/chatsound.mp3');
    notificationSound.loop = false;
    notificationSound.volume = 1.0;
}

function sendMsg(name, msg, chName) {

    $.ajax({
        type: "POST",
        url: "/gamechats/sendMessage",
        dataType: "json",
        contentType: "application/json",
        data: JSON.stringify(
            {
                "channel_name": chName,
                "name": name,
                "message": msg
            }
        )
    });
}

function notifyChatReceiver() {
    // Only send notification if the chatbox is minimized
    var chatboxHeight = $("#ui-chatbox").height();

    if (chatboxHeight != 385) {
        // Show the notification icon
        $("#chatbox-notification-icon").css("display", "inline");
    }

    notificationSound.play();
}

$(window).resize(function() {
    // Move chatbox to the bottom right
    var chatboxHeight = $("#ui-chatbox").height();

    if (chatboxHeight == 385) { // 390 = height from css
        var topOffset = $("#gl-sidebar").height() - $("#ui-chatbox").height();
        $("#ui-chatbox").css("top", topOffset);
    } else {
        // Move the chatbox down so we only show the title bar
        var topOffset = $("#gl-sidebar").height() - ($("#chatbox-title-bar").height() * 3);
        $("#ui-chatbox").css("top", topOffset);
    }
});

  



