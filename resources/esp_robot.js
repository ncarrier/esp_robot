var ws = new WebSocket("ws://esp_robot.local:81");

ws.onopen = function(e) {
	ws.send("My name is John");
};
ws.onerror = function(error) {
	alert(`[error] ${error.message}`);
};
console.log(ws.readyState);
