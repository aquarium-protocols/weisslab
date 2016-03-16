Yeast Strain QC
---
#### How it works?
The yeast strain QC workflow takes a yeast plate and produces QCPCR results presented in a gel image. In detail, the workflow can be scheduled by starting yeast_strain_QC metacol. The workflow pools all yeast strain QC tasks and start lysates for each yeast plate from specified number of colonies as entered in the task input, then it sets up PCR reactions with primers specified in QC Primer 1 and QC Primer 2 in the corresponding yeast strain sample field. It then pours a number of gels based on number of PCR reactions, runs the gel with the PCR results, takes a picture of the gel and uploads it in the Aquarium where you can find in the job log of image_gel.

When picking up colonies from a yeast plate, the workflow follows the following rules. If the plate has only one region and some colonies are marked with circle as c1, c2, c3, ..., it will pick these colonies starting from c1 until reach the specified number of colonies. If the plate has several regions, e.g. a streaked plates with different regions, and if each region is marked as c1, c2, c3, ..., it will pick one colony from each region until reach the specified number of colonies. If nothing is marked up, it will randomly pick up medium to large size colonies and mark them with c1, c2, c3.

The workflow manages all the status of the tasks as "waiting", "lysate", "pcr", "gel run", "gel imaged", you can easily track the progress of your tasks.

#### Input requirements
| Argument name   |  Data type | Data structure | Inventory type | Sample property | Item required |
|:---------- |:------------- |:------------- |:------------- |:------------- |:------------- |
| yeast_plate_ids  |  item id | array | Yeast Plate | QC Primer 1, QC Primer 2 | Primer Stock for QC Primer 1 and QC Primer 2 |
| num_colonies  |  integer | array | N/A | N/A | N/A |

num_colonies is to indicate how many colonies you want to pick from each plate for QC. The array length of yeast_plate_ids and num_colonies need to be the same so they are one to one correspondence.

