module top_module(
  input clk,
  input [n-1:0] in,
  output [n-1:0] out
);parameter n = 4; // number of input and output signals

reg [n-1:0] pipeline_reg; // register to hold input values

always @(posedge clk) begin
  pipeline_reg <= in; // store input values on clock edge
end

assign out = pipeline_reg; // output stored values

endmodule