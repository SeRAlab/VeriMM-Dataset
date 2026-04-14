module top_module(
  input clk, // Added clock input
  input [n-1:0] in,
  input [n-1:0] rin,
  output [n-1:0] out
);parameter n = 4; // number of input signals

reg [n-1:0] delay_line; // delay line for received signal

always @(posedge clk) begin
  delay_line <= rin;
end

assign out = in - delay_line; // subtract delayed signal from original signal

endmodule