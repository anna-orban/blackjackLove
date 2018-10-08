function love.load()
    deck = {}
    for suitIndex, suit in ipairs({'club', 'heart', 'spade', 'diamond'}) do
        for rank = 1, 13 do
            print('suit: '..suit..', rank: '..rank)
            table.insert(deck, {suit = suit, rank = rank})
        end
    end

    playerHand = {}
    table.insert(playerHand, table.remove(deck, love.math.random(#deck)))
    table.insert(playerHand, table.remove(deck, love.math.random(#deck)))
    print('Player hand: ')
    for cardIndex, card in ipairs(playerHand) do
        print('suit: '..card.suit..', rank: '..card.rank)
    end

    print('Total number of cards in deck: '..#deck)
end

function love.draw()
    local output = {}
    table.insert(output, 'Player hand: ')
    for cardIndex, card in ipairs(playerHand) do
        table.insert( output, 'suit: '..card.suit..', rank: '..card.rank)
    end

    love.graphics.print(table.concat(output, '\n'), 15, 15)
end