=begin
  CLASS: AbstractPlayers

  Author: Luo Jiehao, 7852402

  REMARKS: To define an abstract superclass for Player class and InteractivePlayer class.
=end
class AbstractPlayers
  
=begin
  AbstractPlayers.new
      
  PURPOSE: to override the "new" method to disallow creating instances of this class.
  PARAMETERS:
    *args: any parameters.
=end 
  def AbstractPlayers.new(*args)
    if (self == AbstractPlayers)
      raise "AbstractPlayers is an abstract class and cannot be instantiated. "
    else
      super
    end
  end
  
end