=begin
  CLASS: Model

  Author: Luo Jiehao, 7852402

  REMARKS: To define an instance that represents a guess in the game.
=end

class Model
=begin
  initialize
      
  PURPOSE: to set the fields in each instance of this class.
  PARAMETERS:
    people: list of all suspect cards in this game.
    places: list of all place cards in this game.
    weapons: list of all weapon cards in this game.
=end   
  def initialize( people, places, weapons )
    @people = people
    @places = places
    @weapons = weapons
    
    @criminal  # The chosen suspect card that represents the criminal.                    
    @crimeScene  # The chosen place card that represents the crime scene. 
    @lethalWeapon  # The chosen weapon card that represents the lethal weapon. 
    @arrayOfPlayers  # List of all players in this game.
    @indiceOfRemovedPlayers = Array.new(0)  # list of indices of players who have been removed from this game.
  end
  
=begin
  setPlayers
      
  PURPOSE: to set the field of @arrayOfPlayers, and print out all cards in this game.
  PARAMETERS:
    arrayOfPlayers: new value to be set in @arrayOfPlayers.
=end    
  def setPlayers( arrayOfPlayers )
    @arrayOfPlayers = arrayOfPlayers
    
    for i in 0... @arrayOfPlayers.length()
      @arrayOfPlayers[i].setup(@arrayOfPlayers.length(), i, @people, @places, @weapons)
    end
    
    puts "Here are the names of all the suspects: "
    for i in 0... @people.length
      print "#{@people[i].value}"
      if(i != @people.length-1)
        print ", "
      end
    end
    puts ""
    puts "Here are all the locations: "
    for i in 0... @places.length
      print "#{@places[i].value}"
      if(i != @places.length-1)
        print ", "
      end
    end
    puts ""
    puts "Here are all the weapons: "
    for i in 0... @weapons.length
      print "#{@weapons[i].value}"
      if(i != @weapons.length-1)
        print ", "
      end
    end
    puts ""
  end

=begin
  setupCards
      
  PURPOSE: Shuffle the cards and deal them to each player.
=end        
  def setupCards
    @people = @people.shuffle
    @places = @places.shuffle
    @weapons = @weapons.shuffle
    
    @criminal = @people[0]
    @crimeScene = @places[0]
    @lethalWeapon = @weapons[0]
    
    remaining = @people[1... @people.length()] + @places[1... @places.length()] + @weapons[1... @weapons.length()]
    remaining = remaining.shuffle
    
    index = 0
    
    for i in 0...remaining.length
      @arrayOfPlayers[index].setCard(remaining[i])
      index = (index + 1) % @arrayOfPlayers.length
    end
    
  end
  
=begin
  play
      
  PURPOSE: Play the game.
=end  
  def play
      
    isOver = false  # indicate if the game is over.
    indexOfPlayer = 0; # the index of the player of the current turn.
    
    while( isOver == false )
      
      # find the next player that has not be removed.      
      while( @indiceOfRemovedPlayers.index(indexOfPlayer) != nil )
        indexOfPlayer = (indexOfPlayer + 1) % @arrayOfPlayers.length
      end
      
      puts "Current turn: #{indexOfPlayer}"
      
      theGuess = @arrayOfPlayers[indexOfPlayer].getGuess
      
      if(theGuess.type == true)
        puts "Player #{indexOfPlayer}: accusation: #{theGuess.person.value} in #{theGuess.place.value} with the #{theGuess.weapon.value}. "
      else
        puts "Player #{indexOfPlayer}: suggestion: #{theGuess.person.value} in #{theGuess.place.value} with the #{theGuess.weapon.value}. "
      end
      
      # if the guess is an accusation.
      if(theGuess.type == true)
        # if accusation is true, game over.
        if(theGuess.person.value == @criminal.value && theGuess.place.value == @crimeScene.value && theGuess.weapon.value == @lethalWeapon.value) 
          isOver = true
          puts "Player #{indexOfPlayer} won the game. "
        # otherwise, remove the player who made the accusation.
        else
          @indiceOfRemovedPlayers.push(indexOfPlayer)
          puts "Player #{indexOfPlayer} made a bad accusation and was removed from the game. "
          if( @indiceOfRemovedPlayers.length == @arrayOfPlayers.length - 1 )
            isOver = true
            puts "There is only one player left. Game Over! "
          end
        end
      # if the guess is an suggestion.
      else
        # Asking the next player.
        indexOfAnswerer = (indexOfPlayer + 1) % @arrayOfPlayers.length
        isAnswered = false
        
        theAnswer = nil
        # ask all other players until there is an answer or no one can answer.
        while( indexOfAnswerer != indexOfPlayer && !isAnswered )
          theAnswer = @arrayOfPlayers[indexOfAnswerer].canAnswer( indexOfPlayer, theGuess )
          
          if(theAnswer != nil)
            puts "Player #{indexOfAnswerer} answered. "
            isAnswered = true         
          else
            indexOfAnswerer = (indexOfAnswerer + 1) % @arrayOfPlayers.length       
          end
          
        end
        
        # give the answer to the guesser.
        if(theAnswer == nil)
          @arrayOfPlayers[indexOfPlayer].receiveInfo( -1, theAnswer )
        else
          @arrayOfPlayers[indexOfPlayer].receiveInfo( indexOfAnswerer, theAnswer )
        end    
      end#if
      
      indexOfPlayer = (indexOfPlayer + 1) % @arrayOfPlayers.length
    end#while       
  end #def
end #class