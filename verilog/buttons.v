module buttons (
    input  wire        clk_i,
    input  wire        rst_ni,
    input  wire        en_i,
    input  wire        we_i,
    input  wire [31:0] addr_i,
    input  wire [31:0] wdata_i,
    input  wire [ 9:0] push_i,
    input  wire [ 7:0] switch_i,
    output wire [31:0] rdata_o,
    output wire        irq_o
);

    localparam ACTIVE_LOW = 2'b00;
    localparam RISING_EDGE = 2'b01;
    localparam FALLING_EDGE = 2'b10;
    localparam ACTIVE_HIGH = 2'b11; // default

    reg [31:0] val_r;
    reg [31:0] val_next_r;

    reg [31:0] src_r;
    reg [31:0] src_next_r;

    reg [31:0] ptm_r;
    reg [31:0] stm_r;

    reg [31:0] rdata_r;

    genvar k;
    genvar l;

    // push buttons logic
    generate
        for (k = 0; k < 10; k = k + 1) begin : gen_push_button_logic
            always @(*) begin
                case (ptm_r[2*k +: 2])
                    ACTIVE_LOW: src_next_r[k] = (push_i[k] == 0);
                    RISING_EDGE: begin
                        if (addr_i == 32'h70000004 && wdata_i == 32'h0 && en_i==1 && we_i==1) begin
                            src_next_r[k] = 0;
                        end else if (src_r[k] == 1) begin
                            src_next_r[k] = 1;
                        end else begin
                            src_next_r[k] = (val_r[k] == 0 && push_i[k] == 1);
                        end
                    end
                    FALLING_EDGE: begin
                        if (addr_i == 32'h70000004 && wdata_i == 32'h0 && en_i==1 && we_i==1) begin
                            src_next_r[k] = 0;
                        end else if (src_r[k] == 1) begin
                            src_next_r[k] = 1;
                        end else begin
                            src_next_r[k] = (val_r[k] == 1 && push_i[k] == 0);
                        end
                    end
                    ACTIVE_HIGH: src_next_r[k] = (push_i[k] == 1);
                    default: src_next_r[k] = (push_i[k] == 1);
                endcase
            end
        end
    endgenerate

    // switch logic
    generate
        for (l = 0; l < 8; l = l + 1) begin : gen_switch_logic
            always @(*) begin
                case (stm_r[2*l +: 2])
                    ACTIVE_LOW: src_next_r[l+16] = (switch_i[l] == 0);
                    RISING_EDGE: begin
                        if (addr_i == 32'h70000004 && wdata_i == 32'h0 && en_i==1 && we_i==1) begin
                            src_next_r[l+16] = 0;
                        end else if (src_r[l+16] == 1) begin
                            src_next_r[l+16] = 1;
                        end else begin
                            src_next_r[l+16] = (val_r[l+16] == 0 && switch_i[l] == 1);
                        end
                    end
                    FALLING_EDGE: begin
                        if (addr_i == 32'h70000004 && wdata_i == 32'h0 && en_i==1 && we_i==1) begin
                            src_next_r[l+16] = 0;
                        end else if (src_r[l+16] == 1) begin
                            src_next_r[l+16] = 1;
                        end else begin
                            src_next_r[l+16] = (val_r[l+16] == 1 && switch_i[l] == 0);
                        end
                    end
                    ACTIVE_HIGH: src_next_r[l+16] = (switch_i[l] == 1);
                    default: src_next_r[l+16] = (switch_i[l] == 1);
                endcase
            end
        end
    endgenerate

    // val_next logic
    always @(*) begin
        val_next_r = {8'b0, switch_i, 6'b0, push_i};
    end

    // read management
    always @(posedge clk_i) begin
        if (rst_ni == 0) begin
            rdata_r <= 32'h0;
        end else if (en_i == 1 && we_i == 0) begin
            if (addr_i == 32'h70000000) begin
                rdata_r <= val_next_r;
            end else if (addr_i == 32'h70000004) begin
                rdata_r <= src_next_r;
            end else begin
                rdata_r <= 32'h0;
            end
        end else begin
            rdata_r <= 32'h0;
        end
    end

    // write management
    always @(posedge clk_i) begin
        val_r <= val_next_r;
        src_r <= src_next_r;
        ptm_r <= ptm_r;
        stm_r <= stm_r;
        if (rst_ni == 0) begin
            val_r <= 32'h0;
            src_r <= 32'h0;
            ptm_r <= {12'b0, ({10{ACTIVE_HIGH}})};
            stm_r <= {16'b0, ({8{ACTIVE_HIGH}})};
        end else if (en_i == 1 && we_i == 1) begin
            if (addr_i == 32'h70000008) begin
                ptm_r <= {12'b0, wdata_i[19:0]};
            end else if (addr_i == 32'h7000000C) begin
                stm_r <= {16'b0, wdata_i[15:0]};
            end
        end
    end


    assign rdata_o = rdata_r;
    assign irq_o = |src_r;

endmodule
