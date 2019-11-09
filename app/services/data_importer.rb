require 'csv'

class DataImporter
  FILE_LOCATION = "#{Rails.root}/data/holding-list.csv"

  class << self
    def run
      data_for_rails_model.map do |item_data|
        holding = Holding.new(item_data)
        if holding.save
          holding
        else
          log_holding_errors(item_data, holding)
          nil
        end
      end
    end

    private

    def data_from_file
      CSV.read(FILE_LOCATION, headers: true)
    end

    def data_for_rails_model
      data_from_file.map do |item|
        make_attribute_names_lowercase_and_underscored(item.to_hash)
      end
    end

    def make_attribute_names_lowercase_and_underscored(item)
      item.transform_keys do |key|
        key.downcase.gsub(' ', '_').to_sym
      end
    end

    def log_holding_errors(item_data, holding)
      Rails.logger.warn(
        "CSV row beginning with \"#{item_data.first}\" was not imported because the data is invalid.\n" +
        "Here are the error messages: #{holding.errors.full_messages.join("\n")}"
      )
    end
  end
end
