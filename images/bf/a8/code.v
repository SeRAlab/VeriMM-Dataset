module top_module(i_0r0, i_0r1, i_0a, o_0r, o_0a, o_1r, o_1a, reset);input i_0r0;
  input i_0r1;
  output reg i_0a;  // Changed to reg
  output reg o_0r;  // Changed to reg
  input o_0a;
  output reg o_1r;  // Changed to reg
  input o_1a;
  input reset;

  reg icomplete_0;
  reg sel_0;
  reg sel_1;
  reg gsel_0;
  reg gsel_1;
  reg oack_0;
  reg match0_0;
  reg match1_0;
  reg comp_0;

  always @(i_0r0, i_0r1, reset) begin
    if (reset) begin
      icomplete_0 <= 0;
      sel_0 <= 0;
      sel_1 <= 0;
      gsel_0 <= 0;
      gsel_1 <= 0;
      oack_0 <= 0;
      match0_0 <= 0;
      match1_0 <= 0;
      comp_0 <= 0;
    end else begin
      match0_0 <= i_0r0;
      match1_0 <= i_0r1;
      comp_0 <= i_0r0 & i_0r1;
      icomplete_0 <= comp_0;
      sel_0 <= match0_0;
      sel_1 <= match1_0;
    end
  end

  always @(sel_0, sel_1, icomplete_0) begin
    gsel_0 <= sel_0 & icomplete_0;
    gsel_1 <= sel_1 & icomplete_0;
  end

  always @(o_0a, o_1a) begin
    oack_0 <= o_0a | o_1a;
  end

  always @(oack_0, icomplete_0) begin
    i_0a <= oack_0 & icomplete_0;  // i_0a is an output reg
  end

  always @(gsel_0) begin
    o_0r <= gsel_0;  // o_0r is an output reg
  end

  always @(gsel_1) begin
    o_1r <= gsel_1;  // o_1r is an output reg
  end

endmodule