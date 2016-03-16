Sequencing
---
#### How it works?
The sequencing workflow takes plasmid stocks and prepares sequencing reaction mix in stripwells with corresponding primer stocks. It submits orders to Genewiz and send to do Sanger sequencing. When sequencing results are back, it guides the technicians to upload the results into Aquarium.

#### Input requirements
| Argument name   |  Data type | Data structure | Inventory type | Sample property | Item required |
|:---------- |:------------- |:------------- |:------------- |:------------- |:------------- |
| plasmid_stock_ids  |  item id | array | Plasmid Stock or Fragment Stock | Length | Plasmid Stock or Fragment Stock |
| primer_ids | sample id | array of arrays | Primer | Not required | Primer aliquot |

Each item id in the plasmid_stock_ids uses the corresponding subarray of primer_ids to set up sequencing reaction.
