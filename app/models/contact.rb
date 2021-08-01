class Contact < ApplicationRecord

  # def self.import(file)
  #   CSV.foreach(file.path, headers: true,header_converters: :symbol) do |row|
  #     contact = find_by(fist_name: row["fist_name"]) || new
  #     contact.attributes = row.to_hash
  #     # Contact.create! row.to_hash.delete_if { |k, _| k.blank? }
  #     contact.save!
  #   end
  # end

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      # contact = find_by_id(row["id"]) || new
      contact = find_by(first_name: row["first_name"]) || new
      contact.attributes = row.to_hash
      # Contact.create! row.to_hash.delete_if { |k, _| k.blank? }
      contact.save! 
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    # when ".csv" then Roo::CSV.new(file.path, file_warning: :ignore)
    when ".xls" then Roo::Excel.new(file.path, file_warning: :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, file_warning: :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
end
