require 'spec_helper'

describe Jeti::Log::File do

  context 'with data file 1min-tx-rx.log' do

    before(:all) { @file = Jeti::Log::File.new(data_file('1min-tx-rx.log')) }

    subject { @file }

    its(:name) { should eql('Flame Wheel') }

    its(:duration) { should be_within(1.0).of(60.0) }

    its(:rx_data?) { should be true }

    its(:mgps_data?) { should be false }

    its(:to_kml?) { should be false }

    specify { expect { subject.to_kml }.to raise_error }

    specify { expect { subject.to_kml_file }.to raise_error }

    specify { expect { subject.to_kml_placemark }.to raise_error }

  end

  context 'with data file gps-crash.log' do

    before(:all) { @file = Jeti::Log::File.new(data_file('gps-crash.log')) }

    subject { @file }

    its(:name) { should eql('Flame Wheel') }

    its(:duration) { should be_within(0.1).of(286.2) }

    its(:rx_data?) { should be true }

    it { is_expected.to have(553).rx_data }

    it 'should have some select rx data' do
      d = subject.rx_data[0]
      expect(d.antenna1).to eql(9)
      expect(d.antenna2).to eql(9)
      expect(d.quality).to eql(100)
      expect(d.voltage).to be_within(0.1).of(4.7)

      d = subject.rx_data[100]
      expect(d.antenna1).to eql(9)
      expect(d.antenna2).to eql(9)
      expect(d.quality).to eql(100)
      expect(d.voltage).to be_within(0.1).of(4.7)

      d = subject.rx_data[400]
      expect(d.antenna1).to eql(5)
      expect(d.antenna2).to eql(4)
      expect(d.quality).to eql(96)
      expect(d.voltage).to be_within(0.1).of(4.7)
    end

    its(:mgps_data?) { should be true }

    it { is_expected.to have(539).mgps_data }

    it 'should have some select gps information' do
      loc = subject.mgps_data[0]
      expect(loc.time).to eql(219552)
      expect(loc.latitude).to be_within(0.0001).of(41.1856)
      expect(loc.longitude).to be_within(0.0001).of(-96.0103)
      expect(loc.altitude(:meters)).to eql(309)
      expect(loc.course).to eql(0)
      expect(loc.satellite_count).to eql(8)

      loc = subject.mgps_data[250]
      expect(loc.time).to eql(347038)
      expect(loc.latitude).to be_within(0.0001).of(41.1868)
      expect(loc.longitude).to be_within(0.0001).of(-96.0094)
      expect(loc.altitude(:meters)).to eql(352)
      expect(loc.course).to eql(294)
      expect(loc.satellite_count).to eql(9)

      loc = subject.mgps_data[450]
      expect(loc.time).to eql(456409)
      expect(loc.latitude).to be_within(0.0001).of(41.1871)
      expect(loc.longitude).to be_within(0.0001).of(-96.0091)
      expect(loc.altitude(:meters)).to eql(333)
      expect(loc.course).to eql(0)
      expect(loc.satellite_count).to eql(9)
    end

    its(:mezon_data?) { should be false }

    its(:to_kml?) { should be true }

    its(:to_kml) { should be_a(String) }

    its(:to_kml_file) { should be_a(KMLFile) }

    it 'should take options for file and placemark' do
      kml = subject.to_kml_file({ :name => 'File Name' }, { :name => 'Placemark Name' })
      expect(kml.objects[0].name).to eql('File Name')
      expect(kml.objects[0].features[0].name).to eql('Placemark Name')
    end

    its(:to_kml_placemark) { should be_a(KML::Placemark) }

  end

  context 'with data file mezon-1.log' do

    before(:all) { @file = Jeti::Log::File.new(data_file('mezon-1.log')) }

    subject { @file }

    its(:name) { should eql('Goblin 700') }

    its(:duration) { should be_within(0.1).of(9.2) }

    its(:rx_data?) { should be true }

    its(:mgps_data?) { should be false }

    its(:mezon_data?) { should be true }

    it 'should have some select mezon data' do
      d = subject.mezon_data[0]
      expect(d.battery_current).to be_within(0.1).of(0)
      expect(d.battery_voltage).to be_within(0.1).of(22.9)
      expect(d.bec_current).to be_within(0.1).of(0.1)
      expect(d.bec_voltage).to be_within(0.1).of(5.5)

      d = subject.mezon_data[35]
      expect(d.battery_current).to be_within(0.1).of(0)
      expect(d.battery_voltage).to be_within(0.1).of(22.9)
      expect(d.bec_current).to be_within(0.1).of(0.1)
      expect(d.bec_voltage).to be_within(0.1).of(5.5)

      d = subject.mezon_data[60]
      expect(d.battery_current).to be_within(0.1).of(0)
      expect(d.battery_voltage).to be_within(0.1).of(22.9)
      expect(d.bec_current).to be_within(0.1).of(0.1)
      expect(d.bec_voltage).to be_within(0.1).of(5.5)
    end

    its(:to_kml?) { should be false }

    specify { expect { subject.to_kml }.to raise_error }

    specify { expect { subject.to_kml_file }.to raise_error }

    specify { expect { subject.to_kml_placemark }.to raise_error }

  end

  context 'with data file mezon-2.log' do

    before(:all) { @file = Jeti::Log::File.new(data_file('mezon-2.log')) }

    subject { @file }

    its(:name) { should eql('Goblin 700') }

    its(:duration) { should be_within(0.1).of(43.6) }

    its(:rx_data?) { should be true }

    its(:mgps_data?) { should be false }

    its(:mezon_data?) { should be true }

    it 'should have some select mezon data' do
      d = subject.mezon_data[0]
      expect(d.battery_current).to be_within(0.1).of(0)
      expect(d.battery_voltage).to be_within(0.1).of(46.2)
      expect(d.bec_current).to be_within(0.1).of(0.1)
      expect(d.bec_voltage).to be_within(0.1).of(5.5)
      expect(d.temperature(:c)).to be_within(0.1).of(17)
      expect(d.temperature(:f)).to be_within(0.1).of(62.6)

      d = subject.mezon_data[20]
      expect(d.battery_current).to be_within(0.1).of(0)
      expect(d.battery_voltage).to be_within(0.1).of(46.2)
      expect(d.bec_current).to be_within(0.1).of(0.1)
      expect(d.bec_voltage).to be_within(0.1).of(5.5)
      expect(d.temperature(:c)).to be_within(0.1).of(17)
      expect(d.temperature(:f)).to be_within(0.1).of(62.6)

      d = subject.mezon_data[220]
      expect(d.battery_current).to be_within(0.1).of(0)
      expect(d.battery_voltage).to be_within(0.1).of(46.1)
      expect(d.bec_current).to be_within(0.1).of(0.1)
      expect(d.bec_voltage).to be_within(0.1).of(5.5)
      expect(d.temperature(:c)).to be_within(0.1).of(16)
      expect(d.temperature(:f)).to be_within(0.1).of(60.8)
    end

    its(:to_kml?) { should be false }

    specify { expect { subject.to_kml }.to raise_error }

    specify { expect { subject.to_kml_file }.to raise_error }

    specify { expect { subject.to_kml_placemark }.to raise_error }

  end

  context 'with data file mezon-3.log' do

    before(:all) { @file = Jeti::Log::File.new(data_file('mezon-3.log')) }

    subject { @file }

    its(:name) { should eql('Goblin 700') }

    its(:duration) { should be_within(1).of(371) }

    its(:rx_data?) { should be true }

    its(:mgps_data?) { should be false }

    its(:mezon_data?) { should be true }

    it 'should have some select mezon data' do
      d = subject.mezon_data[0]
      expect(d.time).to eql(180401)
      expect(d.battery_current).to eql(0)
      expect(d.battery_voltage).to be_within(0.1).of(49.8)
      expect(d.bec_current).to be_within(0.1).of(0.0)
      expect(d.bec_voltage).to be_within(0.1).of(5.5)
      expect(d.temperature(:c)).to be_within(0.1).of(21)
      expect(d.temperature(:f)).to be_within(0.1).of(69.8)
      expect(d.capacity).to eql(0)
      expect(d.rpm).to eql(0)
      expect(d.run_time).to eql(0)
      expect(d.pwm).to eql(0)

      d = subject.mezon_data[200]
      expect(d.time).to eql(200528)
      expect(d.battery_current).to eql(5)
      expect(d.battery_voltage).to be_within(0.1).of(49.4)
      expect(d.bec_current).to be_within(0.1).of(0.0)
      expect(d.bec_voltage).to be_within(0.1).of(5.5)
      expect(d.temperature(:c)).to be_within(0.1).of(23)
      expect(d.temperature(:f)).to be_within(0.1).of(73.4)
      expect(d.capacity).to eql(10)
      expect(d.rpm).to eql(1732)
      expect(d.run_time).to eql(14)
      expect(d.pwm).to eql(26)

      d = subject.mezon_data[500]
      expect(d.time).to eql(230044)
      expect(d.battery_current).to eql(9)
      expect(d.battery_voltage).to be_within(0.1).of(48.6)
      expect(d.bec_current).to be_within(0.1).of(0.0)
      expect(d.bec_voltage).to be_within(0.1).of(5.5)
      expect(d.temperature(:c)).to be_within(0.1).of(25)
      expect(d.temperature(:f)).to be_within(0.1).of(77)
      expect(d.capacity).to eql(81)
      expect(d.rpm).to eql(2543)
      expect(d.run_time).to eql(44)
      expect(d.pwm).to eql(88)

      d = subject.mezon_data[1000]
      expect(d.time).to eql(279377)
      expect(d.battery_current).to eql(9)
      expect(d.battery_voltage).to be_within(0.1).of(48.2)
      expect(d.bec_current).to be_within(0.1).of(0.0)
      expect(d.bec_voltage).to be_within(0.1).of(5.5)
      expect(d.temperature(:c)).to be_within(0.1).of(28)
      expect(d.temperature(:f)).to be_within(0.1).of(82.4)
      expect(d.capacity).to eql(206)
      expect(d.rpm).to eql(2522)
      expect(d.run_time).to eql(93)
      expect(d.pwm).to eql(88)

      d = subject.mezon_data[1500]
      expect(d.time).to eql(328599)
      expect(d.battery_current).to eql(9)
      expect(d.battery_voltage).to be_within(0.1).of(47.9)
      expect(d.bec_current).to be_within(0.1).of(0.0)
      expect(d.bec_voltage).to be_within(0.1).of(5.5)
      expect(d.temperature(:c)).to be_within(0.1).of(31)
      expect(d.temperature(:f)).to be_within(0.1).of(87.8)
      expect(d.capacity).to eql(329)
      expect(d.rpm).to eql(2516)
      expect(d.run_time).to eql(142)
      expect(d.pwm).to eql(88)
    end

    its(:to_kml?) { should be false }

    specify { expect { subject.to_kml }.to raise_error }

    specify { expect { subject.to_kml_file }.to raise_error }

    specify { expect { subject.to_kml_placemark }.to raise_error }

  end

  context 'with data file mui-50.log' do

    before(:all) { @file = Jeti::Log::File.new(data_file('mui-50.log')) }

    subject { @file }

    its(:name) { should eql('Flame Wheel') }

    its(:duration) { should be_within(1).of(245) }

    its(:rx_data?) { should be true }

    its(:mgps_data?) { should be false }

    its(:mezon_data?) { should be false }

    its(:mui_data?) { should be true }

    it 'should have some select mui data' do
      d = subject.mui_data[0]
      expect(d.time).to eql(204719)
      expect(d.current).to be_within(0.1).of(10.8)
      expect(d.voltage).to be_within(0.1).of(11.8)
      expect(d.capacity).to eql(108)
      expect(d.run_time).to eql(189)

      d = subject.mui_data[500]
      expect(d.time).to eql(315730)
      expect(d.current).to be_within(0.1).of(15.9)
      expect(d.voltage).to be_within(0.1).of(10.9)
      expect(d.capacity).to eql(709)
      expect(d.run_time).to eql(300)

      d = subject.mui_data[1000]
      expect(d.time).to eql(426258)
      expect(d.current).to be_within(0.1).of(8.6)
      expect(d.voltage).to be_within(0.1).of(10.9)
      expect(d.capacity).to eql(1324)
      expect(d.run_time).to eql(411)
    end

    its(:to_kml?) { should be false }

    specify { expect { subject.to_kml }.to raise_error }

    specify { expect { subject.to_kml_file }.to raise_error }

    specify { expect { subject.to_kml_placemark }.to raise_error }

  end

  context 'with data file tx-controls.log' do

    before(:all) { @file = Jeti::Log::File.new(data_file('tx-controls.log')) }

    subject { @file }

    its(:name) { should eql('Blade 130X') }

    its(:duration) { should be_within(1).of(19) }

  end

  context 'with data file no-comments.log' do

    before(:all) { @file = Jeti::Log::File.new(data_file('no-comments.log')) }

    subject { @file }

    its(:name) { should eql('Unknown') }

  end

  context 'with data file sharp-in-comments.log' do

    before(:all) { @file = Jeti::Log::File.new(data_file('sharp-in-comments.log')) }

    subject { @file }

    its(:name) { should eql('Quad #4') }

  end

  it 'should raise for invalid or missing files' do
    files = invalid_data_files
    expect(files).to have(9).files

    files.each do |f|
      expect { Jeti::Log::File.new(f) }.to raise_error
    end
  end

  describe '#jeti?' do

    it 'should be false for invalid or missing files' do
      files = invalid_data_files
      expect(files).to have(9).files

      files.each do |f|
        expect(Jeti::Log::File.jeti?(f)).to be_falsey
      end
    end

    it 'should be true for valid files' do
      files = data_files
      expect(files).to have(10).files

      files.each do |f|
        expect(Jeti::Log::File.jeti?(f)).to be_truthy
      end
    end

    it 'should return a file object' do
      expect(Jeti::Log::File.jeti?(data_files[0])).to be_a(Jeti::Log::File)
    end

    it 'should return nil when invalid' do
      expect(Jeti::Log::File.jeti?(invalid_data_files[0])).to be_nil
    end

  end

end
