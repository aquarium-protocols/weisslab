Plasmid Verification
---
#### How it works?
The plasmid verification workflow takes an E coli Plate of Plasmid, produces plasmid stocks from specified number of colonies on that plate, and produces sequencing results by sending sequencing reactions with specified primers. In detail, the workflow pools all plasmid verification tasks and starts specified number of overnights from each plate, produces plasmid stocks using miniprep from overnights that have growth, sets up sequencing reactions for each plasmid stock with specified primers, sends to a sequencing facility (currently Genewiz), and finally uploads the sequencing results into Aquarium.

#### Input requirements
| Argument name   |  Data type | Data structure | Inventory type | Sample property | Item required |
|:---------- |:------------- |:------------- |:------------- |:------------- |:------------- |
| plate_ids  |  item id  | array | E coli Plate of Plasmid | Bacterial Marker (e.g. Amp, Kan, etc) | E coli Plate of Plasmid |
| num_colonies | integer (1-10) | array | N/A | N/A | N/A |
| primer_ids | sample id | array of arrays | Primer | Not required | Primer Aliquot |
