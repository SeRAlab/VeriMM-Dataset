module top_module(
  // inputs:
  clk,
  jrst_n,
  trc_ctrl,
  tw,

  // outputs:
  tracemem_on,
  tracemem_trcdata,
  tracemem_tw,
  trc_im_addr,
  trc_wrap,
  xbrk_wrap_traceoff
);output           tracemem_on;
  output  [ 35: 0] tracemem_trcdata;
  output           tracemem_tw;
  output  [  6: 0] trc_im_addr;
  output           trc_wrap;
  output           xbrk_wrap_traceoff;
  input            clk;
  input            jrst_n;
  input   [ 15: 0] trc_ctrl;
  input   [ 35: 0] tw;

  wire             tracemem_on;
  wire    [ 35: 0] tracemem_trcdata;
  wire             tracemem_tw;
  reg     [  6: 0] trc_im_addr /* synthesis ALTERA_ATTRIBUTE = "SUPPRESS_DA_RULE_INTERNAL=\"D101,D103,R101\""  */;
  wire    [ 35: 0] trc_im_data;
  wire             trc_on_chip;
  reg              trc_wrap /* synthesis ALTERA_ATTRIBUTE = "SUPPRESS_DA_RULE_INTERNAL=\"D101,D103,R101\""  */;
  wire             tw_valid;
  wire             xbrk_wrap_traceoff;
  
  assign tracemem_on = ~trc_ctrl[8];
  assign tracemem_trcdata = 0;
  assign tracemem_tw = (tw[35:32] != 4'b0000);
  assign trc_im_data = tw;
  assign tw_valid = |trc_im_data[35 : 32];
  assign xbrk_wrap_traceoff = (trc_ctrl[10] & trc_wrap);

  always @(posedge clk or negedge jrst_n) begin
    if (~jrst_n) begin
      trc_im_addr <= 0;
      trc_wrap <= 0;
    end else begin
      if (trc_wrap) begin
        trc_im_addr <= 0;
        trc_wrap <= 0;
      end else begin
        if (tw_valid) trc_im_addr <= trc_im_addr + 1;
        if (trc_im_addr == 7'h7F) trc_wrap <= 1;
      end
    end
  end

endmodule