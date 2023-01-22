extends Node2D

export var SOCKET_URL = ""

var _client = WebSocketClient.new()

func _ready():
	_client.connect("connection_closed", self, "_on_connection_closed")
	_client.connect("connection_error", self, "_on_connection_closed")
	_client.connect("connection_established", self, "_on_connected")
	_client.connect("data_received", self, "_on_data")
	
	var err = _client.connect_to_url(SOCKET_URL)
	if err != OK:
		print("Unable to connect")
		set_process(false)
		
func _process(delta):
	_client.poll()
	
func _on_connection_closed(was_clean = false):
	print("Closed, clean = ", was_clean)
	set_process(false)
	
func _on_connected(protocol = ""):
	print("Connected with protocol: ", protocol)
	
func _on_data():
	var payload = JSON.parse(_client.get.peer(1).get_packet().get_string_from_utf8()).result
	print("Received data: ", payload)
	
func _send():
	_client.get_peer(1).put_packet(JSON.print({"name": "Het"}).to_utf8())
