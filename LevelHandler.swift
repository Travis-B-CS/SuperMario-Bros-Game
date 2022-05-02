import Igis
import Scenes
import Foundation

class LevelHandler : RenderableEntity {
    let marioSprite : Mario
    var currentLevel = 1
    var interactionLayer : InteractionLayer?
    var score = 0
    var lives = 3
    var frozenTimer = 0
    var activeEntities : [RenderableEntity] = [];
    
    let stageClearSound : Audio
    var shouldRenderStageClear = false
    
    let mushroomImage : Image
    let castleImage : Image

    var cheats = false
    
    init(mario:Mario) {
        func getAudio(url:String, loop:Bool) -> Audio { // function for getting audio
            guard let url = URL(string:url) else {
                fatalError("Failed to create URL for "+url)
            }
            return Audio(sourceURL: url, shouldLoop:loop)
        }
        
        func getImage(url:String) -> Image { // A function for getting Images
            guard let url = URL(string:url) else {
                fatalError("Failed to create URL for "+url)
            }
            return Image(sourceURL:url)
        }
        
        stageClearSound = getAudio(url: "https://www.codermerlin.com/users/brett-kaplan/mario/sounds/smb_stage_clear.wav", loop:false)
        
        castleImage = getImage(url: "https://www.codermerlin.com/users/brett-kaplan/mario/castle.png")
        mushroomImage = getImage(url: "https://www.codermerlin.com/users/brett-kaplan/mario/mushroom.png")
        
        marioSprite = mario
        
        super.init(name: "LevelHandler")

        // adds this instance of the level handler class to the mario class instance in order to be able to use functions from this class.
        marioSprite.setLevelHandler(handler: self)
    }

    // gets a string with 4 digits with zeros as the leading numbers.
    func getFourZeroes(x:Int) -> String {
        var y = String(x)
        for _ in 0 ..< 4 - String(x).count {
            y = "0"+y
        }
        return y
    }
    
    override func setup(canvasSize:Size, canvas:Canvas) {
        canvas.setup(stageClearSound, mushroomImage, castleImage)
    }
    
    override func calculate(canvasSize: Size) {
        // if screen is frozen
        if(frozenTimer > 0) {
            frozenTimer -= 1
            if(frozenTimer == 0) {
                // sets the keys back to what they were before freezing
                if let interactionLayer = interactionLayer {
                    interactionLayer.unclearKeysDown()
                }
            }
        }
        // change levels if mario is on the right side of the boundaries.
        if(marioSprite.topLeft.x + marioSprite.marioSize.width > marioSprite.cSize.width + 10) {
            shouldRenderStageClear = true
            clearLevel()
            
            currentLevel += 1
            score += 3
            setFrozenTimer(value: 30)
            
            switch(currentLevel) {
            case 1:
                levelOne(canvasSize: canvasSize)
            case 2:
                levelTwo(canvasSize: canvasSize)
            case 3:
                levelThree(canvasSize: canvasSize)
            case 4:
                levelFour(canvasSize: canvasSize)
            case 5:
                levelFive(canvasSize: canvasSize)
            case 6:
                levelSix(canvasSize: canvasSize)
            case 7:
                levelSeven(canvasSize: canvasSize)
            case 8:
                levelEight(canvasSize: canvasSize)
            case 9:
                levelNine(canvasSize: canvasSize)                
            case 10:
                levelTen(canvasSize: canvasSize)
            default:
                setLives(value: 0, bypass: true)
                marioSprite.setVelocityX(new: 0)
                marioSprite.setVelocityY(new: 0)
            }
        }
    }
    
