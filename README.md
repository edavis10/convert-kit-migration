Migration of subscribers to convert kit.

1. x Add a import-drip tag
2. Import all tags - create_tags.rb
  - Skip Read tags
3. Create CSV exports for each tag
  - Skip Read tags
3. Create CSV exports for each campaign/sequence
  - Skip Read tags
4. Import the import-drip CSV export which includes all subscribers
5. Import each CSV file
  - ??? add to sequences if the tag is for a sequence
  - ??? make sure sequences' exclusions are correct


---
  
6. 
2. Add all subs with a import-drip tag to CK
4. Scrape CSV and add tags for each subscriber
  * skip all read tags
  * before adding any app tag, add an exclusion tag for that app JSON - exclude, etc
5. Scrape CSV and add subscribers to each sequence based on their campaigns

