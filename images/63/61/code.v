module top_module(
  input wire clk,
  input wire resetq,
  input wire [31:0] baud,
  input wire restart,
  output wire ser_clk);parameter CLKFREQ = 1000000;
  /* needs to be (CLKFREQ).bit_length() + 1 */
  parameter RWIDTH = 25;

  wire [RWIDTH-1:0] aclkfreq = CLKFREQ;
  reg [RWIDTH-1:0] d;
  wire [RWIDTH-1:0] dInc = d[RWIDTH-1] ? ({4'd0, baud}) : (({4'd0, baud}) - aclkfreq);
  wire [RWIDTH-1:0] dN = restart ? 0 : (d + dInc);
  wire fastclk = ~d[RWIDTH-1];
  assign ser_clk = fastclk;

  always @(negedge resetq or posedge clk)
  begin
    if (!resetq) begin
      d <= 0;
    end else begin
      d <= dN;
    end
  end
endmodule