    override func render(canvas: Canvas) {
        // render the score text
        var text = Text(location:Point(x:50, y:90), text:getFourZeroes(x:score))
        text.font = "30pt Arial"
        text.alignment = .left
        canvas.render(text)

        if let canvasSize = canvas.canvasSize {
            var text = Text(location:Point(x: canvasSize.width / 2, y:125), text:"LEVEL: \(currentLevel)")
            text.font = "30pt Arial"
            text.alignment = .center
            canvas.render(text)
        }

        
        if(lives <= 0) {
            if let canvasSize = canvas.canvasSize {
                // Render Text if game over:
                let gameOverText = Text(location:canvasSize.center, text:"GAME OVER!")
                gameOverText.font = "60pt Arial"
                gameOverText.alignment = .center
                canvas.render(gameOverText)
            }
        }

        if currentLevel == 10, let canvasSize = canvas.canvasSize {
            if castleImage.isReady {
                castleImage.renderMode = .destinationRect(Rect(topLeft: Point(x: canvasSize.width - 320 - 30, y: canvasSize.height - 92 - 376 - 30), size: Size(width: 320, height: 376)))
                canvas.render(castleImage)
            }

            if marioSprite.marioSize.width <= 10 {
                setLives(value: 0, bypass: true)
                return
            }

            if marioSprite.topLeft.x >= canvasSize.width - 160 - 85 {
                // entered the castle door
                marioSprite.stopWorking() // makes velocity do nothing, so player can't control it.
                
                marioSprite.setMarioSize(size: Size(width: marioSprite.marioSize.width - 2, height: marioSprite.marioSize.height - 3))
                marioSprite.topLeft.x += 1
                marioSprite.topLeft.y += 1
            }
        }

        // render sound if needed
        if shouldRenderStageClear && stageClearSound.isReady {
            canvas.render(stageClearSound)
            shouldRenderStageClear = false
        }
        
        if let canvasSize = canvas.canvasSize {
            // render the lives mushroom images
            if mushroomImage.isReady {
                if lives == 3 {
                    let shroomDestinationRectLeft = Rect(topLeft:Point(x: (canvasSize.width / 2 - 30 - 15 - 60), y: 15), size:Size(width:60, height:60))
                    mushroomImage.renderMode = .destinationRect(shroomDestinationRectLeft)
                    canvas.render(mushroomImage)
                    
                    let shroomDestinationRectCentered = Rect(topLeft:Point(x: (canvasSize.width / 2 - 30), y: 15), size:Size(width: 60, height:60))
                    mushroomImage.renderMode = .destinationRect(shroomDestinationRectCentered)
                    canvas.render(mushroomImage)
                    
                    let shroomDestinationRectRight = Rect(topLeft:Point(x: (canvasSize.width / 2 + 30 + 15), y: 15), size:Size(width:60, height:60))
                    mushroomImage.renderMode = .destinationRect(shroomDestinationRectRight)
                    canvas.render(mushroomImage)
                } else if lives == 2 {
                    let shroomDestinationRectLeft = Rect(topLeft:Point(x: (canvasSize.width / 2 - 60 - 15), y: 15), size:Size(width:60, height:60))
                    mushroomImage.renderMode = .destinationRect(shroomDestinationRectLeft)
                    canvas.render(mushroomImage)
                    
                    let shroomDestinationRectRight = Rect(topLeft:Point(x: (canvasSize.width / 2 + 15), y: 15), size:Size(width:60, height:60))
                    mushroomImage.renderMode = .destinationRect(shroomDestinationRectRight)
                    canvas.render(mushroomImage)
                    
                } else if lives == 1 {
                    let shroomDestinationRectCentered = Rect(topLeft:Point(x: (canvasSize.width / 2 - 30), y: 15), size:Size(width: 60, height:60))
                    mushroomImage.renderMode = .destinationRect(shroomDestinationRectCentered)
                    canvas.render(mushroomImage)
                }
            }
        }
    }

    // be able to use interaction layer functions from this instance of this class
    func setHandler(handler:InteractionLayer) {
        interactionLayer = handler;
    }

    func setScore(value: Int) {
        score = value
    }

    func setLives(value: Int, bypass: Bool = false) {
        if (lives > value && bypass == false) {
            score -= 5
            if score < 0 {
                score = 0
            }
        }
        if cheats == false || bypass == true {
            lives = value
        }
        if(lives <= 0 ) {
            clearLevel()
            if let interactionLayer = interactionLayer {
                interactionLayer.clearKeysDown()
                marioSprite.setVelocityX(new: 0)
                marioSprite.setVelocityY(new: 0)
            }
        }
    }

    func setCheats(value: Bool) {
        self.cheats = value
    }

    // set the frozen timer & stops mario from being able to move.
    func setFrozenTimer(value: Int) {
        frozenTimer = value
        if value > 0 {
            if let interactionLayer = interactionLayer {
                interactionLayer.clearKeysDown()
                marioSprite.setVelocityX(new: 0)
                marioSprite.setVelocityY(new: 0)
            }
        }
    }

    // clear the level of objects
    func clearLevel() {
        for entity in activeEntities {
            if let interactionLayer = interactionLayer {
                interactionLayer.removeEntity(entity:entity)
            }
        }
        marioSprite.setGoombas(tiles: [])
        marioSprite.setBoxes(tiles: [])
        marioSprite.setCoins(tiles: [])
        activeEntities = []
        
        marioSprite.topLeft = Point(x:10, y:marioSprite.topLeft.y)
    }

