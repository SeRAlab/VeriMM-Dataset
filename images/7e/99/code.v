module top_module(
  input [3:0] A,
  input [3:0] B,
  input Cin,
  output reg [3:0] S,    // Change output S to reg
  output reg Cout        // Change Cout to reg as well
);always @(*) begin
    {Cout, S} = A + B + Cin; // Add A, B, and Cin, storing Cout in the MSB
  end

endmodule