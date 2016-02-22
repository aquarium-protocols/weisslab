needs "aqualib/lib/standard"
needs "aqualib/lib/cloning"

class Protocol

  include Standard
  include Cloning

  def arguments
    {
      io_hash: {},
      "plasmid_stock_ids Plasmid Stock"=> [323,327],
      "fragment_ids Fragment"=> [126,249],
      debug_mode: "Yes",
    }
  end

  def main
    io_hash = input[:io_hash]
    io_hash = input if !input[:io_hash] || input[:io_hash].empty?
    io_hash = { fragment_ids: [], stripwell_ids: [], plasmid_stock_ids: [], item_choice_mode: "No" }.merge io_hash

    if io_hash[:debug_mode].downcase == "yes"
      def debug
        true
      end
    end

    if io_hash[:plasmid_stock_ids].length == 0
      show {
        title "No plasmid digestion required"
        note "No plasmid digestion required. Thanks for you effort!"
      }
      return { io_hash: io_hash }
    end

    if io_hash[:fragment_ids].length == 0
      show {
        title "Fragment ids need to be specified"
        note "Fragment ids need to be specified as an output of the digestion."
      }
      return { io_hash: io_hash }
    end

    plasmid_stocks = io_hash[:plasmid_stock_ids].collect{ |pid| find(:item, id: pid )[0] }

    cut_smart = choose_group_specific_sample_stock "Enzyme Buffer", "NEB CutSmart 10X", "Enzyme Buffer Stock"

    take plasmid_stocks + [cut_smart], interactive: true, method: "boxes"

    fragments = io_hash[:fragment_ids].collect { |x| find(:sample, id: x)[0] }
    stripwells = produce spread fragments, "Stripwell", 1, 12

    show {
      title "Grab an ice block"
      warning "In the following step you will take restriction enzyme out of the freezer. Make sure the enzyme is kept on ice for the duration of the protocol."
    }

    enzyme_stock = choose_group_specific_sample_stock "Enzyme", "IsceI", "Enzyme Stock"

    take [enzyme_stock], interactive: true, method: "boxes"

    # assuming 500 ng of DNA and 25 uL diagnostic reaction
    show {
      title "Prepare Stripwell Tubes"
      stripwells.each do |sw|
        check "Label a new stripwell with the id #{sw}. Use enough number of wells to write down the id number."
        check "Pipette 2 µL from #{cut_smart} into wells" + sw.non_empty_string + "."
      end
    }

    plasmid_stocks_volumes = plasmid_stocks.collect { |p| (500.0/(p.datum[:concentration]||500)).round(1) }

    plasmid_stocks_volumes_list = plasmid_stocks_volumes.zip(plasmid_stocks).collect { |a| a.join(" µL of ") }

    enzymes_volumes_list = (1..plasmid_stocks.length).collect { |x| "1 µL of #{enzyme_stock}" }

    water_volume_list = plasmid_stocks_volumes.collect { |v| "#{17-v} µL"}

    load_samples_variable_vol( ["Plasmid", "Enzyme", "MG Water"], [plasmid_stocks_volumes_list, enzymes_volumes_list, water_volume_list ], stripwells ) {
      warning "Use a fresh pipette tip for each transfer."
    }

    incubate = show {
      title "Incubate"
      check "Put the cap on each stripwell. Press each one very hard to make sure it is sealed."
      separator
      check "Place the stripwells into a small green tube holder and then place in 37 C incubator."
      image "put_green_tube_holder_to_incubator"
    }

    stripwells.each do |sw|
      sw.move "37 C incubator"
    end

    release stripwells
    release plasmid_stocks + [cut_smart] + [enzyme_stock], interactive: true, method: "boxes"

    if io_hash[:task_ids]
      io_hash[:task_ids].each do |tid|
        task = find(:task, id: tid)[0]
        set_task_status(task,"plasmid digested")
      end
    end

    io_hash[:stripwell_ids] = stripwells.collect { |s| s.id }
    return { io_hash: io_hash }

  end

end
