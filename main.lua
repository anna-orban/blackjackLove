function love.load()
    deck = {}
    for suitIndex, suit in ipairs({'club', 'heart', 'spade', 'diamond'}) do
        for rank = 1, 13 do
            print('suit: '..suit..', rank: '..rank)
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

    print('Total number of cards in deck: '..#deck)
end

function love.draw()
    local output = {}
    table.insert(output, 'Player hand: ')
    for cardIndex, card in ipairs(playerHand) do
        table.insert(output, 'suit: '..card.suit..', rank: '..card.rank)
    end
    table.insert(output, '')
    table.insert(output, 'Dealer hand: ')
    for cardIndex, card in ipairs(dealerHand) do
        table.insert(output, 'suit: '..card.suit..', rank: '..card.rank)
    end

    love.graphics.print(table.concat(output, '\n'), 15, 15)
end

function love.keypressed(key)
    if key == 'h' then
        takeCard(playerHand)
    end
end