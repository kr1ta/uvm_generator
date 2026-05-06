//---------------------------------------------------------
// Class: sequencer
//---------------------------------------------------------

class sequencer extends uvm_sequencer#({{prefix}}_item);
    `uvm_component_utils({{prefix}}_agent_pkg::sequencer)

    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction
endclass
