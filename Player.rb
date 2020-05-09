require_relative "AbstractPlayers"

=begin
  CLASS: Player

  Author: Luo Jiehao, 7852402

  REMARKS: To define an instance that represents a computer player in the game.
=end
class Player < AbstractPlayers
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
  attr_reader:listOfAllSuspects, :listOfAllLocations, :listOfAllWeapons
  
  def setup( numOfPlayers, indexOfCurrentPlayer, listOfAllSuspects, listOfAllLocations, listOfAllWeapons )
    @numOfPlayers = numOfPlayers
    @indexOfCurrentPlayer = indexOfCurrentPlayer
    @listOfAllSuspects = listOfAllSuspects.clone
    @listOfAllLocations = listOfAllLocations.clone
    @listOfAllWeapons = listOfAllWeapons.clone
    @cardsInHand = Array.new(0)
  end
  
=begin
  setCard
      
  PURPOSE: to indicate that the player has been dealt a new card.
  PARAMETERS:
    newCard: the new card to be dealt to this player
=end    
  def setCard( newCard )
    @cardsInHand.push(newCard)
    
    # since the computer player doesn't make bad guess, 
    # we delete the card just received from the lists of potential right cards.
    i = 0
    while( i < @listOfAllSuspects.length )
      if( @listOfAllSuspects[i].value == newCard.value && @listOfAllSuspects[i].type == newCard.type )
        @listOfAllSuspects.delete_at(i)
      else
        i = i + 1
      end
    end
    
    i = 0
    while( i < @listOfAllLocations.length )
      if( @listOfAllLocations[i].type == newCard.type && @listOfAllLocations[i].value == newCard.value )
        @listOfAllLocations.delete_at(i)
      else
        i = i + 1
      end
    end
  
    i = 0
    while( i < @listOfAllWeapons.length )
      if( @listOfAllWeapons[i].type == newCard.type && @listOfAllWeapons[i].value == newCard.value )
        @listOfAllWeapons.delete_at(i)
      else
        i = i + 1
      end
    end
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
  def canAnswer(playerIndex, guess)
    
    cardFound = nil

    for i in 0...@cardsInHand.length
      if( @cardsInHand[i].type() == :person )
        if(guess.person.value == @cardsInHand[i].value())
          cardFound = @cardsInHand[i]
        end
      elsif( @cardsInHand[i].type() == :place )
        if(guess.place.value == @cardsInHand[i].value())
          cardFound = @cardsInHand[i]
        end
      elsif( @cardsInHand[i].type() == :weapon )
        if(guess.weapon.value == @cardsInHand[i].value())
          cardFound = @cardsInHand[i]
        end
      end #if
    end #for
    
    #if(cardFound != nil)
      puts "Asking player #{@indexOfCurrentPlayer}. "
    #end
    
    return cardFound
    
  end
  
=begin
  getGuess
      
  PURPOSE: let this player make a guess.
  RETURNS:
    the guess this player made.
=end  
  def getGuess
    
    # choose a random card from the lists of potential right cards.
    personOfGuess = rand(@listOfAllSuspects.length)
    placeOfGuess = rand(@listOfAllLocations.length)
    weaponOfGuess = rand(@listOfAllWeapons.length)
    
    # if the there are only 3 cards in the 3 lists, then there is only one possibility of the right answer, so it is an accusation.
    if( @listOfAllSuspects.length == 1 && @listOfAllLocations.length == 1 && @listOfAllWeapons.length == 1 )  
      isAccusation = true
    else
      isAccusation = false
    end
    
    return Guess.new(@listOfAllSuspects[personOfGuess], @listOfAllLocations[placeOfGuess], @listOfAllWeapons[weaponOfGuess], isAccusation)
    
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
      puts "No one could answer. "
    else
      # since the computer player doesn't make bad guess, 
      # we delete the card just showed by other players from the lists of potential right cards.
      if( card.type == :person )
        i = 0
        while( i < @listOfAllSuspects.length )
          if(@listOfAllSuspects[i].value == card.value)
            @listOfAllSuspects.delete_at(i)
          else
            i = i + 1
          end
        end
      elsif( card.type == :place )
        i = 0
        while( i < @listOfAllLocations.length )
          if(@listOfAllLocations[i] == card)
            @listOfAllLocations.delete_at(i)
          else
            i = i + 1
          end
        end
      elsif( card.type == :weapon )
        i = 0
        while( i < @listOfAllWeapons.length )
          if(@listOfAllWeapons[i] == card)
            @listOfAllWeapons.delete_at(i)
          else
            i = i + 1
          end
        end
      end
    end #if
  end
  
end