    // sets up level one
    func levelOne(canvasSize:Size) {
        if let interactionLayer = interactionLayer {
            let questionTile = QuestionBlockTile(whatInside:"coin")
            questionTile.setTopLeft(point: Point(x: canvasSize.width / 2, y: canvasSize.height - 200 - 96 - 100))
            let coin = Coin()
            coin.setRect(newRect: questionTile.rect)
                
            questionTile.setInsideCoin(value: coin)
            questionTile.setLevelHandler(handler: self)
            
            let groundCoin = Coin()
            groundCoin.setRect(newRect: Rect(topLeft:Point(x: canvasSize.width / 2 - 200, y: canvasSize.height - 50 - 96 - 100), size:Size(width: 96, height: 96)))
            groundCoin.setActive(value: true)
            
            let groundCoin2 = Coin()
            groundCoin2.setRect(newRect: Rect(topLeft:Point(x: canvasSize.width / 2 - 400, y: canvasSize.height - 50 - 96 - 100), size:Size(width: 96, height: 96)))
            groundCoin2.setActive(value: true)
            
            let groundCoin3 = Coin()
            groundCoin3.setRect(newRect: Rect(topLeft:Point(x: canvasSize.width / 2 - 600, y: canvasSize.height - 50 - 96 - 100), size:Size(width: 96, height: 96)))
            groundCoin3.setActive(value: true)
            
            interactionLayer.renderCoin(coin: groundCoin)
            interactionLayer.renderCoin(coin: groundCoin2)
            interactionLayer.renderCoin(coin: groundCoin3)
            interactionLayer.renderCoin(coin: coin)
            interactionLayer.renderQuestionBlockTile(questionTile: questionTile)
            
            marioSprite.setCoins(tiles: [groundCoin, groundCoin2, groundCoin3])
            marioSprite.setBoxes(tiles: [questionTile])
            
            activeEntities.append(contentsOf:[groundCoin, groundCoin2, groundCoin3, questionTile, coin])
            
        }
    }

    // setups up level two
    func levelTwo(canvasSize: Size) {
        if let interactionLayer = interactionLayer {
            let questionTile = QuestionBlockTile(whatInside:"coin")
            questionTile.setTopLeft(point: Point(x: canvasSize.width / 3, y: canvasSize.height - 200 - 96 - 100))
            let coin = Coin()
            coin.setRect(newRect: questionTile.rect)
            
            questionTile.setInsideCoin(value: coin)
            questionTile.setLevelHandler(handler: self)
            
            let questionTile2 = QuestionBlockTile(whatInside:"coin")
            questionTile2.setTopLeft(point: Point(x: canvasSize.width / 2 + 100, y: canvasSize.height - 200 - 96 - 100))
            let coin2 = Coin()
            coin2.setRect(newRect: questionTile2.rect)
            
            questionTile2.setInsideCoin(value: coin2)
            questionTile2.setLevelHandler(handler: self)
            
            let groundCoin = Coin()
            groundCoin.setRect(newRect: Rect(topLeft:Point(x: canvasSize.width / 2 - 200, y: canvasSize.height - 50 - 96 - 100), size:Size(width: 96, height: 96)))
            groundCoin.setActive(value: true)
            
            let groundCoin2 = Coin()
            groundCoin2.setRect(newRect: Rect(topLeft:Point(x: canvasSize.width / 2, y: canvasSize.height - 50 - 96 - 100), size:Size(width: 96, height: 96)))
            groundCoin2.setActive(value: true)
            
            let groundCoin3 = Coin()
            groundCoin3.setRect(newRect: Rect(topLeft:Point(x: canvasSize.width / 2 + 200, y: canvasSize.height - 50 - 96 - 100), size:Size(width: 96, height: 96)))
            groundCoin3.setActive(value: true)

            let goomba = Goomba()
            goomba.setTopLeft(value: Point(x: canvasSize.width / 2 + 300, y: canvasSize.height - 96 - 96 - 30))
            goomba.setVelocityX(value: 2)

            interactionLayer.renderGoomba(goomba: goomba)
            interactionLayer.renderCoin(coin: groundCoin)
            interactionLayer.renderCoin(coin: groundCoin2)
            interactionLayer.renderCoin(coin: groundCoin3)
            interactionLayer.renderCoin(coin: coin)
            interactionLayer.renderCoin(coin: coin2)
            interactionLayer.renderQuestionBlockTile(questionTile: questionTile)
            interactionLayer.renderQuestionBlockTile(questionTile: questionTile2)
            
            marioSprite.setCoins(tiles: [groundCoin, groundCoin2, groundCoin3])
            marioSprite.setBoxes(tiles: [questionTile, questionTile2])
            marioSprite.setGoombas(tiles: [goomba])

            activeEntities.append(contentsOf:[groundCoin, groundCoin2, groundCoin3, questionTile, coin, questionTile2, coin2, goomba])
        }

    }

