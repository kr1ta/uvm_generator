//---------------------------------------------------------
// Class: predictor
//---------------------------------------------------------

class predictor extends uvm_component;
    `uvm_component_utils(example_env_pkg::predictor)

    //---------------------------------------------------------
    // Fields: in_fifo, in_item
    //---------------------------------------------------------

    uvm_tlm_analysis_fifo #(uvm_sequence_item) in_fifo;

    uvm_sequence_item in_item;

    //---------------------------------------------------------
    // Field: ap
    //---------------------------------------------------------

    // Analysis port for predicted items.

    uvm_analysis_port#(uvm_sequence_item) ap;

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        in_fifo = new("in_fifo", this);
        ap  = new("ap", this);
    endfunction

    virtual function void phase_ended(uvm_phase phase);
        if ( phase.is(uvm_reset_phase::get()) ) begin
            in_fifo.flush();
        end
    endfunction

    virtual task main_phase(uvm_phase phase);
        uvm_sequence_item out_item;

        forever begin
            in_fifo.get(in_item);

            out_item = uvm_sequence_item::type_id::create("out_item");

            // prediction logic

            ap.write(out_item);
        end
    endtask

endclass
