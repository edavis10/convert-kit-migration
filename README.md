Migration of subscribers to convert kit.

1. Add a import-drip tag
2. Import all tags - create_tags.rb
  - Skip Read tags
3. Create CSV exports for each tag
  - Skip Read tags
3. Create CSV exports for each campaign/sequence
  - Skip Read tags
4. Import the import-drip CSV export which includes all subscribers
6. Import each CSV file
  - NO, drip has this data bad: -add to sequences if the tag is for a sequence-
  - import-drip-completed-X if the file is for a sequence that they subs completed in Drip
  JSON: onboarding complete and billing complete -> customer with import-drip-conpleted-drip-onboarding

  - add tag like import-drip-completed-json-uninstall when importing the uninstall tags
7. Import each campaign file from drip into CK
  - import-drip-completed-X if the file is for a sequence that they subs completed in Drip


[x] uninstall and reinstall tags? - not tags in drip, events. Imported by export