    // sets up level three
    func levelThree(canvasSize: Size) {
        if let interactionLayer = interactionLayer {
            let questionTile = QuestionBlockTile(whatInside:"coin")
            questionTile.setTopLeft(point: Point(x: canvasSize.width / 4, y: canvasSize.height - 200 - 96 - 100))
            let coin = Coin()
            coin.setRect(newRect: questionTile.rect)
            questionTile.setInsideCoin(value: coin)
            questionTile.setLevelHandler(handler: self)
            
            let tile1 = QuestionBlockTile(whatInside:"don't animate")
            tile1.setTopLeft(point: Point(x: canvasSize.width / 2 - 96, y: canvasSize.height - 200 - 96 - 100))
            tile1.setActivated(value: true)

            let questionTile2 = QuestionBlockTile(whatInside:"don't animate")
            questionTile2.setTopLeft(point: Point(x: canvasSize.width / 2, y: canvasSize.height - 200 - 96 - 100))
            questionTile2.setLevelHandler(handler: self)
            questionTile2.setActivated(value: true)

            let tile2 = QuestionBlockTile(whatInside:"don't animate")
            tile2.setTopLeft(point: Point(x: canvasSize.width / 2 + 96, y: canvasSize.height - 200 - 96 - 100))
            tile2.setActivated(value: true)
            
            let questionTile3 = QuestionBlockTile(whatInside:"coin")
            questionTile3.setTopLeft(point: Point(x: canvasSize.width / 2 + (canvasSize.width / 4), y: canvasSize.height - 200 - 96 - 100))
            let coin3 = Coin()
            coin3.setRect(newRect: questionTile3.rect)
            
            questionTile3.setInsideCoin(value: coin3)
            questionTile3.setLevelHandler(handler: self)
            
            let groundCoin = Coin()
            groundCoin.setRect(newRect: Rect(topLeft:Point(x: canvasSize.width / 8, y: canvasSize.height - 50 - 96 - 100), size:Size(width: 96, height: 96)))
            groundCoin.setActive(value: true)

            let groundCoin2 = Coin()
            groundCoin2.setRect(newRect: Rect(topLeft:Point(x: canvasSize.width / 2 + 350, y: canvasSize.height - 50 - 96 - 100), size:Size(width: 96, height: 96)))
            groundCoin2.setActive(value: true)
            
            let groundCoin3 = Coin()
            groundCoin3.setRect(newRect: Rect(topLeft:Point(x: canvasSize.width / 2 + 200, y: canvasSize.height - 50 - 96 - 100), size:Size(width: 96, height: 96)))
            groundCoin3.setActive(value: true)

            let goomba = Goomba()
            goomba.setTopLeft(value: Point(x: canvasSize.width / 2 + 300, y: canvasSize.height - 96 - 96 - 30))
            goomba.setVelocityX(value: 2)
            
            let goomba2 = Goomba()
            goomba2.setTopLeft(value: Point(x: canvasSize.width / 2 - 300, y: canvasSize.height - 96 - 96 - 30))
            goomba2.setVelocityX(value: 2)
            
            interactionLayer.renderGoomba(goomba: goomba)
            interactionLayer.renderGoomba(goomba: goomba2)
            interactionLayer.renderCoin(coin: groundCoin)
            interactionLayer.renderCoin(coin: groundCoin2)
            interactionLayer.renderCoin(coin: groundCoin3)
            interactionLayer.renderCoin(coin: coin)
            interactionLayer.renderCoin(coin: coin3)
            interactionLayer.renderQuestionBlockTile(questionTile: questionTile)
            interactionLayer.renderQuestionBlockTile(questionTile: tile1)
            interactionLayer.renderQuestionBlockTile(questionTile: questionTile2)
            interactionLayer.renderQuestionBlockTile(questionTile: tile2)
            interactionLayer.renderQuestionBlockTile(questionTile: questionTile3)
            
            marioSprite.setCoins(tiles: [groundCoin, groundCoin2, groundCoin3])
            marioSprite.setBoxes(tiles: [questionTile, tile1, questionTile2, tile2, questionTile3])
            marioSprite.setGoombas(tiles: [goomba, goomba2])

            activeEntities.append(contentsOf:[groundCoin, groundCoin2, groundCoin3, questionTile, coin, tile1, questionTile2, tile2, questionTile3, coin3, goomba, goomba2])
        }
       
    }

