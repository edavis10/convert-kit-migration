require 'csv'
require 'fileutils'
require_relative 'convert_kit_migration'

FileUtils.rm_rf("convert-kit")
FileUtils.mkdir_p("convert-kit")
FileUtils.mkdir_p("convert-kit/by-tag")
FileUtils.mkdir_p("convert-kit/by-sequence")

def export_row(row, tag)
  [
    tag,
    row[1],
    row[2],
    row[8],
    row[9],
    row[10],
    row[16],
    row[17],
    row[20],
    row[21],
    row[22],
    row[30],
    row[31]
  ]
end

def row_headers
  ["current_tag_or_sequence",
   "email",
   "timezone",
   "referrer",
   "landing_url",
   "ip_address",
   "json_shopify_domain",
   "json_user_id",
   "name",
   "rci_shopify_domain",
   "rci_user_id",
   "sticky_shopify_domain",
   "sticky_user_id"
  ]

end

# Remove slashes from the filename
# Map "* installed" to "* install" to match the old event names and new tagname
def tag_name_to_filename(tag)
  tag.gsub("/", " SLASH ").gsub("installed", "install")
end

def export_tag_to_csv(tag)
  tag_csv = CSV.open("convert-kit/by-tag/#{tag_name_to_filename(tag)}.csv", "wb") do |output_csv|
    output_csv << row_headers

    CSV.foreach("drip/subscribers.csv", headers: :first_row) do |row|
      if row[6].include?(tag) || tag == "import-drip"
        if tag.include?("installed")
          # Map "* installed" to "* install" to match the old event names and new tagname
          output_csv << export_row(row, tag.gsub("installed", "install"))
        else
          output_csv << export_row(row, tag)
        end
      end
    end
  end
end

def export_sequence_to_csv(sequence)
  sequence_csv = CSV.open("convert-kit/by-sequence/#{tag_name_to_filename(sequence)}.csv", "wb") do |output_csv|
    output_csv << row_headers

    CSV.foreach("drip/subscribers.csv", headers: :first_row) do |row|
      if row[7].include?(sequence)
        output_csv << export_row(row, sequence)
      end
    end
  end
end



ConvertKitMigration.tags_from_drip.each do |tag|
 puts tag
 export_tag_to_csv(tag)
end


ConvertKitMigration.sequences_from_drip.each do |sequence|
 puts sequence
 export_sequence_to_csv(sequence)
end

