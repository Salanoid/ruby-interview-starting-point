# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Services::ParseCsvService, method: :call do
  context 'when the request is successful' do
    let(:csv_data) { "Starbucks Seattle,47.61,-122.33\nStarbucks San Francisco,37.77,-122.42" }
    let(:parse_csv_service_instance) { Services::ParseCsvService.new(csv_data) }

    it 'CSV file should include Starbucks' do
      expect(parse_csv_service_instance.call).to be_a(Array)
      expect(parse_csv_service_instance.call.first[:name]).to eq 'Starbucks Seattle'
      expect(parse_csv_service_instance.call.size).to be > 0
      expect(parse_csv_service_instance.call.first).to be_a(Hash)
      expect(parse_csv_service_instance.call.first.keys).to include(:name, :x, :y)
    end
  end

  context 'when CSV contains malformed rows' do
    let(:malformed_csv_data) do
      "Starbucks Seattle,47.61,\n,37.77,-122.42\nStarbucks Seattle2,47.63,-122.4"
    end
    let(:parse_csv_service_instance) { Services::ParseCsvService.new(malformed_csv_data) }

    it 'ignores partially malformed rows' do
      expect(parse_csv_service_instance.call).to eq(
        [
          { name: 'Starbucks Seattle2', y: 47.63, x: -122.4 }
        ]
      )
    end
  end

  context 'when CSV is empty' do
    let(:empty_csv_data) { '' }
    let(:parse_csv_service_instance) { Services::ParseCsvService.new(empty_csv_data) }

    it 'returns an empty array' do
      expect(parse_csv_service_instance.call).to eq([])
    end
  end
end
