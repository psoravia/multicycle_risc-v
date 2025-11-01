`timescale 1ns / 1ps

module tb_register_file ();
    // Inputs
    reg        clk_i;
    reg [4:0]  aa_i, ab_i, aw_i;
    reg        wren_i;
    reg [31:0] wrdata_i;

    // Outputs
    wire [31:0] a_o, b_o;

    // Instantiate the Unit Under Test (UUT)
    register_file uut (
        .clk_i (clk_i),
        .aa_i (aa_i),
        .ab_i (ab_i),
        .aw_i (aw_i),
        .wren_i (wren_i),
        .wrdata_i (wrdata_i),
        .a_o (a_o),
        .b_o (b_o)
    );

    initial begin
        // Generate waveform file
        $dumpfile("dump/tb_register_file.vcd");
        $dumpvars(0, tb_register_file);

        $display("TEST : nothing written");
        aa_i = 0; ab_i = 2; aw_i = 5'b1; wren_i = 0; wrdata_i = 32'h000000FF;
        #10;
        $display("a_o = %h", a_o);
        $display("b_o = %h", b_o);

        $display();

        $display("TEST : writte 32'h000000FF to x2");
        aa_i = 4; ab_i = 5; aw_i = 2; wren_i = 1; wrdata_i = 32'h000000FF;
        #10;
        $display("a_o = %h", a_o);
        $display("b_o = %h", b_o);

        $display();

        $display("TEST : read back 32'h000000FF from x2");
        aa_i = 2; ab_i = 5; aw_i = 3; wren_i = 1; wrdata_i = 32'h00000FFF;
        #10;
        $display("a_o = %h", a_o);
        $display("b_o = %h", b_o);

        $display();

        $display("TEST : trying to write to x0");
        aa_i = 6; ab_i = 3; aw_i = 0; wren_i = 1; wrdata_i = 32'hFFFFFFFF;
        #10;
        $display("x0 = %h", uut.reg_array_r[0]);
        $display("a_o = %h", a_o);
        $display("b_o = %h", b_o);

        $display();

        $display("TEST : check if x0 has been written to");
        aa_i = 0; ab_i = 3; aw_i = 7; wren_i = 0; wrdata_i = 32'hFFFFFFFF;
        #10;
        $display("x0 = %h", uut.reg_array_r[0]);
        $display("a_o = %h", a_o);
        $display("b_o = %h", b_o);

        $display();

        // Finish simulation
        $finish;
    end

    always begin
        #5 clk_i = ~clk_i;
    end
endmodule