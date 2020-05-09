=begin
  CLASS: Guess

  Author: Luo Jiehao, 7852402

  REMARKS: To define an instance that represents a guess in the game.
=end

class Guess
  attr_reader :person, :place, :weapon, :type
  
=begin
  initialize
      
  PURPOSE: to set the 4 fields in each instance of this class.
  PARAMETERS:
    person: person card in this guess.
    place: place card in this guess.
    weapon: weapon card in this guess.
    type: type card in this guess.
=end 
  def initialize(person, place, weapon, type)
    @person = person
    @place = place
    @weapon = weapon
    @type = type
  end

=begin
  isAccusation
      
  PURPOSE: to return the "type" variable of this instance.
  RETURN:
    @type: the "type" variable of this instance.
=end   
  def isAccusation
      return @type
  end
  
end