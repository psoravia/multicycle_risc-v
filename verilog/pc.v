module pc (
    input  wire        clk_i,
    input  wire        rst_ni,
    input  wire        en_i,
    input  wire        sel_alu_i,
    input  wire        sel_pc_base_i,
    input  wire        add_imm_i,
    input  wire [31:0] imm_i,
    input  wire [31:0] alu_i,
    input  wire        sel_mtvec_i,
    input  wire        sel_mepc_i,
    input  wire [31:0] mtvec_i,
    input  wire [31:0] mepc_i,
    output wire [31:0] addr_o
);

    reg [31:0] addr;
    reg [31:0] addr_next;

    // next-state logic
    always @(*) begin
        addr_next = addr;
        if (en_i) begin
            if (sel_mtvec_i) begin
                addr_next = mtvec_i;
            end
            else if (sel_mepc_i) begin
                addr_next = mepc_i;
            end
            else if (sel_alu_i) begin
                addr_next = alu_i;
            end
            else if (add_imm_i) begin
                if (sel_pc_base_i) begin
                    addr_next = addr + imm_i - 4;
                end else begin
                    addr_next = addr + imm_i;
                end
            end else begin
                addr_next = addr + 4;
            end
        end else begin
            addr_next = addr;
        end
        addr_next = addr_next & 32'hFFFFFFFC;
    end

    // state memory
    always @(posedge clk_i) begin
        if (!rst_ni) begin
            addr <= 32'h80000000;
        end else begin
            addr <= addr_next;
        end
    end

    // output logic
    assign addr_o = addr;
endmodule
