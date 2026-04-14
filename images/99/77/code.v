module top_module(
  input [3:0] a,
  input [3:0] b,
  input cin,
  output reg [3:0] sum, // Changed to output reg
  output reg cout       // Changed to output reg
);always @(*) begin
    {cout, sum} = a + b + cin; // Use concatenation to determine cout
  end
  
endmodule