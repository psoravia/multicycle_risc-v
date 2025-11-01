`timescale 1ns/1ps

module tb_csr2;
    // Signals
    reg clk_i;
    reg rst_ni;
    reg [11:0] addr_i;
    reg [31:0] wdata_i;
    reg irq_i;
    reg [31:0] pc_i;
    reg write_i;
    reg set_i;
    reg clear_i;
    reg interrupt_i;
    reg mret_i;
    wire [31:0] rdata_o;
    wire [31:0] mtvec_o;
    wire [31:0] mepc_o;
    wire ipending_o;

    // Instantiate CSR module
    csr dut (
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .addr_i(addr_i),
        .wdata_i(wdata_i),
        .irq_i(irq_i),
        .pc_i(pc_i),
        .write_i(write_i),
        .set_i(set_i),
        .clear_i(clear_i),
        .interrupt_i(interrupt_i),
        .mret_i(mret_i),
        .rdata_o(rdata_o),
        .mtvec_o(mtvec_o),
        .mepc_o(mepc_o),
        .ipending_o(ipending_o)
    );
    localparam BASE_REG = 32'h70000000;
    localparam SRC_ADDRESS = BASE_REG + 4;
    localparam MIE_BIT      = 3;
    localparam MPIE_BIT     = 7;
    localparam MBIE_BIT     = 11;
    localparam MBIP_BIT     = 11;

    // Clock generation
    always begin
        #5 clk_i = ~clk_i;
    end

    // Test stimulus
    initial begin
        // Initialize signals
        clk_i = 0;
        rst_ni = 1;
        addr_i = 0;
        wdata_i = 0;
        irq_i = 0;
        pc_i = 0;
        write_i = 0;
        set_i = 0;
        clear_i = 0;
        interrupt_i = 0;
        mret_i = 0;

        // Reset test
        $display("Testing reset...");
        rst_ni = 0;
        #10
        
        
        rst_ni = 1;
        #10
        
        // Verify reset values
        addr_i = 12'h300; // mstatus
        #10
        if(rdata_o !== 32'h1800) $display("Reset Error: mstatus = %h, expected 32'h1800 , mstatus is : %h", rdata_o,dut.mstatus_r);
        else $display("Reset Test Passed: mstatus correctly initialized to 0x1800");

        // Test 1: Write to mtvec
        $display("\nTesting mtvec write...");
        addr_i = 12'h305;
        wdata_i = 32'h1000_0000;
        write_i = 1;
        #10
        write_i = 0;
        if(mtvec_o !== 32'h1000_0000) $display("Error: mtvec = %h, expected 32'h1000_0000", mtvec_o);
        else $display("mtvec Write Test Passed");

        $display("\nTesting interrupt handling...");
        dut.mstatus_r[MIE_BIT] = 1;
        pc_i = 32'h2000_0000;
        interrupt_i = 1;
        $display("%b", dut.mie_r);
        #10
        interrupt_i = 0;
       
        if(mepc_o !== 32'h2000_0000) $display("Error: mepc = %h, expected 32'h2000_0000", mepc_o);
        else $display("mepc Save Test Passed");
       
        addr_i = 12'h342;
        #10
        if(rdata_o !== 32'h8000_0800) $display("Error: mcause = %h, expected 32'h8000_0800", rdata_o);
        else $display("mcause Test Passed");

        $display("\nTesting IRQ handling...");
        irq_i = 1;
        #10
        irq_i = 0;
        if(ipending_o) $display("Error: ipending set after IRQ");
        else $display("IRQ Test Passed");

        $display("\nTesting mret handling...");
        addr_i = 12'h300; // Read mstatus
        #10
        mret_i = 1;
        #10
        mret_i = 0;
        if((rdata_o & 32'h80) !== 32'h80) $display("Error: MPIE bit not set after mret");
        else $display("mret Test Passed");

        $display("\nTesting set operation...");
        addr_i = 12'h304; // mie
        wdata_i = 32'h800; // Set MBIE bit
        set_i = 1;
        #10
        set_i = 0;
        if((rdata_o & 32'h800) !== 32'h800) $display("Error: set operation failed on mie");
        else $display("Set Operation Test Passed");

        $display("\nTesting clear operation...");
        addr_i = 12'h304; // mie
        wdata_i = 32'h800; // Clear MBIE bit
        clear_i = 1;
        #10
        clear_i = 0;
        if((rdata_o & 32'h800) !== 32'h0) $display("Error: clear operation failed on mie");
        else $display("Clear Operation Test Passed");

        $display("\nTesting control signal mutual exclusivity...");
        addr_i = 12'h304;
        wdata_i = 32'hFFFF_FFFF;
        write_i = 1;
        set_i = 1;
        clear_i = 1;
        #10
        write_i = 0;
        set_i = 0;
        clear_i = 0;
        $display("Mutual Exclusivity Test Complete - Check waveform for verification");

        #20;
        $display("\nTestbench completed");
        $finish;
    end

    initial begin
        $dumpfile("csr_tb.vcd");
        $dumpvars(0, csr_tb);
    end

endmodule
