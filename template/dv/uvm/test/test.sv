//---------------------------------------------------------
// Class: test
//---------------------------------------------------------

class test extends uvm_test;
    `uvm_component_utils({{prefix}}_test_pkg::test)

    // Watchdog.
    watchdog wdg;

    // Reset agent configuration.
    reset_agent_pkg::cfg reset_agent_cfg;

    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        set_overrides();

        // Create watchdog.
        wdg = watchdog::type_id::create("wdg", this);
        uvm_resource_db#(int)::set(
            {get_full_name(), ".wdg"}, "timeout_ns", 1_000_000);

        // Create environment.
        env = {{prefix}}_env_pkg::env::type_id::create("env", this);

        // Reset agent configuration.
        reset_agent_cfg = reset_agent_pkg::cfg::type_id::create("reset_agent_cfg");

        setup_configs();
    endfunction

    virtual function void set_overrides();
    endfunction

    virtual function void setup_configs();
        // Reset agent configuration setup.
        if(!uvm_resource_db#(virtual reset_intf)::read_by_name(
            get_full_name(), "vif", reset_agent_cfg.vif))
        begin
            `uvm_fatal(get_name(), "Can't get reset_intf!");
        end

        // Randomize and pass reset_agent_cfg.
        if(!reset_agent_cfg.randomize() with {
            duration_type == reset_utils_pkg::CLOCKS;
            sync_type     == reset_utils_pkg::SYNC_ACTIVE; })
            `uvm_fatal(get_name(), "Can't randomize 'reset_agent_cfg'!");

        uvm_resource_db#(reset_agent_pkg::cfg)::set(
            {get_full_name(), ".env.reset_agent*"}, "cfg", reset_agent_cfg);
    endfunction

    virtual task reset_phase(uvm_phase phase);
        reset_seq_pkg::seq_with_duration reset;

        phase.raise_objection(this);

        reset = reset_seq_pkg::seq_with_duration::type_id::create("reset");
        reset.start(env.reset_agent.sqr);

        phase.drop_objection(this);
    endtask

    virtual task main_phase(uvm_phase phase);
        phase.raise_objection(this);

        // start sequences here

        phase.drop_objection(this);
    endtask

endclass
