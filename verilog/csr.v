
module csr (
    input  wire        clk_i,
    input  wire        rst_ni,
    input  wire [11:0] addr_i,
    input  wire [31:0] wdata_i,
    input  wire        irq_i,
    input  wire [31:0] pc_i,
    input  wire        write_i,
    input  wire        set_i,
    input  wire        clear_i,
    input  wire        interrupt_i,
    input  wire        mret_i,
    output wire [31:0] rdata_o,
    output wire [31:0] mtvec_o,
    output wire [31:0] mepc_o,
    output wire        ipending_o
);

  //! Don't change the following definition.
  //! Should be used for storing the CSR registers values as
  //! described in the assignment.
  reg [31:0] mstatus_r, mie_r, mtvec_r, mepc_r, mcause_r, mip_r;

  reg [31:0] rdata_r;


  // read
  always @(*) begin
    if (rst_ni == 0) begin
      rdata_r = 32'b0;
    end else begin
      case (addr_i)
        12'h300: rdata_r = mstatus_r;
        12'h304: rdata_r = mie_r;
        12'h305: rdata_r = mtvec_r;
        12'h341: rdata_r = mepc_r;
        12'h342: rdata_r = mcause_r;
        12'h344: rdata_r = mip_r;
        default: rdata_r = 32'b0;
      endcase
    end
  end

  // modify registers
  always @(posedge clk_i) begin
    mstatus_r <= mstatus_r;
    mie_r <= mie_r;
    mtvec_r <= mtvec_r;
    mepc_r <= mepc_r;
    mcause_r <= mcause_r;
    mip_r <= {20'b0, (irq_i == 1 && mstatus_r[3] == 1 && mie_r[11] == 1), 11'b0};

    if (rst_ni == 0) begin
      mstatus_r <= 32'h0000_1800;
      mie_r <= 32'h0;
      mtvec_r <= 32'h0;
      mepc_r <= 32'h0;
      mcause_r <= 32'h0;
      mip_r <= 32'h0;
    end else if (
      write_i==0 &&
      set_i==0 &&
      clear_i==0 &&
      interrupt_i==1 &&
      mret_i==0
    ) begin
      mepc_r <= pc_i;
      mcause_r <= 32'h80000800;
      mstatus_r <= {19'b0, mstatus_r[12:11], 3'b0, mstatus_r[3], 3'b0, 1'b0, 3'b0};
    end else if (write_i == 0 && set_i == 0 && clear_i == 0 && interrupt_i == 0 && mret_i==1) begin
      mstatus_r <= {19'b0, mstatus_r[12:11], 3'b0, 1'b1, 3'b0, mstatus_r[7], 3'b0};
    end else if (write_i == 1 && set_i == 0 && clear_i == 0 && interrupt_i == 0 && mret_i==0) begin
      if (addr_i == 12'h300) begin
        mstatus_r <= {19'b0, wdata_i[12:11], 3'b0, wdata_i[7], 3'b0, wdata_i[3], 3'b0};
      end else if (addr_i == 12'h304) begin
        mie_r <= {20'b0, wdata_i[11], 11'b0};
      end else if (addr_i == 12'h305) begin
        mtvec_r <= wdata_i;
      end else if (addr_i == 12'h341) begin
        mepc_r <= wdata_i;
      end else if (addr_i == 12'h342) begin
        mcause_r <= {wdata_i[31], 19'b0, wdata_i[11], 11'b0};
      end else if (addr_i == 12'h344) begin
        mip_r <= {20'b0, wdata_i[11], 11'b0};
      end
    end else if (write_i == 0 && set_i == 1 && clear_i == 0 && interrupt_i == 0 && mret_i==0) begin
      if (addr_i == 12'h300) begin
        mstatus_r <= {19'b0,
                      (mstatus_r[12:11] | wdata_i[12:11]),
                      3'b0,
                      (mstatus_r[7] | wdata_i[7]),
                      3'b0,
                      (mstatus_r[3] | wdata_i[3]),
                      3'b0};
      end else if (addr_i == 12'h304) begin
        mie_r <= {20'b0, (mie_r[11] | wdata_i[11]), 11'b0};
      end else if (addr_i == 12'h305) begin
        mtvec_r <= (mtvec_r | wdata_i);
      end else if (addr_i == 12'h341) begin
        mepc_r <= (mepc_r | wdata_i);
      end else if (addr_i == 12'h342) begin
        mcause_r <= {(mcause_r[31] | wdata_i[31]), 19'b0, (mcause_r[11] | wdata_i[11]), 11'b0};
      end else if (addr_i == 12'h344) begin
        mip_r <= {20'b0, (mip_r[11] | wdata_i[11]), 11'b0};
      end
    end else if (write_i == 0 && set_i == 0 && clear_i == 1 && interrupt_i == 0 && mret_i==0) begin
      if (addr_i == 12'h300) begin
        mstatus_r <= {19'b0,
                      (mstatus_r[12:11] & (~wdata_i[12:11])),
                      3'b0,
                      (mstatus_r[7] & (~wdata_i[7])),
                      3'b0,
                      (mstatus_r[3] & (~wdata_i[3])),
                      3'b0};
      end else if (addr_i == 12'h304) begin
        mie_r <= {20'b0, (mie_r[11] & (~wdata_i[11])), 11'b0};
      end else if (addr_i == 12'h305) begin
        mtvec_r <= (mtvec_r & (~wdata_i));
      end else if (addr_i == 12'h341) begin
        mepc_r <= (mepc_r & (~wdata_i));
      end else if (addr_i == 12'h342) begin
        mcause_r <= {(mcause_r[31] & (~wdata_i[31])),
                    19'b0,
                    (mcause_r[11] & (~wdata_i[11])),
                    11'b0};
      end else if (addr_i == 12'h344) begin
        mip_r <= {20'b0, (mip_r[11] & (~wdata_i[11])), 11'b0};
      end
    end
  end

  assign rdata_o = rdata_r;
  assign mtvec_o = mtvec_r;
  assign mepc_o = mepc_r;
  assign ipending_o = (|mip_r);

endmodule
