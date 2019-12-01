var ws = new WebSocket("ws://esp_robot.local:81");

var servo_disabled = -1;
var left_wheel_setpoint = servo_disabled;
var right_wheel_setpoint = servo_disabled;
var head_setpoint = 90;
var left_eye_increment = 5;
var right_eye_increment = 5;

ws.onerror = function(error) {
	alert(`[error] ${error.message}`);
};
ws.onopen = function(e) {
	console.log("open");
	/* resynchronize the eyes */
	left_eye_increment = 0;
	right_eye_increment = 0;
	send_message();

	left_eye_increment = 5;
	right_eye_increment = 5;
	send_message();
};

send_message = function(e) {
	var msg = {
		left_wheel : left_wheel_setpoint,
		right_wheel : right_wheel_setpoint,
		head : head_setpoint,
		left_eye: left_eye_increment,
		right_eye: right_eye_increment,
	};
	ws.send(JSON.stringify(msg));
}

document.onkeypress = function(e) {
	console.log('Frappe de la touche de code ' + e.which);
	if (e.which == 101) { // e
		left_wheel_setpoint = left_wheel_setpoint + 1;
		send_message();
	} else if (e.which == 106) { // j
		left_wheel_setpoint = left_wheel_setpoint - 1;
		send_message();
	} else if (e.which == 117) { // u
		right_wheel_setpoint = right_wheel_setpoint + 1;
		send_message();
	} else if (e.which == 107) { // k
		right_wheel_setpoint = right_wheel_setpoint - 1;
		send_message();
	} else if (e.which == 105) { // i
		head_setpoint = head_setpoint + 1;
		send_message();
	} else if (e.which == 120) { // x
		head_setpoint = head_setpoint - 1;
		send_message();
	} else if (e.which == 97) { // a
		left_eye_increment = left_eye_increment + 1;
		send_message();
	} else if (e.which == 59) { // ;
		left_eye_increment = left_eye_increment - 1;
		send_message();
	} else if (e.which == 111) { // o
		right_eye_increment = right_eye_increment + 1;
		send_message();
	} else if (e.which == 113) { // q
		right_eye_increment = right_eye_increment - 1;
		send_message();
	}
}
