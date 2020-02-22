class Airport
  DEFAULT_CAPACITY = 4

  attr_accessor :hanger, :capacity
  attr_reader :name
  
  def initialize(name:, capacity: DEFAULT_CAPACITY)
    @hanger = []
    @name = name
    @capacity = capacity
  end

  def land_plane(plane)
    raise "Stormy, you can't land...go to a non stormy country" if is_stormy?
    raise "cannot land plane, hanger full" if is_full?
    store_plane(plane)
    
  end

  def store_plane(plane)
    @hanger.push(plane)
  end

  def take_off_plane(flight_number)
    raise "it's stormy. Have a sit in the airport lounge until the storm clears off" if is_stormy?
    @hanger.map.with_index { |plane, i|
      if plane[:flight_number] == flight_number
        takeoff_message(plane)
        return @hanger.delete_at(i) 
      end
    }
    exceptions
  end

  def exceptions
    raise "plane does not exist in the hanger to take off" if @hanger.length > 0
    raise "no planes to take off"
  end

  def takeoff_message(plane)
    puts "Welcome on board to #{plane[:airline]}. We are about to take off to #{plane[:next_takeoff_destination]}. We hope you have a pleasant journey and thank you for choosing #{plane[:airline]}"
  end

  def is_stormy?
    rand(4) == 1
  end

  def is_full?
    @hanger.length >= capacity ? true : false;
  end
end