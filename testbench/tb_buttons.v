`timescale 1ns / 1ps

module tb_buttons ();
    
    // inputs
    reg clk_i, rst_ni, en_i, we_i;
    reg [31:0] addr_i, wdata_i;
    reg [9:0] push_i;
    reg [7:0] switch_i;

    // outputs
    wire [31:0] rdata_o;
    wire irq_o;


    // Instantiate the Unit Under Test (UUT)
    buttons uut (
        .clk_i (clk_i),
        .rst_ni (rst_ni),
        .en_i (en_i),
        .we_i (we_i),
        .addr_i (addr_i),
        .wdata_i (wdata_i),
        .push_i (push_i),
        .switch_i (switch_i),
        .rdata_o (rdata_o),
        .irq_o (irq_o)
    );

    initial begin
        // Generate waveform file
        $dumpfile("dump/tb_buttons.vcd");
        $dumpvars(0, tb_buttons);

        $display("TEST : Reset");
        rst_ni = 0;
        en_i = 1;
        we_i = 0;
        addr_i = 32'h70000000;
        wdata_i = 32'h0;
        push_i = 10'b0;
        switch_i = 8'b0;
        #10;
        if (rdata_o === 32'h00000000) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 32'h00000000, got rdata_o = %h", rdata_o);
        end
        if (irq_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected irq_o = 0, got irq_o = %h", irq_o);
        end

        $display("TEST : Push buttons and switches");
        rst_ni = 1;
        en_i = 1;
        we_i = 0;
        addr_i = 32'h70000000;
        wdata_i = 32'h0;
        push_i = 10'b1010101011;
        switch_i = 8'b00111010;
        #10;
        if (rdata_o === 32'b00000000_00111010_000000_1010101011) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 32'b00000000_00111010_000000_1010101011, got rdata_o = %h", rdata_o);
        end
        if (irq_o === 1) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected irq_o = 1, got irq_o = %h", irq_o);
        end

        $display("TEST : Modify pushed buttons and switches");
        rst_ni = 1;
        en_i = 1;
        we_i = 0;
        addr_i = 32'h70000000;
        wdata_i = 32'h0;
        push_i = 10'b1111111000;
        switch_i = 8'b00001111;
        #10;
        if (rdata_o === 32'b00000000_00001111_000000_1111111000) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 32'b00000000_00001111_000000_1111111000, got rdata_o = %h", rdata_o);
        end
        if (irq_o === 1) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected irq_o = 1, got irq_o = %h", irq_o);
        end

        $display("TEST : If disable, then pushing buttons or switches does nothing");
        rst_ni = 1;
        en_i = 0;
        we_i = 0;
        addr_i = 32'h70000000;
        wdata_i = 32'h0;
        push_i = 10'b0001110001;
        switch_i = 8'b11110000;
        #10;
        if (rdata_o === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 32'b0, got rdata_o = %h", rdata_o);
        end
        if (irq_o === 1) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected irq_o = 1, got irq_o = %h", irq_o);
        end

        $display("TEST : Reset");
        rst_ni = 0;
        en_i = 0;
        we_i = 0;
        addr_i = 32'h70000000;
        wdata_i = 32'h0;
        push_i = 10'b0001110001;
        switch_i = 8'b11110000;
        #10;
        if (rdata_o === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 32'b0, got rdata_o = %h", rdata_o);
        end
        if (irq_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected irq_o = 0, got irq_o = %h", irq_o);
        end
        
        $display();

        $display("TEST : Setup buttons trigger modes");
        rst_ni = 1;
        en_i = 1;
        we_i = 1;
        addr_i = 32'h70000008;
        wdata_i = 32'b000000000000_00_01_01_10_01_11_10_11_01_00;
        push_i = 10'b0;
        switch_i = 8'b0;
        #10;
        if (rdata_o === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 32'b0, got rdata_o = %h", rdata_o);
        end
        if (irq_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected irq_o = 0, got irq_o = %h", irq_o);
        end
        if (uut.ptm_r === 32'b000000000000_00_01_01_10_01_11_10_11_01_00) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected ptm_r = 000000000000_00_01_01_10_01_11_10_11_01_00, got ptm_r = %h", uut.ptm_r);
        end
        if (uut.val_r === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected val_r = 00000000_00000000_000000_0000000000, got src_r = %b_%b_%b_%b", uut.val_r[31:24], uut.val_r[23:16], uut.val_r[15:10], uut.val_r[9:0]);
        end

        $display("TEST : Setup switches trigger modes");
        rst_ni = 1;
        en_i = 1;
        we_i = 1;
        addr_i = 32'h7000000C;
        wdata_i = 32'b0000000000000000_01_10_00_11_11_10_00_01;
        push_i = 10'b1000000001;
        switch_i = 8'b0;
        #10;
        if (rdata_o === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 32'b0, got rdata_o = %h", rdata_o);
        end
        if (irq_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected irq_o = 0, got irq_o = %h", irq_o);
        end
        if (uut.stm_r === 32'b0000000000000000_01_10_00_11_11_10_00_01) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected stm_r = 0000000000000000_01_10_00_11_11_10_00_01, got stm_r = %h", uut.stm_r);
        end
        if (uut.val_r === 32'b00000000_00000000_000000_1000000001) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected val_r = 00000000_00000000_000000_1000000001, got src_r = %b_%b_%b_%b", uut.val_r[31:24], uut.val_r[23:16], uut.val_r[15:10], uut.val_r[9:0]);
        end

        $display();

        $display("TEST : Interrupts are triggered immediatly 1");
        rst_ni = 1;
        en_i = 1;
        we_i = 0;
        addr_i = 32'h70000004;
        wdata_i = 32'h1;
        push_i = 10'b0_1_1_0_0_1_1_0_1_1;
        switch_i = 8'b1_1_0_1_0_0_1_0;
        #10;
        if (rdata_o === 32'b00000000_10110000_000000_1110010010) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 00000000_10110000_000000_1110010010, got rdata_o = %b_%b_%b_%b", rdata_o[31:24], rdata_o[23:16], rdata_o[15:10], rdata_o[9:0]);
        end
        if (irq_o === 1) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected irq_o = 1, got irq_o = %h", irq_o);
        end
        if (uut.src_r === 32'b00000000_10110000_000000_1110010010) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected src_r = 00000000_10110000_000000_1110010010, got src_r = %b_%b_%b_%b", uut.src_r[31:24], uut.src_r[23:16], uut.src_r[15:10], uut.src_r[9:0]);
        end
        if (uut.val_r === 32'b00000000_1_1_0_1_0_0_1_0_000000_0_1_1_0_0_1_1_0_1_1) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected val_r = 00000000_1_1_0_1_0_0_1_0_000000_0_1_1_0_0_1_1_0_1_1, got src_r = %b_%b_%b_%b", uut.val_r[31:24], uut.val_r[23:16], uut.val_r[15:10], uut.val_r[9:0]);
        end

        $display();

        $display("TEST : Interrupts are triggered immediatly 2");
        rst_ni = 1;
        en_i = 1;
        we_i = 0;
        addr_i = 32'h70000004;
        wdata_i = 32'h1;
        push_i = 10'b0_0_0_0_0_1_0_1_1_1;
        switch_i = 8'b0_0_1_0_0_1_0_1;
        #10;
        if (rdata_o === 32'b00000000_11000011_000000_1110011110) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 32'b00000000_11000011_000000_1110011110, got rdata_o = %b_%b_%b_%b", rdata_o[31:24], rdata_o[23:16], rdata_o[15:10], rdata_o[9:0]);
        end
        if (irq_o === 1) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected irq_o = 1, got irq_o = %h", irq_o);
        end
        if (uut.src_r === 32'b00000000_11000011_000000_1110011110) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected src_r = 32'b00000000_11000011_000000_1110011110, got src_r = %b_%b_%b_%b", uut.src_r[31:24], uut.src_r[23:16], uut.src_r[15:10], uut.src_r[9:0]);
        end
        if (uut.val_r === 32'b00000000_0_0_1_0_0_1_0_1_000000_0_0_0_0_0_1_0_1_1_1) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected val_r = 00000000_0_0_1_0_0_1_0_1_000000_0_0_0_0_0_1_0_1_1_1, got src_r = %b_%b_%b_%b", uut.val_r[31:24], uut.val_r[23:16], uut.val_r[15:10], uut.val_r[9:0]);
        end

        $display();

        $display("TEST : Interrupts are triggered immediatly 3");
        rst_ni = 1;
        en_i = 1;
        we_i = 0;
        addr_i = 32'h70000004;
        wdata_i = 32'h1;
        push_i = 10'b1_1_1_1_1_1_1_0_0_0;
        switch_i = 8'b0_1_0_0_1_0_0_0;
        #10;
        if (rdata_o === 32'b00000000_11101111_000000_0110111011) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 32'b00000000_11101111_000000_0110111011, got rdata_o = %b_%b_%b_%b", rdata_o[31:24], rdata_o[23:16], rdata_o[15:10], rdata_o[9:0]);
        end
        if (irq_o === 1) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected irq_o = 1, got irq_o = %h", irq_o);
        end
        if (uut.src_r === 32'b00000000_11101111_000000_0110111011) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected src_r = 32'b00000000_11101111_000000_0110111011, got src_r = %b_%b_%b_%b", uut.src_r[31:24], uut.src_r[23:16], uut.src_r[15:10], uut.src_r[9:0]);
        end
        if (uut.val_r === 32'b00000000_0_1_0_0_1_0_0_0_000000_1_1_1_1_1_1_1_0_0_0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected val_r = 32'b00000000_0_1_0_0_1_0_0_0_000000_1_1_1_1_1_1_1_0_0_0, got src_r = %b_%b_%b_%b", uut.val_r[31:24], uut.val_r[23:16], uut.val_r[15:10], uut.val_r[9:0]);
        end

        $display();

        $display("TEST : Writing all zeros to the SRC register clears all falling and rising edge");
        rst_ni = 1;
        en_i = 1;
        we_i = 1;
        addr_i = 32'h70000004;
        wdata_i = 32'h0;
        push_i = 10'b0_0_1_1_1_0_0_1_1_0;
        switch_i = 8'b0_1_1_0_1_0_1_1;
        #10;
        if (rdata_o === 32'h0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 00000000_00000000_000000_0000000000, got rdata_o = %b_%b_%b_%b", rdata_o[31:24], rdata_o[23:16], rdata_o[15:10], rdata_o[9:0]);
        end
        if (irq_o === 1) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected irq_o = 1, got irq_o = %h", irq_o);
        end
        if (uut.src_r === 32'b00000000_00001000_000000_1000000101) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected src_r = 00000000_00001000_000000_1000000101, got src_r = %b_%b_%b_%b", uut.src_r[31:24], uut.src_r[23:16], uut.src_r[15:10], uut.src_r[9:0]);
        end
        if (uut.val_r === 32'b00000000_0_1_1_0_1_0_1_1_000000_0_0_1_1_1_0_0_1_1_0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected val_r = 00000000_0_1_1_0_1_0_1_1_000000_0_0_1_1_1_0_0_1_1_0, got src_r = %b_%b_%b_%b", uut.val_r[31:24], uut.val_r[23:16], uut.val_r[15:10], uut.val_r[9:0]);
        end
            
        $display();

        $display("TEST : Writing not all zeros to the SRC register does nothing");
        rst_ni = 1;
        en_i = 1;
        we_i = 1;
        addr_i = 32'h70000004;
        wdata_i = 32'h2;
        push_i = 10'b1_1_1_0_0_1_1_1_0_1;
        switch_i = 8'b1_0_0_0_1_1_0_0;
        #10;
        if (rdata_o === 32'h0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 00000000_00000000_000000_0000000000, got rdata_o = %b_%b_%b_%b", rdata_o[31:24], rdata_o[23:16], rdata_o[15:10], rdata_o[9:0]);
        end
        if (irq_o === 1) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected irq_o = 1, got irq_o = %h", irq_o);
        end
        if (uut.src_r === 32'b00000000_11101010_000000_0101010100) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected src_r = 00000000_11101010_000000_0101010100, got src_r = %b_%b_%b_%b", uut.src_r[31:24], uut.src_r[23:16], uut.src_r[15:10], uut.src_r[9:0]);
        end
        if (uut.val_r === 32'b00000000_1_0_0_0_1_1_0_0_000000_1_1_1_0_0_1_1_1_0_1) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected val_r = 00000000_1_0_0_0_1_1_0_0_000000_1_1_1_0_0_1_1_1_0_1, got src_r = %b_%b_%b_%b", uut.val_r[31:24], uut.val_r[23:16], uut.val_r[15:10], uut.val_r[9:0]);
        end

        $display();

        $display("TEST : Changing buttons trigger modes");
        rst_ni = 1;
        en_i = 1;
        we_i = 1;
        addr_i = 32'h70000008;
        wdata_i = 32'b000000000000_01_10_10_11_00_10_01_00_11_01;
        push_i = 10'b0;
        switch_i = 8'b0;
        #10;
        if (rdata_o === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 32'b0, got rdata_o = %h", rdata_o);
        end
        if (irq_o === 1) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected irq_o = 1, got irq_o = %h", irq_o);
        end
        if (uut.ptm_r === 32'b000000000000_01_10_10_11_00_10_01_00_11_01) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected ptm_r = 000000000000_01_10_10_11_00_10_01_00_11_01, got ptm_r = %h", uut.ptm_r);
        end
        if (uut.src_r === 32'b00000000_11100110_000000_1101001001) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected src_r = 32'b00000000_11100110_000000_1101001001, got src_r = %b_%b_%b_%b", uut.src_r[31:24], uut.src_r[23:16], uut.src_r[15:10], uut.src_r[9:0]);
        end
        if (uut.val_r === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected val_r = 0, got src_r = %b_%b_%b_%b", uut.val_r[31:24], uut.val_r[23:16], uut.val_r[15:10], uut.val_r[9:0]);
        end

        $display("TEST : Changing switches trigger modes");
        rst_ni = 1;
        en_i = 1;
        we_i = 1;
        addr_i = 32'h7000000C;
        wdata_i = 32'b0000000000000000_00_10_01_11_01_00_11_10;
        push_i = 10'b0;
        switch_i = 8'b0;
        #10;
        if (rdata_o === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 32'b0, got rdata_o = %h", rdata_o);
        end
        if (irq_o === 1) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected irq_o = 1, got irq_o = %h", irq_o);
        end
        if (uut.stm_r === 32'b0000000000000000_00_10_01_11_01_00_11_10) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected stm_r = 0000000000000000_00_10_01_11_01_00_11_10, got stm_r = %h", uut.stm_r);
        end
        if (uut.src_r === 32'b00000000_11100110_000000_1100101101) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected src_r = 32'b00000000_11100110_000000_1100101101, got src_r = %b_%b_%b_%b", uut.src_r[31:24], uut.src_r[23:16], uut.src_r[15:10], uut.src_r[9:0]);
        end
        if (uut.val_r === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected val_r = 0, got src_r = %b_%b_%b_%b", uut.val_r[31:24], uut.val_r[23:16], uut.val_r[15:10], uut.val_r[9:0]);
        end

        $display();

        $display("TEST : Interrupts are triggered immediatly 4");
        rst_ni = 1;
        en_i = 1;
        we_i = 0;
        addr_i = 32'h70000004;
        wdata_i = 32'h1;
        push_i = 10'b1_0_1_0_0_1_0_0_1_1;
        switch_i = 8'b1_0_0_0_1_0_1_1;
        #10;
        if (rdata_o === 32'b00000000_01101110_000000_1100101111) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 32'b00000000_01101110_000000_1100101111, got rdata_o = %b_%b_%b_%b", rdata_o[31:24], rdata_o[23:16], rdata_o[15:10], rdata_o[9:0]);
        end
        if (irq_o === 1) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected irq_o = 1, got irq_o = %h", irq_o);
        end
        if (uut.src_r === 32'b00000000_01101110_000000_1100101111) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected src_r = 32'b00000000_01101110_000000_1100101111, got src_r = %b_%b_%b_%b", uut.src_r[31:24], uut.src_r[23:16], uut.src_r[15:10], uut.src_r[9:0]);
        end
        if (uut.val_r === 32'b00000000_1_0_0_0_1_0_1_1_000000_1_0_1_0_0_1_0_0_1_1) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected val_r = 00000000_1_0_0_0_1_0_1_1_000000_1_0_1_0_0_1_0_0_1_1, got src_r = %b_%b_%b_%b", uut.val_r[31:24], uut.val_r[23:16], uut.val_r[15:10], uut.val_r[9:0]);
        end

        $display();

        $display("TEST : Interrupts are triggered immediatly 5");
        rst_ni = 1;
        en_i = 1;
        we_i = 0;
        addr_i = 32'h70000004;
        wdata_i = 32'h1;
        push_i = 10'b0_1_0_0_1_0_1_0_1_1;
        switch_i = 8'b0_0_1_1_0_1_0_0;
        #10;
        if (rdata_o === 32'b00000000_11111001_000000_1110011111) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 32'b00000000_11111001_000000_1110011111, got rdata_o = %b_%b_%b_%b", rdata_o[31:24], rdata_o[23:16], rdata_o[15:10], rdata_o[9:0]);
        end
        if (irq_o === 1) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected irq_o = 1, got irq_o = %h", irq_o);
        end
        if (uut.src_r === 32'b00000000_11111001_000000_1110011111) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected src_r = 32'b00000000_11111001_000000_1110011111, got src_r = %b_%b_%b_%b", uut.src_r[31:24], uut.src_r[23:16], uut.src_r[15:10], uut.src_r[9:0]);
        end
        if (uut.val_r === 32'b00000000_0_0_1_1_0_1_0_0_000000_0_1_0_0_1_0_1_0_1_1) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected val_r = 00000000_0_0_1_1_0_1_0_0_000000_0_1_0_0_1_0_1_0_1_1, got src_r = %b_%b_%b_%b", uut.val_r[31:24], uut.val_r[23:16], uut.val_r[15:10], uut.val_r[9:0]);
        end

        $display();

        $display("TEST : Reset resets all register to correct value if en = 0");
        rst_ni = 0;
        en_i = 0;
        we_i = 0;
        addr_i = 32'h70000004;
        wdata_i = 32'h1;
        push_i = 10'b0_1_0_0_1_0_1_0_1_1;
        switch_i = 8'b0_0_1_1_0_1_0_0;
        #10;
        if (rdata_o === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 00000000_00000000_000000_0000000000, got rdata_o = %b_%b_%b_%b", rdata_o[31:24], rdata_o[23:16], rdata_o[15:10], rdata_o[9:0]);
        end
        if (irq_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected irq_o = 0, got irq_o = %h", irq_o);
        end
        if (uut.src_r === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected src_r = 00000000_00000000_000000_0000000000, got src_r = %b_%b_%b_%b", uut.src_r[31:24], uut.src_r[23:16], uut.src_r[15:10], uut.src_r[9:0]);
        end
        if (uut.val_r === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected val_r = 00000000_00000000_000000_0000000000, got src_r = %b_%b_%b_%b", uut.val_r[31:24], uut.val_r[23:16], uut.val_r[15:10], uut.val_r[9:0]);
        end
        if (uut.ptm_r === 32'b000000000000_11_11_11_11_11_11_11_11_11_11) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected ptm_r = 000000000000_11_11_11_11_11_11_11_11_11_11, got ptm_r = %h", uut.ptm_r);
        end
        if (uut.stm_r === 32'b0000000000000000_11_11_11_11_11_11_11_11) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected stm_r = 0000000000000000_11_11_11_11_11_11_11_11, got stm_r = %h", uut.stm_r);
        end

        $display();

        $display("TEST : Reset resets all register to correct value if en = 1");
        rst_ni = 1;
        en_i = 1;
        we_i = 0;
        addr_i = 32'h70000004;
        wdata_i = 32'h1;
        push_i = 10'b0_1_0_0_1_0_1_0_1_1;
        switch_i = 8'b0_0_1_1_0_1_0_0;
        #10;
        if (irq_o === 1) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected irq_o = 1, got irq_o = %h", irq_o);
        end
        rst_ni = 0;
        en_i = 1;
        we_i = 0;
        addr_i = 32'h70000004;
        wdata_i = 32'h1;
        push_i = 10'b0_1_0_0_1_0_1_0_1_1;
        switch_i = 8'b0_0_1_1_0_1_0_0;
        #10;
        if (rdata_o === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 00000000_00000000_000000_0000000000, got rdata_o = %b_%b_%b_%b", rdata_o[31:24], rdata_o[23:16], rdata_o[15:10], rdata_o[9:0]);
        end
        if (irq_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected irq_o = 0, got irq_o = %h", irq_o);
        end
        if (uut.src_r === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected src_r = 00000000_00000000_000000_0000000000, got src_r = %b_%b_%b_%b", uut.src_r[31:24], uut.src_r[23:16], uut.src_r[15:10], uut.src_r[9:0]);
        end
        if (uut.val_r === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected val_r = 00000000_00000000_000000_0000000000, got src_r = %b_%b_%b_%b", uut.val_r[31:24], uut.val_r[23:16], uut.val_r[15:10], uut.val_r[9:0]);
        end
        if (uut.ptm_r === 32'b000000000000_11_11_11_11_11_11_11_11_11_11) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected ptm_r = 000000000000_11_11_11_11_11_11_11_11_11_11, got ptm_r = %h", uut.ptm_r);
        end
        if (uut.stm_r === 32'b0000000000000000_11_11_11_11_11_11_11_11) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected stm_r = 0000000000000000_11_11_11_11_11_11_11_11, got stm_r = %h", uut.stm_r);
        end

        $display();

        $display("TEST : Reset resets all register to correct value if en = 1 and we = 1");
        rst_ni = 1;
        en_i = 1;
        we_i = 0;
        addr_i = 32'h70000004;
        wdata_i = 32'h1;
        push_i = 10'b0_1_0_0_1_0_1_0_1_1;
        switch_i = 8'b0_0_1_1_0_1_0_0;
        #10;
        if (irq_o === 1) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected irq_o = 1, got irq_o = %h", irq_o);
        end
        rst_ni = 0;
        en_i = 1;
        we_i = 1;
        addr_i = 32'h70000008;
        wdata_i = 32'h1;
        push_i = 10'b0_1_0_0_1_0_1_0_1_1;
        switch_i = 8'b0_0_1_1_0_1_0_0;
        #10;
        if (rdata_o === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 00000000_00000000_000000_0000000000, got rdata_o = %b_%b_%b_%b", rdata_o[31:24], rdata_o[23:16], rdata_o[15:10], rdata_o[9:0]);
        end
        if (irq_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected irq_o = 0, got irq_o = %h", irq_o);
        end
        if (uut.src_r === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected src_r = 00000000_00000000_000000_0000000000, got src_r = %b_%b_%b_%b", uut.src_r[31:24], uut.src_r[23:16], uut.src_r[15:10], uut.src_r[9:0]);
        end
        if (uut.val_r === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected val_r = 00000000_00000000_000000_0000000000, got src_r = %b_%b_%b_%b", uut.val_r[31:24], uut.val_r[23:16], uut.val_r[15:10], uut.val_r[9:0]);
        end
        if (uut.ptm_r === 32'b000000000000_11_11_11_11_11_11_11_11_11_11) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected ptm_r = 000000000000_11_11_11_11_11_11_11_11_11_11, got ptm_r = %h", uut.ptm_r);
        end
        if (uut.stm_r === 32'b0000000000000000_11_11_11_11_11_11_11_11) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected stm_r = 0000000000000000_11_11_11_11_11_11_11_11, got stm_r = %h", uut.stm_r);
        end

        $display();

        $display("TEST : Writing to bad address 1");
        rst_ni = 1;
        en_i = 1;
        we_i = 1;
        addr_i = 32'h70000000;
        wdata_i = 32'b01100110011001100110011001100110;
        push_i = 10'b0;
        switch_i = 8'b0;
        #10;
        if (rdata_o === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 32'b0, got rdata_o = %h", rdata_o);
        end
        if (irq_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected irq_o = 0, got irq_o = %h", irq_o);
        end
        if (uut.ptm_r === 32'b000000000000_11_11_11_11_11_11_11_11_11_11) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected ptm_r = 000000000000_11_11_11_11_11_11_11_11_11_11, got ptm_r = %h", uut.ptm_r);
        end
        if (uut.stm_r === 32'b0000000000000000_11_11_11_11_11_11_11_11) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected stm_r = 0000000000000000_11_11_11_11_11_11_11_11, got stm_r = %h", uut.stm_r);
        end
        if (uut.src_r === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected src_r = 0, got src_r = %b_%b_%b_%b", uut.src_r[31:24], uut.src_r[23:16], uut.src_r[15:10], uut.src_r[9:0]);
        end
        if (uut.val_r === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected val_r = 0, got src_r = %b_%b_%b_%b", uut.val_r[31:24], uut.val_r[23:16], uut.val_r[15:10], uut.val_r[9:0]);
        end

        $display();

        $display("TEST : Writing to bad address 2");
        rst_ni = 1;
        en_i = 1;
        we_i = 1;
        addr_i = 32'h70000080;
        wdata_i = 32'b01100110011001100110011001100110;
        push_i = 10'b0;
        switch_i = 8'b0;
        #10;
        if (rdata_o === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 32'b0, got rdata_o = %h", rdata_o);
        end
        if (irq_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected irq_o = 0, got irq_o = %h", irq_o);
        end
        if (uut.ptm_r === 32'b000000000000_11_11_11_11_11_11_11_11_11_11) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected ptm_r = 000000000000_11_11_11_11_11_11_11_11_11_11, got ptm_r = %h", uut.ptm_r);
        end
        if (uut.stm_r === 32'b0000000000000000_11_11_11_11_11_11_11_11) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected stm_r = 0000000000000000_11_11_11_11_11_11_11_11, got stm_r = %h", uut.stm_r);
        end
        if (uut.src_r === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected src_r = 0, got src_r = %b_%b_%b_%b", uut.src_r[31:24], uut.src_r[23:16], uut.src_r[15:10], uut.src_r[9:0]);
        end
        if (uut.val_r === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected val_r = 0, got src_r = %b_%b_%b_%b", uut.val_r[31:24], uut.val_r[23:16], uut.val_r[15:10], uut.val_r[9:0]);
        end

        $display();

        $display("TEST : Writing with en = 0 does nothing 1");
        rst_ni = 1;
        en_i = 0;
        we_i = 1;
        addr_i = 32'h70000004;
        wdata_i = 32'b01100110011001100110011001100110;
        push_i = 10'b0;
        switch_i = 8'b0;
        #10;
        if (rdata_o === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 32'b0, got rdata_o = %h", rdata_o);
        end
        if (irq_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected irq_o = 0, got irq_o = %h", irq_o);
        end
        if (uut.ptm_r === 32'b000000000000_11_11_11_11_11_11_11_11_11_11) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected ptm_r = 000000000000_11_11_11_11_11_11_11_11_11_11, got ptm_r = %h", uut.ptm_r);
        end
        if (uut.stm_r === 32'b0000000000000000_11_11_11_11_11_11_11_11) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected stm_r = 0000000000000000_11_11_11_11_11_11_11_11, got stm_r = %h", uut.stm_r);
        end
        if (uut.src_r === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected src_r = 0, got src_r = %b_%b_%b_%b", uut.src_r[31:24], uut.src_r[23:16], uut.src_r[15:10], uut.src_r[9:0]);
        end
        if (uut.val_r === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected val_r = 0, got src_r = %b_%b_%b_%b", uut.val_r[31:24], uut.val_r[23:16], uut.val_r[15:10], uut.val_r[9:0]);
        end

        $display();

        $display("TEST : Writing with en = 0 does nothing 2");
        rst_ni = 1;
        en_i = 0;
        we_i = 1;
        addr_i = 32'h70000008;
        wdata_i = 32'b01100110011001100110011001100110;
        push_i = 10'b0;
        switch_i = 8'b0;
        #10;
        if (rdata_o === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 32'b0, got rdata_o = %h", rdata_o);
        end
        if (irq_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected irq_o = 0, got irq_o = %h", irq_o);
        end
        if (uut.ptm_r === 32'b000000000000_11_11_11_11_11_11_11_11_11_11) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected ptm_r = 000000000000_11_11_11_11_11_11_11_11_11_11, got ptm_r = %h", uut.ptm_r);
        end
        if (uut.stm_r === 32'b0000000000000000_11_11_11_11_11_11_11_11) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected stm_r = 0000000000000000_11_11_11_11_11_11_11_11, got stm_r = %h", uut.stm_r);
        end
        if (uut.src_r === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected src_r = 0, got src_r = %b_%b_%b_%b", uut.src_r[31:24], uut.src_r[23:16], uut.src_r[15:10], uut.src_r[9:0]);
        end
        if (uut.val_r === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected val_r = 0, got src_r = %b_%b_%b_%b", uut.val_r[31:24], uut.val_r[23:16], uut.val_r[15:10], uut.val_r[9:0]);
        end

        $display();

        $display("TEST : Writing with en = 0 does nothing 3");
        rst_ni = 1;
        en_i = 0;
        we_i = 1;
        addr_i = 32'h7000000C;
        wdata_i = 32'b01100110011001100110011001100110;
        push_i = 10'b0;
        switch_i = 8'b0;
        #10;
        if (rdata_o === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 32'b0, got rdata_o = %h", rdata_o);
        end
        if (irq_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected irq_o = 0, got irq_o = %h", irq_o);
        end
        if (uut.ptm_r === 32'b000000000000_11_11_11_11_11_11_11_11_11_11) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected ptm_r = 000000000000_11_11_11_11_11_11_11_11_11_11, got ptm_r = %h", uut.ptm_r);
        end
        if (uut.stm_r === 32'b0000000000000000_11_11_11_11_11_11_11_11) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected stm_r = 0000000000000000_11_11_11_11_11_11_11_11, got stm_r = %h", uut.stm_r);
        end
        if (uut.src_r === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected src_r = 0, got src_r = %b_%b_%b_%b", uut.src_r[31:24], uut.src_r[23:16], uut.src_r[15:10], uut.src_r[9:0]);
        end
        if (uut.val_r === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected val_r = 0, got src_r = %b_%b_%b_%b", uut.val_r[31:24], uut.val_r[23:16], uut.val_r[15:10], uut.val_r[9:0]);
        end

        $display();

        $display("TEST : Writing with we = 0 does nothing 1");
        rst_ni = 1;
        en_i = 1;
        we_i = 0;
        addr_i = 32'h70000004;
        wdata_i = 32'b01100110011001100110011001100110;
        push_i = 10'b0;
        switch_i = 8'b0;
        #10;
        if (rdata_o === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 32'b0, got rdata_o = %h", rdata_o);
        end
        if (irq_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected irq_o = 0, got irq_o = %h", irq_o);
        end
        if (uut.ptm_r === 32'b000000000000_11_11_11_11_11_11_11_11_11_11) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected ptm_r = 000000000000_11_11_11_11_11_11_11_11_11_11, got ptm_r = %h", uut.ptm_r);
        end
        if (uut.stm_r === 32'b0000000000000000_11_11_11_11_11_11_11_11) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected stm_r = 0000000000000000_11_11_11_11_11_11_11_11, got stm_r = %h", uut.stm_r);
        end
        if (uut.src_r === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected src_r = 0, got src_r = %b_%b_%b_%b", uut.src_r[31:24], uut.src_r[23:16], uut.src_r[15:10], uut.src_r[9:0]);
        end
        if (uut.val_r === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected val_r = 0, got src_r = %b_%b_%b_%b", uut.val_r[31:24], uut.val_r[23:16], uut.val_r[15:10], uut.val_r[9:0]);
        end

        $display();

        $display("TEST : Writing with we = 0 does nothing 2");
        rst_ni = 1;
        en_i = 1;
        we_i = 0;
        addr_i = 32'h70000008;
        wdata_i = 32'b01100110011001100110011001100110;
        push_i = 10'b0;
        switch_i = 8'b0;
        #10;
        if (rdata_o === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 32'b0, got rdata_o = %h", rdata_o);
        end
        if (irq_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected irq_o = 0, got irq_o = %h", irq_o);
        end
        if (uut.ptm_r === 32'b000000000000_11_11_11_11_11_11_11_11_11_11) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected ptm_r = 000000000000_11_11_11_11_11_11_11_11_11_11, got ptm_r = %h", uut.ptm_r);
        end
        if (uut.stm_r === 32'b0000000000000000_11_11_11_11_11_11_11_11) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected stm_r = 0000000000000000_11_11_11_11_11_11_11_11, got stm_r = %h", uut.stm_r);
        end
        if (uut.src_r === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected src_r = 0, got src_r = %b_%b_%b_%b", uut.src_r[31:24], uut.src_r[23:16], uut.src_r[15:10], uut.src_r[9:0]);
        end
        if (uut.val_r === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected val_r = 0, got src_r = %b_%b_%b_%b", uut.val_r[31:24], uut.val_r[23:16], uut.val_r[15:10], uut.val_r[9:0]);
        end

        $display();

        $display("TEST : Writing with we = 0 does nothing 3");
        rst_ni = 1;
        en_i = 1;
        we_i = 0;
        addr_i = 32'h7000000C;
        wdata_i = 32'b01100110011001100110011001100110;
        push_i = 10'b0;
        switch_i = 8'b0;
        #10;
        if (rdata_o === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 32'b0, got rdata_o = %h", rdata_o);
        end
        if (irq_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected irq_o = 0, got irq_o = %h", irq_o);
        end
        if (uut.ptm_r === 32'b000000000000_11_11_11_11_11_11_11_11_11_11) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected ptm_r = 000000000000_11_11_11_11_11_11_11_11_11_11, got ptm_r = %h", uut.ptm_r);
        end
        if (uut.stm_r === 32'b0000000000000000_11_11_11_11_11_11_11_11) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected stm_r = 0000000000000000_11_11_11_11_11_11_11_11, got stm_r = %h", uut.stm_r);
        end
        if (uut.src_r === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected src_r = 0, got src_r = %b_%b_%b_%b", uut.src_r[31:24], uut.src_r[23:16], uut.src_r[15:10], uut.src_r[9:0]);
        end
        if (uut.val_r === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected val_r = 0, got src_r = %b_%b_%b_%b", uut.val_r[31:24], uut.val_r[23:16], uut.val_r[15:10], uut.val_r[9:0]);
        end

        $display();

        $display("TEST : Reading with bad address does nothing");
        rst_ni = 1;
        en_i = 1;
        we_i = 0;
        addr_i = 32'h700000C0;
        wdata_i = 32'b01100110011001100110011001100110;
        push_i = 10'b0;
        switch_i = 8'b0;
        #10;
        if (rdata_o === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 32'b0, got rdata_o = %h", rdata_o);
        end
        if (irq_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected irq_o = 0, got irq_o = %h", irq_o);
        end
        if (uut.ptm_r === 32'b000000000000_11_11_11_11_11_11_11_11_11_11) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected ptm_r = 000000000000_11_11_11_11_11_11_11_11_11_11, got ptm_r = %h", uut.ptm_r);
        end
        if (uut.stm_r === 32'b0000000000000000_11_11_11_11_11_11_11_11) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected stm_r = 0000000000000000_11_11_11_11_11_11_11_11, got stm_r = %h", uut.stm_r);
        end
        if (uut.src_r === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected src_r = 0, got src_r = %b_%b_%b_%b", uut.src_r[31:24], uut.src_r[23:16], uut.src_r[15:10], uut.src_r[9:0]);
        end
        if (uut.val_r === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected val_r = 0, got src_r = %b_%b_%b_%b", uut.val_r[31:24], uut.val_r[23:16], uut.val_r[15:10], uut.val_r[9:0]);
        end

        $display();

        $display("TEST : Reading with en = 0 does nothing");
        rst_ni = 1;
        en_i = 0;
        we_i = 0;
        addr_i = 32'h700000C0;
        wdata_i = 32'b01100110011001100110011001100110;
        push_i = 10'b0;
        switch_i = 8'b0;
        #10;
        if (rdata_o === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 32'b0, got rdata_o = %h", rdata_o);
        end
        if (irq_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected irq_o = 0, got irq_o = %h", irq_o);
        end
        if (uut.ptm_r === 32'b000000000000_11_11_11_11_11_11_11_11_11_11) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected ptm_r = 000000000000_11_11_11_11_11_11_11_11_11_11, got ptm_r = %h", uut.ptm_r);
        end
        if (uut.stm_r === 32'b0000000000000000_11_11_11_11_11_11_11_11) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected stm_r = 0000000000000000_11_11_11_11_11_11_11_11, got stm_r = %h", uut.stm_r);
        end
        if (uut.src_r === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected src_r = 0, got src_r = %b_%b_%b_%b", uut.src_r[31:24], uut.src_r[23:16], uut.src_r[15:10], uut.src_r[9:0]);
        end
        if (uut.val_r === 32'b0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected val_r = 0, got src_r = %b_%b_%b_%b", uut.val_r[31:24], uut.val_r[23:16], uut.val_r[15:10], uut.val_r[9:0]);
        end

        $display();

        // Finish simulation
        $finish;
    end

    always begin
        #5 clk_i = ~clk_i;
    end
endmodule