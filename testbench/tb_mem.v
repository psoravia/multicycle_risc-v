`timescale 1ns / 1ps

module tb_mem ();
    
    // inputs
    reg clk_i, en_i, we_i;
    reg [31:0] addr_i, wdata_i;

    // outputs
    wire [31:0] rdata_o;

    // Instantiate the Unit Under Test (UUT)
    mem uut (
        .clk_i (clk_i),
        .en_i (en_i),
        .we_i (we_i),
        .addr_i (addr_i),
        .wdata_i (wdata_i),
        .rdata_o (rdata_o)
    );

    initial begin
        // Generate waveform file
        $dumpfile("dump/tb_mem.vcd");
        $dumpvars(0, tb_mem);

        $display("TEST : Write to MEM the value 0xFFFFFFFF");
        en_i = 1;
        we_i = 1;
        addr_i = 32'h80000ABF;
        wdata_i = 32'hFFFFFFFF;
        #10;
        if (rdata_o === 32'h0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 32'h0, got rdata_o = %h", rdata_o);
        end

        $display();

        $display("TEST : Read from MEM the value 0xFFFFFFFF");
        en_i = 1;
        we_i = 0;
        addr_i = 32'h80000ABF;
        wdata_i = 32'hFFFFFFFF;
        #10;
        if (rdata_o === 32'hFFFFFFFF) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 32'hFFFFFFFF, got rdata_o = %h", rdata_o);
        end

        $display();

        $display("TEST : Write to MEM the value 0xAAAAAAAA but MEM is not enable");
        en_i = 0;
        we_i = 1;
        addr_i = 32'h80000ABF;
        wdata_i = 32'hAAAAAAAA;
        #10;
        if (rdata_o === 32'h0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 32'h0, got rdata_o = %h", rdata_o);
        end

        $display();

        $display("TEST : Check previous write was not effective");
        en_i = 1;
        we_i = 0;
        addr_i = 32'h80000ABF;
        wdata_i = 32'h0;
        #10;
        if (rdata_o === 32'hFFFFFFFF) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 32'hFFFFFFFF, got rdata_o = %h", rdata_o);
        end

        $display();

        $display("TEST : Another write to MEM");
        en_i = 1;
        we_i = 1;
        addr_i = 32'h9FFFFFFF;
        wdata_i = 32'hABCD1234;
        #10;
        if (rdata_o === 32'h0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 32'h0, got rdata_o = %h", rdata_o);
        end

        $display();

        $display("TEST : Data has been written to MEM");
        en_i = 1;
        we_i = 0;
        addr_i = 32'h9FFFFFFF;
        wdata_i = 32'h0;
        #10;
        en_i = 0;
        if (rdata_o === 32'hABCD1234) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 32'hABCD1234, got rdata_o = %h", rdata_o);
        end

        $display();

        $display("TEST : Read but MEM is disabled");
        en_i = 0;
        we_i = 0;
        addr_i = 32'h9FFFFFFF;
        wdata_i = 32'h0;
        #10;
        if (rdata_o === 32'h0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 32'h0, got rdata_o = %h", rdata_o);
        end

        $display();

        // Finish simulation
        $finish;
    end

    always begin
        #5 clk_i = ~clk_i;
    end
endmodule