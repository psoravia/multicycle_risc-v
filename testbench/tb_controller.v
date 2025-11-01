`timescale 1ns / 1ps

module tb_controller ();
    // Inputs
    reg        clk_i, rst_ni;
    reg [31:0] instruction_i;
    reg ipending_i;

    // Outputs
    wire branch_op_o;
    wire [31:0] imm_o;
    wire ir_en_o;
    wire pc_add_imm_o;
    wire pc_en_o;
    wire pc_sel_alu_o;
    wire pc_sel_pc_base_o;
    wire rf_we_o;
    wire sel_addr_o;
    wire sel_b_o;
    wire sel_mem_o;
    wire sel_pc_o;
    wire sel_imm_o;
    wire we_o;
    wire [5:0] alu_op_o;
    wire csr_write_o;
    wire csr_set_o;
    wire csr_clear_o;
    wire csr_interrupt_o;
    wire csr_mret_o;
    wire sel_csr_o;
    wire pc_sel_mtvec_o;
    wire pc_sel_mepc_o;

    // Instantiate the Unit Under Test (UUT)
    controller uut (
        .clk_i (clk_i),
        .rst_ni (rst_ni),
        .instruction_i (instruction_i),
        .ipending_i (ipending_i),
        .branch_op_o (branch_op_o),
        .imm_o (imm_o),
        .ir_en_o (ir_en_o),
        .pc_add_imm_o (pc_add_imm_o),
        .pc_en_o (pc_en_o),
        .pc_sel_alu_o (pc_sel_alu_o),
        .pc_sel_pc_base_o (pc_sel_pc_base_o),
        .rf_we_o (rf_we_o),
        .sel_addr_o (sel_addr_o),
        .sel_b_o (sel_b_o),
        .sel_mem_o (sel_mem_o),
        .sel_pc_o (sel_pc_o),
        .sel_imm_o (sel_imm_o),
        .we_o (we_o),
        .alu_op_o (alu_op_o),
        .csr_write_o (csr_write_o),
        .csr_set_o (csr_set_o),
        .csr_clear_o (csr_clear_o),
        .csr_interrupt_o (csr_interrupt_o),
        .csr_mret_o (csr_mret_o),
        .sel_csr_o (sel_csr_o),
        .pc_sel_mtvec_o (pc_sel_mtvec_o),
        .pc_sel_mepc_o (pc_sel_mepc_o)
    );

    initial begin
        // Generate waveform file
        $dumpfile("dump/tb_controller.vcd");
        $dumpvars(0, tb_controller);

        rst_ni = 0; instruction_i = 32'b0;
        ipending_i = 0;

        #10;

        $display();
        $display("TESTs : I-type instructions");
        $display();
        
        $display("TEST : `addi`");
        instruction_i = 32'b111111111111_00000_000_00000_0010011;
        rst_ni = 0;
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.I_TYPE) begin
            $display("Error, not in I_TYPE");
        end
        if (rf_we_o !== 1) begin
            $display("Error, rf_we_o is %b, expected 1", rf_we_o);
        end
        if (imm_o !== 32'hFFFFFFFF) begin
            $display("Error, imm_o is %h, expected 32'bFFFFFFFF", imm_o);
        end
        if (alu_op_o !== 6'b000_000) begin
            $display("Error, alu_op_o is %b, expected 000_000", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end

        $display("TEST : `addi` finished");

        $display("TEST : `xori`");
        instruction_i = 32'b111111111111_00000_100_00000_0010011;
        rst_ni = 0;
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.I_TYPE) begin
            $display("Error, not in I_TYPE");
        end
        if (rf_we_o !== 1) begin
            $display("Error, rf_we_o is %b, expected 1", rf_we_o);
        end
        if (imm_o !== 32'hFFFFFFFF) begin
            $display("Error, imm_o is %h, expected 32'bFFFFFFFF", imm_o);
        end
        if (alu_op_o !== 6'b100_100) begin
            $display("Error, alu_op_o is %b, expected 100_100", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end

        $display("TEST : `xori` finished");

        $display("TEST : `ori`");
        instruction_i = 32'b111111111111_00000_110_00000_0010011;
        rst_ni = 0;
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.I_TYPE) begin
            $display("Error, not in I_TYPE");
        end
        if (rf_we_o !== 1) begin
            $display("Error, rf_we_o is %b, expected 1", rf_we_o);
        end
        if (imm_o !== 32'hFFFFFFFF) begin
            $display("Error, imm_o is %h, expected 32'bFFFFFFFF", imm_o);
        end
        if (alu_op_o !== 6'b100_110) begin
            $display("Error, alu_op_o is %b, expected 100_110", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end

        $display("TEST : `ori` finished");

        $display("TEST : `andi`");
        instruction_i = 32'b111111111111_00000_111_00000_0010011;
        rst_ni = 0;
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.I_TYPE) begin
            $display("Error, not in I_TYPE");
        end
        if (rf_we_o !== 1) begin
            $display("Error, rf_we_o is %b, expected 1", rf_we_o);
        end
        if (imm_o !== 32'hFFFFFFFF) begin
            $display("Error, imm_o is %h, expected 32'bFFFFFFFF", imm_o);
        end
        if (alu_op_o !== 6'b100_111) begin
            $display("Error, alu_op_o is %b, expected 100_111", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end

        $display("TEST : `andi` finished");

        $display("TEST : `slti`");
        instruction_i = 32'b111111111111_00000_010_00000_0010011;
        rst_ni = 0;
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.I_TYPE) begin
            $display("Error, not in I_TYPE");
        end
        if (rf_we_o !== 1) begin
            $display("Error, rf_we_o is %b, expected 1", rf_we_o);
        end
        if (imm_o !== 32'hFFFFFFFF) begin
            $display("Error, imm_o is %h, expected 32'bFFFFFFFF", imm_o);
        end
        if (alu_op_o !== 6'b011_100) begin
            $display("Error, alu_op_o is %b, expected 011_100", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end

        $display("TEST : `slti` finished");

        $display("TEST : `sltiu`");
        instruction_i = 32'b111111111111_00000_011_00000_0010011;
        rst_ni = 0;
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.I_TYPE) begin
            $display("Error, not in I_TYPE");
        end
        if (rf_we_o !== 1) begin
            $display("Error, rf_we_o is %b, expected 1", rf_we_o);
        end
        if (imm_o !== 32'hFFFFFFFF) begin
            $display("Error, imm_o is %h, expected 32'bFFFFFFFF", imm_o);
        end
        if (alu_op_o !== 6'b011_110) begin
            $display("Error, alu_op_o is %b, expected 011_110", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end

        $display("TEST : `sltiu` finished");


        $display("TEST : `slli`");
        instruction_i = 32'b000000001010_00000_001_00000_0010011;
        rst_ni = 0;
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.I_TYPE) begin
            $display("Error, not in I_TYPE");
        end
        if (rf_we_o !== 1) begin
            $display("Error, rf_we_o is %b, expected 1", rf_we_o);
        end
        if (imm_o !== 32'hA) begin
            $display("Error, imm_o is %h, expected 32'hA", imm_o);
        end
        if (alu_op_o !== 6'b110_001) begin
            $display("Error, alu_op_o is %b, expected 110_001", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end

        $display("TEST : `slli` finished");


        $display("TEST : `srli`");
        instruction_i = 32'b000000001010_00000_101_00000_0010011;
        rst_ni = 0;
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.I_TYPE) begin
            $display("Error, not in I_TYPE");
        end
        if (rf_we_o !== 1) begin
            $display("Error, rf_we_o is %b, expected 1", rf_we_o);
        end
        if (imm_o !== 32'hA) begin
            $display("Error, imm_o is %h, expected 32'hA", imm_o);
        end
        if (alu_op_o !== 6'b110_101) begin
            $display("Error, alu_op_o is %b, expected 110_101", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end

        $display("TEST : `srli` finished");


        $display("TEST : `srai`");
        instruction_i = 32'b010000001010_00000_101_00000_0010011;
        rst_ni = 0;
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.I_TYPE) begin
            $display("Error, not in I_TYPE");
        end
        if (rf_we_o !== 1) begin
            $display("Error, rf_we_o is %b, expected 1", rf_we_o);
        end
        if (imm_o !== 32'h40A) begin
            $display("Error, imm_o is %h, expected 32'h40A", imm_o);
        end
        if (alu_op_o !== 6'b111_101) begin
            $display("Error, alu_op_o is %b, expected 111_101", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end

        $display("TEST : `srai` finished");

        $display();
        $display("TESTs : R-type instructions");
        $display();

        $display("TEST : `sll`");
        instruction_i = 32'b0000000_00000_00000_001_00000_0110011;
        rst_ni = 0;
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.R_TYPE) begin
            $display("Error, not in R_TYPE");
        end
        if (rf_we_o !== 1) begin
            $display("Error, rf_we_o is %b, expected 1", rf_we_o);
        end
        if (sel_b_o !== 1) begin
            $display("Error, sel_b_o is %b, expected 1", sel_b_o);
        end
        if (alu_op_o !== 6'b110_001) begin
            $display("Error, alu_op_o is %b, expected 110_001", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end

        $display("TEST : `sll` finished");


        $display("TEST : `srl`");
        instruction_i = 32'b0000000_00000_00000_101_00000_0110011;
        rst_ni = 0;
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.R_TYPE) begin
            $display("Error, not in R_TYPE");
        end
        if (rf_we_o !== 1) begin
            $display("Error, rf_we_o is %b, expected 1", rf_we_o);
        end
        if (sel_b_o !== 1) begin
            $display("Error, sel_b_o is %b, expected 1", sel_b_o);
        end
        if (alu_op_o !== 6'b110_101) begin
            $display("Error, alu_op_o is %b, expected 110_101", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end

        $display("TEST : `srl` finished");


        $display("TEST : `sra`");
        instruction_i = 32'b0100000_00000_00000_101_00000_0110011;
        rst_ni = 0;
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.R_TYPE) begin
            $display("Error, not in R_TYPE");
        end
        if (rf_we_o !== 1) begin
            $display("Error, rf_we_o is %b, expected 1", rf_we_o);
        end
        if (sel_b_o !== 1) begin
            $display("Error, sel_b_o is %b, expected 1", sel_b_o);
        end
        if (alu_op_o !== 6'b111_101) begin
            $display("Error, alu_op_o is %b, expected 111_101", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end

        $display("TEST : `sra` finished");


        $display("TEST : `add`");
        instruction_i = 32'b0000000_00000_00000_000_00000_0110011;
        rst_ni = 0;
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.R_TYPE) begin
            $display("Error, not in R_TYPE");
        end
        if (rf_we_o !== 1) begin
            $display("Error, rf_we_o is %b, expected 1", rf_we_o);
        end
        if (sel_b_o !== 1) begin
            $display("Error, sel_b_o is %b, expected 1", sel_b_o);
        end
        if (alu_op_o !== 6'b000_000) begin
            $display("Error, alu_op_o is %b, expected 000_000", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end

        $display("TEST : `add` finished");


        $display("TEST : `sub`");
        instruction_i = 32'b0100000_00000_00000_000_00000_0110011;
        rst_ni = 0;
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.R_TYPE) begin
            $display("Error, not in R_TYPE");
        end
        if (rf_we_o !== 1) begin
            $display("Error, rf_we_o is %b, expected 1", rf_we_o);
        end
        if (sel_b_o !== 1) begin
            $display("Error, sel_b_o is %b, expected 1", sel_b_o);
        end
        if (alu_op_o !== 6'b001_000) begin
            $display("Error, alu_op_o is %b, expected 001_000", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end

        $display("TEST : `sub` finished");


        $display("TEST : `xor`");
        instruction_i = 32'b0000000_00000_00000_100_00000_0110011;
        rst_ni = 0;
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.R_TYPE) begin
            $display("Error, not in R_TYPE");
        end
        if (rf_we_o !== 1) begin
            $display("Error, rf_we_o is %b, expected 1", rf_we_o);
        end
        if (sel_b_o !== 1) begin
            $display("Error, sel_b_o is %b, expected 1", sel_b_o);
        end
        if (alu_op_o !== 6'b100_100) begin
            $display("Error, alu_op_o is %b, expected 100_100", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end

        $display("TEST : `xor` finished");


        $display("TEST : `or`");
        instruction_i = 32'b0000000_00000_00000_110_00000_0110011;
        rst_ni = 0;
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.R_TYPE) begin
            $display("Error, not in R_TYPE");
        end
        if (rf_we_o !== 1) begin
            $display("Error, rf_we_o is %b, expected 1", rf_we_o);
        end
        if (sel_b_o !== 1) begin
            $display("Error, sel_b_o is %b, expected 1", sel_b_o);
        end
        if (alu_op_o !== 6'b100_110) begin
            $display("Error, alu_op_o is %b, expected 100_110", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end

        $display("TEST : `or` finished");


        $display("TEST : `and`");
        instruction_i = 32'b0000000_00000_00000_111_00000_0110011;
        rst_ni = 0;
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.R_TYPE) begin
            $display("Error, not in R_TYPE");
        end
        if (rf_we_o !== 1) begin
            $display("Error, rf_we_o is %b, expected 1", rf_we_o);
        end
        if (sel_b_o !== 1) begin
            $display("Error, sel_b_o is %b, expected 1", sel_b_o);
        end
        if (alu_op_o !== 6'b100_111) begin
            $display("Error, alu_op_o is %b, expected 100_111", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end

        $display("TEST : `and` finished");


        $display("TEST : `slt`");
        instruction_i = 32'b0000000_00000_00000_010_00000_0110011;
        rst_ni = 0;
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.R_TYPE) begin
            $display("Error, not in R_TYPE");
        end
        if (rf_we_o !== 1) begin
            $display("Error, rf_we_o is %b, expected 1", rf_we_o);
        end
        if (sel_b_o !== 1) begin
            $display("Error, sel_b_o is %b, expected 1", sel_b_o);
        end
        if (alu_op_o !== 6'b011_100) begin
            $display("Error, alu_op_o is %b, expected 011_100", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end

        $display("TEST : `slt` finished");


        $display("TEST : `sltu`");
        instruction_i = 32'b0000000_00000_00000_011_00000_0110011;
        rst_ni = 0;
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.R_TYPE) begin
            $display("Error, not in R_TYPE");
        end
        if (rf_we_o !== 1) begin
            $display("Error, rf_we_o is %b, expected 1", rf_we_o);
        end
        if (sel_b_o !== 1) begin
            $display("Error, sel_b_o is %b, expected 1", sel_b_o);
        end
        if (alu_op_o !== 6'b011_110) begin
            $display("Error, alu_op_o is %b, expected 011_110", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end

        $display("TEST : `sltu` finished");


        $display();
        $display("TESTs : U-type instructions");
        $display();
        
        $display("TEST : `lui`");
        instruction_i = 32'b11111111111111111111_00000_0110111;
        rst_ni = 0;
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.U_TYPE) begin
            $display("Error, not in U_TYPE");
        end
        if (rf_we_o !== 1) begin
            $display("Error, rf_we_o is %b, expected 1", rf_we_o);
        end
        if (sel_imm_o !== 1) begin
            $display("Error, sel_imm_o is %b, expected 1", sel_imm_o);
        end
        if (imm_o !== 32'b11111111111111111111_00000_0000000) begin
            $display("Error, imm_o is %h, expected 11111111111111111111_00000_0000000", imm_o);
        end
        if (alu_op_o !== 6'b000_000) begin
            $display("Error, alu_op_o is %b, expected 000_000", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end

        $display("TEST : `lui` finished");


        $display();
        $display("TESTs : LOAD instructions");
        $display();
        
        $display("TEST : `lw`");
        instruction_i = 32'b111111111111_00000_010_00000_0000011;
        rst_ni = 0;
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.LOAD1) begin
            $display("Error, not in LOAD1");
        end
        if (sel_addr_o !== 1) begin
            $display("Error, sel_addr_o is %b, expected 1", sel_addr_o);
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end
        if (imm_o !== 32'hFFFFFFFF) begin
            $display("Error, imm_o is %h, expected 32'hFFFFFFFF", imm_o);
        end
        if (alu_op_o !== 6'b000_000) begin
            $display("Error, alu_op_o is %b, expected 000_000", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.LOAD2) begin
            $display("Error, not in LOAD2");
        end
        if (sel_addr_o !== 1) begin
            $display("Error, sel_addr_o is %b, expected 1", sel_addr_o);
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end
        if (sel_mem_o !== 1) begin
            $display("Error, sel_mem_o is %b, expected 1", sel_mem_o);
        end
        if (rf_we_o !== 1) begin
            $display("Error, rf_we_o is %b, expected 1", rf_we_o);
        end
        if (imm_o !== 32'hFFFFFFFF) begin
            $display("Error, imm_o is %h, expected 32'hFFFFFFFF", imm_o);
        end
        if (alu_op_o !== 6'b000_000) begin
            $display("Error, alu_op_o is %b, expected 000_000", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end

        $display("TEST : `lw` finished");
        

        $display();
        $display("TESTs : S-Type instructions");
        $display();
        
        $display("TEST : `sw`");
        instruction_i = 32'b0101010_00000_00000_010_01010_0100011;
        rst_ni = 0;
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.S_TYPE) begin
            $display("Error, not in S_TYPE");
        end
        if (sel_addr_o !== 1) begin
            $display("Error, sel_addr_o is %b, expected 1", sel_addr_o);
        end
        if (we_o !== 1) begin
            $display("Error, we_o is %b, expected 1", we_o);
        end
        if (imm_o !== 32'b00000000000000000000_0101010_01010) begin
            $display("Error, imm_o is %h, expected 00000000000000000000_0101010_01010", imm_o);
        end
        if (alu_op_o !== 6'b000_000) begin
            $display("Error, alu_op_o is %b, expected 000_000", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end

        $display("TEST : `sw` finished");

        $display();



        $display();
        $display("TESTs : BREAK instructions");
        $display();
        
        $display("TEST : `ebreak`");
        instruction_i = 32'b000000000001_00000_000_00000_1110011;
        rst_ni = 0;
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.BREAK) begin
            $display("Error, not in BREAK");
        end
        if (alu_op_o !== 6'b000_000) begin
            $display("Error, alu_op_o is %b, expected 000_000", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.BREAK) begin
            $display("Error, not in BREAK");
        end
        #10;
        if (uut.state_r !== uut.BREAK) begin
            $display("Error, not in BREAK");
        end

        $display("TEST : `ebreak` finished");



        $display();
        $display("TESTs : B-Type instructions");
        $display();
        
        $display("TEST : `beq`");
        instruction_i = 32'b1_010101_00000_00000_000_1100_0_1100011;
        rst_ni = 0;
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.B_TYPE) begin
            $display("Error, not in B_TYPE");
        end
        if (branch_op_o !== 1) begin
            $display("Error, branch_op_o is %b, expected 1", branch_op_o);
        end
        if (sel_b_o !== 1) begin
            $display("Error, sel_b_o is %b, expected 1", sel_b_o);
        end
        if (pc_sel_pc_base_o !== 1) begin
            $display("Error, pc_sel_pc_base_o is %b, expected 1", pc_sel_pc_base_o);
        end
        if (pc_add_imm_o !== 1) begin
            $display("Error, pc_add_imm_o is %b, expected 1", pc_add_imm_o);
        end
        if (imm_o !== 32'hFFFF_F2B8) begin
            $display("Error, imm_o is %b, expected 32'hFFFF_F2B8", imm_o);
        end
        if (alu_op_o !== 6'b011_000) begin
            $display("Error, alu_op_o is %b, expected 011_000", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end

        $display("TEST : `beq` finished");

        $display("TEST : `bne`");
        instruction_i = 32'b1_010101_00000_00000_001_1100_0_1100011;
        rst_ni = 0;
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.B_TYPE) begin
            $display("Error, not in B_TYPE");
        end
        if (branch_op_o !== 1) begin
            $display("Error, branch_op_o is %b, expected 1", branch_op_o);
        end
        if (sel_b_o !== 1) begin
            $display("Error, sel_b_o is %b, expected 1", sel_b_o);
        end
        if (pc_sel_pc_base_o !== 1) begin
            $display("Error, pc_sel_pc_base_o is %b, expected 1", pc_sel_pc_base_o);
        end
        if (pc_add_imm_o !== 1) begin
            $display("Error, pc_add_imm_o is %b, expected 1", pc_add_imm_o);
        end
        if (imm_o !== 32'hFFFF_F2B8) begin
            $display("Error, imm_o is %b, expected 32'hFFFF_F2B8", imm_o);
        end
        if (alu_op_o !== 6'b011_001) begin
            $display("Error, alu_op_o is %b, expected 011_001", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end

        $display("TEST : `bne` finished");

        $display("TEST : `blt`");
        instruction_i = 32'b1_010101_00000_00000_100_1100_0_1100011;
        rst_ni = 0;
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.B_TYPE) begin
            $display("Error, not in B_TYPE");
        end
        if (branch_op_o !== 1) begin
            $display("Error, branch_op_o is %b, expected 1", branch_op_o);
        end
        if (sel_b_o !== 1) begin
            $display("Error, sel_b_o is %b, expected 1", sel_b_o);
        end
        if (pc_sel_pc_base_o !== 1) begin
            $display("Error, pc_sel_pc_base_o is %b, expected 1", pc_sel_pc_base_o);
        end
        if (pc_add_imm_o !== 1) begin
            $display("Error, pc_add_imm_o is %b, expected 1", pc_add_imm_o);
        end
        if (imm_o !== 32'hFFFF_F2B8) begin
            $display("Error, imm_o is %b, expected 32'hFFFF_F2B8", imm_o);
        end
        if (alu_op_o !== 6'b011_100) begin
            $display("Error, alu_op_o is %b, expected 011_100", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end

        $display("TEST : `blt` finished");


        $display("TEST : `bge`");
        instruction_i = 32'b1_010101_00000_00000_101_1100_0_1100011;
        rst_ni = 0;
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.B_TYPE) begin
            $display("Error, not in B_TYPE");
        end
        if (branch_op_o !== 1) begin
            $display("Error, branch_op_o is %b, expected 1", branch_op_o);
        end
        if (sel_b_o !== 1) begin
            $display("Error, sel_b_o is %b, expected 1", sel_b_o);
        end
        if (pc_sel_pc_base_o !== 1) begin
            $display("Error, pc_sel_pc_base_o is %b, expected 1", pc_sel_pc_base_o);
        end
        if (pc_add_imm_o !== 1) begin
            $display("Error, pc_add_imm_o is %b, expected 1", pc_add_imm_o);
        end
        if (imm_o !== 32'hFFFF_F2B8) begin
            $display("Error, imm_o is %b, expected 32'hFFFF_F2B8", imm_o);
        end
        if (alu_op_o !== 6'b011_101) begin
            $display("Error, alu_op_o is %b, expected 011_101", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end

        $display("TEST : `bge` finished");


        $display("TEST : `bltu`");
        instruction_i = 32'b1_010101_00000_00000_110_1100_0_1100011;
        rst_ni = 0;
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.B_TYPE) begin
            $display("Error, not in B_TYPE");
        end
        if (branch_op_o !== 1) begin
            $display("Error, branch_op_o is %b, expected 1", branch_op_o);
        end
        if (sel_b_o !== 1) begin
            $display("Error, sel_b_o is %b, expected 1", sel_b_o);
        end
        if (pc_sel_pc_base_o !== 1) begin
            $display("Error, pc_sel_pc_base_o is %b, expected 1", pc_sel_pc_base_o);
        end
        if (pc_add_imm_o !== 1) begin
            $display("Error, pc_add_imm_o is %b, expected 1", pc_add_imm_o);
        end
        if (imm_o !== 32'hFFFF_F2B8) begin
            $display("Error, imm_o is %b, expected 32'hFFFF_F2B8", imm_o);
        end
        if (alu_op_o !== 6'b011_110) begin
            $display("Error, alu_op_o is %b, expected 011_110", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end

        $display("TEST : `bltu` finished");

        $display("TEST : `bgeu`");
        instruction_i = 32'b1_010101_00000_00000_111_1100_0_1100011;
        rst_ni = 0;
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.B_TYPE) begin
            $display("Error, not in B_TYPE");
        end
        if (branch_op_o !== 1) begin
            $display("Error, branch_op_o is %b, expected 1", branch_op_o);
        end
        if (sel_b_o !== 1) begin
            $display("Error, sel_b_o is %b, expected 1", sel_b_o);
        end
        if (pc_sel_pc_base_o !== 1) begin
            $display("Error, pc_sel_pc_base_o is %b, expected 1", pc_sel_pc_base_o);
        end
        if (pc_add_imm_o !== 1) begin
            $display("Error, pc_add_imm_o is %b, expected 1", pc_add_imm_o);
        end
        if (imm_o !== 32'hFFFF_F2B8) begin
            $display("Error, imm_o is %b, expected 32'hFFFF_F2B8", imm_o);
        end
        if (alu_op_o !== 6'b011_111) begin
            $display("Error, alu_op_o is %b, expected 011_111", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end

        $display("TEST : `bgeu` finished");



        $display();
        $display("TESTs : J-Type instructions");
        $display();
        
        $display("TEST : `jal`");
        instruction_i = 32'b1_1101011010_0_00000111_00000_1101111;
        rst_ni = 0;
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.J_TYPE) begin
            $display("Error, not in J_TYPE");
        end
        if (rf_we_o !== 1) begin
            $display("Error, rf_we_o is %b, expected 1", rf_we_o);
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (pc_sel_pc_base_o !== 1) begin
            $display("Error, pc_sel_pc_base_o is %b, expected 1", pc_sel_pc_base_o);
        end
        if (pc_add_imm_o !== 1) begin
            $display("Error, pc_add_imm_o is %b, expected 1", pc_add_imm_o);
        end
        if (sel_pc_o !== 1) begin
            $display("Error, sel_pc_o is %b, expected 1", sel_pc_o);
        end
        if (imm_o !== 32'hFFF076B4) begin
            $display("Error, imm_o is %b, expected 32'hFFF076B4", imm_o);
        end
        if (alu_op_o !== 6'b000_000) begin
            $display("Error, alu_op_o is %b, expected 000_000", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end

        $display("TEST : `jal` finished");




        $display();
        $display("TESTs : JALR instruction");
        $display();
        
        $display("TEST : `jalr`");
        instruction_i = 32'b000010101110_00000_000_00000_1100111;
        rst_ni = 0;
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.JALR) begin
            $display("Error, not in JALR");
        end
        if (rf_we_o !== 1) begin
            $display("Error, rf_we_o is %b, expected 1", rf_we_o);
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (sel_pc_o !== 1) begin
            $display("Error, sel_pc_o is %b, expected 1", sel_pc_o);
        end
        if (imm_o !== 32'h000000AE) begin
            $display("Error, imm_o is %b, expected 32'h000000AE", imm_o);
        end
        if (alu_op_o !== 6'b000_000) begin
            $display("Error, alu_op_o is %b, expected 000_000", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end

        $display("TEST : `jalr` finished");

        $display();
        $display("TESTs : CSR instructions");
        $display();

        $display("TEST : csrrw");
        instruction_i = 32'b111111111111_00101_001_00110_1110011;
        rst_ni = 0;

        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.CSR) begin
            $display("Error, not in CSR");
        end
        if (rf_we_o !== 1) begin
            $display("Error, rf_we_o is %b, expected 1", rf_we_o);
        end
        if (sel_csr_o !== 1) begin
            $display("Error, sel_csr_o is %b, expected 1", sel_csr_o);
        end
        if (csr_write_o !== 1) begin
            $display("Error, csr_write_o is %b, expected 1", csr_write_o);
        end
        if (csr_set_o !== 0) begin
            $display("Error, csr_set_o is %b, expected 0", csr_set_o);
        end
        if (csr_clear_o !== 0) begin
            $display("Error, csr_clear_o is %b, expected 0", csr_clear_o);
        end
        if (sel_imm_o !== 0) begin
            $display("Error, sel_imm_o is %b, expected 0", sel_imm_o);
        end
        if (imm_o !== 32'h0) begin
            $display("Error, imm_o is %h, expected 32'b0", imm_o);
        end
        if (alu_op_o !== 6'b000_000) begin
            $display("Error, alu_op_o is %b, expected 000_000", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end

        $display("TEST : `csrrw` finished");

        $display();

        $display("TEST : csrrs");
        instruction_i = 32'b111111111111_00101_010_00110_1110011;
        rst_ni = 0;

        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.CSR) begin
            $display("Error, not in CSR");
        end
        if (rf_we_o !== 1) begin
            $display("Error, rf_we_o is %b, expected 1", rf_we_o);
        end
        if (sel_csr_o !== 1) begin
            $display("Error, sel_csr_o is %b, expected 1", sel_csr_o);
        end
        if (csr_write_o !== 0) begin
            $display("Error, csr_write_o is %b, expected 0", csr_write_o);
        end
        if (csr_set_o !== 1) begin
            $display("Error, csr_set_o is %b, expected 1", csr_set_o);
        end
        if (csr_clear_o !== 0) begin
            $display("Error, csr_clear_o is %b, expected 0", csr_clear_o);
        end
        if (sel_imm_o !== 0) begin
            $display("Error, sel_imm_o is %b, expected 0", sel_imm_o);
        end
        if (imm_o !== 32'h0) begin
            $display("Error, imm_o is %h, expected 32'b0", imm_o);
        end
        if (alu_op_o !== 6'b000_000) begin
            $display("Error, alu_op_o is %b, expected 000_000", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end

        $display("TEST : `csrrs` finished");

        $display();

        $display("TEST : csrrc");
        instruction_i = 32'b111111111111_00101_011_00110_1110011;
        rst_ni = 0;

        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.CSR) begin
            $display("Error, not in CSR");
        end
        if (rf_we_o !== 1) begin
            $display("Error, rf_we_o is %b, expected 1", rf_we_o);
        end
        if (sel_csr_o !== 1) begin
            $display("Error, sel_csr_o is %b, expected 1", sel_csr_o);
        end
        if (csr_write_o !== 0) begin
            $display("Error, csr_write_o is %b, expected 0", csr_write_o);
        end
        if (csr_set_o !== 0) begin
            $display("Error, csr_set_o is %b, expected 0", csr_set_o);
        end
        if (csr_clear_o !== 1) begin
            $display("Error, csr_clear_o is %b, expected 1", csr_clear_o);
        end
        if (sel_imm_o !== 0) begin
            $display("Error, sel_imm_o is %b, expected 0", sel_imm_o);
        end
        if (imm_o !== 32'h0) begin
            $display("Error, imm_o is %h, expected 32'b0", imm_o);
        end
        if (alu_op_o !== 6'b000_000) begin
            $display("Error, alu_op_o is %b, expected 000_000", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end

        $display("TEST : `csrrc` finished");

        $display();

        $display("TEST : csrrwi");
        instruction_i = 32'b111111111111_10101_101_00110_1110011;
        rst_ni = 0;

        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.CSR) begin
            $display("Error, not in CSR");
        end
        if (rf_we_o !== 1) begin
            $display("Error, rf_we_o is %b, expected 1", rf_we_o);
        end
        if (sel_csr_o !== 1) begin
            $display("Error, sel_csr_o is %b, expected 1", sel_csr_o);
        end
        if (csr_write_o !== 1) begin
            $display("Error, csr_write_o is %b, expected 1", csr_write_o);
        end
        if (csr_set_o !== 0) begin
            $display("Error, csr_set_o is %b, expected 0", csr_set_o);
        end
        if (csr_clear_o !== 0) begin
            $display("Error, csr_clear_o is %b, expected 0", csr_clear_o);
        end
        if (sel_imm_o !== 1) begin
            $display("Error, sel_imm_o is %b, expected 1", sel_imm_o);
        end
        if (imm_o !== 32'b000000000000000000000000000_10101) begin
            $display("Error, imm_o is %h, expected 32'b000000000000000000000000000_10101", imm_o);
        end
        if (alu_op_o !== 6'b000_000) begin
            $display("Error, alu_op_o is %b, expected 000_000", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end

        $display("TEST : `csrrwi` finished");


        $display();

        $display("TEST : csrrsi");
        instruction_i = 32'b111111111111_00101_110_00110_1110011;
        rst_ni = 0;

        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.CSR) begin
            $display("Error, not in CSR");
        end
        if (rf_we_o !== 1) begin
            $display("Error, rf_we_o is %b, expected 1", rf_we_o);
        end
        if (sel_csr_o !== 1) begin
            $display("Error, sel_csr_o is %b, expected 1", sel_csr_o);
        end
        if (csr_write_o !== 0) begin
            $display("Error, csr_write_o is %b, expected 0", csr_write_o);
        end
        if (csr_set_o !== 1) begin
            $display("Error, csr_set_o is %b, expected 1", csr_set_o);
        end
        if (csr_clear_o !== 0) begin
            $display("Error, csr_clear_o is %b, expected 0", csr_clear_o);
        end
        if (sel_imm_o !== 1) begin
            $display("Error, sel_imm_o is %b, expected 1", sel_imm_o);
        end
        if (imm_o !== 32'b000000000000000000000000000_00101) begin
            $display("Error, imm_o is %h, expected 32'b000000000000000000000000000_00101", imm_o);
        end
        if (alu_op_o !== 6'b000_000) begin
            $display("Error, alu_op_o is %b, expected 000_000", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end

        $display("TEST : `csrrsi` finished");


        $display();

        $display("TEST : csrrci");
        instruction_i = 32'b111111111111_11101_111_00110_1110011;
        rst_ni = 0;

        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.CSR) begin
            $display("Error, not in CSR");
        end
        if (rf_we_o !== 1) begin
            $display("Error, rf_we_o is %b, expected 1", rf_we_o);
        end
        if (sel_csr_o !== 1) begin
            $display("Error, sel_csr_o is %b, expected 1", sel_csr_o);
        end
        if (csr_write_o !== 0) begin
            $display("Error, csr_write_o is %b, expected 0", csr_write_o);
        end
        if (csr_set_o !== 0) begin
            $display("Error, csr_set_o is %b, expected 0", csr_set_o);
        end
        if (csr_clear_o !== 1) begin
            $display("Error, csr_clear_o is %b, expected 1", csr_clear_o);
        end
        if (sel_imm_o !== 1) begin
            $display("Error, sel_imm_o is %b, expected 1", sel_imm_o);
        end
        if (imm_o !== 32'b000000000000000000000000000_11101) begin
            $display("Error, imm_o is %h, expected 32'b000000000000000000000000000_11101", imm_o);
        end
        if (alu_op_o !== 6'b000_000) begin
            $display("Error, alu_op_o is %b, expected 000_000", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end

        $display("TEST : `csrrci` finished");

        $display();
        $display("TESTs : Interrupts");

        instruction_i = 32'b111111111111_00000_000_00000_0010011;
        rst_ni = 0;
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        ipending_i = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (csr_interrupt_o !== 1) begin
            $display("Error, csr_interrupt_o is %b, expected 1", csr_interrupt_o);
        end
        if (pc_sel_mtvec_o !== 1) begin
            $display("Error, pc_sel_mtvec_o is %b, expected 1", pc_sel_mtvec_o);
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 0) begin
            $display("Error, ir_en_o is %b, expected 0", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        $display("TEST : interrupts finished");

        $display();
        $display("TEST : `mret`");
        instruction_i = 32'b001100000010_00111_000_01001_1110011;
        rst_ni = 0;
        ipending_i = 0;
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end
        if (we_o !== 0) begin
            $display("Error, we_o is %b, expected 0", we_o);
        end

        rst_ni = 1;
        #10;
        if (uut.state_r !== uut.FETCH2) begin
            $display("Error, not in FETCH2");
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (ir_en_o !== 1) begin
            $display("Error, ir_en_o is %b, expected 1", ir_en_o);
        end
        #10;
        if (uut.state_r !== uut.DECODE) begin
            $display("Error, not in DECODE");
        end
        #10;
        if (uut.state_r !== uut.INTERRUPT_RETURN) begin
            $display("Error, not in INTERRUPT_RETURN");
        end
        if (csr_mret_o !== 1) begin
            $display("Error, csr_mret_o is %b, expected 1", csr_mret_o);
        end
        if (pc_sel_mepc_o !== 1) begin
            $display("Error, pc_sel_mepc_o is %b, expected 1", pc_sel_mepc_o);
        end
        if (pc_en_o !== 1) begin
            $display("Error, pc_en_o is %b, expected 1", pc_en_o);
        end
        if (alu_op_o !== 6'b000_000) begin
            $display("Error, alu_op_o is %b, expected 000_000", alu_op_o);
        end
        #10;
        if (uut.state_r !== uut.FETCH1) begin
            $display("Error, not in FETCH1");
        end

        $display("TEST : `mret` finished");

        $display();

        // Finish simulation
        $finish;
    end

    always begin
        #5 clk_i = ~clk_i;
    end
endmodule
