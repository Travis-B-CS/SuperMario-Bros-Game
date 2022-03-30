import Igis
import Scenes
import Foundation

class QuestionBlockTile : RenderableEntity {

    let questionTile : Image
    let blankTile : Image
    var activated = false
    var activatedTimer = 0
    var topLeft = Point(x:0,y:0)
    var rect = Rect(topLeft:Point(x:0,y:0), size:Size(width:96, height:96))
    var inside = "";
    
    init(whatInside:String) {
        func getImage(url:String) -> Image { // A function for getting Images
            guard let url = URL(string:url) else {
                fatalError("Failed to create URL for "+url)
            }
            return Image(sourceURL:url)
        }

        inside = whatInside

        questionTile = getImage(url: "https://www.codermerlin.com/users/brett-kaplan/mario/questionBlockTile.png")
        blankTile = getImage(url: "https://www.codermerlin.com/users/brett-kaplan/mario/blankTile.png")
    }

    override func setup(canvasSize: Size, canvas: Canvas) {
        canvas.setup(questionTile, blankTile)
    }
    
    override func calculate(canvasSize: Size) {
        if(activated == true && activatedTimer < 20) {
            if(inside == "coin") {
                
            }
            
            if(activatedTimer < 10) {
                topLeft.y -= (96 / 10)
            } else {
                topLeft.y += (96 / 10)
            }
            activatedTimer += 1
        }
    }

    override func render(canvas:Canvas) {
        if activatedTimer < 10 {
            if questionTile.isReady {
                rect = Rect(topLeft:topLeft, size:Size(width:96, height:96))
                questionTile.renderMode = .destinationRect(rect)
                canvas.render(questionTile)
            }
        } else {
            if blankTile.isReady {
                rect = Rect(topLeft:topLeft, size:Size(width:96, height:96))
                blankTile.renderMode = .destinationRect(rect)
                canvas.render(blankTile)
            }
        }
    }

    func setInside(value: String) {
        inside = value
    }

    func setActivated(value : Bool) {
        activated = value
    }

    func setTopLeft(point : Point) {
        topLeft = point
    }
    
}
