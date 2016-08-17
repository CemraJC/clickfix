var clicker = document.querySelector(".click-target");
var click_log = document.querySelector(".click-info");


function logClickEvent(msg, button) {
    var full_message_string = "At " + new Date().toTimeString().match(/^[0-9:]{2,10}/)[0] + " a <b>" + msg + "</b> event was detected." + (typeof button === "string" ? " (" + button + ")": "");
    click_log.innerHTML = click_log.innerHTML + full_message_string + "<br>";
    click_log.scrollTop = 100000; // A hacky way of sticking scroll to the bottom
}

function buttonDecode(number) {
    if (typeof number !== "number") {
        return false;
    }

    switch (number) {
        case 1:
            return "Left Button";
        case 2:
            return "Right Button";
        case 4:
            return "Middle Button";
        default:
            return false;
    }
}

clicker.addEventListener('mousedown', function(e){
    e.preventDefault();
    logClickEvent("mouse down", buttonDecode(e.buttons));

    if (e.detail === 2) {
        logClickEvent("double click");
    }
});

clicker.addEventListener('mouseup', function(e){
    e.preventDefault();
    logClickEvent("mouse up", buttonDecode(e.buttons));
});

clicker.addEventListener('contextmenu', function(e){
    e.preventDefault();
});