module top_module(
  input [3:0] A,
  input [3:0] B,
  input Cin,
  output reg [3:0] C,
  output reg Cout
);reg [3:0] sum;
  
  always @(*) begin
    sum = A + B + Cin;
    C = sum[3:0];
    Cout = sum[4];
  end
  
endmodule