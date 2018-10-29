function love.load()
    deck = {}
    for suitIndex, suit in ipairs({'club', 'heart', 'spade', 'diamond'}) do
        for rank = 1, 13 do
            table.insert(deck, {suit = suit, rank = rank})
        end
    end

    function takeCard(hand)
        table.insert(hand, table.remove(deck, love.math.random(#deck)))
    end

    playerHand = {}
    takeCard(playerHand)
    takeCard(playerHand)

    dealerHand = {}
    takeCard(dealerHand)
    takeCard(dealerHand)


    roundOver = false

    function getTotal(hand)
        local total = 0
        local hasAce = false
        for cardIndex, card in ipairs(hand) do
            if card.rank > 10 then
                total = total + 10
            else
                total = total + card.rank
            end
            if card.rank == 1 then
                hasAce = true
            end
        end
        if hasAce and total <= 11 then
            total = total + 10
        end
        return total
    end

    images = {}
    for nameIndex, name in ipairs({
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,
        'pip_heart', 'pip_diamond', 'pip_club', 'pip_spade',
        'mini_heart', 'mini_diamond', 'mini_club', 'mini_spade',
        'card', 'card_face_down',
        'face_jack', 'face_queen', 'face_king',
     }) do
        images[name] = love.graphics.newImage('images/'..name..'.png')
    end

    love.graphics.setBackgroundColor(1, 1, 1)

end

function love.draw()

    function hasHandWon(thisHand, otherHand)
        return getTotal(thisHand) <= 21 and (getTotal(otherHand) > 21 or getTotal(thisHand) > getTotal(otherHand))
    end

    function drawWinner(message)
        love.graphics.print(message, marginX, 268)
    end

    function drawCard(card, x, y)
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(images.card, x, y)

        local cardWidth = 53
        local cardHeight = 73
        local suitImage = images['mini_'..card.suit]

        local function drawCorner(image, xOffset, yOffset)
            love.graphics.draw(image, x + xOffset, y + yOffset)
            love.graphics.draw(image, x + cardWidth - xOffset, y + cardHeight - yOffset, 0, -1, -1)
        end

        if card.suit == 'heart' or card.suit == 'diamond' then
            love.graphics.setColor(.89, .06, .39)
        else 
            love.graphics.setColor(.2, .2, .2)
        end

        drawCorner(images[card.rank], 3, 4)
        drawCorner(suitImage, 3, 14)

        if card.rank > 10 then
            local faceImage
            if card.rank == 11 then
                faceImage = images.face_jack
            elseif card.rank == 12 then
                faceImage = images.face_queen
            elseif card.rank == 13 then
                faceImage = images.face_king
            end
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(faceImage, x + 12, y + 11)

        else
            local function drawPip (offsetX, offsetY, mirrorX, mirrorY)
                local pipImage = images['pip_'..card.suit]
                local pipWidth = 11
                love.graphics.draw(pipImage, x + offsetX, y + offsetY)
                if mirrorX then
                    love.graphics.draw(pipImage, x + cardWidth - offsetX - pipWidth, y + offsetY)
                end
                if mirrorY then
                    love.graphics.draw(pipImage, x + offsetX + pipWidth, y + cardHeight - offsetY, 0, -1, -1)
                end
                if mirrorX and mirrorY then
                    love.graphics.draw(pipImage, x + cardWidth - offsetX, y + cardHeight - offsetY, 0, -1, -1)
                end
            end

            local xLeft = 11
            local xMid = 21
            local yTop = 7
            local yMid = 31
            local yThird = 19
            local yQuarter = 23
            local pipImage = images['pip_'..card.suit]
            local pipWidth = 11

            
            if card.rank == 1 then
                drawPip(xMid, yMid, false, false)
            elseif card.rank == 2 then
                drawPip(xMid, yTop, false, true)    
            elseif card.rank == 3 then
                drawPip(xMid, yMid, false, false)
                drawPip(xMid, yTop, false, true)
            elseif card.rank == 4 then
                drawPip(xLeft, yTop, true, true)
            elseif card.rank == 5 then
                drawPip(xMid, yMid, false, false)
                drawPip(xLeft, yTop, true, true)
            elseif card.rank == 6 then
                drawPip(xLeft, yTop, true, true)
                drawPip(xLeft, yMid, true, false)
            elseif card.rank == 7 then
                drawPip(xLeft, yTop, true, true)
                drawPip(xLeft, yMid, true, false)
                drawPip(xMid, yThird, false, false)
            elseif card.rank == 8 then
                drawPip(xLeft, yTop, true, true)
                drawPip(xLeft, yMid, true, false)
                drawPip(xMid, yThird, false, true)
            elseif card.rank == 9 then
                drawPip(xLeft, yTop, true, true)
                drawPip(xLeft, yQuarter, true, true)
                drawPip(xMid, yMid, false, false)
            elseif card.rank == 10 then
                drawPip(xLeft, yTop, true, true)
                drawPip(xLeft, yQuarter, true, true)
                drawPip(xMid, 16, false, true)
            end
        end
    end

    local cardSpacing = 60
    local marginX =10

    for cardIndex, card in ipairs(dealerHand) do
        local dealerMarginY = 30
        if not roundOver and cardIndex == 1 then
            love.graphics.draw(images.card_face_down, marginX, dealerMarginY)
        else
            drawCard(card, ((cardIndex - 1) * cardSpacing) + marginX, dealerMarginY)
        end
    end
    
    for cardIndex, card in ipairs(playerHand) do
        drawCard(card, ((cardIndex - 1) * cardSpacing) + marginX, 140)
    end

    love.graphics.setColor(0, 0, 0)

    if roundOver then
        love.graphics.print('Total: '..getTotal(dealerHand), marginX, 10)
        if hasHandWon(playerHand, dealerHand) then
            drawWinner('Player wins')
        elseif hasHandWon(dealerHand, playerHand) then
            drawWinner('Dealer wins')
        else
            drawWinner('Draw')
        end
    else
        love.graphics.print('Total: ?', marginX, 10)
    end

    love.graphics.print('Total: '..getTotal(playerHand), marginX, 120)

end

function love.keypressed(key)
    if not roundOver then
        if key == 'h' then
            takeCard(playerHand)
            if getTotal(playerHand) >= 21 then
                roundOver = true
            end
        elseif key == 's' then
            roundOver = true
        end
        if roundOver then
            while getTotal(dealerHand) < 17 do
                takeCard(dealerHand)
            end
        end
    else 
        love.load()
    end
end