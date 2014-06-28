require 'json'

class Measurements::Cardiogram < ActiveRecord::Base
  include Measurements::Base

  attr_accessible :cardiogram

  validates :cardiogram, :presence => true

  def ecg_file=(file)
    file = file.path if file.respond_to?(:path)
    parsed = ECGParser.new(file).parse
    update_attributes parsed
  end

  def cardiogram(channel=1)
    data =JSON::parse(read_attribute :cardiogram)[channel-1]
    max = 4000
    data.inject([]){|res,n|res<<[res.size*10,max-n];res }
  end

  def cardiogram?(channel=1)
     summ = JSON::parse(read_attribute :cardiogram)[channel-1].inject(:+) rescue nil
     summ > 0 if summ
  end

  class << self
    def from_ECG(file)
      parsed = ECGParser.new(file).parse
      new parsed
    end
  end

  class ECGParser
    def initialize(file)
      if file.is_a? String
        raise "File `#{file}` is not found" unless File.exists?(file)
        file = File.open file
      end

      raise "Only String or IO allowed, `#{file.class}` given" unless file.is_a? IO
      @io = file
    end

    def parse
      params = {}

      header = parse_header @io.read(512)
      params.merge! header.slice(:hpc_mode_length, :qrs_duration, :heart_rate,
        :rhythm_result, :storage_data_type, :rest_unparsed).
        merge(:created_at => "#{header[:year]}-#{header[:month]}-#{header[:day]}T#{header[:hour]}-#{header[:min]}-#{header[:sec]}",
              :filename => "#{header[:filename]}.#{header[:file_extention]}")

      body = parse_body @io

      params.merge :cardiogram => body.to_json
    end

    private

    def parse_header bytes
      parsed = bytes.unpack('aA8a3a4a2a2a2a2a2nnnCCa477')
      keys = [:header, :filename, :file_extention, :year, :month, :day,
        :hour, :min, :sec, :hpc_mode_length, :qrs_duration, :heart_rate,
        :rhythm_result, :storage_data_type, :rest_unparsed]
      Hash[[keys, parsed].transpose]
    end

    def parse_body io
      channels = []
      while bytes = io.read(8)
        channels << bytes.unpack('v4')
      end
      channels.transpose
    end
  end
end
