needs "aqualib/lib/standard"
needs "aqualib/lib/cloning"

class Protocol

  include Standard
  include Cloning

  def arguments
    {
      io_hash: {},
      #Enter the plasmid  ids as array of arrays, eg [[2058,2059],[2060,2061],[2058,2062]]
      plasmid_ids: [1,2,3,4],
      #Tell the system if the ids you entered are sample ids or item ids by enter sample or item, sample is the default option in the protocol.
      sample_or_item: "sample",
      debug_mode: "Yes"
    }
  end

  def main
    io_hash = input[:io_hash]
    io_hash = input if !input[:io_hash] || input[:io_hash].empty?
    
     # setup default values for io_hash.
    io_hash = { Plasmids: [], item_choice_mode: "No", debug_mode: "No" }.merge io_hash
    
    plasmids = io_hash[:plasmid_ids].collect{ |pid| find(:item, id: pid)[0] }    
        
    show {
      title "CHO Cytometry Preparation"
      note "This protocol will walk you through preparing a 24-well plate for analysis via flow cytometry."
      }
    
    # take plasmids, interactive: true, method: "boxes"
    
    
    show {
      title "Gather materials"
      warning "Ensure Trypsin is pre-warmed to 37C and 1X PBS is room temperature!"
      check "Obtain 1.7mL eppendorfs and a tube rack; label tube tops from 1 to 15"
      check "Obtain a 96-well plate and label with 4/5/2017 and the Group name"
      }
    
    
    show {
      title "Aspirating Media"
      check "Aspirate existing media from each well, being careful to come in from side NOT touching the bottom of each well."
      }
    
    show {
      title "PBS Rinse"
      check "Add 0.2mL of PBS to each well to rinse residual DMEM and aspirate PBS off from well."
      }
        
    show {
      title "Preparing Trypsin"
      check "Pipette 0.1mL of 0.05% Trypsin into each well."
      check "Swirl plate gently to mix."
      }
    
    show {
      title "Incubation Step for Trypsin at 37C"
      note "Incubate plate with Trypsin added for 10 minutes at 37C."
       timer initial: { hours: 0, minutes: 6, seconds: 0}
      }
    
    show {
      title "Quenching Trypsin"
      check "Swirl plate gently to ensure cells are no longer adherent. You may want to look at them under the microscope to ensure they've detached."
      check "Pipette 0.5mL DMEM into each well to stop Trypsin reaction."
      }
      
    show {
      title "Centrifuge Cells"
      check "Pipette 0.6mL from each well into labeled 1.7mL eppendorf tubes."
      check "Spin down eppendorf tubes for 5 minutes at 1500rpm."
      }
            
    show {
      title "Aspirate"
      check "Gently, aspirate DMEM+Trypsin mixture from each eppendorf. Taking care NOT to get too close to cell pellet."
      warning "You may not see a cell pellet but trust that it is there."
      warning "It is better to leave residual liquid in the bottom of the tube than risk getting it all."
      }
      
      show {
      title "Resuspend"
      check "Using a fresh tube for each tube, add 0.15mL of PBS to each eppendorf and pipette several times to resuspend cell pellet."
      }
      
      show {
      title "Aliquot cells"
      check "Taking the 1.7mL eppendorfs, pipette 0.18mL from each tube into wells A1-A12 and B1-B3 in order on the 96-well plate."
      }
      
      
    show {
      title "Clean and Store"
      check "Wipe plate with EtOH and return plate to TAs for storing in cold room until cytometry session"
      check "Dispose of 1.7mL eppendorfs in biowaste."
      check "Clean hood"
      }
    
    
    # Set tasks in the io_hash to be transfected
     if io_hash[:task_ids]
       io_hash[:task_ids].each do |tid|
         task = find(:task, id: tid)[0]
         set_task_status(task,"trypsinized")
       end
     end
     return { io_hash: io_hash }
    
  end
end
