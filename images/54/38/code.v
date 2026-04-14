module top_module(
  input clk,
  input rst,
  input en,
  input [n-1:0] in,
  output [n-1:0] out
);parameter n = 4; // number of input and output signals

reg [n-1:0] reg_out; // register output

always @(posedge clk) begin
  if (rst) begin
    reg_out <= 0; // reset to all zeros
  end else if (en) begin
    reg_out <= in; // capture input signals
  end
end

assign out = reg_out; // assign register output to output signals

endmodule