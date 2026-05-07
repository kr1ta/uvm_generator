class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(example_env_pkg::scoreboard)

    // Predictor.
    predictor prd;

    // Comparator.
    comparator cmp;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        prd = predictor ::type_id::create("prd", this);
        cmp = comparator::type_id::create("cmp", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        // Connect predictor ap to comparator FIFO.
        prd.ap.connect(cmp.pred_fifo.analysis_export);
    endfunction

endclass
