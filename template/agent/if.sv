//---------------------------------------------------------
// Interface: {{prefix}}_if
//---------------------------------------------------------

interface {{prefix}}_if (
    input logic clk,
    input logic aresetn
);

    logic [31:0] tdata;

    logic tvalid;
    logic tready;

    //---------------------------------------------------------
    // Tasks: Wait for clock/reset tasks.
    //---------------------------------------------------------

    task wait_for_clks(int num);
        repeat(num) @(posedge clk);
    endtask

    task wait_for_reset();
        wait(!aresetn);
    endtask

    task wait_for_unreset();
        wait(aresetn);
    endtask

endinterface
