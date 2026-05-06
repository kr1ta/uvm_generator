//---------------------------------------------------------
// Class: monitor
//---------------------------------------------------------

class monitor extends uvm_monitor;
    `uvm_component_utils({{prefix}}_agent_pkg::monitor)

    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual {{prefix}}_if vif;

    typedef {{prefix}}_item REQ;

    uvm_analysis_port#(REQ) ap;

    virtual function void build_phase(uvm_phase phase);
        ap = new("ap", this);
    endfunction

    virtual task reset_phase(uvm_phase phase);
        vif.wait_for_reset();
        vif.wait_for_unreset();
    endtask

    virtual task main_phase(uvm_phase phase);
        forever begin
            REQ req;
            req = REQ::type_id::create("req");

            do vif.wait_for_clks(1);
            while ( !(vif.tready === 1 && vif.tvalid === 1) );

            req.tdata = vif.tdata;
            req.unpack_data();

            ap.write(req);
        end
    endtask

endclass
