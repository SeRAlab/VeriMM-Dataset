module top_module(
  input [2:0] a,
  output reg [2:0] twos_comp,
  output reg [2:0] and_output
);// 2's complement module
  wire [2:0] inverted_a;
  assign inverted_a = ~a;
  assign twos_comp = inverted_a + 3'b1;

  // Bitwise-AND module
  wire [2:0] constant_value = 3'b101;
  assign and_output = a & constant_value;

endmodule