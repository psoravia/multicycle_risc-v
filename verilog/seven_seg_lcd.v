module seven_seg_lcd (
    input  wire        clk_i,
    input  wire        rst_ni,
    input  wire        en_i,
    input  wire        we_i,
    input  wire [31:0] waddr_i,
    input  wire [31:0] wdata_i,
    output wire [31:0] disp_o
);

    reg [31:0] lcd_content_r;

    always @(posedge clk_i) begin
        if (rst_ni == 0) begin
            lcd_content_r <= 32'h00000000;
        end else if (en_i == 1 && we_i == 1 && waddr_i == 32'h60000000) begin
            lcd_content_r <= wdata_i;
        end else begin
            lcd_content_r <= lcd_content_r;
        end
    end

    assign disp_o = lcd_content_r;

endmodule
