require "airport"

shared_context "common airport" do
    let(:airport) {described_class.new({name: "Gatwick", capacity: 5})}
    let(:default_capacity) {4}
    let(:plane_klass) {instance_double(Plane, {flight_details: {airline: "Qatar Airways", flight_number: "QA101", next_takeoff_destination:"Tokyo"}})}
    let(:flight_details) {plane_klass.flight_details}
    let(:no_storm) { allow(airport).to receive(:is_stormy?).and_return(false)}
    let(:stormy) {allow(airport).to receive(:is_stormy?).and_return(true)}
end

describe Airport do
  include_context "common airport"

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

  describe "method functionality - " do
    context "hanger state change" do
      it "store_plane should push plane into hanger array" do
        no_storm
        expect{airport.store_plane(flight_details)}.to change{airport.hanger.length}.by(1) 
      end

      it "hanger array includes 1 flight detail" do
        no_storm
        airport.land_plane(flight_details)
        expect(airport.hanger).to include(flight_details)
      end

      it "#is_stormy should return true or false" do
        expect(airport.is_stormy?).to eq(true).or eq(false)
      end
    end
    context "#take_off_plane" do
      it "should remove plane from hanger array" do
        no_storm
        flight_number_to_take_off = "TH101"
        airport.land_plane(flight_details)
        expect{airport.take_off_plane("QA101")}.to change{airport.hanger.length}.by(-1)
      end

      it "will no longer have the plane in hanger" do
        no_storm
        airport.land_plane(flight_details)
        airport.take_off_plane("QA101")
        expect(airport.hanger).to_not include(flight_details)
      end

      it "land 3 planes and only allow the 2nd plane to take off" do
        no_storm
        def generate_flight(airline:, flight_number:, next_takeoff_destination:)
          plane = plane_klass
          allow(plane).to receive(:flight_details).and_return({airline: airline, flight_number: flight_number, next_takeoff_destination: next_takeoff_destination})
          return plane
        end
        
        plane_one = flight_details
        airport.land_plane(plane_one)

        plane_two = generate_flight({airline: "Thai Airways", flight_number: "TH101", next_takeoff_destination:"Bangkok"})
        airport.land_plane(plane_two.flight_details)

        plane_three = generate_flight({airline: "Etihad Airways", flight_number: "ET101", next_takeoff_destination:"Dubai"})
        airport.land_plane(plane_three.flight_details)
        
        airport.take_off_plane("TH101")
        expect(airport.hanger).not_to include({airline: "Thai Airways", flight_number: "TH101", next_takeoff_destination:"Bangkok"})
      end
    end
  end
  context "raise_error functionality - " do
    it "prevent #land_plane if airport capacity is full" do
      no_storm
      allow(airport).to receive(:is_full?).and_return(true)
      expect{airport.land_plane(flight_details)}.to raise_error("cannot land plane, hanger full")
    end

    it "prevent take off if stormy and raises error" do
      no_storm
      airport.land_plane(flight_details)
      stormy
      expect{airport.take_off_plane("QA101")}.to raise_error("it's stormy. Have a sit in the airport lounge until the storm clears off")
    end

    it "raises error when planes are in the hanger but user attempts to take off a plane that is not included in the hanger" do
      no_storm
      airport.land_plane(flight_details)
      expect{airport.take_off_plane("JAL101")}.to raise_error("plane does not exist in the hanger to take off")
    end

    it "raises error when no planes are in the hanger" do
      no_storm
      expect{airport.take_off_plane("TH101")}.to raise_error("no planes to take off")
    end

    it "#land_plane prevents landing if stormy and raises error" do
      stormy
      expect{airport.land_plane(flight_details)}.to raise_error("Stormy, you can't land...go to a non stormy country")
    end
    
    it "#land_plane throws error if a hash is not passed as argument" do
      expect{airport.land_plane("hi")}.to raise_error("please enter a plane")
    end
  end
end