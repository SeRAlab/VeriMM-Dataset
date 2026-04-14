module top_module(
  input clk,
  input reset,
  input [3:0] A,
  input [3:0] B,
  input Cin,
  output reg [3:0] S,   // Change net to reg
  output reg Cout       // Change net to reg
);always @ (posedge clk or posedge reset) begin
    if (reset) begin
      S <= 4'b0;
      Cout <= 1'b0;
    end else begin
      {Cout, S} <= A + B + Cin;
    end
  end
  
endmodule