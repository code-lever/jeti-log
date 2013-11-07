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

    its(:to_kml?) { should be_false }

    specify { expect { subject.to_kml }.to raise_error }

    specify { expect { subject.to_kml_file }.to raise_error }

    specify { expect { subject.to_kml_placemark }.to raise_error }

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
      loc = subject.mgps_locations[0]
      expect(loc.time).to eql(219552)
      expect(loc.latitude).to be_within(0.0001).of(41.1856)
      expect(loc.longitude).to be_within(0.0001).of(-96.0103)
      expect(loc.altitude(:meters)).to eql(309)
      expect(loc.course).to eql(0)

      loc = subject.mgps_locations[250]
      expect(loc.time).to eql(347038)
      expect(loc.latitude).to be_within(0.0001).of(41.1868)
      expect(loc.longitude).to be_within(0.0001).of(-96.0094)
      expect(loc.altitude(:meters)).to eql(352)
      expect(loc.course).to eql(294)

      loc = subject.mgps_locations[450]
      expect(loc.time).to eql(456409)
      expect(loc.latitude).to be_within(0.0001).of(41.1871)
      expect(loc.longitude).to be_within(0.0001).of(-96.0091)
      expect(loc.altitude(:meters)).to eql(333)
      expect(loc.course).to eql(0)
    end

    its(:to_kml?) { should be_true }

    its(:to_kml) { should be_a(String) }

    its(:to_kml_file) { should be_a(KMLFile) }

    it 'should take options for file and placemark' do
      kml = subject.to_kml_file({ :name => 'File Name' }, { :name => 'Placemark Name' })
      kml.objects[0].name.should eql('File Name')
      kml.objects[0].features[0].name.should eql('Placemark Name')
    end

    its(:to_kml_placemark) { should be_a(KML::Placemark) }

  end

  context 'with data file mezon-1.log' do

    before(:all) { @file = Jeti::Log::File.new(data_file('mezon-1.log')) }

    subject { @file }

    its(:duration) { should be_within(0.1).of(9.2) }

    its(:antenna1_signals?) { should be_true }

    its(:antenna2_signals?) { should be_true }

    its(:bec_voltages?) { should be_true }

    it 'should have some select bec voltages' do
      expect(subject.bec_voltages[0]).to eql([1009713, 5.5])
      expect(subject.bec_voltages[10]).to eql([1012219, 5.5])
      expect(subject.bec_voltages[35]).to eql([1018579, 5.5])
    end

    its(:esc_voltages?) { should be_true }

    it 'should have some select esc voltages' do
      expect(subject.esc_voltages[0]).to eql([1009713, 22.9])
      expect(subject.esc_voltages[10]).to eql([1011179, 22.9])
      expect(subject.esc_voltages[50]).to eql([1016099, 22.9])
      expect(subject.esc_voltages[60]).to eql([1017179, 22.9])
    end

    its(:esc_temperatures?) { should be_true }

    its(:rx_voltages?) { should be_true }

    its(:signal_qualities?) { should be_true }

    its(:mgps_locations?) { should be_false }

    its(:to_kml?) { should be_false }

    specify { expect { subject.to_kml }.to raise_error }

    specify { expect { subject.to_kml_file }.to raise_error }

    specify { expect { subject.to_kml_placemark }.to raise_error }

  end

  context 'with data file mezon-2.log' do

    before(:all) { @file = Jeti::Log::File.new(data_file('mezon-2.log')) }

    subject { @file }

    its(:duration) { should be_within(0.1).of(43.6) }

    its(:antenna1_signals?) { should be_true }

    its(:antenna2_signals?) { should be_true }

    its(:bec_voltages?) { should be_true }

    it 'should have some select bec voltages' do
      expect(subject.bec_voltages[0]).to eql([304210, 5.5])
      expect(subject.bec_voltages[10]).to eql([306719, 5.5])
      expect(subject.bec_voltages[50]).to eql([316519, 5.5])
      expect(subject.bec_voltages[120]).to eql([333722, 5.5])
    end

    its(:esc_voltages?) { should be_true }

    it 'should have some select esc voltages' do
      expect(subject.esc_voltages[0]).to eql([304210, 46.2])
      expect(subject.esc_voltages[10]).to eql([305578, 46.2])
      expect(subject.esc_voltages[50]).to eql([310319, 46.2])
      expect(subject.esc_voltages[160]).to eql([323800, 46.2])
    end

    its(:esc_temperatures?) { should be_true }

    it 'should have some select esc temperatures' do
      expect(subject.esc_temperatures(:c)[0]).to eql([304210, 17])
      expect(subject.esc_temperatures(:f)[0]).to eql([304210, 62.6])
      expect(subject.esc_temperatures(:c)[10]).to eql([310018, 17])
      expect(subject.esc_temperatures(:f)[10]).to eql([310018, 62.6])
      expect(subject.esc_temperatures(:c)[50]).to eql([334623, 16])
      expect(subject.esc_temperatures(:f)[50]).to eql([334623, 60.8])
    end

    its(:rx_voltages?) { should be_true }

    its(:signal_qualities?) { should be_true }

    its(:mgps_locations?) { should be_false }

    its(:to_kml?) { should be_false }

    specify { expect { subject.to_kml }.to raise_error }

    specify { expect { subject.to_kml_file }.to raise_error }

    specify { expect { subject.to_kml_placemark }.to raise_error }

  end

  it 'should raise for invalid or missing files' do
    files = invalid_data_files
    files.should have(9).files

    files.each do |f|
      expect { Jeti::Log::File.new(f) }.to raise_error
    end
  end

end
