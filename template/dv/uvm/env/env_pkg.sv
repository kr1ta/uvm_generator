//---------------------------------------------------------
// Package: {{prefix}}_env_pkg
//---------------------------------------------------------

package {{prefix}}_env_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "{{prefix}}_predictor.sv"
    `include "{{prefix}}_comparator.sv"
    `include "{{prefix}}_scoreboard.sv"
    `include "{{prefix}}_env.sv"

endpackage

