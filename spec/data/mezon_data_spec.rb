require 'spec_helper'

describe Jeti::Log::Data::MezonData do

  subject { described_class.new(25, [15.1, 5, 5.4, 1, 250, 1000, 25, 150, 99]) }

  its(:time) { should eql(25) }

  its(:battery_voltage) { should be_within(0.1).of(15.1) }

  its(:battery_current) { should be_within(0.1).of(5) }

  its(:bec_voltage) { should be_within(0.1).of(5.4) }

  its(:bec_current) { should be_within(0.1).of(1) }

  its(:capacity) { should eql(250) }

  its(:rpm) { should eql(1000) }

  its(:temperature) { should be_within(0.1).of(25) }

  it 'should convert temperature to F' do
    expect(subject.temperature(:f)).to be_within(0.1).of(77)
  end

  its(:run_time) { should eql(150) }

  its(:pwm) { should eql(99) }

end
