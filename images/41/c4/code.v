module top_module(
  input [3:0] A,
  input [3:0] B,
  input cin,
  output reg [3:0] sum,  // Changed to output reg
  output reg cout        // Changed to output reg
);always @(*) begin
    {cout, sum} = A + B + cin; // Use concatenation to get carry-out properly
  end
  
endmodule