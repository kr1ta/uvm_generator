`timescale 1ns/1ps

module tb;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import example_test_pkg::*;

    parameter CLK_PERIOD = 10;

    logic clk_i;

    // Clock generation.
    initial begin
        clk_i <= 0;
        forever begin
            #(CLK_PERIOD/2) clk_i = ~clk_i;
        end
    end

    // Reset interface.
    reset_intf reset_if(clk_i);

    // declare DUT here

    initial begin
        uvm_resource_db#(int unsigned)::set(
            "uvm_test_top*", "CLK_PERIOD", CLK_PERIOD);

        uvm_resource_db#(virtual reset_intf)::set(
            "uvm_test_top", "vif", reset_if);

        run_test();
    end

endmodule
