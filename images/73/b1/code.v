module top_module(
  input [3:0] binary_in,
  input clk,              // Add the clk input
  output [3:0] gray_out
);// Create temporary wires to hold intermediate values
  wire xor1, xor2, xor3;

  // Create D flip-flops to hold previous output bits
  reg [3:0] gray_reg;
  always @(posedge clk) begin
    gray_reg <= {xor3, xor2, xor1, binary_in[0]};
  end

  // Calculate each bit of the output using XOR gates
  assign xor1 = binary_in[0] ^ binary_in[1];
  assign xor2 = binary_in[1] ^ binary_in[2];
  assign xor3 = binary_in[2] ^ binary_in[3];

  // Assign output
  assign gray_out = gray_reg;

endmodule