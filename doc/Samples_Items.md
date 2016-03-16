Samples and Items
---
#### Samples and Items

In Aquarium there is a hierarchy of different object types. In general, a sample is the definition of something like a plasmid called "pLAB1". Each sample has a specific sample ID. The sample pLAB1 has a specific sample type, in this case plasmid. Each sample has specific container types. For example, for a plasmid sample type, the containers are plasmid stocks, plasmid glycerol stocks, 1 ng/µl stocks, ect. There can be multiple copies of each container type of a sample that exist physically in the lab at the same time. Each container type item has a specific item ID in Aquarium.

#### Creating a new sample

To define a new sample go to the inventory dropdown menu and select the desired sample type for the new sample. (Plasmid, Primer, Yeast Strain, etc.) Then, for example, to define a new plasmid click on the "New Plasmid" button at the bottom of the page. This pulls up a page with information fields to fill out. The "New Plasmid" page has fields for the name of the plasmids, the project of the sample, a description of the plasmid, sequencing verification and other relevant information. Other sample types have similar informaiton field pages that must be completed to define a new sample. When the fields are completed click on "Save Sample Information" and Aquarium will assign a unique sample number to the new sample.

#### Creating new items

Creating new items of samples is relatively easy. For the most part items of samples will be created automatically through protocols, but there are times where an item may need to be entered outside of a protocol. To do this, go to the inventory page of the sample of which a new item is desired. Click on the desired container type and click the "New" button and Aquarium will create a new item with a unique item ID number.

#### Creating New Sample Types

If new protocol or new task requires a new sample type, it can be defined in the following manner. First, click on the inventory dropdown menu and click on the "Sample Type Definitions" option. This leads to a page with all the defined sample types currently available in the system. At the bottom of this page there is a button labeled "New Sample type", this will open a page with a space for a name, a descripiton, and up to 8 fields. These fields can be defined to take strings, numbers, urls, or links to any other sample type. Not all fields necessarily need to be used. Once all of the information fields on this page are filled out, clicking the "Save Sample Type" will define the new sample. 

#### Creating New Container Types

Each sample type has different forms it can exist in. In the Aquarium system these forms are referred to as container types. To define a new container type for a given sample, navigate back to the "Sample Type Definitions" page. Once there, click the link to the name of the sample type you wish to add a container type too. The link will bring up a page that lists the fields of the sample type and all of its containers. At the bottom of the listed containers, there is an "add" button that pulls up a page with a number of different data fields to fill out. The fields include, name of the container type, description, and the location prefix for the location wizard. Additionally, there are a few other optional fields present such as cost per container, vendor and safety information. The functionality for using the information in the additional fields is currently being developed. 

#### Deleting Items

Deleting items in Aquarium is easy. Just navigate to the sample page of the item to be deleted and click on the black "x" to the right of the item. The only consideration when manually deleting an item is to make sure the item is physically removed from the location it had been occupying. That way new items assigned a location by the location wizards will be able to be placed in their correct, unoccupied, slots.

#### Deleting Samples

Deleting sample is also relatively easy. Go to the inventory drop down tab, select the sample type of the sample to be deleted and then click on the black "x" to the right of the sample name. The same consideration of physical removal for deleting items exists for deleting samples. Since a sample can have many items associated with it, all of the associated items with the sample being deleted will need to be physically removed from their inventory slots.

### Importing Items using spreadsheets

Users can import items by uploading a CSV file to Aquarium.  Go to the inventory drop down tab, and select 'Import Samples from Spreadsheet'.  Remember to save your spreadsheet as a .csv, and locate and select the file on this page.

The CSV file should have the following format:

| Inventory Type | | | | | |
|:------------- | :------------- | :------------- | :------------- | :------------- | :------------- |
| Field1 Data |  Field2 Data | Field3 Data | Field4 data | Field5 data | none |

Inventory classes are specified in the Inventory drop down tab.  There are a few tricky things to note about item imports:

1.  Right now it only works for items, and not samples.  If you want to mass import samples, you have to use the API (see API section)
2.  The owner and description fields are ignored in CSV processing.  Will update this when this if fixed.
3.  The last column must be populated with 'none'.

An example CSV file for plasmid item uploads should look like the following:

| Plasmids | | | | | | | | | | |
|:------------- |:------------- |:------------- |:------------- |:------------- ||:------------- |:------------- |:------------- |:------------- |:------------- |:------------- |
| [BC16-G1]_pDEST-12(y) | BC16-G1 | https://benchling.com/s/42vkxQ6P/edit | https://benchling.com/s/JFj2klF/edit | AMP | | 6041 | | ISce-I | | None |