    // sets up level four
    func levelFour(canvasSize: Size) {
        if let interactionLayer = interactionLayer {
            let groundCoin = Coin()
            groundCoin.setRect(newRect: Rect(topLeft:Point(x: canvasSize.width / 4, y: canvasSize.height - 50 - 96 - 100), size:Size(width: 96, height: 96)))
            groundCoin.setActive(value: true)

            let groundCoin2 = Coin()
            groundCoin2.setRect(newRect: Rect(topLeft:Point(x: canvasSize.width / 2, y: canvasSize.height - 50 - 96 - 100), size:Size(width: 96, height: 96)))
            groundCoin2.setActive(value: true)
            
            let groundCoin3 = Coin()
            groundCoin3.setRect(newRect: Rect(topLeft:Point(x: canvasSize.width / 2 + (canvasSize.width / 4), y: canvasSize.height - 50 - 96 - 100), size:Size(width: 96, height: 96)))
            groundCoin3.setActive(value: true)

            let goomba = Goomba()
            goomba.setTopLeft(value: Point(x: canvasSize.width / 4, y: canvasSize.height - 96 - 96 - 30))
            goomba.setVelocityX(value: 2)
            
            let goomba2 = Goomba()
            goomba2.setTopLeft(value: Point(x: canvasSize.width / 2, y: canvasSize.height - 96 - 96 - 30))
            goomba2.setVelocityX(value: 4)
            
            let goomba3 = Goomba()
            goomba3.setTopLeft(value: Point(x: canvasSize.width / 2 + (canvasSize.width / 4), y: canvasSize.height - 96 - 96 - 30))
            goomba3.setVelocityX(value: 2)
            
            interactionLayer.renderGoomba(goomba: goomba)
            interactionLayer.renderGoomba(goomba: goomba2)
            interactionLayer.renderGoomba(goomba: goomba3)
            interactionLayer.renderCoin(coin: groundCoin)
            interactionLayer.renderCoin(coin: groundCoin2)
            interactionLayer.renderCoin(coin: groundCoin3)
            
            marioSprite.setCoins(tiles: [groundCoin, groundCoin2, groundCoin3])
            marioSprite.setGoombas(tiles: [goomba, goomba2, goomba3])
            
            activeEntities.append(contentsOf:[groundCoin, groundCoin2, groundCoin3, goomba, goomba2, goomba3])
        }
                
    }

    // sets up level five
    func levelFive(canvasSize: Size) {
        if let interactionLayer = interactionLayer {
            let goomba = Goomba()
            goomba.setTopLeft(value: Point(x: canvasSize.width / 2 - 96, y: canvasSize.height - 96 - 96 - 30))
            goomba.setVelocityX(value: 2)
            
            let goomba2 = Goomba()
            goomba2.setTopLeft(value: Point(x: canvasSize.width / 2 - (96 * 3), y: canvasSize.height - 96 - 96 - 30))
            goomba2.setVelocityX(value: 4)
            
            let goomba3 = Goomba()
            goomba3.setTopLeft(value: Point(x: canvasSize.width / 2 - (96 * 5), y: canvasSize.height - 96 - 96 - 30))
            goomba3.setVelocityX(value: 2)
            
            let goomba4 = Goomba()
            goomba4.setTopLeft(value: Point(x: canvasSize.width / 2 - (96 * 7), y: canvasSize.height - 96 - 96 - 30))
            goomba4.setVelocityX(value: 3)
            
            let goomba5 = Goomba()
            goomba5.setTopLeft(value: Point(x: canvasSize.width / 2 + 96, y: canvasSize.height - 96 - 96 - 30))
            goomba5.setVelocityX(value: 2)
            
            let goomba6 = Goomba()
            goomba6.setTopLeft(value: Point(x: canvasSize.width / 2 + (96 * 3), y: canvasSize.height - 96 - 96 - 30))
            goomba6.setVelocityX(value: 4)
            
            let goomba7 = Goomba()
            goomba7.setTopLeft(value: Point(x: canvasSize.width / 2 + (96 * 5), y: canvasSize.height - 96 - 96 - 30))
            goomba7.setVelocityX(value: 2)
            
            let goomba8 = Goomba()
            goomba8.setTopLeft(value: Point(x: canvasSize.width / 2 + (96 * 7), y: canvasSize.height - 96 - 96 - 30))
            goomba8.setVelocityX(value: 3)
            
            interactionLayer.renderGoomba(goomba: goomba)
            interactionLayer.renderGoomba(goomba: goomba2)
            interactionLayer.renderGoomba(goomba: goomba3)
            interactionLayer.renderGoomba(goomba: goomba4)
            interactionLayer.renderGoomba(goomba: goomba5)
            interactionLayer.renderGoomba(goomba: goomba6)
            interactionLayer.renderGoomba(goomba: goomba7)
            interactionLayer.renderGoomba(goomba: goomba8)
            
            marioSprite.setGoombas(tiles: [goomba, goomba2, goomba3, goomba4, goomba5, goomba6, goomba7, goomba8])
            activeEntities.append(contentsOf:[goomba, goomba2, goomba3, goomba4, goomba5, goomba6, goomba7, goomba8])
        }
    }

