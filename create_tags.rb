require_relative 'convert_kit_migration'

tags = ConvertKitMigration.tags_from_drip
ConvertKitMigration.create_missing_tags(tags)

puts tags
