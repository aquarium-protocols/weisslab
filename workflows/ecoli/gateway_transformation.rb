needs "aqualib/lib/standard"
needs "aqualib/lib/cloning"

class Protocol

  include Standard
  include Cloning

  def arguments
    {
      io_hash: {},
      "gateway_result_ids Stripwell" => [7,6],
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

    take stripwells, interactive: true

    move transformed_aliquots, "37 C incubator"

    # delete stripwells
    stripwells.each do |stripwell|
        stripwell.mark_as_deleted
    end

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
