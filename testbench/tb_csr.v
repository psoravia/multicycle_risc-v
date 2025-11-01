`timescale 1ns / 1ps

module tb_csr ();

    // inputs
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

    // outputs
    wire [31:0] rdata_o;
    wire [31:0] mtvec_o;
    wire [31:0] mepc_o;
    wire ipending_o;
    
    // Instantiate the Unit Under Test (UUT)
    csr uut (
        .clk_i (clk_i),
        .rst_ni (rst_ni),
        .addr_i (addr_i),
        .wdata_i (wdata_i),
        .irq_i (irq_i),
        .pc_i (pc_i),
        .write_i (write_i),
        .set_i (set_i),
        .clear_i (clear_i),
        .interrupt_i (interrupt_i),
        .mret_i (mret_i),
        .rdata_o (rdata_o),
        .mtvec_o (mtvec_o),
        .mepc_o (mepc_o),
        .ipending_o (ipending_o)
    );

    initial begin
        // Generate waveform file
        $dumpfile("dump/tb_csr.vcd");
        $dumpvars(0, tb_csr);

        $display("TEST : Reset");
        rst_ni = 0;
        addr_i = 12'b1;
        wdata_i = 32'h1;
        irq_i = 1;
        pc_i = 32'h1;
        write_i = 0;
        set_i = 0;
        clear_i = 0;
        interrupt_i = 1;
        mret_i = 0;
        #10;
        if (rdata_o === 32'h0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected rdata_o = 32'h00000000, got rdata_o = %h", rdata_o);
        end
        if (mtvec_o === 32'h0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected mtvec_o = 32'h00000000, got mtvec_o = %h", mtvec_o);
        end
        if (mepc_o === 32'h0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected mepc_o = 32'h00000000, got mepc_o = %h", mepc_o);
        end
        if (ipending_o === 0) begin
            $display("Correct output !");
        end else begin
            $display("Wrong output ! Expected ipending_o = 0, got ipending_o = %b", ipending_o);
        end

        

        $display();

        // Finish simulation
        $finish;
    end

    always begin
        #5 clk_i = ~clk_i;
    end
endmodule