require 'csv'

# id,email,time_zone,status,created_at,confirmed_at,tags,campaign_names,referrer,landing_url,ip_address,lead_score,lifetime_value,user_id,ab_bucket,imported_at,json_shopify_domain,json_user_id,landing_page,medium,name,rci_shopify_domain,rci_user_id,rcn_shopify_domain,rcn_user_id,replies,seg_shopify_domain,seg_user_id,shopify_domain,source,sticky_shopify_domain,sticky_user_id,tag_0,tag_1,tags,utc_offset

class ConvertKitMigration
  def self.tags_from_drip
    tags = []

    CSV.foreach("drip/subscribers.csv") do | row|
      tags += row[6].split(',')
    end

    # Unique
    tags.uniq!
    # Add our new tracking tag
    tags << "import-drip"
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
end
