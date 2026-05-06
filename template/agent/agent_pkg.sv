//---------------------------------------------------------
// Package: {{prefix}}_agent_pkg
//---------------------------------------------------------

package {{prefix}}_agent_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "{{prefix}}_item.sv"
    `include "{{prefix}}_sequence.sv"
    `include "{{prefix}}_sequencer.sv"
    `include "{{prefix}}_driver.sv"
    `include "{{prefix}}_monitor.sv"
    `include "{{prefix}}_agent.sv"

endpackage
