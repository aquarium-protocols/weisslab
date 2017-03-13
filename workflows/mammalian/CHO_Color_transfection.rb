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
    io_hash = { tube_ids: [], Plasmids: [], item_choice_mode: "No", debug_mode: "No" }.merge io_hash
    
    plasmids = io_hash[:plasmid_ids].collect{ |pid| find(:item, id: pid)[0] }    
    tubes = produce spread plasmids, "1.7mL Tube", 1, 12
    
    show {
      title "CHO Transfection"
      note "This protocol will perform a co-transfection of CHO-K1 cells using Viafect with 1-3 constitutive color plasmids."
      }
    
    take plasmids, interactive: true, method: "boxes"
   
    
    show {
      title "Prepare Tubes"
      tubes.each do |tu|
        check "Label a new tube with the id #{tu}. "
        end
    }

    plasmid_stocks_volumes = plasmids.collect { |p| (300.0/(p.datum[:concentration]||300)).round(1) }
    plasmid_stocks_volumes_list = plasmid_stocks_volumes.zip(plasmids).collect { |a| a.join(" µL of ") }
    water_volume_list = plasmid_stocks_volumes.collect { |v| “#{48.5 – v} uL” }
    load_samples_variable_vol( ["Plasmid", "MG Water"], [plasmid_stocks_volumes_list,  water_volume_list ], tubes) {
      warning "Use a fresh pipette tip for each transfer."
    }
show {
	        title "Add Viafect and Incubation"
	        note "Add 1.5 µL of Viafect to each tube"
	        tubes.each do |tu|
	          bullet "Tubes #{tu.id}, numbers #{tu.non_empty_string}"
	        end

	      }


    
  end
end
