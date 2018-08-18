if (!hasGetUserMedia()) {
    showWarning("Your Browser is NOT Compatible With Chat");
}

navigator.getUserMedia = navigator.getUserMedia ||
                          navigator.webkitGetUserMedia ||
                          navigator.mozGetUserMedia ||
                          navigator.msGetUserMedia;
var drone;

var configuration = {
    iceServers: [{
        urls: 'stun:stun.l.google.com:19302'
    }]
};

function establishChatRoom(chatName) {
    if (typeof (drone) !== "undefined") { return; }
    drone = new ScaleDrone('BwJjuCknWXodh2YU', {
        data: {
            username: User.Username
        }
    });
    if (typeof (chatName) === "undefined") {
        drone.roomname = "observable-" + Math.floor(Math.random() * 0xFFFFFF).toString(16);
    } else {
        drone.roomname = chatName;
    }

    drone.on('open', error => {
        if (error) {
            return onError(error);
        }
        drone.room = drone.subscribe(drone.roomname);
        drone.room.on('open', error => {
            if (error) {
                onError(error);
            }
        });

        drone.room.on('members', members => {
            if (members.length > 2) {
                return showWarning('The room is full');
            }
            drone.room.members = members;
            var isOfferer = members.length === 2;
            startWebRTC(isOfferer);
            startListentingToSignals();
        });

        drone.room.on('member_join', member => {
            var data = {
                username: member.clientData.username,
                chatRoomName: drone.room.name
            }
            callBack("corner.aspx/UserJoined", data, null, false);
        });

        drone.room.on('member_leave', member => {
            var data = {
                username: member.clientData.username,
                chatRoomName: drone.room.name
            }
            callBack("corner.aspx/UserLeft", data, function (msg) {
                if (msg.d == false) {
                    $(".chat-room-row[data-room_id=" + drone.room.name + "]").remove();
                    if (typeof (localVideo.srcObject) !== 'undefined') {
                        localVideo.srcObject = null;
                        remoteVideo.srcObject = null;
                    }
                    else {
                        localVideo.src = "";
                        remoteVideo.src = "";
                    }
                    drone.room.unsubscribe();
                    drone.close();
                    drone.localStream.stop();
                } else if (msg.d == true) {
                    if (typeof (remoteVideo.srcObject) !== 'undefined') {
                        remoteVideo.srcObject = null;
                    }
                    else { remoteVideo.src = ""; }
                } else if (msg.d == null) {
                    submitError("Failed to Find Chat Member on Leave (Tech Support Notified)", JSON.stringify({ msg: msg, data: data, drone: drone }));
                }
            }, false);
        });
    });

    return drone.roomname;
}

function sendMessage(message) {
    drone.publish({
        room: drone.room.name,
        message
    });
}

var pc;
function startWebRTC(isOfferer) {
    pc = new RTCPeerConnection(configuration);

    pc.onicecandidate = event => {
        if (event.candidate) {
            sendMessage({ 'candidate': event.candidate });
        }
    };

    if (isOfferer) {
        pc.onnegotiationneeded = () => {
            pc.createOffer().then(localDescCreated).catch(onError);
        }
    }

    pc.onaddstream = event => {
        if (typeof (remoteVideo.srcObject) !== 'undefined') {
            remoteVideo.srcObject = event.stream;
        }
        else {
            remoteVideo.src = URL.createObjectURL(event.stream);
        }
        
    };

    navigator.getUserMedia({
        audio: true,
        video: true,
    }, stream => {
        if (typeof (localVideo.srcObject) !== 'undefined') {
            localVideo.srcObject = stream;
        }
        else {
            localVideo.src = URL.createObjectURL(stream);
        }
        pc.addStream(stream);
        drone.localStream = stream;
    }, onError);
}

function startListentingToSignals() {
    drone.room.on('data', (message, client) => {
        if (!client || client.id === drone.clientId) {
            return;
        }
        if (message.sdp) {
            pc.setRemoteDescription(new RTCSessionDescription(message.sdp), () => {
                if (pc.remoteDescription.type === 'offer') {
                    pc.createAnswer().then(localDescCreated).catch(onError);
                }
            }, onError);
        } else if (message.candidate) {
            pc.addIceCandidate(
              new RTCIceCandidate(message.candidate), onSuccess, onError
            );
        }
    });
}

function localDescCreated(desc) {
    pc.setLocalDescription(
      desc,
      () => sendMessage({ 'sdp': pc.localDescription }),
      onError
    );
}

function hasGetUserMedia() {
    return !!(navigator.getUserMedia || navigator.webkitGetUserMedia ||
              navigator.mozGetUserMedia || navigator.msGetUserMedia);
}

function onSuccess() { };
function onError(error) {
    console.error(error);
};