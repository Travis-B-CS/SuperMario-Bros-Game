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
    var animationTime = 0;

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
        canvas.setup(goombaImage)
    }

    override func calculate(canvasSize: Size) {
        if(isDead == true) {
            return
        }

        if(isSquished == true) {
            squishedTime += 1

            if(squishedTime > 10) {
                isDead = true
            }
            return;
        }

        animationFrame += 1

        if(animationFrame >= 10) {
            animationFrame = 0
        }
    }

    override func render(canvas: Canvas) {
        if(isDead == true) {return}

        if(isSquished == true) {
            if(goombaSquished.isReady) {
                goombaSquished.renderMode = .desinationRect(Rect(topLeft:topLeft, size:Size(width: 92, height: 92)))
                canvas.render(goombaSquished)
            }
            return;
        }
        
        if(animationFrame / 5 == 0) {
            if(goombaLeft.isReady) {
                goombaLeft.renderMode = .desinationRect(Rect(topLeft:topLeft, size:Size(width: 92, height: 92)))
                canvas.render(goombaLeft)
            }
        } else {
            if(goombaRight.isReady) {
                goombaRight.renderMode = .desinationRect(Rect(topLeft:topLeft, size:Size(width: 92, height: 92)))
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
    
}
