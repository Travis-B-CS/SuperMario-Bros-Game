import Igis
import Scenes
import Foundation

class Mario : RenderableEntity {

    let mainStance : Image
    let leftStance : Image
    let jumpRightStance : Image
    let jumpLeftStance : Image
    let walkRight1 : Image
    let walkRight2 : Image
    let walkRight3 : Image
    let walkLeft1 : Image
    let walkLeft2 : Image
    let walkLeft3 : Image
    var walkingAnimationFrame = 0
    
    var marioSize = Size(width:0, height:0)
    var topLeft = Point(x:0,y:0)
    var cSize : Size = Size(width:0,height:0)
    
    var velocityX = 0.0
    var velocityY = 0.0
    
    var questionTiles : [QuestionBlockTile] = []
    var coinTiles : [Coin] = []
    var goombas : [Goomba] = []
    
    var levelHandler : LevelHandler?
    
    init(tiles:[QuestionBlockTile]) {
        func getImage(url:String) -> Image { // A function for getting Images
            guard let url = URL(string:url) else {
                fatalError("Failed to create URL for "+url)
            }
            return Image(sourceURL:url)
        }

        questionTiles = tiles

        mainStance = getImage(url: "https://www.codermerlin.com/users/brett-kaplan/mario/mainStance.png")
        leftStance = getImage(url: "https://www.codermerlin.com/users/brett-kaplan/mario/leftMainStance.png")
        jumpRightStance = getImage(url: "https://www.codermerlin.com/users/brett-kaplan/mario/jumpStance.png")
        jumpLeftStance = getImage(url: "https://www.codermerlin.com/users/brett-kaplan/mario/leftJumpStance.png")
        walkRight1 = getImage(url: "https://www.codermerlin.com/users/brett-kaplan/mario/walkRight1.png")
        walkRight2 = getImage(url: "https://www.codermerlin.com/users/brett-kaplan/mario/walkRight2.png")
        walkRight3 = getImage(url: "https://www.codermerlin.com/users/brett-kaplan/mario/walkRight3.png")
        walkLeft1 = getImage(url: "https://www.codermerlin.com/users/brett-kaplan/mario/walkLeft1.png")
        walkLeft2 = getImage(url: "https://www.codermerlin.com/users/brett-kaplan/mario/walkLeft2.png")
        walkLeft3 = getImage(url: "https://www.codermerlin.com/users/brett-kaplan/mario/walkLeft3.png")

        super.init(name: "Mario")
    }

    override func calculate(canvasSize: Size) {        
        topLeft.x += Int(velocityX)
        topLeft.y += Int(velocityY)

        if(topLeft.y + marioSize.height >= canvasSize.height - 96 - 20) {
            topLeft.y = canvasSize.height - 96 - marioSize.height - 20
        } else {
            velocityY += 1.0
        }

        if(topLeft.x < 5) {
            topLeft.x = 5
            if(velocityX < 0) {
                velocityX = 0
            }
        }

        if(velocityX != 0) {
            walkingAnimationFrame += 1
            if(walkingAnimationFrame >= 21) {
                walkingAnimationFrame = 0
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
        canvas.setup(mainStance, leftStance, jumpRightStance, jumpLeftStance, walkRight1, walkLeft1, walkRight2, walkLeft2, walkRight3, walkLeft3)
        cSize = canvasSize
    }

    var currentStance = "right"
    
    override func render(canvas:Canvas) {
        marioSize = Size(width:107, height:140)
        
        if(velocityY < 0) {
            if(velocityX > 0 || (velocityX == 0 && currentStance == "right")) {
                currentStance = "right"
                marioSize = Size(width:107, height:140)
                if jumpRightStance.isReady {
                    jumpRightStance.renderMode = .destinationRect(Rect(topLeft:topLeft, size:marioSize))
                    canvas.render(jumpRightStance)
                }
            } else if(velocityX < 0 || (velocityX == 0 && currentStance == "left")) {
                currentStance = "left"
                marioSize = Size(width:107, height:140)
                if jumpLeftStance.isReady {
                    jumpLeftStance.renderMode = .destinationRect(Rect(topLeft:topLeft, size:marioSize))
                    canvas.render(jumpLeftStance)
                }
            }
        }
        else {
            if(velocityX == 0) {
                if(currentStance == "right") {
                    if mainStance.isReady {
                        mainStance.renderMode = .destinationRect(Rect(topLeft:topLeft, size:marioSize))
                        canvas.render(mainStance)
                    }
                } else if(currentStance == "left") {
                    if leftStance.isReady {
                        leftStance.renderMode = .destinationRect(Rect(topLeft:topLeft, size:marioSize))
                        canvas.render(leftStance)
                    }
                }
            }
            if(velocityX > 0) {
                currentStance = "right"
                switch(walkingAnimationFrame / 7) {
                case 0:
                    if walkRight1.isReady {
                        walkRight1.renderMode =  .destinationRect(Rect(topLeft:topLeft, size:marioSize))
                        canvas.render(walkRight1)
                    }
                case 1:
                    if walkRight2.isReady {
                        walkRight2.renderMode = .destinationRect(Rect(topLeft:topLeft, size:marioSize))
                        canvas.render(walkRight2)
                    }
                case 2:
                    if walkRight3.isReady {
                        walkRight3.renderMode = .destinationRect(Rect(topLeft:topLeft, size:marioSize))
                        canvas.render(walkRight3)
                    }
                default:
                    if mainStance.isReady {
                        mainStance.renderMode = .destinationRect(Rect(topLeft:topLeft, size:marioSize))
                        canvas.render(mainStance)
                    }
                }
            } else if(velocityX < 0) {
                currentStance = "left"
                switch(walkingAnimationFrame / 7) {
                case 0:
                    if walkLeft1.isReady {
                        walkLeft1.renderMode = .destinationRect(Rect(topLeft:topLeft, size:marioSize))
                        canvas.render(walkLeft1)
                    }
                case 1:
                    if walkLeft2.isReady {
                        walkLeft2.renderMode = .destinationRect(Rect(topLeft:topLeft, size:marioSize))
                        canvas.render(walkLeft2)
                    }
                case 2:
                    if walkLeft3.isReady {
                        walkLeft3.renderMode = .destinationRect(Rect(topLeft:topLeft, size:marioSize))
                        canvas.render(walkLeft3)
                    }
                default:
                    if leftStance.isReady {
                        leftStance.renderMode = .destinationRect(Rect(topLeft:topLeft, size:marioSize))
                        canvas.render(leftStance)
                    }
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

    func setGoombas(tiles:[Goomba]) {
        goombas = tiles
    }

    func setLevelHandler(handler:LevelHandler) {
        levelHandler = handler
    }
    
}
