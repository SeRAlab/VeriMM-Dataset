module top_module(
  input clk,
  input [3:0] A,
  input [3:0] B,
  input Cin,
  output reg [3:0] S,  // Change 'output' to 'output reg'
  output reg Cout      // Change 'output' to 'output reg'
);always @(posedge clk) begin
  {Cout, S} <= A + B + Cin;
end

endmodule