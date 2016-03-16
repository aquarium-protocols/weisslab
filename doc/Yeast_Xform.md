Yeast Transformation
---
#### How it works?
The yeast transformation workflow takes a yeast strain id as input and produces a yeast plate through transforming a digested plasmid into a parent yeast strain. The yeast strain sample field defines the integrant and the parent yeast strain. The workflow can be scheduled by starting yeast_transformtion metacol. In detail, it pools all the yeast transformation tasks, starts overnights for the parent strains that do not have enough yeast competent cells for this batch of transformation. If there is any overnights, it then progresses to inoculate overnights into large volume growth and make as many as possible yeast competent cells and places in the M80C boxes. In the meantime, it digests the plasmid stock of the plasmid that specified in the integrant field of the yeast strain. It then transforms the digested plasmids into the parent strain yeast competent cells and plates them on selective media plates using info specified in the yeast marker field of the plasmid. The workflow currently can also handle plasmids with KanMX yeast marker, it will incubate the transformed mixtures for 3 hours and then plate on +G418 plates.

#### Input requirements
 The parent is to link a yeast strain as your parent strain for this transformation and integrant links to the plasmid you are planning to digest and transform into the parent strain to make the yeast transformed strain. You need to make sure there is at least one plasmid stock for the plasmid. You also need to make sure the yeast marker field in properly entered in the plasmid sample page.

| Argument name   |  Data type | Data structure | Inventory type | Sample property | Item required |
|:---------- |:------------- |:------------- |:------------- |:------------- |:------------- |
| yeast_transformed_strain_ids  |  sample id | array | Yeast Strain | Parent, Integrant (or Plasmid) | None |
