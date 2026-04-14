module top_module(
  input clk, // Add clock input
  input [n-1:0] in,
  output [m-1:0] out
);parameter n = 4; // number of input signals
parameter m = 2; // number of output signals
parameter s = 3; // number of pipeline stages

reg [n-1:0] stage1_out;
reg [n-1:0] stage2_out;
reg [n-1:0] stage3_out;

always @(posedge clk) begin
  stage1_out <= in;
end

always @(posedge clk) begin
  stage2_out <= stage1_out + 1;
end

always @(posedge clk) begin
  stage3_out <= stage2_out * 2;
end

assign out = stage3_out;

endmodule