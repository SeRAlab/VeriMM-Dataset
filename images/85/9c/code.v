module top_module(
  input clk,
  input [37:0] jdo,
  input jrst_n,
  input reset_n,
  input take_action_tracectrl,
  input take_action_tracemem_a,
  input take_action_tracemem_b,
  input take_no_action_tracemem_a,
  input [15:0] trc_ctrl,
  input [35:0] tw,
  output reg tracemem_on,
  output reg [35:0] tracemem_trcdata,
  output reg tracemem_tw,
  output reg trc_enb,
  output reg [6:0] trc_im_addr,
  output reg trc_wrap,
  output reg xbrk_wrap_traceoff
);wire trc_on_chip = ~trc_ctrl[8];
  wire tw_valid = |tw[35:32];

  always @(posedge clk or negedge jrst_n) begin
    if (!jrst_n) begin
      trc_im_addr <= 0;
      trc_wrap <= 0;
    end else if (!take_action_tracectrl && !take_action_tracemem_a && !take_action_tracemem_b && !take_no_action_tracemem_a) begin
      trc_im_addr <= 0;
      trc_wrap <= 0;
    end else if (take_action_tracectrl && (jdo[4] | jdo[3])) begin
      if (jdo[4]) trc_im_addr <= 0;
      if (jdo[3]) trc_wrap <= 0;
    end else if (trc_enb & trc_on_chip & tw_valid) begin
      trc_im_addr <= trc_im_addr + 1;
      if (&trc_im_addr) trc_wrap <= 1;
    end
  end

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) trc_enb <= 0;
    else trc_enb <= trc_ctrl[0];
  end

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) tracemem_on <= 0;
    else tracemem_on <= trc_enb;
  end

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) tracemem_trcdata <= 0;
    else tracemem_trcdata <= (trc_enb & tw_valid) ? tw : tracemem_trcdata;
  end

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) tracemem_tw <= 0;
    else tracemem_tw <= trc_wrap;
  end

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) xbrk_wrap_traceoff <= 0;
    else xbrk_wrap_traceoff <= trc_ctrl[10] & trc_wrap;
  end

endmodule