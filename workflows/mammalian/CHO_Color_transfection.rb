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
      title "CHO Transfection"
      note "This protocol will perform a co-transfection of CHO-K1 cells using Viafect with an inducible TRE-Tight/rtTA3 plasmids."
      check "Well 1 is a -DOX inducible mKate with const eYFP"
      check "Well 2 is a +DOX inducible mKate with const eYFP"
      check "Well 3 is a negative transfection control"
      }
    
    # take plasmids, interactive: true, method: "boxes"
    
    
    show {
      title "Labeling Plastic Ware"
      warning "Ensure you stay sterile with all items coming into the TC hood!"
      check "Obtain a 24-well plate from the TAs and label with your initials, CHO1, and 3/20/2017"
      check "Get 3 1.7mL Eppendorfs and label them 1, 2, and 3."
      }
    
    
    show {
      title "Preparing Transfection Complexes"
      note "Obtain plasmids 3004, 3005, 3006, and 3007, all are in 150ng/uL aliquots"
      note "Pipette the following tube combinations:"
      warning "Be aware of the plasmid identifies AND different volumes"
      check "2uL of 3004 into Tube 1"
      check "2uL of 3005 into Tube 1"
      check "2uL of 3006 into Tube 1"
      check "2uL of 3007 into Tube 1"
      
      check "2uL of 3004 into Tube 2"
      check "2uL of 3005 into Tube 2"
      check "2uL of 3006 into Tube 2"
      check "2uL of 3007 into Tube 2"
      
      check "2uL of 3006 into Tube 3"
      check "6uL of 3007 into Tube 3"
      }
    
        
    show {
      title "Preparing Transfection Complexes"
      check "Pipette 40.5uL of Optimem Serum-Free Media into Tubes 1, 2, and 3."
      check "Pipette 1.5uL of Viafect into Tubes 1, 2, and 3."
      check "Swirl tube to mix and proceed."
      }
    
    show {
      title "Incubation Step for Complexes at Room-Temperature"
      note "Incubate complexes for 12 minutes and click OK when timer ends."
       timer initial: { hours: 0, minutes: 12, seconds: 0}
      }
    
    show {
      title "Transfection"
      check "Pipette 50uL of Tube 1 into Well A6"
      check "Pipette 50uL of Tube 2 into Well B6"
      check "Pipette 50uL of Tube 3 into Well C6"
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
