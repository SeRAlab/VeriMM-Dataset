module top_module(
  input clk, // Added the clock input
  input [n-1:0] in,
  output reg [m-1:0] out // Changed output to reg type to allow assignment in always block
);parameter n = 8; // number of input signals
parameter m = 4; // number of output signals
parameter s = 3; // number of stages
parameter w = 16; // width of pipeline register

reg [w-1:0] stage1_out;
reg [w-1:0] stage2_out;
reg [w-1:0] stage3_out;

// Stage 1
always @ (posedge clk) begin
  stage1_out <= in;
end

// Stage 2
always @ (posedge clk) begin
  stage2_out <= stage1_out;
end

// Stage 3
always @ (posedge clk) begin
  stage3_out <= stage2_out;
end

// Pipeline Register
always @ (posedge clk) begin
  out[0] <= stage1_out[w-1:w-m]; // Adjusted to assign a slice or specific width to match m
  out[1] <= stage2_out[w-1:w-m];
  out[2] <= stage3_out[w-1:w-m];
end

endmodule