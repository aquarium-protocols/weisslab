Gibson Assembly
---
#### How it works?
The Gibson Assembly workflow takes a Gibson recipe, a **plasmid** you want to build from a number of **fragments**, as input and produces an E coli Plate of Plasmid for the **plasmid**. In detail, the workflow can be started by scheduling gibson_assembly metacol, it pools all Gibson recipes submitted to the Gibson Assembly tasks and sequentially starts gibson, ecoli_transformation, plate_ecoli_transformation, image_plate protocols to produce plates of E coli colonies that contain the plasmids.

At the beginning of gibson protocol, the workflow processes all the Gibson Assembly tasks labled as "waiting" and "ready", if fragments in a task all have fragment stocks ready and length info entered in the sample field, it will push the task to "ready" stack and fires up the gibson reactions whereas if any stock is missing or length info is missing, it will push the task to "waiting" stack. The gibson protocol uses the concentration data and length info for the fragment stocks to calculate volumes of fragment stocks to add to achieve approximate equal molar concentrations for each fragment in the reaction. Notably, if a fragment stock that needs to be used in the gibson reaction exists but lacks the concentration data, the protocol will instruct the techs to measure the concentration and record the data before starting all the reactions. The ecoli_transformation protocol takes all the gibson reaction results produced by the gibson protocol and start electroporation to transform them into DH5alpha electrocompetent aliquots. It will then incubate all transformed aliquots in 37 C incubator for 30 minutes. The plate_ecoli_transformation protocol plates all Transformed E. coli Aliquots sitting in 37 C incubator on corresponding selective media plates based on the bacterial marker info provided and then place back in 37 C incubator. The image_plate protocol takes all the incubated plates after 18 hours, take pictures, upload them in the Aquarium and also count the colonies on each plate. If the number of colonies on a plate is zero, the protocol will instruct the tech to discard the plate, otherwise, it will parafilm all the plates and put into an available box in the deli fridge and update the inventory location.

The workflow also manages all the status of the tasks like described in the fragment construction section, you can check the progress of you task by clicking each status tab. If you Gibson reaction successfully has colonies, it will be pushed to the "imaged and stored in fridge" tab, if no colonies show up, it will be pushed to the "no colonies" tab. If you notice that your tasks are sitting in the "waiting" for too long, you should probably read the following input requirements.

#### Input requirements

| Argument name   |  Data type | Data structure | Inventory type | Sample property | Item required |
|:---------- |:------------- |:------------- |:------------- |:------------- |:------------- |
| plasmid  |  sample id |  integer | Plasmid | Bacterial Marker, Length | None |
| fragments  |  sample id |  array | Fragment | Length | Fragment Stock |

You need to ensure there is at least one fragment stock for the fragment. If you do not have a fragment stock or run out of fragment stock, new fragment construction task will automatically submitted for you.
