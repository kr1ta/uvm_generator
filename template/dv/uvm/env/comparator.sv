//---------------------------------------------------------
// Class: comparator
//---------------------------------------------------------

class comparator extends uvm_component;
    `uvm_component_utils({{prefix}}_env_pkg::comparator)

    //---------------------------------------------------------
    // Fields: real_fifo, pred_fifo
    //---------------------------------------------------------

    uvm_tlm_analysis_fifo #(uvm_sequence_item) real_fifo;
    uvm_tlm_analysis_fifo #(uvm_sequence_item) pred_fifo;

    //---------------------------------------------------------
    // Fields: pred_item, real_item
    //---------------------------------------------------------

    // Items for FIFO get() method.

    uvm_sequence_item pred_item, real_item;

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        real_fifo = new("real_fifo", this);
        pred_fifo = new("pred_fifo", this);
    endfunction

    virtual function void phase_ended(uvm_phase phase);
        if ( phase.is(uvm_reset_phase::get()) ) begin
            real_fifo.flush();
            pred_fifo.flush();
        end
    endfunction

    virtual task main_phase(uvm_phase phase);
        forever begin
            // Get predicted item.
            pred_fifo.get(pred_item);

            // Get real item.
            real_fifo.get(real_item);

            // Compare them.
            compare();
        end
    endtask

    virtual function void compare();
        // write comparison logic here
    endfunction

endclass
