require "airport"

shared_context "common" do
    let(:airport) {described_class.new({name: "Gatwick", capacity: 5})}
    let(:default_capacity) {4}
    let(:plane_klass) {instance_double(Plane, {flight_details: {airline: "Qatar Airways", flight_number: "QA101", next_takeoff_destination:"Tokyo"}})}
    let(:flight_details) {plane_klass.flight_details}
end

describe Airport do
  include_context "common"

  describe "has attributes" do
    it "hanger containig an empty array, name of airport and capacity of 5" do
      expect(airport).to have_attributes(hanger: [], name: "Gatwick", capacity: 5)
    end

    it "has default capacity of 10 if capacity is not passed as a keyword argument." do
      airport_no_capacity_specified = described_class.new({name: "Gatwick"})
      expect(airport_no_capacity_specified.capacity).to eq(default_capacity) 
    end
  end


  describe "responds to method" do
    it "#land_plane" do
      expect(airport).to respond_to(:land_plane).with(1).arguments, "create land_plane method with one argument"
    end
    it "#take_off_plane" do
      expect(airport).to respond_to(:take_off_plane).with(1).arguments, "create take_off_plane method"
    end
    it "#is_stormy?" do
      expect(airport).to respond_to(:is_stormy?)
    end
    it "#store_plane" do
      expect(airport).to respond_to(:store_plane).with(1).arguments
    end
    it "#is_full?" do
      expect(airport).to respond_to(:is_full?)
    end
  end

  context "method functionality - " do
    it "store_plane should push plane into hanger array"do
      expect{airport.store_plane(flight_details)}.to change{airport.hanger.length}.by(1) 
    end

    it "hanger array includes 1 flight detail" do
      airport.land_plane(flight_details)
      expect(airport.hanger).to include(flight_details)
    end

    it "take_off_plane should remove plane from hanger array" do
      airport.land_plane(flight_details)
      expect{airport.take_off_plane(flight_details)}.to change{airport.hanger.length}.by(-1)
    end

    it "take_off_plane will no longer have the plane in hanger" do
      airport.land_plane(flight_details)
      airport.take_off_plane(flight_details)
      expect(airport.hanger).to_not include(flight_details)
    end

    it "prevent land_plane if airport capacity is full" do
      plane = "Qatar Airways"
      allow(airport).to receive(:is_full?).and_return(true)
      expect{airport.land_plane(plane)}.to raise_error("cannot land plane, hanger full")
    end

    it "is_stormy should return true or false" do
      expect(airport.is_stormy?).to eq(true).or eq(false)
    end
  end

end