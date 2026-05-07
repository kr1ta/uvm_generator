//---------------------------------------------------------
// Class: env
//---------------------------------------------------------

class env extends uvm_env;
    `uvm_component_utils({{prefix}}_env_pkg::env)

    // Reset agent.
    reset_agent_pkg::agent reset_agent;

    // Scoreboard.
    scoreboard scb;

    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        // Create agents.
        reset_agent = reset_agent_pkg::agent::type_id::create("reset_agent", this);

        // Create scoreboard.
        scb = scoreboard::type_id::create("scb", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        // connect agents to scoreboard
    endfunction

endclass
