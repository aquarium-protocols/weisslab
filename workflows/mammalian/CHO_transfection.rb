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
    io_hash = { tube_ids: [], Plasmids: [], item_choice_mode: "No" debug_mode: "No" }.merge io_hash
    
    io_hash[:plasmid_stock_ids] = io_hash[:Plasmids]
    
    
    if io_hash[:debug_mode].downcase == "yes"
      def debug
        true
      end
    end
    
     if io_hash[:plasmid_stock_ids].length == 0
      show {
        title "No plasmid transfection required"
        note "No transfection required. Thanks for you effort!"
      }
      return { io_hash: io_hash }
    end

    plasmid_stocks = io_hash[:plasmid_stock_ids].collect{ |pid| find(:item, id: pid )[0] }
        
    show {
      title "CHO Transfection"
      note "This protocol will perform a co-transfection of CHO-K1 cells using Viafect with the following plasmids."
      note io_hash[:plasmid_stocks].collect { |id| "#{id}" }
      }
    
      
    take plasmid_stocks, interactive: true, method: "boxes"
    
  end
end
