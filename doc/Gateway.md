Gateway Cloning
---
#### How it works?
The gateway cloning workflow takes 2 ENTR plasmid and 1 DEST plasmid to make a DEST_result plasmid. The gateway.rb takes plasmid stocks of 2 ENTR plasmid and 1 DEST plasmid and performs an LR reaction in a stripwell. Then gateway_transformation.rb transforms the contents in the stripwell into competent cell, plate_ecoli_transformation.rb plates the transformed aliquot on to selective media plate and incubate, then check_and_store_plate.rb records the num_of_colony on the plate and store the plate in a 4 C fridge.

#### Input requirements
| Argument name   |   Data type | Data structure | Inventory type | Sample property |
|:---------- |:------------- |:------------- |:------------- |:------------- |
| ENTRs  |  sample id |  array (length of 2) | Plasmid | Not required |
| DEST | sample id  | integer | Plasmid | Not required |
| DEST_result | sample id  | integer | Plasmid | Bacterial Marker (e.g. Amp, Kan, etc) |
