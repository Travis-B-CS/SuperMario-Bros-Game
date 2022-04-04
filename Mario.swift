import Igis
import Scenes
import Foundation

class Mario : RenderableEntity {

    let mainStance : Image
    let leftStance : Image
    let jumpRightStance : Image
    let jumpLeftStance : Image
    var marioSize = Size(width:0, height:0)
    var topLeft = Point(x:0,y:0)
    var cSize : Size = Size(width:0,height:0)
    var velocityX = 0.0
    var velocityY = 0.0
    var questionTiles : [QuestionBlockTile] = []
    var coinTiles : [Coin] = []
    var levelHandler : LevelHandler?
    
    init(tiles:[QuestionBlockTile]) {
        func getImage(url:String) -> Image { // A function for getting Images
            guard let url = URL(string:url) else {
                fatalError("Failed to create URL for "+url)
            }
            return Image(sourceURL:url)
        }

        questionTiles = tiles

        mainStance = getImage(url: "https://www.codermerlin.com/users/brett-kaplan/mario/mario.png")
        leftStance = getImage(url: "https://www.codermerlin.com/users/brett-kaplan/mario/leftmario.png")
        jumpRightStance = getImage(url: "https://www.codermerlin.com/users/brett-kaplan/mario/marioJump.png")
        jumpLeftStance = getImage(url: "https://www.codermerlin.com/users/brett-kaplan/mario/leftMarioJump.png")

        super.init(name: "Mario")
    }

    override func calculate(canvasSize: Size) {        
        topLeft.x += Int(velocityX)
        topLeft.y += Int(velocityY)

        if(topLeft.y + marioSize.height >= canvasSize.height - 96 - 30) {
            topLeft.y = canvasSize.height - 96 - marioSize.height - 30
        } else {
            velocityY += 1.0
        }

        if(topLeft.x < 5) {
            topLeft.x = 5
            if(velocityX < 0) {
                velocityX = 0
            }
        }

        for box in questionTiles {
            // topLeft references Mario
            //box.rect.topLeft references the box
            //if we assume hiting from the bottom, the y-cords gotta be equal
            if (topLeft.y <= box.rect.topLeft.y + box.rect.size.height) {
                // ok now for the x-cords...
                
                //the only times when the x-coord doesn't work is if mario's top right is left of the box's top left
                // or when mario's top left is right of the box's top right
                if(!(topLeft.x + marioSize.width < box.rect.topLeft.x || topLeft.x > box.rect.topLeft.x + box.rect.size.width )) {
                    // Need to test if topLeft.y - velocityY is still less than (didnt hit from bottom)
                    if(topLeft.y - Int(velocityY) < box.rect.topLeft.y + box.rect.size.height) {
                        // need to see which side it came from so can stop velocityX and reset its position
                        if(topLeft.x > box.rect.topLeft.x + box.rect.size.width / 2) {
                            topLeft.x = box.rect.topLeft.x + box.rect.size.width
                        } else {
                            topLeft.x = box.rect.topLeft.x - marioSize.width
                        }
                        velocityX = 0
                        continue;
                    }
                    
                    // print("TOUCHED BLOCK")
                    box.setActivated(value: true)
                    velocityY = 7.5
                    topLeft.y = box.rect.topLeft.y + box.rect.size.height
                }
            }
        }
        
        for box in coinTiles {
            if box.isActive {
                if (topLeft.y <= box.rect.topLeft.y + box.rect.size.height) {
                    if(!(topLeft.x + marioSize.width < box.rect.topLeft.x || topLeft.x > box.rect.topLeft.x + box.rect.size.width )) {
                        box.setActive(value: false)
                        if let levelHandler = levelHandler {
                            levelHandler.setScore(value: levelHandler.score + 1)
                        }
                    }
                }
            }
        }
    }

    override func setup(canvasSize:Size, canvas:Canvas) {
        canvas.setup(mainStance, leftStance, jumpRightStance, jumpLeftStance)
        cSize = canvasSize
    }

    var currentStance = "main"
    
    override func render(canvas:Canvas) {
        if(velocityY < 0) {
            if(velocityX > 0 || (velocityX == 0 && currentStance == "main")) {
                currentStance = "main"
                marioSize = Size(width:107, height:140)
                if jumpRightStance.isReady {
                    jumpRightStance.renderMode = .destinationRect(Rect(topLeft:topLeft, size:marioSize))
                    canvas.render(jumpRightStance)
                }
            } else if(velocityX < 0 || (velocityX == 0 && currentStance == "leftmain")) {
                currentStance = "leftmain"
                marioSize = Size(width:107, height:140)
                if jumpLeftStance.isReady {
                    jumpLeftStance.renderMode = .destinationRect(Rect(topLeft:topLeft, size:marioSize))
                    canvas.render(jumpLeftStance)
                }
            }
        }
        else {
            if(velocityX > 0 || (velocityX == 0 && currentStance == "main")) {
                currentStance = "main"
                marioSize = Size(width:107, height:140)
                if mainStance.isReady {
                    mainStance.renderMode = .destinationRect(Rect(topLeft:topLeft, size:marioSize))
                    canvas.render(mainStance)
                }
            } else if(velocityX < 0 || (velocityX == 0 && currentStance == "leftmain")) {
                currentStance = "leftmain"
                marioSize = Size(width:107, height:140)
                if leftStance.isReady {
                    leftStance.renderMode = .destinationRect(Rect(topLeft:topLeft, size:marioSize))
                    canvas.render(leftStance)
                }
            }
        }
    }
    
    func move(to point:Point) {
        topLeft = point
    }

    func jump() {
        if(topLeft.y + marioSize.height >= cSize.height - 96 - 30) {
            velocityY = -15.0
        }
    }

    func setVelocityX(new:Double) {
        velocityX = new
    }

    func setVelocityY(new:Double) {
        velocityY = new
    }

    func setBoxes(tiles:[QuestionBlockTile]) {
        questionTiles = tiles
    }

    func setCoins(tiles:[Coin]) {
        coinTiles = tiles
    }

    func setLevelHandler(handler:LevelHandler) {
        levelHandler = handler
    }
    
}
