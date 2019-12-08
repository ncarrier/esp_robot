var ws;

var servo_disabled = -1;
var left_wheel_setpoint = servo_disabled;
var right_wheel_setpoint = servo_disabled;
var head_setpoint = 90;
var left_eye_increment = 5;
var right_eye_increment = 5;

var keys = {
	PageUp: false,
	ArrowUp: false,
	PageDown: false,
	ArrowLeft: false,
	ArrowDown: false,
	ArrowRight: false,
};

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
	ws = new WebSocket("ws://192.168.4.1:81");
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

function on_control_down(e) {
	/* e.code if keyboard event, e.currentTarget.id if mouse event */
	element_name = e.code ? e.code : e.currentTarget.id;
	document.getElementById("banner").innerHTML = element_name;

	element = document.getElementById(element_name);
	if (element) {
		e.preventDefault();
		if (keys[element_name])
			return;
		keys[element_name] = true;
		element.style.backgroundColor = "#cbcbf1";
		updateMovement();
		updateHead();
	}
}
document.onkeydown = on_control_down;

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

function on_control_up(e) {
	element_name = e.code ? e.code : e.currentTarget.id;

	element = document.getElementById(element_name);
	if (element) {
		e.preventDefault();
		keys[element_name] = false;
		element.style.backgroundColor = "#f6f6ff";
		updateMovement();
		updateHead();
	}
}
document.onkeyup = on_control_up;

for (var key in keys) {
	var element = document.getElementById(key)
	element.onmousedown = on_control_down;
	element.onmouseup = on_control_up;
	element.oncontextmenu = on_control_down;
	element.ontouchstart = on_control_down;
	element.ontouchend = on_control_up;
}

function on_accelerometer_down(e) {
	/* e.code if keyboard event, e.currentTarget.id if mouse event */
	element_name = e.code ? e.code : e.currentTarget.id;

	element = document.getElementById(element_name);
	if (element) {
		e.preventDefault();
		element.style.backgroundColor = "#cbcbf1";
		window.ondevicemotion = on_device_motion;
	}
}

function on_accelerometer_up(e) {
	element_name = e.code ? e.code : e.currentTarget.id;

	element = document.getElementById(element_name);
	if (element) {
		e.preventDefault();
		element.style.backgroundColor = "#f6f6ff";
		window.ondevicemotion = undefined;
	}
}

var element = document.getElementById("accelerometer")
element.onmousedown = on_accelerometer_down;
element.onmouseup = on_accelerometer_up;
element.oncontextmenu = on_accelerometer_down;
element.ontouchstart = on_accelerometer_down;
element.ontouchend = on_accelerometer_up;

init_ws();

window.oncontextmenu = function(event) {
    event.preventDefault();
    event.stopPropagation();
    return false;
};

var gravity = [0, 0, 0];
var gravity_element = document.getElementById('gravity')

function compute_gravity_vector(x, y, z) {
	var alpha = 0.8;
	var norm;
	var x;
	var y;
	var z;
	var ts;

	/* lowpass filter the gravity vector to filter sudden movements */
	gravity[0] = alpha * gravity[0] + (1 - alpha) * x;
	gravity[1] = alpha * gravity[1] + (1 - alpha) * y;
	gravity[2] = alpha * gravity[2] + (1 - alpha) * z;

	/* normalize the gravity vector */
	norm = Math.sqrt(Math.pow(gravity[0], 2) + Math.pow(gravity[1], 2) +
		Math.pow(gravity[2], 2));
	x = gravity[0] / norm;
	y = gravity[1] / norm;
	z = gravity[2] / norm;
}

function on_device_motion(event) {
	var a = event.accelerationIncludingGravity;
	var intensity;

	compute_gravity_vector(a.x, a.y, a.z);

	if (gravity[1] > -1 && gravity[1] < 1) {
		if (gravity[0] > 4.8 && gravity[0] < 6.8) {
			/* common neutral zone, no movement */
			left_wheel_setpoint = 0;
			right_wheel_setpoint = 0;
			console.log("common neutral zone");
		} else if (gravity[0] > 6.8) {
			/* neutral zone for y, speed proportional to distance to center */
			intensity = (gravity[0] - 6.8) / (9.8 - 6.8);
			left_wheel_setpoint = intensity * 90 + 90;
			right_wheel_setpoint = 180 - left_wheel_setpoint;
			console.log("y neutral zone");
		}
	}

	gravity_element.innerHTML =
		"x = " + Number.parseFloat(gravity[0]).toFixed(2) +
		", y = " + Number.parseFloat(gravity[1]).toFixed(2) +
		", z = " + Number.parseFloat(gravity[2]).toFixed(2);

	send_message();
};

if (!window.DeviceOrientationEvent)
	gravity_element.innerHTML = "DeviceOrientation isn't supported";

function accelerometer_on_click(e) {
	if (window.fullScreen)
		document.exitFullscreen();
	else
		document.documentElement.requestFullscreen();
	window.screen.mozLockOrientation("landscape");
}

var accelerometer = document.getElementById("fullscreen");
accelerometer.ontouchstart = accelerometer_on_click;

