require 'spec_helper'

describe Jeti::Log::Data::RxData do

  subject { described_class.new(150, [7.89, 9, 8, 89]) }

  its(:time) { should eql(150) }

  its(:voltage) { should be_within(0.1).of(7.89) }

  its(:antenna1) { should eql(9) }

  its(:antenna2) { should eql(8) }

  its(:quality) { should eql(89) }

end
