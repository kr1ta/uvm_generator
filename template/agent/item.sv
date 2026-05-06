//---------------------------------------------------------
// Class: {{prefix}}_item
//---------------------------------------------------------

class {{prefix}}_item extends uvm_sequence_item;

    `uvm_object_utils(cmd_agent_pkg::{{prefix}}_item)

    function new(string name = "");
        super.new(name);
    endfunction

    rand logic [31:0] tdata;

    //---------------------------------------------------------
    // Functions: Common.
    //---------------------------------------------------------

    // do_copy

    virtual function void do_copy(uvm_object rhs);
        {{prefix}}_item that;

        if( !$cast(that, rhs) )
            `uvm_fatal(get_name(),
                $sformatf("rhs is not '{{prefix}}_item' type"));

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
