require 'rubygems'
require 'bundler/setup'
require 'dotenv/load'
require 'pry'
require 'csv'
require 'convertkit'

Convertkit.configure do |config|
  config.api_secret = ENV["CONVERT_KIT_API_SECRET"]
  config.api_key = ENV["CONVERT_KIT_API_KEY"]
end


# id,email,time_zone,status,created_at,confirmed_at,tags,campaign_names,referrer,landing_url,ip_address,lead_score,lifetime_value,user_id,ab_bucket,imported_at,json_shopify_domain,json_user_id,landing_page,medium,name,rci_shopify_domain,rci_user_id,rcn_shopify_domain,rcn_user_id,replies,seg_shopify_domain,seg_user_id,shopify_domain,source,sticky_shopify_domain,sticky_user_id,tag_0,tag_1,tags,utc_offset

class ConvertKitMigration
  def self.sequences_from_drip
    seq = []

    CSV.foreach("drip/subscribers.csv", headers: :first_row) do |row|
      seq += row[7].split(',')
    end

    # Unique
    seq.uniq!
    # # Remove test tags
    # tags.reject! {|tag| tag.match(/\Atest\Z/) }
    # # Remove visit tags
    # tags.reject! {|tag| tag.include?("visit") }
    # # Content upgrade with [ ]s
    # tags.reject! {|tag| tag.include?("[Content upgrade]") }
    # # Read
    # tags.reject! {|tag| tag.include?("Read - ") }
    # tags.reject! {|tag| tag.include?("Read") }
    # # Visit titles that got split oddly
    # tags.reject! {|tag| tag.match(/^ /) }
    # # Old SEG
    # tags.reject! {|tag| tag.include?("SEG") }
    # # Testing tags
    # tags.reject! {|tag| tag.include?("data-test") }

    return seq.sort
  end

  def self.tags_from_drip
    tags = []

    CSV.foreach("drip/subscribers.csv", headers: :first_row) do |row|
      tags += row[6].split(',')
    end

    # Unique
    tags.uniq!
    # Add our new tracking tag
    tags << "import-drip"
    # Remove test tags
    tags.reject! {|tag| tag.match(/\Atest\Z/) }
    # Remove visit tags
    tags.reject! {|tag| tag.include?("visit") }
    # Content upgrade with [ ]s
    tags.reject! {|tag| tag.include?("[Content upgrade]") }
    # Read
    tags.reject! {|tag| tag.include?("Read - ") }
    tags.reject! {|tag| tag.include?("Read") }
    # Visit titles that got split oddly
    tags.reject! {|tag| tag.match(/^ /) }
    # Old SEG
    tags.reject! {|tag| tag.include?("SEG") }
    # Testing tags
    tags.reject! {|tag| tag.include?("data-test") }

    return tags.sort
  end

  def self.create_missing_tags(tags_to_create)
    client = Convertkit::Client.new
    response = client.tags
    if response.success?
      current_tags = response.body["tags"].collect {|t| t["name"] }
      if current_tags.empty?
        raise
      else
        missing_tags = tags_to_create - current_tags
        if missing_tags.empty?
          # No-op: no tags needed
        else
          client.create_tags(missing_tags)
        end
      end
    else
      raise
    end

  end
end
