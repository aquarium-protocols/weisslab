needs "aqualib/lib/standard"
needs "aqualib/lib/cloning"

class Protocol

  include Standard
  include Cloning

  def arguments
    {
      io_hash: {},
      "gateway_result_ids Stripwell" => [52],
      debug_mode: "Yes",
      cell_type: "DB3.1"
    }
  end #arguments

  def main
    io_hash = input[:io_hash]
    io_hash = input if !input[:io_hash] || input[:io_hash].empty?

    # setup default values for io_hash.
    io_hash = { gateway_result_ids: [], debug_mode: "No", cell_type: "DB3.1" }.merge io_hash

    if io_hash[:debug_mode].downcase == "yes"
      def debug
        true
      end
    end

    stripwells = io_hash[:gateway_result_ids].collect { |i| collection_from i }
    stripwells_array = stripwells.collect { |s| s.matrix }
    io_hash[:plasmid_ids] = stripwells_array.flatten
    io_hash[:plasmid_ids].delete(-1)

    io_hash[:cell_type] = "DB3.1" if !io_hash[:cell_type] || io_hash[:cell_type] == ""

    transformed_aliquots = io_hash[:plasmid_ids].collect { |id| produce new_sample find(:sample, id: id)[0].name, of: "Plasmid", as: "Transformed E. coli Aliquot"}

    num = transformed_aliquots.length

    take stripwells, interactive: true

    show {
      title "Retrive #{io_hash[:cell_type]} competent cell aliquot"
      note "Grab #{num} of #{io_hash[:cell_type]} competent cell aliquot from M80"
      note "Label with the following id: #{transformed_aliquots.collect { |t| "#{t}" }.join(", ")}"
    }

    transformed_aliquot_ids = transformed_aliquots.collect { |t| "#{t}" }

    # load competent cell aliquot from stripwell
    load_samples_variable_vol(["Competent Cell Aliquot"],[transformed_aliquot_ids], stripwells, title_prefix: "Unload") {
      note "Pieptte 1 µL from each well into labeled competent cell aliquot."
      note "Discard the stripwell into waste bin after unloading."
    }

    # delete stripwells
    stripwells.each do |stripwell|
        stripwell.mark_as_deleted
    end

    show {
      title "Incubate on ice"
      note "Place the following tube on ice for 30 min."
      note transformed_aliquot_ids.join(", ")
      note "Click OK to start a 30 min timer."
    }

    show {
      title "Retrieve all tubes after 30 min"
      timer initial: { hours: 0, minutes: 30, seconds: 0}
    }

    show {
      title "Heat shock at 42 C"
      note "Place the following tube at 42 C water bath."
      note transformed_aliquot_ids.join(", ")
      note "Click OK to start a 30 sec timer."
    }

    show {
      title "Retrieve all tubes immedieately after 30 sec"
      timer initial: { hours: 0, minutes: 0, seconds: 30}
    }

    show {
      title "Incubate on ice and add S.O.C"
      note "Incubate all tubes on ice for 2 minutes."
      timer initial: { hours: 0, minutes: 2, seconds: 0}
      note "Add 0.9 mL of room temperature S.O.C medium into each tube after incubation."
      note transformed_aliquot_ids.join(", ")
      warning "S.O.C is made by dissolving 0.5 mL of 20% glucose in 25 ml of SOB. Make sure that the SOC is clear and not cloudy (contaminated)."
    }

    show {
      title "Incubate and shake at 37 C"
      note "Place the followng tube in a shaker incubator at 37 C and 280 rpm"
      note transformed_aliquot_ids.join(", ")
      note "Retrive all the tubes after 60 min by starting the plate_gateway_transformation protocol in the workflow."
    }

    move transformed_aliquots, "37 C shaker incubator"

    release stripwells

    io_hash[:transformed_aliquot_ids] = transformed_aliquots.collect { |t| t.id }

    # Set tasks in the io_hash to be transformed
    if io_hash[:task_ids]
      io_hash[:task_ids].each do |tid|
        task = find(:task, id: tid)[0]
        set_task_status(task,"transformed")
      end
    end
    return { io_hash: io_hash }

  end #main

end #Protocol
