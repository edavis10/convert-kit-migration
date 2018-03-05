require 'csv'
require 'fileutils'
require_relative 'convert_kit_migration'

FileUtils.mkdir_p("convert-kit")

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
["current_tag",
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

def export_tag_to_csv(tag)
  tag_csv = CSV.generate do |output_csv|
    output_csv << row_headers

    CSV.foreach("drip/subscribers.csv") do |row|
      if row[6].include?(tag) || tag == "import_drip"
        output_csv << export_row(row, tag)
      end
    end
  end
end

ConvertKitMigration.tags_from_drip.each do |tag|

  puts export_tag_to_csv(tag)
end
