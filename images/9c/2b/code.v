module top_module(
  input clk,
  input [7:0] A,
  input [7:0] B,
  output reg [15:0] C
);reg [15:0] C_delayed;

always @(posedge clk) begin
  C_delayed <= C;
  C <= A + B;
end

always @(posedge clk) begin
  C <= C_delayed;
end

endmodule