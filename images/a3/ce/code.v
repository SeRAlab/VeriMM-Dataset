module top_module(
  input clk,  // Added clock input
  input [n*w-1:0] in,
  output [m*w-1:0] out
);parameter n = 4; // number of input signals
parameter m = 2; // number of output signals
parameter w = 32; // number of bits in each input signal

reg [n*w-1:0] pipeline_reg; // pipeline register to store input signals

always @(posedge clk) begin
  pipeline_reg <= in; // store input signals in pipeline register
end

assign out = pipeline_reg; // output signals from pipeline register

endmodule