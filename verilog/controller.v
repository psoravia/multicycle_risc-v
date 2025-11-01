module controller (
    input wire clk_i,
    input wire rst_ni,

    // Current instruction
    input wire [31:0] instruction_i,

    // pending interrupt
    input wire ipending_i,

    // Branch operation
    output reg branch_op_o,

    // Immediate value correctly extended
    output reg [31:0] imm_o,

    // Instruction Register control signals
    output reg ir_en_o,

    // PC control signals
    output reg pc_add_imm_o,
    output reg pc_en_o,
    output reg pc_sel_alu_o,
    output reg pc_sel_pc_base_o,

    // Register file control signals
    output reg rf_we_o,

    // Multiplexer control signals
    output reg sel_addr_o,
    output reg sel_b_o,
    output reg sel_mem_o,
    output reg sel_pc_o,
    output reg sel_imm_o,

    // Memory control signals
    output reg we_o,

    // ALU control signals
    output reg [5:0] alu_op_o,

    // CSR signals
    output reg csr_write_o,
    output reg csr_set_o,
    output reg csr_clear_o,
    output reg csr_interrupt_o,
    output reg csr_mret_o,
    output reg sel_csr_o,
    output reg pc_sel_mtvec_o,
    output reg pc_sel_mepc_o
);

    // all the psssible states of the controller
    localparam FETCH1 = 4'b0000;
    localparam FETCH2 = 4'b0001;
    localparam DECODE = 4'b0010;
    localparam U_TYPE = 4'b0011;
    localparam R_TYPE = 4'b0100;
    localparam S_TYPE = 4'b0101;
    localparam I_TYPE = 4'b0110;
    localparam BREAK = 4'b0111;
    localparam B_TYPE = 4'b1000;
    localparam J_TYPE = 4'b1001;
    localparam JALR = 4'b1010;
    localparam LOAD1 = 4'b1011;
    localparam LOAD2 = 4'b1100;
    localparam CSR = 4'b1101;
    localparam INTERRUPT_RETURN = 4'b1110;

    // all the opcodes
    localparam R_TYPE_OP = 7'b0110011;
    localparam I_TYPE_OP = 7'b0010011;
    localparam U_TYPE_OP = 7'b0110111;
    localparam LOAD_OP = 7'b0000011;
    localparam S_TYPE_OP = 7'b0100011;
    localparam SYSTEM_OP = 7'b1110011;
    localparam B_TYPE_OP = 7'b1100011;
    localparam J_TYPE_OP = 7'b1101111;
    localparam JALR_OP = 7'b1100111;

    reg [3:0] state_r;
    reg [3:0] state_next_r;

    // next-state logic
    always @(*) begin
        state_next_r = FETCH1;
        case (state_r)
            FETCH1: state_next_r = FETCH2;
            FETCH2: begin
                if (ipending_i == 1) begin
                    state_next_r = FETCH1;
                end else begin
                    state_next_r = DECODE;
                end
            end
            DECODE: begin
                case (instruction_i[6:0])
                    R_TYPE_OP: state_next_r = R_TYPE;
                    I_TYPE_OP: state_next_r = I_TYPE;
                    U_TYPE_OP: state_next_r = U_TYPE;
                    LOAD_OP: state_next_r = LOAD1;
                    S_TYPE_OP: state_next_r = S_TYPE;
                    SYSTEM_OP: begin
                        if (instruction_i[31:20] == 12'b000000000001 &&
                            instruction_i[14:12] == 3'b0
                        ) begin
                            state_next_r = BREAK;
                        end else if (instruction_i[31:20] == 12'h302 &&
                                    instruction_i[14:12] == 3'b0
                                    ) begin
                            state_next_r = INTERRUPT_RETURN;
                        end
                        else begin
                            state_next_r = CSR;
                        end
                    end
                    B_TYPE_OP: state_next_r = B_TYPE;
                    J_TYPE_OP: state_next_r = J_TYPE;
                    JALR_OP: state_next_r = JALR;
                    default: state_next_r = BREAK;
                endcase
            end
            U_TYPE: state_next_r = FETCH2;
            R_TYPE: state_next_r = FETCH2;
            S_TYPE: state_next_r = FETCH1;
            I_TYPE: state_next_r = FETCH2;
            BREAK: state_next_r = BREAK;
            B_TYPE: state_next_r = FETCH1;
            J_TYPE: state_next_r = FETCH1;
            JALR: state_next_r = FETCH1;
            LOAD1: state_next_r = LOAD2;
            LOAD2: state_next_r = FETCH1;
            CSR: state_next_r = FETCH2;
            INTERRUPT_RETURN: state_next_r = FETCH1;
            default: state_next_r = BREAK;
        endcase
    end

    // state memory
    always @(posedge clk_i) begin
        if (!rst_ni) begin
            state_r <= FETCH1;
        end else begin
            state_r <= state_next_r;
        end
    end

    // output logic
    always @(*) begin
        // default values
        branch_op_o = 0;
        imm_o = 32'b0;
        ir_en_o = 0;
        pc_add_imm_o = 0;
        pc_en_o = 0;
        pc_sel_alu_o = 0;
        pc_sel_pc_base_o = 0;
        rf_we_o = 0;
        sel_addr_o = 0;
        sel_b_o = 0;
        sel_mem_o = 0;
        sel_pc_o = 0;
        sel_imm_o = 0;
        we_o = 0;
        csr_write_o = 0;
        csr_set_o = 0;
        csr_clear_o = 0;
        csr_interrupt_o = 0;
        csr_mret_o = 0;
        sel_csr_o = 0;
        pc_sel_mtvec_o = 0;
        pc_sel_mepc_o = 0;
        case (state_r)
            FETCH1: we_o = 0;
            FETCH2: begin
                if (ipending_i == 1) begin
                    csr_interrupt_o = 1;
                    pc_sel_mtvec_o = 1;
                    pc_en_o = 1;
                end else begin
                    pc_en_o = 1;
                    ir_en_o = 1;
                end
            end
            DECODE: ;
            I_TYPE: begin
                imm_o = {{20{instruction_i[31]}},  instruction_i[31:20]};
                rf_we_o = 1; // ???
            end
            R_TYPE: begin
                rf_we_o = 1;
                sel_b_o = 1;
            end
            U_TYPE: begin
                imm_o = instruction_i[31:12] << 12;
                rf_we_o = 1;
                sel_imm_o = 1;
            end
            LOAD1: begin
                sel_addr_o = 1;
                imm_o = {{20{instruction_i[31]}},  instruction_i[31:20]};
            end
            LOAD2: begin
                sel_addr_o = 1;
                imm_o = {{20{instruction_i[31]}},  instruction_i[31:20]};
                sel_mem_o = 1;
                rf_we_o = 1;
            end
            S_TYPE: begin
                imm_o = {{20{instruction_i[31]}}, {instruction_i[31:25], instruction_i[11:7]}};
                sel_addr_o = 1;
                we_o = 1;
            end
            BREAK: ;
            B_TYPE: begin
                imm_o = {{19{instruction_i[31]}},
                         {instruction_i[31],
                          instruction_i[7],
                          instruction_i[30:25],
                          instruction_i[11:8],
                          1'b0}
                        };
                branch_op_o = 1;
                sel_b_o = 1;
                pc_sel_pc_base_o = 1;
                pc_add_imm_o = 1;
            end
            J_TYPE: begin
                imm_o = {{11{instruction_i[31]}},
                         {instruction_i[31],
                          instruction_i[19:12],
                          instruction_i[20],
                          instruction_i[30:21],
                          1'b0}
                        };
                rf_we_o = 1;
                pc_en_o = 1;
                pc_sel_pc_base_o = 1;
                pc_add_imm_o = 1;
                sel_pc_o = 1;
            end
            JALR: begin
                imm_o = {{20{instruction_i[31]}}, instruction_i[31:20]};
                rf_we_o = 1;
                pc_en_o = 1;
                pc_sel_alu_o = 1;
                sel_pc_o = 1;
            end
            CSR: begin
                sel_csr_o = 1;
                rf_we_o = 1;
                case (instruction_i[14:12])
                    3'b001: begin
                        csr_write_o = 1;
                        csr_set_o = 0;
                        csr_clear_o = 0;
                        sel_imm_o = 0;
                        imm_o = 32'b0;
                    end
                    3'b010: begin
                        csr_write_o = 0;
                        csr_set_o = 1;
                        csr_clear_o = 0;
                        sel_imm_o = 0;
                        imm_o = 32'b0;
                    end
                    3'b011: begin
                        csr_write_o = 0;
                        csr_set_o = 0;
                        csr_clear_o = 1;
                        sel_imm_o = 0;
                        imm_o = 32'b0;
                    end
                    3'b101: begin
                        csr_write_o = 1;
                        csr_set_o = 0;
                        csr_clear_o = 0;
                        sel_imm_o = 1;
                        imm_o = {27'b0, instruction_i[19:15]};
                    end
                    3'b110: begin
                        csr_write_o = 0;
                        csr_set_o = 1;
                        csr_clear_o = 0;
                        sel_imm_o = 1;
                        imm_o = {27'b0, instruction_i[19:15]};
                    end
                    3'b111: begin
                        csr_write_o = 0;
                        csr_set_o = 0;
                        csr_clear_o = 1;
                        sel_imm_o = 1;
                        imm_o = {27'b0, instruction_i[19:15]};
                    end
                    default: begin
                        csr_write_o = 0;
                        csr_set_o = 0;
                        csr_clear_o = 0;
                        sel_imm_o = 0;
                        imm_o = 32'b0;
                    end
                endcase
            end
            INTERRUPT_RETURN: begin
                csr_mret_o = 1;
                pc_sel_mepc_o = 1;
                pc_en_o = 1;
            end
            default: begin
                branch_op_o = 0;
                imm_o = 32'b0;
                ir_en_o = 0;
                pc_add_imm_o = 0;
                pc_en_o = 0;
                pc_sel_alu_o = 0;
                pc_sel_pc_base_o = 0;
                rf_we_o = 0;
                sel_addr_o = 0;
                sel_b_o = 0;
                sel_mem_o = 0;
                sel_pc_o = 0;
                sel_imm_o = 0;
                we_o = 0;
                csr_write_o = 0;
                csr_set_o = 0;
                csr_clear_o = 0;
                csr_interrupt_o = 0;
                csr_mret_o = 0;
                sel_csr_o = 0;
                pc_sel_mtvec_o = 0;
                pc_sel_mepc_o = 0;
            end
        endcase
    end

    // generate alu_op_o
    always @(*) begin
        alu_op_o = 6'b0;
        case (instruction_i[6:0])
            I_TYPE_OP: begin
                case (instruction_i[14:12])
                    3'b000: alu_op_o = {instruction_i[14:12], 3'b000};
                    3'b100, 3'b110, 3'b111: alu_op_o = {instruction_i[4:2], instruction_i[14:12]};
                    3'b010, 3'b011: alu_op_o = {3'b011, instruction_i[13:12], 1'b0};
                    3'b001: alu_op_o = {3'b110, instruction_i[14:12]};
                    3'b101: alu_op_o = {2'b11, instruction_i[30], instruction_i[14:12]};
                    default: alu_op_o = 6'b0;
                endcase
            end
            R_TYPE_OP: begin
                case (instruction_i[14:12])
                    3'b000: alu_op_o = {1'b0, instruction_i[31:30], 3'b000};
                    3'b100, 3'b110, 3'b111: alu_op_o = {instruction_i[4:2], instruction_i[14:12]};
                    3'b010, 3'b011: alu_op_o = {3'b011, instruction_i[13:12], 1'b0};
                    3'b001: alu_op_o = {3'b110, instruction_i[14:12]};
                    3'b101: alu_op_o = {2'b11, instruction_i[30], instruction_i[14:12]};
                    default: alu_op_o = 6'b0;
                endcase
            end
            U_TYPE_OP: ; // check later
            LOAD_OP: alu_op_o = 6'b0;
            S_TYPE_OP: alu_op_o = 6'b0;
            SYSTEM_OP: ; // check later
            B_TYPE_OP: alu_op_o = {3'b011, instruction_i[14:12]};
            J_TYPE_OP: ; // check later
            JALR_OP: ; // check later
            default: alu_op_o = 6'b0;
        endcase
    end

endmodule
