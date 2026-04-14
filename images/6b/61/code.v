module top_module(
  input [3:0] A,
  input [3:0] B,
  input Cin,
  output reg [3:0] S,  // Change to output reg
  output reg Cout      // Change to output reg
);always @(*)  // Use @(*) for sensitivity list
begin
  {Cout, S} = A + B + Cin;  // Concatenate to get carry out
end

endmodule