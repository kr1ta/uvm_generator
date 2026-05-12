//---------------------------------------------------------
// Class: example_item
//---------------------------------------------------------

class example_item extends uvm_sequence_item;

    `uvm_object_utils(example_agent_pkg::example_item)

    function new(string name = "");
        super.new(name);
    endfunction

    rand logic [31:0] tdata;

    //---------------------------------------------------------
    // Functions: Common.
    //---------------------------------------------------------

    // do_copy

    virtual function void do_copy(uvm_object rhs);
        example_item that;

        if( !$cast(that, rhs) )
            `uvm_fatal(get_name(),
                $sformatf("rhs is not 'example_item' type"));

        super.do_copy(that);

        this.tdata = that.tdata;
    endfunction

    // convert2string

    virtual function string convert2string();
        string str;

        str = {str, $sformatf("\ntdata: %d", tdata)};

        return str;
    endfunction

endclass
