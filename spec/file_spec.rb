require 'spec_helper'

describe Jeti::Log::File do

  describe '#new' do

    context 'with data file 1min-tx-rx.log' do

      before(:all) { @file = Jeti::Log::File.new(data_file('1min-tx-rx.log')) }

      subject { @file }

      its(:duration) { should be_within(1.0).of(60.0) }

      its(:rx_voltages?) { should be_true }

      it { should have(115).rx_voltages }

#      it { should have(16187).entries }

#      it { should have(16187).messages }

    end

    it 'should raise for invalid or missing files' do
      files = invalid_data_files
      files.should have(9).files

      files.each do |f|
        expect { Jeti::Log::File.new(f) }.to raise_error
      end
    end

  end

end
