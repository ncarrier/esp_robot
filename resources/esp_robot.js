var ws = new WebSocket("ws://esp_robot.local:81");

var left_wheel_setpoint = 90;
var right_wheel_setpoint = 90;
var head_setpoint = 90;

ws.onopen = function(e) {
	console.log("open");
};
ws.onerror = function(error) {
	alert(`[error] ${error.message}`);
};

send_message = function(e) {
	// TODO put in range
	var msg = {
		left_wheel : left_wheel_setpoint,
		right_wheel : right_wheel_setpoint,
		head : head_setpoint,
	};
	ws.send(JSON.stringify(msg));
}

document.onkeypress = function(e) {
	console.log('Frappe de la touche de code ' + e.which);
	if (e.which == 101) {
		right_wheel_setpoint = right_wheel_setpoint + 1;
		send_message();
	} else if (e.which == 106) {
		right_wheel_setpoint = right_wheel_setpoint - 1;
		send_message();
	}
}
