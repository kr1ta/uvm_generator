//---------------------------------------------------------
// Class: sequencer
//---------------------------------------------------------

class sequencer extends uvm_sequencer#(example_item);
    `uvm_component_utils(example_agent_pkg::sequencer)

    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction
endclass
