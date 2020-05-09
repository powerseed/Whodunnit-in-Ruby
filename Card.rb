=begin
  CLASS: Card

  Author: Luo Jiehao, 7852402

  REMARKS: To define an instance that represents a card in the game.
=end

class Card
  
  attr_reader :type, :value
  
=begin
  initialize
      
  PURPOSE: to set the 2 fields in each instance of this class.
  PARAMETERS:
    type: the type of this card. 
    value: the value of this card.
=end 
  def initialize(type, value)
    @type = type
    @value = value
  end
  
end