needs "aqualib/lib/standard"
needs "aqualib/lib/cloning"

class Protocol

  include Standard
  include Cloning

  def arguments
    {
      io_hash: {},
      stripwell_ids: [584,587],
      debug_mode: "Yes"
    }
  end

  def main
    io_hash = input[:io_hash]
    io_hash = input if !input[:io_hash] || input[:io_hash].empty?
    io_hash = { debug_mode: "No", stripwell_ids: [] }.merge io_hash # set default value of io_hash

    debug_mode = false

    # redefine the debug function based on the debug_mode input
    if io_hash[:debug_mode].downcase == "yes"
      def debug
        true
      end
      debug_mode = true
    end

    stripwells = io_hash[:stripwell_ids].collect { |i| collection_from i }
    take stripwells, interactive: true
    fragment_stocks = []
    stripwells.each do |stripwell|
      fragment_stocks.concat(distribute stripwell, "Fragment Stock")
    end

    stripwell_to_column_tab = [["Stripwell id", "Location", "QIAquick column"]]
    column_id = 1
    # store which locations on stripwell that has content
    contents_wells_loc = Hash.new { |h, k| h[k] = [] }
    stripwells.each do |stripwell|
      stripwell.matrix[0].each_with_index do |id, loc|
        if id != -1
          stripwell_to_column_tab.push [ stripwell.id, loc+1, { content: column_id, check: true } ]
          column_id += 1
          contents_wells_loc[stripwell.id].push loc+1
        end
      end
    end

    show {
      title "Add Buffer PB to stripwell"
      stripwells.each do |stripwell|
        check "Stripwell #{stripwell.id}: Add 100 µL Buffer PB to wells: #{contents_wells_loc[stripwell.id].join(", ")}"
      end
      check "If the color of the mixture is orange or violet, add 10 µL 3 M sodium acetate, pH 5.0, and mix. The color of the mixture will turn yellow."
    }

    num = fragment_stocks.length

    show {
      title "Label QIAquick column and add contents from stripwell"
      check "Grab #{num} of QIAquick column each in a provided 2 mL collection tube, label with 1 to #{num} on the top."
      check "Add stripwell contents to LABELED pink QIAquick column using the following table."
      table stripwell_to_column_tab
      check "Discard the stripwell after transfering all the contents."
    }

    show {
      title "Centrifuge steps"
      note "All centrifuge are at 17,900 xg"
      check "Centrifuge LABELED QIAquick column 1 to #{num} for 30-60 seconds"
      check "Discard flow-through and place the QIAquick column back in the same tube."
      check "Add 750 µL Buffer PE to the QIAquick column and centrifuge for 30-60 seconds"
      check "Discard flow-through and place the QIAquick column back in the same tube."
      check "Centrifuge the QIAquick column once more in the provided 2 mL collection tube for 1 min to remove residual wash buffer."
    }

    column_to_fragment_stock_tab = [["1.5 mL tube id", "QIAquick column"]]
    fragment_stocks.each_with_index do |x,idx|
      column_to_fragment_stock_tab.push [ { content: x.id, check: true }, idx + 1 ]
    end

    show {
      title "Set up 1.5 mL tubes"
      check "Grab #{num} of 1.5 mL tube and label with the id shown in the 1.5 mL tube id column in the following table."
      check "Place QIAquick column in the labeled 1.5 mL tube according to the following table"
      table column_to_fragment_stock_tab
    }

    show {
      title "Elute DNA"
      note "Do the following for each of the column sitting in a labeled 1.5 mL tube."
      check "Add 50 µL Buffer EB or water to the center of the QIAquick membrane."
      check "Let the column sit still on 1.5 mL tube for 1 min."
      check "Centrifuge the column at 17,900 xg for 1 min."
      check "Throw away the column, keep the 1.5 mL tube and close the cap."
    }

    stripwells.each do |stripwell|
      stripwell.mark_as_deleted
    end unless debug_mode

    release fragment_stocks, interactive: true, method: "boxes"

    io_hash[:fragment_stock_ids] = fragment_stocks.collect { |x| x.id }

    if io_hash[:task_ids]
      io_hash[:task_ids].each do |tid|
        task = find(:task, id: tid)[0]
        set_task_status(task,"done")
      end
    end

    return { io_hash: io_hash }

  end # main

end # Protocol
