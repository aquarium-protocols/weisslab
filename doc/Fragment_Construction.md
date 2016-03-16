Fragment Construction
---
#### How it works?
The Fragment Construction workflow takes fragment sample id as input and produces corresponding fragment stock as output. It pools all the fragment sample ids submitted to the Fragment Construction tasks, build each fragment using the information entered into the sample field through the process of running PCR, pour_gel, run_gel, cut_gel and purify_gel protocols.

For each fragment, it finds the 1ng/µL plasmid stock of the fragment. If a 1ng/µL plasmid stock does not exist, it will try to dilute from the plasmid stock if there is any. It also finds the primer aliquot for the forward primer and reverse primer. It uses the T Anneal data in the forward and reverse primer field and uses the lower of the two as the desired annealing temperature for the PCR. The workflow first clusters all PCRs into 3 temperature groups, >= 70 C, 67 -70 C, < 67 C based on the desired annealing temperature. Then it finds the lowest annealing temperature in each group and uses that as the final annealing temperature. The workflow runs the PCR reactions for all fragments based on above information and stocks it finds, then pours a number of gels based on the number of PCR reactions, runs the gel and then cut the gel based on the length info in the fragment field, finally purifies the gel and results in a fragment stock with concentration recorded in the datum field and placed in the M20 boxes. If a gel band does not match the length info, the corresponding gel lane will not be cut and no fragment stock will be produced for that fragment.

#### Input requirements
| Argument name   |  Data type | Data structure | Inventory type | Sample property | Item required |
|:---------- |:------------- |:------------- |:------------- |:------------- |:------------- |
| fragments  |  sample id |  array | Fragment | Length, Template, Forward Primer, Reverse Primer  | None |

The template can be a plasmid, fragment, yeast strain, or E coli strain. Corresponding item shown in the table below need to be existed in the inventory for the fragment construction task able to be pushed to ready.

| Template   |      Item required |
|:---------- |:------------- |
| Plasmid  |  Plasmid stock or 1ng/µL Plasmid Stock  |
| Fragment | Fragment Stock or 1ng/µL Fragment Stock |
| Yeast Strain | Lysate or Yeast cDNA if no Lysate  |
| E coli strain | E coli Lysate or Genome Prep if no E coli Lysate |
