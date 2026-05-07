//---------------------------------------------------------
// Class: seq
//---------------------------------------------------------

class seq extends uvm_sequence#(example_item);
    `uvm_object_utils(example_agent_pkg::seq)

    function new(string name = "");
        super.new(name);
    endfunction

    virtual task body();
        req = REQ::type_id::create("req");

        start_item(req);
        if(!req.randomize())
            `uvm_fatal(get_name(), "Can't randomize 'req'!");
        finish_item(req);
    endtask
endclass
