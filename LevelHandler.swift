import Igis
import Scenes
import Foundation

class LevelHandler : RenderableEntity {
    let marioSprite : Mario
    var currentLevel = 1
    var interactionLayer : InteractionLayer?
    var score = 0
    var lives = 3
    var activeEntities : [RenderableEntity] = [];

    let stageClearSound : Audio
    var shouldRenderStageClear = false
    
    init(mario:Mario) {
        func getAudio(url:String, loop:Bool) -> Audio { // function for getting audio
            guard let url = URL(string:url) else {
                fatalError("Failed to create URL for "+url)
            }
            return Audio(sourceURL: url, shouldLoop:loop)
        }

        stageClearSound = getAudio(url: "https://www.codermerlin.com/users/brett-kaplan/mario/sounds/smb_stage_clear.wav", loop:false)

        marioSprite = mario

        super.init(name: "LevelHandler")

        marioSprite.setLevelHandler(handler: self)
    }

    func getFourZeroes(x:Int) -> String {
        var y = String(x)
        for _ in 0 ..< 4 - String(x).count {
            y = "0"+y
        }
        return y
    }

    override func setup(canvasSize:Size, canvas:Canvas) {
        canvas.setup(stageClearSound)
    }

    override func calculate(canvasSize: Size) {
        if(marioSprite.topLeft.x + marioSprite.marioSize.width > marioSprite.cSize.width + 10) {
            shouldRenderStageClear = true
            clearLevel()

            currentLevel += 1
            score += 3
            
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
            default:
                print("You reached the end!")
            }
        }
    }

    override func render(canvas: Canvas) {
        if(lives <= 0) {
            if let canvasSize = canvas.canvasSize {
                // Render Text:
                let gameOverText = Text(location:canvasSize.center, text:"GAME OVER!")
                gameOverText.font = "60pt Arial"
                gameOverText.alignment = .center
                canvas.render(gameOverText)
            }

            clearLevel()
        }
        
        if shouldRenderStageClear && stageClearSound.isReady {
            canvas.render(stageClearSound)
            shouldRenderStageClear = false
        }
        
        let text = Text(location:Point(x:50, y:90), text:getFourZeroes(x:score))
        text.font = "30pt Arial"
        text.alignment = .left
        canvas.render(text)

        if let canvasSize = canvas.canvasSize {
            
            let livesHeader = Text(location:Point(x:canvasSize.width / 2, y:45), text:"LIVES")
            livesHeader.alignment = .center
            livesHeader.font = "30pt Arial"
            canvas.render(livesHeader)
            
            let livesText = Text(location:Point(x:canvasSize.width / 2, y:90), text:String(lives))
            livesText.alignment = .center
            livesText.font = "30pt Arial"
            canvas.render(livesText)
        }
    }

    func setHandler(handler:InteractionLayer) {
        interactionLayer = handler;
    }

    func setScore(value: Int) {
        score = value
    }

    func setLives(value: Int) {
        lives = value
    }

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
            goomba3.setTopLeft(value: Point(x: canvasSize.width / 2 - (96 * 7), y: canvasSize.height - 96 - 96 - 30))
            goomba3.setVelocityX(value: 3)
            
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

    func levelSix(canvasSize: Size) {
    }

    func levelSeven(canvasSize: Size) {
    }

    func levelEight(canvasSize: Size) {
    }

    func levelNine(canvasSize: Size) {
    }

    func levelTen(canvasSize: Size) {
    }
}
