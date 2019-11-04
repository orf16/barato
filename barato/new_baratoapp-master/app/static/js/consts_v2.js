//var direccionserver = 'https://servicio.baratoapp.co/barato/';
var direccionserver = 'http://localhost:8083/barato-1.0/';
var pass = 'gTddSgsRD!Csta5gKXZ$Dfh7jNvg?pMeS75%45A9GCje&^X^?3&$?5Z*Fj#YC47fGaNNX4Mp=syV9UqC-CcAM^^$_7rDsFT89^e+';
var user = 'baratoUser';
var UserEmail = document.getElementById('userEmailToken').value;
var key = 'Prlx+q?Wov8K1%o+bnn%p=Pog+d9GpLK?2pc2znx_xk1=dddmT4X+VZh1zk9yY*BxDI#=D1X?!?RNyuc!L#s^#go47Mj!FCFy%&otu44cMYlQP';
var token = $.base64.encode(user + '@@@' + UserEmail + '@@@' + pass + '@@@' + key);
var config = {
    headers: {
        'Content-Type': 'application/json', 'UserEmail': UserEmail,
        'Token': token
    },
    auth: {
        username: user,
        password: pass
    }
};



function setCookie(cname, cvalue, exdays) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
    var expires = "expires="+d.toUTCString();
    document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
}

function getCookie(cname) {
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for(var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') {
            c = c.substring(1);
        }
        if (c.indexOf(name) == 0) {
            return c.substring(name.length, c.length);
        }
    }
    return "";
}
