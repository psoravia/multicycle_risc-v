`timescale 1ns / 1ps

module tb_pc ();
    // Inputs
    reg        clk_i, rst_ni, en_i, sel_alu_i, sel_pc_base_i, add_imm_i, sel_mtvec_i, sel_mepc_i;
    reg [31:0] imm_i, alu_i, mtvec_i, mepc_i;

    // Outputs
    wire [31:0] addr_o;

    // Instantiate the Unit Under Test (UUT)
    pc uut (
        .clk_i (clk_i),
        .rst_ni (rst_ni),
        .en_i (en_i),
        .sel_alu_i (sel_alu_i),
        .sel_pc_base_i (sel_pc_base_i),
        .add_imm_i (add_imm_i),
        .imm_i (imm_i),
        .alu_i (alu_i),
        .sel_mtvec_i (sel_mtvec_i),
        .sel_mepc_i (sel_mepc_i),
        .mtvec_i (mtvec_i),
        .mepc_i (mepc_i),
        .addr_o (addr_o)
    );

    initial begin
        // Generate waveform file
        $dumpfile("dump/tb_pc.vcd");
        $dumpvars(0, tb_pc);

        
        rst_ni = 0; sel_alu_i = 0; sel_pc_base_i = 0; add_imm_i = 0; imm_i = 32'b0; alu_i = 32'b0;
        sel_mtvec_i = 0; sel_mepc_i = 0; mtvec_i = 32'b0; mepc_i = 32'b0;
        #10;


        $display("TEST : Enable PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);
        #10;
        $display("pc = %h", addr_o);
        #10;
        $display("pc = %h", addr_o);
        #10;
        $display("pc = %h", addr_o);

        $display();

        $display("TEST : Disable PC");
        en_i = 0;
        #10;
        $display("pc = %h", addr_o);
        #10;
        $display("pc = %h", addr_o);
        #10;
        $display("pc = %h", addr_o);
        #10;
        $display("pc = %h", addr_o);

        $display();

        $display("TEST : increment again PC");
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display();

        $display("TEST : Reset PC");
        rst_ni = 0;
        #10;
        $display("pc = %h", addr_o);

        $display();

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display();

        $display("TEST : branching");

        $display("TEST : Reset PC");
        rst_ni = 0;
        #10;
        $display("pc = %h", addr_o);

        $display();

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : branching from base address");
        rst_ni = 1;
        en_i = 1;
        sel_pc_base_i = 1;
        add_imm_i = 1;
        imm_i = 32'h0000_0700;
        #10;
        if (addr_o !== 32'h8000_0710) begin
            $display("Error : addr_o = %h, expected 32'h8000_0710", addr_o);
        end
        $display("pc = %h", addr_o);

        $display();

        $display("TEST : branching (backward)");

        $display("TEST : Reset PC");
        rst_ni = 0;
        sel_pc_base_i = 0;
        add_imm_i = 0;
        #10;
        $display("pc = %h", addr_o);

        $display();

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : branching from base address (backward)");
        rst_ni = 1;
        en_i = 1;
        sel_pc_base_i = 1;
        add_imm_i = 1;
        imm_i = 32'hFFFF_FFF9;
        #10;
        if (addr_o !== 32'h80000008) begin
            $display("Error : addr_o = %h, expected 32'h80000008", addr_o);
        end
        $display("pc = %h", addr_o);


        $display();

        $display("TEST : branching but PC disabled");

        $display("TEST : Reset PC");
        rst_ni = 0;
        sel_pc_base_i = 0;
        add_imm_i = 0;
        #10;
        $display("pc = %h", addr_o);

        $display();

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : branching from base address");
        rst_ni = 1;
        en_i = 0;
        sel_pc_base_i = 1;
        add_imm_i = 1;
        imm_i = 32'h0000_0700;
        #10;
        if (addr_o !== 32'h8000_0014) begin
            $display("Error : addr_o = %h, expected 32'h8000_0014", addr_o);
        end
        $display("pc = %h", addr_o);



        $display();

        $display("TEST : branching from next address");

        $display("TEST : Reset PC");
        rst_ni = 0;
        sel_pc_base_i = 0;
        add_imm_i = 0;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display();

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : branching from next address");
        rst_ni = 1;
        en_i = 1;
        sel_pc_base_i = 0;
        add_imm_i = 1;
        imm_i = 32'h0000_EA13;
        #10;
        if (addr_o !== 32'h8000_EA24) begin
            $display("Error : addr_o = %h, expected 32'h8000_EA24", addr_o);
        end
        $display("pc = %h", addr_o);


        $display();

        $display("TEST : branching from next address (backward)");

        $display("TEST : Reset PC");
        rst_ni = 0;
        sel_pc_base_i = 0;
        add_imm_i = 0;
        #10;
        $display("pc = %h", addr_o);

        $display();

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : branching from base address (backward)");
        rst_ni = 1;
        en_i = 1;
        sel_pc_base_i = 0;
        add_imm_i = 1;
        imm_i = 32'hFFFF_FFF8;
        #10;
        if (addr_o !== 32'h8000000C) begin
            $display("Error : addr_o = %h, expected 32'h8000000C", addr_o);
        end
        $display("pc = %h", addr_o);


        $display();

        $display("TEST : branching on next address but PC disabled");

        $display("TEST : Reset PC");
        rst_ni = 0;
        sel_pc_base_i = 0;
        add_imm_i = 0;
        #10;
        $display("pc = %h", addr_o);

        $display();

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : branching from base address");
        rst_ni = 1;
        en_i = 0;
        sel_pc_base_i = 0;
        add_imm_i = 1;
        imm_i = 32'h0000_0700;
        #10;
        if (addr_o !== 32'h8000_0014) begin
            $display("Error : addr_o = %h, expected 32'h8000_0014", addr_o);
        end
        $display("pc = %h", addr_o);



        $display();

        $display("TEST : branching to the ALU result");

        $display("TEST : Reset PC");
        rst_ni = 0;
        sel_pc_base_i = 0;
        add_imm_i = 0;
        #10;
        $display("pc = %h", addr_o);

        $display();

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : branching from ALU result");
        rst_ni = 1;
        en_i = 1;
        sel_pc_base_i = 0;
        add_imm_i = 0;
        imm_i = 32'h0;
        sel_alu_i = 1;
        alu_i = 32'h800A_BBC1;
        #10;
        if (addr_o !== 32'h800A_BBC0) begin
            $display("Error : addr_o = %h, expected 32'h800A_BBC0", addr_o);
        end
        $display("pc = %h", addr_o);



        $display();

        $display("TEST : branching to the ALU result but PC disabled");

        $display("TEST : Reset PC");
        rst_ni = 0;
        sel_pc_base_i = 0;
        add_imm_i = 0;
        sel_alu_i = 0;
        #10;
        $display("pc = %h", addr_o);

        $display();

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : branching from ALU result but PC disabled");
        rst_ni = 1;
        en_i = 0;
        sel_pc_base_i = 0;
        add_imm_i = 0;
        imm_i = 32'h0;
        sel_alu_i = 1;
        alu_i = 32'h800A_BBC1;
        #10;
        if (addr_o !== 32'h8000_0014) begin
            $display("Error : addr_o = %h, expected 32'h8000_0014", addr_o);
        end
        $display("pc = %h", addr_o);
    
        $display();

        $display();
        $display("TESTs : Machine mode");
        $display();
        
        $display("TEST : Reset PC");
        rst_ni = 0;
        sel_pc_base_i = 0;
        add_imm_i = 0;
        sel_alu_i = 0;
        #10;
        $display("pc = %h", addr_o);
        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);
        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);
        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);
        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);
        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : mtvec");
        rst_ni = 1;
        en_i = 1;
        sel_pc_base_i = 0;
        add_imm_i = 0;
        imm_i = 32'h0;
        sel_alu_i = 0;
        alu_i = 32'h800A_BBC1;
        sel_mtvec_i = 1;
        sel_mepc_i = 0;
        mtvec_i = 32'hBABACDCF;
        mepc_i = 32'hFFFFFFFF;
        #10;
        if (addr_o !== 32'hBABACDCC) begin
            $display("Error : addr_o is %h, expected 32'hBABACDCC", addr_o);
        end else begin
            $display("Correct output !");
        end

        $display();

        $display("TEST : Reset PC");
        rst_ni = 0;
        sel_pc_base_i = 0;
        add_imm_i = 0;
        sel_alu_i = 0;
        sel_mtvec_i = 0;
        #10;
        $display("pc = %h", addr_o);
        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);
        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);
        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);
        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);
        $display("TEST : increment again PC");
        rst_ni = 1;
        en_i = 1;
        #10;
        $display("pc = %h", addr_o);

        $display("TEST : mepc");
        rst_ni = 1;
        en_i = 1;
        sel_pc_base_i = 0;
        add_imm_i = 0;
        imm_i = 32'h0;
        sel_alu_i = 0;
        alu_i = 32'h800A_BBC1;
        sel_mtvec_i = 0;
        sel_mepc_i = 1;
        mtvec_i = 32'hBABACDCF;
        mepc_i = 32'hFFAF7FF0;
        #10;
        if (addr_o !== 32'hFFAF7FF0) begin
            $display("Error : addr_o is %h, expected 32'hFFAF7FF0", addr_o);
        end else begin
            $display("Correct output !");
        end

        $display("TEST : mtvec PC disabled");
        rst_ni = 1;
        en_i = 0;
        sel_pc_base_i = 0;
        add_imm_i = 0;
        imm_i = 32'h0;
        sel_alu_i = 0;
        alu_i = 32'h800A_BBC1;
        sel_mtvec_i = 1;
        sel_mepc_i = 0;
        mtvec_i = 32'hBABACDCF;
        mepc_i = 32'hFFAF7FF0;
        #10;
        if (addr_o !== 32'hFFAF7FF0) begin
            $display("Error : addr_o is %h, expected 32'hFFAF7FF0", addr_o);
        end else begin
            $display("Correct output !");
        end


        $display("TEST : mepc PC disabled");
        rst_ni = 1;
        en_i = 0;
        sel_pc_base_i = 0;
        add_imm_i = 0;
        imm_i = 32'h0;
        sel_alu_i = 0;
        alu_i = 32'h800A_BBC1;
        sel_mtvec_i = 0;
        sel_mepc_i = 1;
        mtvec_i = 32'hBABACDCF;
        mepc_i = 32'hFFFFFFF0;
        #10;
        if (addr_o !== 32'hFFAF7FF0) begin
            $display("Error : addr_o is %h, expected 32'hFFAF7FF0", addr_o);
        end else begin
            $display("Correct output !");
        end

        $display();

        // Finish simulation
        $finish;
    end

    always begin
        #5 clk_i = ~clk_i;
    end
endmodule