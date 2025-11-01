module ir (
    input  wire        clk_i,
    input  wire        enable_i,
    input  wire [31:0] d_i,
    output reg  [31:0] q_o
);

    reg [31:0] q_r;
    reg [31:0] q_next_r;

    // next_state logic
    always @(*) begin
        q_next_r = q_r;
        if (enable_i) begin
            q_next_r = d_i;
        end else begin
            q_next_r = q_r;
        end
    end

    // state memory
    always @(posedge clk_i) begin
        q_r <= q_next_r;
    end

    // output logic
    always @(*) begin
        q_o = q_r;
    end
endmodule
