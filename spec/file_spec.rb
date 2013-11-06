require 'spec_helper'

describe Jeti::Log::File do

  context 'with data file 1min-tx-rx.log' do

    before(:all) { @file = Jeti::Log::File.new(data_file('1min-tx-rx.log')) }

    subject { @file }

    its(:duration) { should be_within(1.0).of(60.0) }

    its(:antenna1_signals?) { should be_true }

    it { should have(115).antenna1_signals }

    it 'should have some select antenna1 signals' do
      expect(subject.antenna1_signals[0]).to eql([1073617, 9])
      expect(subject.antenna1_signals[50]).to eql([1099599, 9])
      expect(subject.antenna1_signals[100]).to eql([1125599, 9])
    end

    its(:antenna2_signals?) { should be_true }

    it { should have(115).antenna2_signals }

    it 'should have some select antenna2 signals' do
      expect(subject.antenna1_signals[10]).to eql([1078799, 9])
      expect(subject.antenna1_signals[60]).to eql([1104817, 9])
      expect(subject.antenna1_signals[90]).to eql([1120425, 9])
    end

    its(:rx_voltages?) { should be_true }

    it { should have(115).rx_voltages }

    it 'should have some select rx voltages' do
      expect(subject.rx_voltages[10]).to eql([1078799, 4.71])
      expect(subject.rx_voltages[60]).to eql([1104817, 4.7])
      expect(subject.rx_voltages[90]).to eql([1120425, 4.71])
    end

    its(:signal_qualities?) { should be_true }

    it { should have(115).signal_qualities }

    it 'should have some select signal qualities' do
      expect(subject.signal_qualities[10]).to eql([1078799, 100])
      expect(subject.signal_qualities[60]).to eql([1104817, 100])
      expect(subject.signal_qualities[90]).to eql([1120425, 100])
    end

    its(:mgps_locations?) { should be_false }

  end

  context 'with data file gps-crash.log' do

    before(:all) { @file = Jeti::Log::File.new(data_file('gps-crash.log')) }

    subject { @file }

    its(:duration) { should be_within(0.1).of(286.2) }

    its(:antenna1_signals?) { should be_true }

    it { should have(553).antenna1_signals }

    it 'should have some select antenna1 signals' do
      expect(subject.antenna1_signals[0]).to eql([219714, 9])
      expect(subject.antenna1_signals[50]).to eql([244741, 9])
      expect(subject.antenna1_signals[100]).to eql([270738, 9])
    end

    its(:antenna2_signals?) { should be_true }

    it { should have(553).antenna2_signals }

    it 'should have some select antenna2 signals' do
      expect(subject.antenna1_signals[10]).to eql([223938, 9])
      expect(subject.antenna1_signals[60]).to eql([249938, 9])
      expect(subject.antenna1_signals[90]).to eql([265538, 9])
    end

    its(:rx_voltages?) { should be_true }

    it { should have(553).rx_voltages }

    it 'should have some select rx voltages' do
      expect(subject.rx_voltages[10]).to eql([223938, 4.69])
      expect(subject.rx_voltages[60]).to eql([249938, 4.69])
      expect(subject.rx_voltages[90]).to eql([265538, 4.69])
    end

    its(:signal_qualities?) { should be_true }

    it { should have(553).signal_qualities }

    it 'should have some select signal qualities' do
      expect(subject.signal_qualities[10]).to eql([223938, 100])
      expect(subject.signal_qualities[60]).to eql([249938, 100])
      expect(subject.signal_qualities[90]).to eql([265538, 100])
    end

    its(:mgps_locations?) { should be_true }

    it { should have(539).mgps_locations }

    it 'should have some select gps locations' do
      locs = subject.mgps_locations
      loc0 = locs[0]
      expect(loc0[0]).to eql(219552)
      expect(loc0[1][:latitude]).to be_within(0.0001).of(41.1856)
      expect(loc0[1][:longitude]).to be_within(0.0001).of(-96.0103)
      expect(loc0[1][:altitude]).to be_within(0.1).of(309)
      expect(loc0[1][:course]).to be_within(0.1).of(0)
    end

  end

  it 'should raise for invalid or missing files' do
    files = invalid_data_files
    files.should have(9).files

    files.each do |f|
      expect { Jeti::Log::File.new(f) }.to raise_error
    end
  end

end
