console.log("JS is loaded")
var ball = document.getElementById('ball')

var offsets = ball.getBoundingClientRect();
var ballX = offsets.x
var ballY = offsets.y
const BallWidth = offsets.width 
const BallHeight = offsets.height 
var ballVx = 0
var ballVy = 0


function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

var mouseX = 0
var mouseY = 0


document.addEventListener('mousemove', function(event) {
    mouseX = event.pageX;
    mouseY = event.pageY;
    // console.log('Mouse X:', mouseX, 'Mouse Y:', mouseY);
  });

function distance(x1, y1, x2, y2) {
    return Math.sqrt((x1-x2)**2 + (y1-y2)**2)
}

function direction(x1, y1, x2, y2) {
    var d = distance(x1, y1, x2, y2)
    return [(x1-x2)/d, (y1-y2)/d]
}

function updateBall(forceX, forceY, dt){

    var height = window.innerHeight
    var width = window.innerWidth
    ballX += ballVx*dt
    ballY += ballVy*dt

    ballVx += forceX*dt
    ballVy += forceY*dt

    if (ballX < BallWidth/2) { 
        ballX = BallWidth/2
        ballVx = -ballVx
    }

    if (ballX > width - BallWidth/2) {
        ballX = width - BallWidth/2
        ballVx = -ballVx
    }

    if (ballY < BallWidth/2){ 
        ballVy = -ballVy
        ballY = BallWidth/2
    }

    if (ballY > height - BallWidth/2) {
        ballY = height - BallWidth/2
        ballVy = -ballVy
    }

    ballVx *= 0.95
    ballVy *= 0.95

    ball.style.left = ballX - BallWidth/2
    ball.style.top = ballY - BallHeight/2
}

function gameLoop(t) {
    var mag = distance(ballX, ballY, mouseX, mouseY)
    if (mag < 5){
        mag = 5
    }
    // console.log(mag)
    var r =  direction(ballX, ballY, mouseX, mouseY)
    var x = r[0]
    var y = r[1]
    // console.log(x)

    forceX = x / mag**2
    forceY = y / mag**2
    updateBall(forceX, forceY, 100)
    // console.log(forceX)
}

function startBall(){
    ball.classList = ""
    ballX = offsets.x + BallWidth/2
    ballY = offsets.y + BallWidth/2
    setInterval(gameLoop, 1000 / 30);
}

ball.onclick = startBall