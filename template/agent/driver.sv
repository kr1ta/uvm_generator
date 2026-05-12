//---------------------------------------------------------
// Class: driver
//---------------------------------------------------------

class driver extends uvm_driver#({{prefix}}_item);

    `uvm_component_utils({{prefix}}_agent_pkg::driver)

    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual {{prefix}}_if vif;

    int delay_min = 0;
    int delay_max = 10;

    virtual function void build_phase(uvm_phase phase);
        void'(uvm_resource_db#(int)::read_by_name(
            get_full_name(), "delay_min", delay_min));
        void'(uvm_resource_db#(int)::read_by_name(
            get_full_name(), "delay_max", delay_max));
    endfunction

    virtual task reset_phase(uvm_phase phase);
        phase.raise_objection(this);
        vif.wait_for_reset();

        unset_master_data();

        vif.wait_for_unreset();
        phase.drop_objection(this);
    endtask

    virtual task main_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            send_master();
            seq_item_port.item_done();
        end
    endtask

    virtual task send_master();
        do_delay();

        vif.tvalid <= '1;
        vif.tdata  <= req.tdata;

        do begin
            vif.wait_for_clks(1);
        end while( !vif.tready );

        unset_master_data();
    endtask

    virtual task unset_master_data();
        vif.tvalid <= '0;
        vif.tdata  <= '0;
    endtask

    virtual task do_delay();
        int delay;
        std::randomize(delay) with { delay inside { [delay_min : delay_max] }; };
        vif.wait_for_clks(delay);
    endtask

endclass
