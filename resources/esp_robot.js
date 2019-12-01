var ws;

var servo_disabled = -1;
var left_wheel_setpoint = servo_disabled;
var right_wheel_setpoint = servo_disabled;
var head_setpoint = 90;
var left_eye_increment = 5;
var right_eye_increment = 5;

var keys = {};

function ws_onerror(error) {
	document.getElementById("banner").innerHTML = `[error] ${error.message}`;
	init_ws();
};

function ws_onopen(e) {
	document.getElementById("banner").innerHTML = "Connected";
	/* reset all, in particular,  re-synchronize the eyes */
	left_eye_increment = 0;
	right_eye_increment = 0;
	left_wheel_setpoint = servo_disabled;
	right_wheel_setpoint = servo_disabled;
	head_setpoint = 90;
	send_message();

	left_eye_increment = 5;
	right_eye_increment = 5;
	send_message();
};

function init_ws() {
	ws = new WebSocket("ws://esp_robot.local:81");
	ws.onerror = ws_onerror;
	ws.onopen = ws_onopen;
}

function send_message(e) {
	var msg = {
		left_wheel : left_wheel_setpoint,
		right_wheel : right_wheel_setpoint,
		head : head_setpoint,
		left_eye: left_eye_increment,
		right_eye: right_eye_increment,
	};
	if (!(ws.readyState === WebSocket.OPEN)) {
		document.getElementById("banner").innerHTML = "Can't speak to robot";
		return;
	}
	ws.send(JSON.stringify(msg));
}

document.onkeypress = function(e) {
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

function updateMovement() {
	left_wheel_setpoint = -1;
	right_wheel_setpoint = -1;
	head_setpoint = 90;
	if (keys["ArrowUp"]) {
		if (keys["ArrowRight"]) {
			if (keys["ArrowLeft"]) {
				if (keys["ArrowDown"]) {
				} else {
				}
			} else {
				if (keys["ArrowDown"]) {
				} else {
					left_wheel_setpoint = 180;
					right_wheel_setpoint = 85;
				}
			}
		} else {
			if (keys["ArrowLeft"]) {
				if (keys["ArrowDown"]) {
				} else {
					left_wheel_setpoint = 110;
					right_wheel_setpoint = 0;
				}
			} else {
				if (keys["ArrowDown"]) {
				} else {
					left_wheel_setpoint = 180;
					right_wheel_setpoint = 0;
				}
			}
		}
	} else {
		if (keys["ArrowRight"]) {
			if (keys["ArrowLeft"]) {
				if (keys["ArrowDown"]) {
				} else {
				}
			} else {
				if (keys["ArrowDown"]) {
					left_wheel_setpoint = 0;
					right_wheel_setpoint = 110;
				} else {
					left_wheel_setpoint = 180;
					right_wheel_setpoint = 180;
				}
			}
		} else {
			if (keys["ArrowLeft"]) {
				if (keys["ArrowDown"]) {
					left_wheel_setpoint = 80;
					right_wheel_setpoint = 180;
				} else {
					left_wheel_setpoint = 0;
					right_wheel_setpoint = 0;
				}
			} else {
				if (keys["ArrowDown"]) {
					left_wheel_setpoint = 0;
					right_wheel_setpoint = 180;
				} else {
				}
			}
		}
	}
	send_message();
}

function updateHead() {
	if (keys["PageUp"]) {
		if (!keys["PageDown"])
			head_setpoint = 180;
	}
	if (!keys["PageUp"]) {
		if (keys["PageDown"])
			head_setpoint = 0;
	}
	send_message();
}

document.onkeydown = function(e) {
	element = document.getElementById(e.code);
	if (element) {
		e.preventDefault();
		if (keys[e.code])
			return;
		keys[e.code] = true;
		element.style.backgroundColor = "#cbcbf1";
		updateMovement();
		updateHead();
	}
}

/*
 * up right left down  left wheel  right wheel
 * 0  0     0    0      0           0
 * 0  0     0    1     -2          -2
 * 0  0     1    0     -2          +2
 * 0  0     1    1     -1          -2
 * 0  1     0    0     +2          -2
 * 0  1     0    1     -2          -1
 * 0  1     1    0     XX          XX
 * 0  1     1    1     XX          XX
 * 1  0     0    0     +2          +2
 * 1  0     0    1     XX          XX
 * 1  0     1    0     +1          +2
 * 1  0     1    1     XX          XX
 * 1  1     0    0     +2          +1
 * 1  1     0    1     XX          XX
 * 1  1     1    0     XX          XX
 * 1  1     1    1     XX          XX
 */

document.onkeyup = function(e) {
	element = document.getElementById(e.code);
	if (element) {
		e.preventDefault();
		keys[e.code] = false;
		element.style.backgroundColor = "#f6f6ff";
		updateMovement();
		updateHead();
	}
}

init_ws();