    // sets up level six
    func levelSix(canvasSize: Size) {
        if let interactionLayer = interactionLayer {
            let groundCoin = Coin()
            groundCoin.setRect(newRect: Rect(topLeft:Point(x: canvasSize.width / 9, y: canvasSize.height - 50 - 96 - 100), size:Size(width: 96, height: 96)))
            groundCoin.setActive(value: true)

            let groundCoin2 = Coin()
            groundCoin2.setRect(newRect: Rect(topLeft:Point(x: canvasSize.width / 9 * 2, y: canvasSize.height - 50 - 96 - 100), size:Size(width: 96, height: 96)))
            groundCoin2.setActive(value: true)
            
            let groundCoin3 = Coin()
            groundCoin3.setRect(newRect: Rect(topLeft:Point(x: canvasSize.width / 9 * 3, y: canvasSize.height - 50 - 96 - 100), size:Size(width: 96, height: 96)))
            groundCoin3.setActive(value: true)
            
            let groundCoin4 = Coin()
            groundCoin4.setRect(newRect: Rect(topLeft:Point(x: canvasSize.width / 9 * 4, y: canvasSize.height - 50 - 96 - 100), size:Size(width: 96, height: 96)))
            groundCoin4.setActive(value: true)
            
            let groundCoin5 = Coin()
            groundCoin5.setRect(newRect: Rect(topLeft:Point(x: canvasSize.width / 9 * 5, y: canvasSize.height - 50 - 96 - 100), size:Size(width: 96, height: 96)))
            groundCoin5.setActive(value: true)
            
            let groundCoin6 = Coin()
            groundCoin6.setRect(newRect: Rect(topLeft:Point(x: canvasSize.width / 9 * 6, y: canvasSize.height - 50 - 96 - 100), size:Size(width: 96, height: 96)))
            groundCoin6.setActive(value: true)
            
            let groundCoin7 = Coin()
            groundCoin7.setRect(newRect: Rect(topLeft:Point(x: canvasSize.width / 9 * 7, y: canvasSize.height - 50 - 96 - 100), size:Size(width: 96, height: 96)))
            groundCoin7.setActive(value: true)
            
            let groundCoin8 = Coin()
            groundCoin8.setRect(newRect: Rect(topLeft:Point(x: canvasSize.width / 9 * 8, y: canvasSize.height - 50 - 96 - 100), size:Size(width: 96, height: 96)))
            groundCoin8.setActive(value: true)
            
            let groundCoin9 = Coin()
            groundCoin9.setRect(newRect: Rect(topLeft:Point(x: canvasSize.width / 9 * 9, y: canvasSize.height - 50 - 96 - 100), size:Size(width: 96, height: 96)))
            groundCoin9.setActive(value: true)

            interactionLayer.renderCoin(coin: groundCoin)
            interactionLayer.renderCoin(coin: groundCoin2)
            interactionLayer.renderCoin(coin: groundCoin3)
            interactionLayer.renderCoin(coin: groundCoin4)
            interactionLayer.renderCoin(coin: groundCoin5)
            interactionLayer.renderCoin(coin: groundCoin6)
            interactionLayer.renderCoin(coin: groundCoin7)
            interactionLayer.renderCoin(coin: groundCoin8)
            interactionLayer.renderCoin(coin: groundCoin9)
            
            marioSprite.setCoins(tiles: [groundCoin, groundCoin2, groundCoin3, groundCoin4, groundCoin5, groundCoin6, groundCoin7, groundCoin8, groundCoin9])
            
            activeEntities.append(contentsOf:[groundCoin, groundCoin2, groundCoin3, groundCoin4, groundCoin5, groundCoin6, groundCoin7, groundCoin8, groundCoin9])           
        }
    }

