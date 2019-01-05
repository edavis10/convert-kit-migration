Migration of subscribers to convert kit.

### Setup

1. Create `.env` file with your convert kit API key and secret

```
export CONVERT_KIT_API_KEY='...'
export CONVERT_KIT_API_SECRET='...'
```

### Import process

1. Add a import-drip tag to CK, useful to track the imported people
2. Consider adding sequence exclusion tags for people who completed campaigns in Drip, that way they aren't emailed again when they are imported.
3. Export your Drip account data
  - All active subscribers, do not use the full **account** export as it's data is bad.
  - Save to `drip/subscribers.csv`
4. Import all tags to CK - `ruby create_tags.rb`
  - Skip Read tags
5. Create CSV exports for each tag and campaign/sequence - `ruby export_to_csv.rb`
  - CSV files for CK are in `convert-kit/[by-tag or by-sequence]`
6. Import the import-drip CSV export to CK which includes all subscribers (`convert-kit/by-tag/import-drip.csv`)
7. Import each CSV file to CK for each sequence and tag you want to keep
  - Bunch of manual work...

