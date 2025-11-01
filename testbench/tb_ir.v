`timescale 1ns / 1ps

module tb_ir ();
    // Inputs
    reg        clk_i;
    reg        enable_i;
    reg [31:0] d_i;

    // Outputs
    wire [31:0] q_o;

    // Instantiate the Unit Under Test (UUT)
    ir uut (
        .clk_i (clk_i),
        .enable_i (enable_i),
        .d_i (d_i),
        .q_o (q_o)
    );

    initial begin
        // Generate waveform file
        $dumpfile("dump/tb_ir.vcd");
        $dumpvars(0, tb_ir);

        $display("TEST : Write to IR the value 0xFFFFFFFF");
        enable_i = 1; d_i = 32'hFFFFFFFF;
        #10;
        $display("q_o = %h", q_o);

        $display();

        $display("TEST : Write to IR the value 0xEEEEEEEE but enable disabled");
        enable_i = 0; d_i = 32'hEEEEEEEE;
        #10;
        $display("q_o = %h", q_o);

        $display();

        // Finish simulation
        $finish;
    end

    always begin
        #5 clk_i = ~clk_i;
    end
endmodule