module top_module(CLK, EN, TE, DATA, Q);input CLK, EN, TE;
  input [31:0] DATA;
  output reg [31:0] Q;

  wire gated_clk;

  assign gated_clk = (EN && !TE) ? CLK : 1'b0;

  always @(posedge gated_clk) begin
    if (EN && !TE) begin
      Q <= DATA;
    end
  end

endmodule