    // sets up level seven
    func levelSeven(canvasSize: Size) {
        if let interactionLayer = interactionLayer {

            let goomba = Goomba()
            goomba.setTopLeft(value: Point(x: canvasSize.width / 4, y: canvasSize.height - 96 - 96 - 30))
            goomba.setVelocityX(value: 2)
            
            let goomba2 = Goomba()
            goomba2.setTopLeft(value: Point(x: canvasSize.width / 2, y: canvasSize.height - 96 - 96 - 30))
            goomba2.setVelocityX(value: 4)
            
            let goomba3 = Goomba()
            goomba3.setTopLeft(value: Point(x: canvasSize.width / 2 + (canvasSize.width / 4), y: canvasSize.height - 96 - 96 - 30))
            goomba3.setVelocityX(value: 2)

            let goomba4 = Goomba()
            goomba4.setTopLeft(value: Point(x: canvasSize.width, y: canvasSize.height - 96 - 96 - 30))
            goomba4.setVelocityX(value: 4)
                        
            let tile1 = QuestionBlockTile(whatInside:"don't animate")
            tile1.setTopLeft(point: Point(x: canvasSize.width / 2 - 96, y: canvasSize.height - 200 - 96 - 100))
            tile1.setActivated(value: true)
                        
            let tile2 = QuestionBlockTile(whatInside:"don't animate")
            tile2.setTopLeft(point: Point(x: canvasSize.width / 2, y: canvasSize.height - 200 - 96 - 100))
            tile2.setActivated(value: true)

            let tile3 = QuestionBlockTile(whatInside:"don't animate")
            tile3.setTopLeft(point: Point(x: canvasSize.width / 4 - 96, y: canvasSize.height - 200 - 96 - 100))
            tile3.setActivated(value: true)
                        
            let tile4 = QuestionBlockTile(whatInside:"don't animate")
            tile4.setTopLeft(point: Point(x: canvasSize.width / 4, y: canvasSize.height - 200 - 96 - 100))
            tile4.setActivated(value: true)
            
            let tile5 = QuestionBlockTile(whatInside:"don't animate")
            tile5.setTopLeft(point: Point(x: canvasSize.width / 2 + (canvasSize.width / 4 - 96), y: canvasSize.height - 200 - 96 - 100))
            tile5.setActivated(value: true)
                        
            let tile6 = QuestionBlockTile(whatInside:"don't animate")
            tile6.setTopLeft(point: Point(x: canvasSize.width / 2 + (canvasSize.width / 4), y: canvasSize.height - 200 - 96 - 100))
            tile6.setActivated(value: true)
            
            interactionLayer.renderGoomba(goomba: goomba)
            interactionLayer.renderGoomba(goomba: goomba2)
            interactionLayer.renderGoomba(goomba: goomba3)
            interactionLayer.renderGoomba(goomba: goomba4)

            interactionLayer.renderQuestionBlockTile(questionTile: tile1)
            interactionLayer.renderQuestionBlockTile(questionTile: tile2)
            interactionLayer.renderQuestionBlockTile(questionTile: tile3)
            interactionLayer.renderQuestionBlockTile(questionTile: tile4)
            interactionLayer.renderQuestionBlockTile(questionTile: tile5)
            interactionLayer.renderQuestionBlockTile(questionTile: tile6)
                        
            marioSprite.setGoombas(tiles: [goomba, goomba2, goomba3, goomba4])
            marioSprite.setBoxes(tiles: [tile1, tile2, tile3, tile4, tile5, tile6])
            
            activeEntities.append(contentsOf:[goomba, goomba2, goomba3, goomba4, tile1, tile2, tile3, tile4, tile5, tile6])
        }
    }

    // sets up level eight
    func levelEight(canvasSize: Size) {
        if let interactionLayer = interactionLayer {

            let goomba = Goomba()
            goomba.setTopLeft(value: Point(x: canvasSize.width / 4, y: canvasSize.height - 96 - 96 - 30))
            goomba.setVelocityX(value: 8)
                    
            let goomba3 = Goomba()
            goomba3.setTopLeft(value: Point(x: canvasSize.width / 2 + (canvasSize.width / 4), y: canvasSize.height - 96 - 96 - 30))
            goomba3.setVelocityX(value: 8)

            let tile1 = QuestionBlockTile(whatInside:"don't animate")
            tile1.setTopLeft(point: Point(x: canvasSize.width / 4 - 96, y: canvasSize.height - 200 - 96 - 100))
            tile1.setActivated(value: true)
                        
            let tile2 = QuestionBlockTile(whatInside:"don't animate")
            tile2.setTopLeft(point: Point(x: canvasSize.width / 4, y: canvasSize.height - 200 - 96 - 100))
            tile2.setActivated(value: true)
            
            let tile5 = QuestionBlockTile(whatInside:"don't animate")
            tile5.setTopLeft(point: Point(x: canvasSize.width / 2 + (canvasSize.width / 4 - 96), y: canvasSize.height - 200 - 96 - 100))
            tile5.setActivated(value: true)
                        
            let tile6 = QuestionBlockTile(whatInside:"don't animate")
            tile6.setTopLeft(point: Point(x: canvasSize.width / 2 + (canvasSize.width / 4), y: canvasSize.height - 200 - 96 - 100))
            tile6.setActivated(value: true)
            
            interactionLayer.renderGoomba(goomba: goomba)
            interactionLayer.renderGoomba(goomba: goomba3)

            interactionLayer.renderQuestionBlockTile(questionTile: tile1)
            interactionLayer.renderQuestionBlockTile(questionTile: tile2)
            interactionLayer.renderQuestionBlockTile(questionTile: tile5)
            interactionLayer.renderQuestionBlockTile(questionTile: tile6)
                        
            marioSprite.setGoombas(tiles: [goomba, goomba3])
            marioSprite.setBoxes(tiles: [tile1, tile2, tile5, tile6])
            
            activeEntities.append(contentsOf:[goomba, goomba3, tile1, tile2, tile5, tile6])
        }
    }
    
