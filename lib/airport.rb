class Airport
  attr_accessor :hanger, :capacity
  attr_reader :name

  def initialize(name:, capacity: 4)
    @hanger = []
    @name = name
    @capacity = capacity
  end

  def land_plane(plane)
    raise "cannot land plane, hanger full" if is_full?
    store_plane(plane)
    
  end

  def store_plane(plane)
    @hanger.push(plane)
  end

  def take_off_plane(flight_number)
    @hanger.map.with_index {
      |plane, i|
      if plane[:flight_number] == flight_number
        return @hanger.delete_at(i) 
      end
    }
    raise "no planes to take off"
  end

  def is_stormy?
    rand(4) == 1
  end

  def is_full?
    @hanger.length >= capacity ? true : false;
  end
end