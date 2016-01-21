/*
 * Copyright 2010, Wen Pu (dexterpu at gmail dot com)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * Check out http://www.cs.illinois.edu/homes/wenpu1/chatbox.html for document
 *
 * Depends on jquery.ui.core, jquery.ui.widiget, jquery.ui.effect
 *
 * Also uses some styles for jquery.ui.dialog
 *
 */


// TODO: implement destroy()
(function($) {
    $.widget("ui.chatbox", {
        options: {
            id: null, //id for the DOM element
            title: null, // title of the chatbox
            user: null, // can be anything associated with this chatbox
            hidden: false,
            offset: 0, // relative to right edge of the browser window
            width: 300, // width of the chatbox
            messageSent: function(id, user, msg) {
                // override this
                this.boxManager.addMsg(user.first_name, msg);
            },
            boxClosed: function(id) {
            }, // called when the close icon is clicked
            boxManager: {
                // thanks to the widget factory facility
                // similar to http://alexsexton.com/?p=51
                init: function(elem) {
                    this.elem = elem;
                },
                addMsg: function(peer, msg) {
                    var self = this;
                    var box = self.elem.uiChatboxLog;
                    var e = document.createElement('div');
                    box.append(e);
                    $(e).hide();

                    var systemMessage = false;

                    if (peer) {
                        var peerName = document.createElement("b");
                        $(peerName).text(peer + ": ");
                        e.appendChild(peerName);
                    } else {
                        systemMessage = true;
                    }

                    var msgElement = document.createElement(
                        systemMessage ? "i" : "span");
                    $(msgElement).text(msg);
                    e.appendChild(msgElement);
                    $(e).addClass("ui-chatbox-msg");
                    $(e).css("maxWidth", $(box).width());
                    $(e).fadeIn();
                    self._scrollToBottom();

                    if (!self.elem.uiChatboxTitlebar.hasClass("ui-state-focus")
                        && !self.highlightLock) {
                        self.highlightLock = true;
                        self.highlightBox();
                    }
                },
                highlightBox: function() {
                    var self = this;
                    self.elem.uiChatboxTitlebar.effect("highlight", {color: "#0085c7"}, 300);
                    self.elem.uiChatbox.effect("bounce", {times: 3}, 300, function() {
                        self.highlightLock = false;
                        self._scrollToBottom();
                    });
                },
                toggleBox: function() {
                    this.elem.uiChatbox.toggle();
                },
                _scrollToBottom: function() {
                    var box = this.elem.uiChatboxLog;
                    box.scrollTop(box.get(0).scrollHeight);
                }
            }
        },
        toggleContent: function(event) {

            this.uiChatboxContent.toggle();

            if (this.uiChatboxContent.is(":visible")) {

                // Resize the chatbox container
                $("#ui-chatbox").css("height", "385px");    // Height must be equal to the height in css

                // Move the chatbox up so we can see the whole chatbox
                var topOffset = $("#gl-sidebar").height() - $("#ui-chatbox").height();
                $("#ui-chatbox").css("top", topOffset);

                // Hide the notification icon
                $("#chatbox-notification-icon").css("display", "none");

                this.uiChatboxInputBox.focus();

            } else {

                // Resize the chatbox container
                $("#ui-chatbox").css("height", $("#chatbox-title-bar").height());

                // Move the chatbox down so we only show the title bar
                var topOffset = $("#gl-sidebar").height() - ($("#chatbox-title-bar").height() * 3);
                $("#ui-chatbox").css("top", topOffset);
            }
        },
        widget: function() {
            return this.uiChatbox
        },
        _create: function() {
            var self = this,
                options = self.options,
                title = options.title || "No Title",
            // chatbox
                uiChatbox = (self.uiChatbox = $('<div id="ui-chatbox" style="position: absolute;bottom: -200px;"></div>'))
                    .appendTo($("#gl-sidebar"))
                    .addClass('ui-widget ' +
                    'ui-corner-top'
                )
                    .attr('outline', 0)
                    .focusin(function() {
                        // ui-state-highlight is not really helpful here
                        //self.uiChatbox.removeClass('ui-state-highlight');
                        self.uiChatboxTitlebar.addClass('ui-state-focus');
                    })
                    .focusout(function() {
                        self.uiChatboxTitlebar.removeClass('ui-state-focus');
                    }),
            // titlebar
                uiChatboxTitlebar = (self.uiChatboxTitlebar = $('<div id="chatbox-title-bar"></div>'))
                    .addClass('ui-widget-header ' +
                    'ui-corner-top ' +
                    'ui-chatbox-titlebar ' +
                    'ui-dialog-header' // take advantage of dialog header style
                )
                    .click(function(event) {
                        self.toggleContent(event);
                    })
                    .appendTo(uiChatbox),
                uiChatboxTitle = (self.uiChatboxTitle = $('<span></span>'))
                    .html(title)
                    .appendTo(uiChatboxTitlebar),
                uiChatboxTitlebarNotification = (self.uiChatboxTitlebarNotification =
                    $('<div id="chatbox-notification-icon" style="display: none;"><img src="/assets/icon_notification.png" /></div>'))
                    .appendTo(uiChatboxTitlebar),
                uiChatboxTitlebarMinimize = (self.uiChatboxTitlebarMinimize = $('<a href="#"></a>'))
                    .addClass('ui-corner-all ' +
                    'ui-chatbox-icon'
                )
                    .attr('role', 'button')
                    .hover(function() { uiChatboxTitlebarMinimize.addClass('ui-state-hover'); },
                    function() { uiChatboxTitlebarMinimize.removeClass('ui-state-hover'); })
                    .click(function(event) {
                        self.toggleContent(event);
                        return false;
                    })
                    .appendTo(uiChatboxTitlebar),
                uiChatboxTitlebarMinimizeText = $('<span></span>')
                    .addClass('ui-icon ' +
                    'ui-icon-minusthick')
                    .text('minimize')
                    .appendTo(uiChatboxTitlebarMinimize),
            // content
                uiChatboxContent = (self.uiChatboxContent = $('<div></div>'))
                    .addClass('ui-widget-content ' +
                    'ui-chatbox-content '
                )
                    .appendTo(uiChatbox),
                uiChatboxLog = (self.uiChatboxLog = self.element)
                    .addClass('ui-widget-content ' +
                    'ui-chatbox-log'
                )
                    .appendTo(uiChatboxContent),
                uiChatboxInput = (self.uiChatboxInput = $('<div></div>'))
                    .addClass('ui-chatbox-input'
                )
                    .click(function(event) {
                        // anything?
                    })
                    .appendTo(uiChatboxContent),
                uiChatboxInputBox = (self.uiChatboxInputBox = $('<textarea></textarea>'))
                    .addClass('ui-chatbox-input-box'
                )
                    .appendTo(uiChatboxInput)
                    .keydown(function(event) {
                        if (event.keyCode && event.keyCode == $.ui.keyCode.ENTER) {
                            msg = $.trim($(this).val());
                            if (msg.length > 0) {
                                self.options.messageSent(self.options.id, self.options.user, msg);
                            }
                            $(this).val('');
                            return false;
                        }
                    })
                    .focusin(function() {
                        uiChatboxInputBox.addClass('ui-chatbox-input-focus');
                        var box = $(this).parent().prev();
                        box.scrollTop(box.get(0).scrollHeight);
                    })
                    .focusout(function() {
                        uiChatboxInputBox.removeClass('ui-chatbox-input-focus');
                    });

            // disable selection
            uiChatboxTitlebar.find('*').add(uiChatboxTitlebar).disableSelection();

            // switch focus to input box when whatever clicked
            uiChatboxContent.children().click(function() {
                // click on any children, set focus on input box
                self.uiChatboxInputBox.focus();
            });

            self._setWidth(self.options.width);
            self._position(self.options.offset);

            self.options.boxManager.init(self);

            if (!self.options.hidden) {
                uiChatbox.show();
            }
        },
        _setOption: function(option, value) {
            if (value != null) {
                switch (option) {
                    case "hidden":
                        if (value)
                            this.uiChatbox.hide();
                        else
                            this.uiChatbox.show();
                        break;
                    case "offset":
                        this._position(value);
                        break;
                    case "width":
                        this._setWidth(value);
                        break;
                }
            }
            $.Widget.prototype._setOption.apply(this, arguments);
        },
        _setWidth: function(width) {
            width = 100;
            this.uiChatboxTitlebar.width((width - 8) + "%");
            this.uiChatboxLog.width((width - 8) + "%");
            this.uiChatboxInput.css("maxWidth", (width - 0) + "%");
            // padding:2, boarder:2, margin:5
            this.uiChatboxInputBox.css("width", (width - 4) + "%");
        },
        _position: function(offset) {
            this.uiChatbox.css("right", offset);
         //   this.uiChatbox.css("top", 300);
        }
    });
}(jQuery));