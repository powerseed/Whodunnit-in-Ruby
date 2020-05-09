require_relative "AbstractPlayers"

=begin
  CLASS: InteractivePlayer

  Author: Luo Jiehao, 7852402

  REMARKS: To define an instance that represents the human player in the game.
=end

class InteractivePlayer < AbstractPlayers
  
=begin
  setup
      
  PURPOSE: to set the 5 fields in each instance of this class.
  PARAMETERS:
    numOfPlayers: the number of players in the game. 
    indexOfCurrentPlayer: the index of the current player (what player number am I?).
    listOfAllSuspects: a list of the suspects that are not excluded from the right guess.
    listOfAllLocations: a list of all the locations that are not excluded from the right guess.
    listOfAllWeapons: and a list of all the weapons that are not excluded from the right guess.
=end 
  def setup( numOfPlayers, indexOfCurrentPlayer, listOfAllSuspects, listOfAllLocations, listOfAllWeapons )
    @numOfPlayers = numOfPlayers
    @indexOfCurrentPlayer = indexOfCurrentPlayer
    @listOfAllSuspects = listOfAllSuspects.clone
    @listOfAllLocations = listOfAllLocations.clone
    @listOfAllWeapons = listOfAllWeapons.clone
    @cardsInHand = Array.new(0)   # array stores the cards received by this player
  end
  
=begin
  setCard
      
  PURPOSE: to indicate that the player has been dealt a new card.
  PARAMETERS:
    newCard: the new card to be dealt to this player
=end  
  def setCard( newCard )
    puts "You received the card #{newCard.value}. "
    @cardsInHand.push(newCard)
  end

=begin
  canAnswer
      
  PURPOSE: to check if the player can answer a guess, and to return the answer if she can.
  PARAMETERS:
    guess: the guess from another player which needs to be answered by this player. 
    playerIndex: the index of the player who made the guess.
  RETURNS:
    the card to be shown to the guess maker.
=end    
  def canAnswer( playerIndex, guess )
        
    cardsFound = Array.new(0)   # to store the cards that are in the guess and are reveived by the this player.
    indexOfCardToShow = -1      # index of the card that to be shown to the player who made a guess in the array above.
    cardToShow = nil            # the paticular card that is about to be shown.
    
    puts "Asking player #{@indexOfCurrentPlayer}. "
    
    # iterate all cards this player owns to find those in the guess.
    for i in 0...@cardsInHand.length
      if( @cardsInHand[i].type() == :person )
        if(guess.person().value() == @cardsInHand[i].value())
          cardsFound.push(@cardsInHand[i])
        end
      elsif( @cardsInHand[i].type() == :place )
        if(guess.place().value() == @cardsInHand[i].value())
          cardsFound.push(@cardsInHand[i])
        end
      elsif( @cardsInHand[i].type() == :weapon )
        if(guess.weapon().value() == @cardsInHand[i].value())
          cardsFound.push(@cardsInHand[i])
        end
      end #if
    end #for
    
    # if there IS any cards found, which means that the player can answer the guess.
    if(cardsFound.length != 0 ) 
      # if there is only one card, just show it.
      if(cardsFound.length == 1)
        puts "Player #{playerIndex} asked you about guess: #{guess.person.value} in #{guess.place.value} with the #{guess.weapon.value}, you only have one card, #{cardsFound[0].value}, showed it to them."
        cardToShow = cardsFound[0]
      # otherwise, ask the human player to choose a card to show.
      else     
        puts "Player #{playerIndex} asked you about guess: #{guess.person.value} in #{guess.place.value} with the #{guess.weapon.value}, Which do you show? "
        
        for i in 0... cardsFound.length
          puts "#{i}: #{cardsFound[i].value}" 
        end
        
        indexOfCardToShow = gets.chomp.to_i
        
        while( indexOfCardToShow < 0 || indexOfCardToShow > cardsFound.length - 1 )
          puts "Invalid number. Please enter again. "
          indexOfCardToShow = gets.chomp.to_i
        end
        
        cardToShow = cardsFound[indexOfCardToShow]
      end
    # if there is no card found, then this player can not answer this guess.
    else
      puts "Player #{playerIndex} asked you about guess: #{guess.person.value} in #{guess.place.value} with the #{guess.weapon.value}, but you couldn't answer. "
    end
      
    return cardToShow   
  end
  
=begin
  getGuess
      
  PURPOSE: let this player make a guess.
  RETURNS:
    the guess this player made.
=end  
  def getGuess
    puts "It is your turn. "
    
    # Let the human player choose 3 card for the guess.
    puts "Which person do you want to suggest? "
    for i in 0... @listOfAllSuspects.length
      puts "#{i}: #{@listOfAllSuspects[i].value}" 
    end 
    input = gets.chomp.to_i
    while( input < 0 || input > @listOfAllSuspects.length - 1 )
      puts "Invalid number. Please enter again. "
      input = gets.chomp.to_i
    end  
    personInGuess = @listOfAllSuspects[input]

    puts "Which location do you want to suggest? "   
    for i in 0... @listOfAllLocations.length
      puts "#{i}: #{@listOfAllLocations[i].value}" 
    end    
    input = gets.chomp.to_i    
    while( input < 0 || input > @listOfAllLocations.length - 1 )
      puts "Invalid number. Please enter again. "
      input = gets.chomp.to_i
    end    
    placeInGuess = @listOfAllLocations[input]

    puts "Which weapon do you want to suggest? "    
    for i in 0... @listOfAllWeapons.length
      puts "#{i}: #{@listOfAllWeapons[i].value}" 
    end    
    input = gets.chomp.to_i  
    while( input < 0 || input > @listOfAllWeapons.length - 1 )
      puts "Invalid number. Please enter again. "
      input = gets.chomp.to_i
    end   
    weaponInGuess = @listOfAllWeapons[input]
    
    puts "Is this an accusation ([Y]/[N])? "
    input = gets.chomp.upcase
    
    # validity checking
    while( input != "Y" && input != "N" )
      puts "Invalid number. Please enter again. "
      input = gets.chomp.upcase
    end
    
    if( input == "Y")  
      isAccusation = true
    else  
      isAccusation = false      
    end
    
    return Guess.new( personInGuess, placeInGuess, weaponInGuess, isAccusation )
    
  end
  
=begin
  receiveInfo
      
  PURPOSE: get the information when another player shows a card to this player.
  PARAMETERS:
    playerIndex: the player who showed a card to this player.
    card: the card showed.
=end 
  def receiveInfo( playerIndex, card )
    if(playerIndex == -1 && card == nil)
      puts "No one could refute your suggestion. "
    else
      puts "Player #{playerIndex} refuted your suggestion by showing you #{card.value}. "
    end    
  end
  
end