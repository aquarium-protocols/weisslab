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
        
    show {title "CHO DOX Circuit Transfection"
      note "This protocol will perform a co-transfection of CHO-K1 cells using Viafect with Module 1 circuits."
      check "Wells 1-5 are all the full QacR circuit with 5 different levels of DOX."
      }
    
    # take plasmids, interactive: true, method: "boxes"
        
    show {
      title "Labeling Plastic Ware"
      warning "Ensure you stay sterile with all items coming into the TC hood!"
      check "Obtain your group's 24-well plate from the incubator and ensure it is labeled with your group name, CHO3, and 4/3/2017"
      check "Get 5 1.7mL Eppendorfs and label them 1-5."
      }
    
      
       show {
      title "Preparing Transfection Complexes"
      note "Obtain plasmids 3008, 3009, 3010, 3011, 3012, 3017, and 3018, all are in 150ng/uL aliquots"
      note "Pipette the following tube combinations:"
      warning "Be aware of the plasmid identifies AND different volumes"
      
      check "2uL of 3011 into Tube 1-5 "
      check "2uL of 3012 into Tube 1-5"
      check "2uL of 3017 into Tube 1-5"
      check "2uL of 3018 into Tube 1-5"
      }


        
    show {
      title "Preparing Transfection Complexes"
      check "Pipette 40.5uL of Optimem Serum-Free Media into Tubes 1-5."
      check "Pipette 1.5uL of Viafect into Tubes 1-5."
      check "Swirl tube to mix and proceed."
      }
    
    show {
      title "Incubation Step for Complexes at Room-Temperature"
      note "Incubate complexes for 12 minutes and click OK when timer ends."
       timer initial: { hours: 0, minutes: 12, seconds: 0}
      }
    
      
    show {
      title "Transfection"
      check "Pipette 50uL of Tube 1 into Well C1"
      check "Pipette 50uL of Tube 2 into Well C2"
      check "Pipette 50uL of Tube 3 into Well C3"
      check "Pipette 50uL of Tube 4 into Well C4"
      check "Pipette 50uL of Tube 5 into Well C5"
      }


      
   
    show {
      title "Clean and Store"
      check "Wipe plate with EtOH and return plate to incubator for growth"
      check "Dispose of 1.7mL eppendorfs in biowaste."
      check "Clean hood"
      }
    
    
    # Set tasks in the io_hash to be transfected
     if io_hash[:task_ids]
       io_hash[:task_ids].each do |tid|
         task = find(:task, id: tid)[0]
         set_task_status(task,"transfected")
       end
     end
     return { io_hash: io_hash }
    
  end
end
