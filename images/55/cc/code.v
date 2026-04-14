module top_module(
  input rstn,
  input clk_in,
  input tx_ack0,
  input [127:0] tx_desc0,
  input cpl_pending_dmawr,
  input cpl_pending_dmard,
  output reg [6:0] cpl_err,
  output reg [127:0] err_desc,
  output reg cpl_pending
);// CPL section
  reg [23:0] cpl_cnt_50ms;
  wire tx_mrd;
  wire [6:0] tx_desc_fmt_type;
  reg cpl_err0_r;

  assign tx_desc_fmt_type = tx_desc0[126:120];
  assign tx_mrd = ((tx_ack0 == 1'b1) && (tx_desc_fmt_type[4:0] == 5'b00000) && (tx_desc_fmt_type[6] == 1'b0)) ? 1'b1 : 1'b0;

  always @ (negedge rstn or posedge clk_in) begin : p_cpl_50ms
    if (rstn == 1'b0) begin
      cpl_cnt_50ms <= 24'h0;
      cpl_pending <= 1'b0;
      cpl_err0_r <= 1'b0;
    end
    else begin
      cpl_pending <= cpl_pending_dmawr | cpl_pending_dmard;
      cpl_err0_r <= (cpl_cnt_50ms == 24'h14) ? 1'b1 : 1'b0;
      if ((cpl_pending == 1'b0) || (tx_mrd == 1'b1)) begin
        cpl_cnt_50ms <= 24'h0;
      end
      else if (cpl_cnt_50ms < 24'h14) begin
        cpl_cnt_50ms <= cpl_cnt_50ms + 24'h1;
      end
    end
  end

  assign cpl_err[0] = cpl_err0_r;
  assign cpl_err[6:1] = 6'h0;
  assign err_desc = 128'h0;

endmodule