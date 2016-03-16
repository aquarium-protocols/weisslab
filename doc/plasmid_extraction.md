Plasmid Extraction
---
#### How it works?
The plasmid extraction workflow takes an E coli Plate of Plasmid with id in plate_ids, picks a number of colonies based on input in num_colonies, starts overnights in corresponding selective media using  info defined in the Plasmid sample Bacterial Marker property, then performs miniprep to produce plasmid stocks.

#### Input requirements
| Argument name   |   Data type | Data structure | Inventory type | Sample property |
|:---------- |:------------- |:------------- |:------------- |:------------- |
| plate_ids  |  item id  | array | E coli Plate of Plasmid | Bacterial Marker (e.g. Amp, Kan, etc) |
| num_colonies | integer | array | N/A | N/A |
