`timescale 1ns / 1ps

module tb_seven_seg_lcd ();
    
    // inputs
    reg clk_i, rst_ni, en_i, we_i;
    reg [31:0] waddr_i, wdata_i;

    // output
    wire [31:0] disp_o;

    // Instantiate the Unit Under Test (UUT)
    seven_seg_lcd uut (
        .clk_i (clk_i),
        .rst_ni (rst_ni),
        .en_i (en_i),
        .we_i (we_i),
        .waddr_i (waddr_i),
        .wdata_i (wdata_i),
        .disp_o (disp_o)
    );

    initial begin
        // Generate waveform file
        $dumpfile("dump/tb_seven_seg_lcd.vcd");
        $dumpvars(0, tb_seven_seg_lcd);

        $display("TEST : Reset");
        en_i = 1;
        we_i = 1;
        rst_ni = 0;
        waddr_i = 32'h60000000;
        wdata_i = 32'h00004F4F;
        #10;
        if (disp_o === 32'h00000000) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 32'h00000000, got rdata_o = %h", disp_o);
        end

        $display("TEST : Write '3' to 7-SEGS display");
        en_i = 1;
        we_i = 1;
        rst_ni = 1;
        waddr_i = 32'h60000000;
        wdata_i = 32'h0000004F;
        #10;
        if (disp_o === 32'h0000004F) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 32'h0000004F, got rdata_o = %h", disp_o);
        end

        $display("TEST : Write 'ABF0' to 7-SEGS display");
        en_i = 1;
        we_i = 1;
        rst_ni = 1;
        waddr_i = 32'h60000000;
        wdata_i = 32'h777C713F;
        #10;
        if (disp_o === 32'h777C713F) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 32'h777C713F, got rdata_o = %h", disp_o);
        end

        $display("TEST : Reset");
        en_i = 0;
        we_i = 0;
        rst_ni = 0;
        waddr_i = 32'h60000000;
        wdata_i = 32'h00004F4F;
        #10;
        if (disp_o === 32'h00000000) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 32'h00000000, got rdata_o = %h", disp_o);
        end
        
        $display();

        // Finish simulation
        $finish;
    end

    always begin
        #5 clk_i = ~clk_i;
    end
endmodule