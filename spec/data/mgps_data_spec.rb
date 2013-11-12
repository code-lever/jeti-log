require 'spec_helper'

describe Jeti::Log::Data::MGPSData do

  subject { described_class.new(25, [150, 41.124, -95.024, 1, 8, 350, 5000, 15, 25,
                                     45, 35, 0, 250, Date.new(2013, 1, 1)]) }

  its(:time) { should eql(25) }

  its(:stamp) { should eql(150) }

  its(:latitude) { should be_within(0.001).of(41.124) }

  its(:longitude) { should be_within(0.001).of(-95.024) }

  its(:quality) { should eql(1) }

  its(:satellite_count) { should eql(8) }

  its(:altitude) { should be_within(0.01).of(350) }

  it 'should provide altitude in feet' do
    expect(subject.altitude(:feet)).to be_within(0.01).of(114.83)
  end

  its(:distance) { should be_within(0.01).of(5000) }

  it 'should provide distance in feet' do
    expect(subject.distance(:feet)).to be_within(0.01).of(1640.42)
  end

  its(:speed) { should be_within(0.01).of(15) }

  it 'should provide speed in mph' do
    expect(subject.speed(:mph)).to be_within(0.01).of(33.55)
  end

  its(:relative_altitude) { should be_within(0.01).of(25) }

  it 'should provide relative altitude in feet' do
    expect(subject.relative_altitude(:feet)).to be_within(0.01).of(8.20)
  end

  its(:course) { should eql(45) }

  its(:azimuth) { should eql(35) }

  its(:impulse) { should eql(0) }

  its(:trip) { should be_within(0.01).of(250) }

  it 'should provide trip in feet' do
    expect(subject.trip(:feet)).to be_within(0.01).of(82.02)
  end

  its(:date) { should eql(Date.new(2013, 1, 1)) }

end
