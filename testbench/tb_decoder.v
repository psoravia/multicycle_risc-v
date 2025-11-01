`timescale 1ns / 1ps

module tb_decoder ();
    // Inputs
    reg [31:0] addr_i;

    // Outputs
    wire en_ram_o, en_leds_o, en_7_seg_lcd_o, en_buttons_o;

    // Variables for test tracking
    integer i;

    // Instantiate the Unit Under Test (UUT)
    decoder uut (
        .addr_i (addr_i),
        .en_ram_o (en_ram_o),
        .en_leds_o (en_leds_o),
        .en_7_seg_lcd_o (en_7_seg_lcd_o),
        .en_buttons_o (en_buttons_o)
    );

    initial begin
        // Generate waveform file
        $dumpfile("dump/tb_decoder.vcd");
        $dumpvars(0, tb_decoder);
        
        addr_i = 32'h0;
        #10;
        if (en_ram_o === 0 && en_leds_o === 0 && en_7_seg_lcd_o === 0 && en_buttons_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output at input addr_i = %h", addr_i);
        end

        addr_i = 32'h4CFAF1FF;
        #10;
        if (en_ram_o === 0 && en_leds_o === 0 && en_7_seg_lcd_o === 0 && en_buttons_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output at input addr_i = %h", addr_i);
        end

        addr_i = 32'h4FFFFFFF;
        #10;
        if (en_ram_o === 0 && en_leds_o === 0 && en_7_seg_lcd_o === 0 && en_buttons_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output at input addr_i = %h", addr_i);
        end

        addr_i = 32'h50000000;
        #10;
        if (en_ram_o === 0 && en_leds_o === 1 && en_7_seg_lcd_o === 0 && en_buttons_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output at input addr_i = %h", addr_i);
        end

        addr_i = 32'h500000AB;
        #10;
        if (en_ram_o === 0 && en_leds_o === 1 && en_7_seg_lcd_o === 0 && en_buttons_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output at input addr_i = %h", addr_i);
        end

        addr_i = 32'h50000FFF;
        #10;
        if (en_ram_o === 0 && en_leds_o === 1 && en_7_seg_lcd_o === 0 && en_buttons_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output at input addr_i = %h", addr_i);
        end

        addr_i = 32'h50001000;
        #10;
        if (en_ram_o === 0 && en_leds_o === 0 && en_7_seg_lcd_o === 0 && en_buttons_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output at input addr_i = %h", addr_i);
        end

        addr_i = 32'h500010F0;
        #10;
        if (en_ram_o === 0 && en_leds_o === 0 && en_7_seg_lcd_o === 0 && en_buttons_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output at input addr_i = %h", addr_i);
        end

        addr_i = 32'h60000000;
        #10;
        if (en_ram_o === 0 && en_leds_o === 0 && en_7_seg_lcd_o === 1 && en_buttons_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output at input addr_i = %h", addr_i);
        end

        addr_i = 32'h60000010;
        #10;
        if (en_ram_o === 0 && en_leds_o === 0 && en_7_seg_lcd_o === 1 && en_buttons_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output at input addr_i = %h", addr_i);
        end

        addr_i = 32'h60000FFF;
        #10;
        if (en_ram_o === 0 && en_leds_o === 0 && en_7_seg_lcd_o === 1 && en_buttons_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output at input addr_i = %h", addr_i);
        end

        addr_i = 32'h60001000;
        #10;
        if (en_ram_o === 0 && en_leds_o === 0 && en_7_seg_lcd_o === 0 && en_buttons_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output at input addr_i = %h", addr_i);
        end

        addr_i = 32'h6FFFFFFF;
        #10;
        if (en_ram_o === 0 && en_leds_o === 0 && en_7_seg_lcd_o === 0 && en_buttons_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output at input addr_i = %h", addr_i);
        end

        addr_i = 32'h70000000;
        #10;
        if (en_ram_o === 0 && en_leds_o === 0 && en_7_seg_lcd_o === 0 && en_buttons_o === 1) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output at input addr_i = %h", addr_i);
        end

        addr_i = 32'h70000002;
        #10;
        if (en_ram_o === 0 && en_leds_o === 0 && en_7_seg_lcd_o === 0 && en_buttons_o === 1) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output at input addr_i = %h", addr_i);
        end

        addr_i = 32'h70000FAB;
        #10;
        if (en_ram_o === 0 && en_leds_o === 0 && en_7_seg_lcd_o === 0 && en_buttons_o === 1) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output at input addr_i = %h", addr_i);
        end

        addr_i = 32'h70000FFF;
        #10;
        if (en_ram_o === 0 && en_leds_o === 0 && en_7_seg_lcd_o === 0 && en_buttons_o === 1) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output at input addr_i = %h", addr_i);
        end

        addr_i = 32'h70001000;
        #10;
        if (en_ram_o === 0 && en_leds_o === 0 && en_7_seg_lcd_o === 0 && en_buttons_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output at input addr_i = %h", addr_i);
        end

        addr_i = 32'h80000000;
        #10;
        if (en_ram_o === 1 && en_leds_o === 0 && en_7_seg_lcd_o === 0 && en_buttons_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output at input addr_i = %h", addr_i);
        end

        addr_i = 32'h81111111;
        #10;
        if (en_ram_o === 1 && en_leds_o === 0 && en_7_seg_lcd_o === 0 && en_buttons_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output at input addr_i = %h", addr_i);
        end

        addr_i = 32'h80C03010;
        #10;
        if (en_ram_o === 1 && en_leds_o === 0 && en_7_seg_lcd_o === 0 && en_buttons_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output at input addr_i = %h", addr_i);
        end

        addr_i = 32'h8FFFFFFF;
        #10;
        if (en_ram_o === 1 && en_leds_o === 0 && en_7_seg_lcd_o === 0 && en_buttons_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output at input addr_i = %h", addr_i);
        end

        addr_i = 32'h94766437;
        #10;
        if (en_ram_o === 1 && en_leds_o === 0 && en_7_seg_lcd_o === 0 && en_buttons_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output at input addr_i = %h", addr_i);
        end

        addr_i = 32'h9FFFFFFF;
        #10;
        if (en_ram_o === 1 && en_leds_o === 0 && en_7_seg_lcd_o === 0 && en_buttons_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output at input addr_i = %h", addr_i);
        end

        addr_i = 32'hA0000000;
        #10;
        if (en_ram_o === 0 && en_leds_o === 0 && en_7_seg_lcd_o === 0 && en_buttons_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output at input addr_i = %h", addr_i);
        end

        addr_i = 32'hA6474378;
        #10;
        if (en_ram_o === 0 && en_leds_o === 0 && en_7_seg_lcd_o === 0 && en_buttons_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output at input addr_i = %h", addr_i);
        end

        addr_i = 32'hFFFFFFFF;
        #10;
        if (en_ram_o === 0 && en_leds_o === 0 && en_7_seg_lcd_o === 0 && en_buttons_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output at input addr_i = %h", addr_i);
        end

        addr_i = 32'h50000A00;
        #10;
        if (en_ram_o === 0 && en_leds_o === 1 && en_7_seg_lcd_o === 0 && en_buttons_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output at input addr_i = %h", addr_i);
        end

        addr_i = 32'h60000A11;
        #10;
        if (en_ram_o === 0 && en_leds_o === 0 && en_7_seg_lcd_o === 1 && en_buttons_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output at input addr_i = %h", addr_i);
        end

        addr_i = 32'h700000B0;
        #10;
        if (en_ram_o === 0 && en_leds_o === 0 && en_7_seg_lcd_o === 0 && en_buttons_o === 1) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output at input addr_i = %h", addr_i);
        end

        addr_i = 32'h8AAAAAAA;
        #10;
        if (en_ram_o === 1 && en_leds_o === 0 && en_7_seg_lcd_o === 0 && en_buttons_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output at input addr_i = %h", addr_i);
        end

        // Finish simulation
        $finish;
    end

endmodule