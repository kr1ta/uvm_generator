//---------------------------------------------------------
// Class: driver
//---------------------------------------------------------

class driver extends uvm_driver#({{prefix}}_item);

    `uvm_component_utils({{prefix}}_agent_pkg::driver)

    uvm_analysis_port#({{prefix}}_item) ap;

    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    virtual {{prefix}}_if vif;

    int delay_min = 0;
    int delay_max = 10;

    bit is_master = 1;

    virtual function void build_phase(uvm_phase phase);
        void'(uvm_resource_db#(int)::read_by_name(
            get_full_name(), "delay_min", delay_min));
        void'(uvm_resource_db#(int)::read_by_name(
            get_full_name(), "delay_max", delay_max));
    endfunction

    virtual task reset_phase(uvm_phase phase);
        phase.raise_objection(this);
        vif.wait_for_reset();

        if( is_master )
            unset_master_data();
        else
            vif.tready <= '0;

        vif.wait_for_unreset();
        phase.drop_objection(this);
    endtask

    virtual task main_phase(uvm_phase phase);
        if( is_master )
            forever begin
                seq_item_port.get_next_item(req);
                send_master();
                seq_item_port.item_done();
            end
        else forever begin
            send_slave();
        end
    endtask

    virtual task send_master();
        ap.write(req);

        do_delay();

        vif.tvalid <= '1;
        vif.tdata  <= req.tdata;

        do begin
            vif.wait_for_clks(1);
        end while( !vif.tready );

        unset_master_data();
    endtask

    virtual task send_slave();
        do_delay();
        vif.tready <= '1;
        do_delay();
        vif.tready <= '0;
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
