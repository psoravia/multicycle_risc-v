module add_sub (
    input  wire [31:0] a_i,
    input  wire [31:0] b_i,
    input  wire        sub_i,
    output wire        carry_o,
    output wire        zero_o,
    output wire [31:0] r_o
);

    assign carry_o = (({1'b0, a_i} + {1'b0, ({32{sub_i}} ^ b_i)} + {32'b0, sub_i}) >>> 32) > 0;
    assign zero_o = (a_i + ({32{sub_i}} ^ b_i) + {31'b0, sub_i}) == 0;
    assign r_o = (a_i + ({32{sub_i}} ^ b_i) + {31'b0, sub_i});
endmodule
