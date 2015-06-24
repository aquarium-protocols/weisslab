needs "aqualib/lib/standard"
needs "aqualib/lib/cloning"

class Protocol

  include Standard
  include Cloning

  def arguments
    {
      io_hash: {},
      #Enter the fragment sample ids as array of arrays, eg [[2058,2059],[2060,2061],[2058,2062]]
      entr_ids: [[1, 2], [1, 2]],
      #Tell the system if the ids you entered are sample ids or item ids by enter sample or item, sample is the default option in the protocol.
      dest_ids: [3, 3]
      dest_result_ids: [4, 4]
      #Enter correspoding plasmid id or fragment id for each fragment to be Gibsoned in.
      debug_mode: "Yes",
    }
  end

  def main
    io_hash = input[:io_hash]
    io_hash = input if !input[:io_hash] || input[:io_hash].empty?

    # setup default values for io_hash.
    io_hash = { entr_ids: [[]], dest_ids: [], dest_result_ids: [], debug_mode: "No" }.merge io_hash

    # Check if inputs are correct
    if !((io_hash[:entr_ids].length == io_hash[:dest_ids].length) && (io_hash[:entr_ids].length == io_hash[:dest_result_ids].length))
      raise "Incorrect inputs, entr_ids, dest_ids, dest_result_ids need to have the same length"
    end

    # Set debug based on debug_mode
    if io_hash[:debug_mode].downcase == "yes"
      def debug
        true
      end
    end

    entr_stocks = io_hash[:entr_ids].collect { |ids| ids.collect { |id| find(:sample,{id: id})[0].in("Plasmid Stock")[0] } }
    dest_stocks = io_hash[:dest_ids].collect { |ids| ids.collect { |id| find(:sample,{id: id})[0].in("Plasmid Stock")[0] } }

    # Flatten the entr_stocks array of arrays
    uniq_entr_stocks = entr_stocks.flatten.uniq
    uniq_dest_stocks = dest_stocks.uniq

    # Tell the user what we are doing
    show {
      title "Gateway Reaction Information"
      note "This protocol will perform Gateway Reaction to build the following plasmids."
      note io_hash[:dest_result_ids].collect { |id| "#{id}" }
    }

    stocks = uniq_entr_stocks + uniq_dest_stocks

    # Take fragment stocks
    take stocks, interactive: true,  method: "boxes"

    # Measure concentration
    stocks_to_measure_conc = (stocks).select { |stock| !stock.datum[:concentration] }

    if stocks_to_measure_conc.length > 0
      data = show {
        title "Nanodrop the following fragment stocks."
        stocks_to_measure_conc.each do |stock|
          get "number", var: "c#{stock.id}", label: "Go to B9 and nanodrop tube #{stock.id}, enter DNA concentrations in the following", default: 30.2
        end
      }
      stocks_to_measure_conc.each do |stock|
        stock.datum = { concentration: data[:"c#{stock.id}".to_sym] }
        stock.save
      end
    end

    # Measure volume
    stocks_to_measure_volume = (stocks).select { |stock| stock.datum[:volume_verified] != "Yes" }

    if stocks_to_measure_volume.length > 0
      stock_volume = show {
        title "Estimate the volume of stocks"
        warning "Pause here, don't click through until you entered estimated volume.".upcase
        stocks_to_measure_volume.each do |stock|
          get "number", var: "v#{stock.id}", label: "Estimate volume for tube #{stock.id}:", default: 28
        end
      }
      # write into datum the verified volumes
      stocks_to_measure_volume.each do |stock|
        stock.datum = stock.datum.merge({ volume: stock_volume[:"v#{stock.id}".to_sym], volume_verified: "Yes" })
        stock.save
      end
    end

    # Dilute stocks

    # Prepare stripwells
    show {
      title "Prepare Stripwell Tubes"
      stripwells.each do |sw|
        if sw.num_samples <= 6
          check "Grab a new stripwell with 6 wells and label with the id #{sw}."
        else
          check "Grab a new stripwell with 12 wells and label with the id #{sw}."
        end
      end
    }

    # Setup gateway reactions

    dest_results = io_hash[:dest_result_ids].collect { |id| find(:sample,{ id: id })[0] }
    gateway_results = produce spread dest_results, "Stripwell", 1, 12

    if io_hash[:task_ids]
      io_hash[:task_ids] = io_hash[:task_ids]
      io_hash[:task_ids].each do |tid|
        task = find(:task, id: tid)[0]
        set_task_status(task,"gateway")
      end
    end

    io_hash[:gateway_result_ids] = gateway_results.collect { |g| g.id }
    return { io_hash: io_hash }
  end

end
