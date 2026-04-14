module bitwise_and (
  input [3:0] a,
  input [3:0] b,
  output reg [3:0] out
);

  // Combinational logic for bitwise AND operation
  always @* begin
    out = a & b;
  end
  
endmodule
