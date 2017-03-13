needs "aqualib/lib/standard"
needs "aqualib/lib/cloning"

class Protocol

  include Standard
  include Cloning

  def arguments
    {
      io_hash: {},
      #Enter the plasmid  ids as array of arrays, eg [[2058,2059],[2060,2061],[2058,2062]]
      Plasmids: [1,2],
      #Tell the system if the ids you entered are sample ids or item ids by enter sample or item, sample is the default option in the protocol.
      sample_or_item: "sample",
      debug_mode: "Yes"
    }
  end


  def main
    io_hash = input[:io_hash]
    io_hash = input if !input[:io_hash] || input[:io_hash].empty?
    
     # setup default values for io_hash.
    io_hash = { Plasmids: [[]], debug_mode: "No" }.merge io_hash
    
    io_hash[:plasmid_ids] = io_hash[:Plasmids]
    
    
    if io_hash[:debug_mode].downcase == "yes"
      def debug
        true
      end
    end
    
    err_messages = []

    plasmid_stocks = io_hash[:plasmid_ids].collect { |ids|
      ids.collect { |id|
        err_messages.push "Sample #{id} does not have any stock" if !find(:sample,{ id: id })[0].in("Plasmid Stock")[0]
        find(:sample,{ id: id })[0].in("Plasmid Stock")[0]
      }
    }
    
    uniq_plasmid_stocks = plasmid_stocks.flatten.uniq
    
    show {
      title "CHO Transfection"
      note "This protocol will perform a co-transfection of CHO-K1 cells using Viafect with the following plasmids."
      note io_hash[:Plasmids].collect { |id| "#{id}" }
      }
    
    stocks = uniq_plasmid_stocks;
    
    take stocks, interactive: true, method: "boxes"

    plasmids = stocks.collect { |p| p.sample }
    tubes = produce spread plasmids, "1.7mL Tube", 1, 12

    # assuming 1800 ng of total DNA and 50uL reaction
    show {
      title "Prepare Tubes"
      tubes.each do |tu|
        check "Label a new tube with the id #{tu}. "
        end
    }
    
    plasmid_stocks_volumes = stocks.collect { |p| (300.0/(p.datum[:concentration]||300)).round(1) }
    plasmid_stocks_volumes_list = plasmid_stocks_volumes.zip(stocks).collect { |a| a.join(" µL of ") }
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
        	timer initial: { hours: 0, minutes: 15, seconds: 0}

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
