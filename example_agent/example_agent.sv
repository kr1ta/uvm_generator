//---------------------------------------------------------
// Class: agent
//---------------------------------------------------------

class agent extends uvm_agent;

    `uvm_component_utils(example_agent_pkg::agent)

    sequencer seqr;
    driver    driver;
    monitor   monitor;

    virtual example_if vif;

    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        driver	= example_agent_pkg::driver   ::type_id::create("driver", this);
        monitor = example_agent_pkg::monitor  ::type_id::create("monitor", this);
        seqr    = example_agent_pkg::sequencer::type_id::create("seqr", this);

        config_components();
    endfunction

    function void connect_phase(uvm_phase phase);
        driver.seq_item_port.connect(seqr.seq_item_export);
    endfunction

    virtual function void config_components();
        // Get interface.
        if(!uvm_resource_db #(virtual example_if)::read_by_name(
            get_full_name(), "vif", vif))
                `uvm_fatal(get_name(), "Can't get vif!");

        // Set interface.
        driver .vif = vif;
        monitor.vif = vif;
    endfunction

endclass

