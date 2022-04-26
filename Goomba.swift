import Igis
import Scenes
import Foundation

class Goomba : RenderableEntity {

    let goombaLeft : Image
    let goombaRight : Image
    let goombaSquished : Image
    
    var topLeft : Point = Point(x:0,y:0)
    var isDead = false
    var isSquished = false
    var squishedTime = 0
    var animationFrame = 0;

    var velocityX = 0

    init() {
        func getImage(url:String) -> Image { // A function for getting Images
            guard let url = URL(string:url) else {
                fatalError("Failed to create URL for "+url)
            }
            return Image(sourceURL:url)
        }

        goombaLeft = getImage(url: "https://www.codermerlin.com/users/brett-kaplan/mario/goombaLeft.png")
        goombaRight = getImage(url: "https://www.codermerlin.com/users/brett-kaplan/mario/goombaRight.png")
        goombaSquished = getImage(url: "https://www.codermerlin.com/users/brett-kaplan/mario/goombaSquished.png")

        super.init(name: "Goomba")
    }

    override func setup(canvasSize:Size, canvas:Canvas) {
        canvas.setup(goombaLeft, goombaRight, goombaSquished)
    }

    override func calculate(canvasSize: Size) {
        topLeft.x += velocityX

        if(topLeft.x + 96 > canvasSize.width - 30) {
            topLeft.x = canvasSize.width - 30 - 96
            velocityX = -velocityX
        }

        if(topLeft.x < 20) {
            topLeft.x = 20
            velocityX = -velocityX
        }

        if(topLeft.y == canvasSize.height - 96 - 96 - 30) {
            topLeft.y = canvasSize.height - 96 - 96 - 25
        }
        
        if(isDead == true) {
            return
        }

        if(isSquished == true) {
            squishedTime += 1

            if(topLeft.y == canvasSize.height - 96 - 96 - 25) {
                topLeft.y = canvasSize.height - 96 - 96 - 15
            }
                    

            if(squishedTime > 20) {
                isDead = true
            }
            return;
        }

        animationFrame += 1

        if(animationFrame >= 20) {
            animationFrame = 0
        }
    }

    override func render(canvas: Canvas) {
        if(isDead == true) {return}

        if(isSquished == true) {
            if(goombaSquished.isReady) {
                goombaSquished.renderMode = .destinationRect(Rect(topLeft:topLeft, size:Size(width: 92, height: 92)))
                canvas.render(goombaSquished)
            }
            setVelocityX(value: 0)
            return;
        }

        // switches the feet if walking
        if(animationFrame / 10 == 0) {
            if(goombaLeft.isReady) {
                goombaLeft.renderMode = .destinationRect(Rect(topLeft:topLeft, size:Size(width: 92, height: 92)))
                canvas.render(goombaLeft)
            }
        } else {
            if(goombaRight.isReady) {
                goombaRight.renderMode = .destinationRect(Rect(topLeft:topLeft, size:Size(width: 92, height: 92)))
                canvas.render(goombaRight)
            }
        }

    }

    func setTopLeft(value: Point) {
        topLeft = value
    }

    func setSquished(value : Bool) {
        isSquished = value
    }

    func setVelocityX(value: Int) {
        velocityX = value
    }
    
}
