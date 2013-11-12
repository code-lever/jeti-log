require 'spec_helper'

describe Jeti::Log::Data::MGPSData do

  subject { described_class.new(25, [41.124, -95.024, 350, 45]) }

  its(:time) { should eql(25) }

  its(:latitude) { should be_within(0.001).of(41.124) }

  its(:longitude) { should be_within(0.001).of(-95.024) }

  its(:altitude) { should be_within(0.01).of(114.83) }

  it 'should provide altitude to meters' do
    expect(subject.altitude(:meters)).to be_within(0.01).of(350)
  end

  its(:course) { should eql(45) }

end