    // sets up level nine
    func levelNine(canvasSize: Size) {
        if let interactionLayer = interactionLayer {
            let groundCoin = Coin()
            groundCoin.setRect(newRect: Rect(topLeft:Point(x: canvasSize.width - 96, y: canvasSize.height - 50 - 96 - 100), size:Size(width: 96, height: 96)))
            groundCoin.setActive(value: true)

            let groundCoin2 = Coin()
            groundCoin2.setRect(newRect: Rect(topLeft:Point(x: canvasSize.width - (96 * 2), y: canvasSize.height - 50 - 96 - 100), size:Size(width: 96, height: 96)))
            groundCoin2.setActive(value: true)
            
            let groundCoin3 = Coin()
            groundCoin3.setRect(newRect: Rect(topLeft:Point(x: canvasSize.width - (96 * 3), y: canvasSize.height - 50 - 96 - 100), size:Size(width: 96, height: 96)))
            groundCoin3.setActive(value: true)

            let goomba = Goomba()
            goomba.setTopLeft(value: Point(x: canvasSize.width / 4, y: canvasSize.height - 96 - 96 - 30))
            goomba.setVelocityX(value: 7)
                    
            let goomba2 = Goomba()
            goomba2.setTopLeft(value: Point(x: canvasSize.width * 3 / 4, y: canvasSize.height - 96 - 96 - 30))
            goomba2.setVelocityX(value: -7)

            let tile1 = QuestionBlockTile(whatInside:"don't animate")
            tile1.setTopLeft(point: Point(x: canvasSize.width / 2 - (96 * 2), y: canvasSize.height - 200 - 96 - 100))
            tile1.setActivated(value: true)
                        
            let tile2 = QuestionBlockTile(whatInside:"don't animate")
            tile2.setTopLeft(point: Point(x: canvasSize.width / 2 + (96 * 2), y: canvasSize.height - 200 - 96 - 100))
            tile2.setActivated(value: true)

            let insideCoin = Coin()
            insideCoin.setRect(newRect: Rect(topLeft: Point(x: canvasSize.width / 2, y: canvasSize.height - 200 - 96 - 100), size: Size(width:96, height:96)))
            insideCoin.setActive(value: false)

            let tile3 = QuestionBlockTile(whatInside:"coin")
            tile3.setTopLeft(point: Point(x: canvasSize.width / 2, y: canvasSize.height - 200 - 96 - 100))
            tile3.setActivated(value: false)
            tile3.setInsideCoin(value: insideCoin)
            tile3.setLevelHandler(handler: self)

            interactionLayer.renderCoin(coin: groundCoin)
            interactionLayer.renderCoin(coin: groundCoin2)
            interactionLayer.renderCoin(coin: groundCoin3)
            interactionLayer.renderCoin(coin: insideCoin)
            interactionLayer.renderGoomba(goomba: goomba)
            interactionLayer.renderGoomba(goomba: goomba2)
            interactionLayer.renderQuestionBlockTile(questionTile: tile1)
            interactionLayer.renderQuestionBlockTile(questionTile: tile2)
            interactionLayer.renderQuestionBlockTile(questionTile: tile3)
            
            marioSprite.setCoins(tiles: [groundCoin, groundCoin2, groundCoin3])
            marioSprite.setGoombas(tiles: [goomba, goomba2])
            marioSprite.setBoxes(tiles: [tile1, tile2, tile3])
            
            activeEntities.append(contentsOf:[groundCoin, groundCoin2, groundCoin3, goomba, goomba2, tile1, tile2, tile3, insideCoin]) 
        }
    }

    // set up level ten
    func levelTen(canvasSize: Size) {
    }
}
