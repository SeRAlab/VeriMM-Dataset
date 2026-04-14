module top_module(
  input [3:0] A,
  input [3:0] B,
  output [7:0] P
);// 4-bit unsigned binary numbers
  // A and B are inputs, P is the output

  // Example: A = 0101, B = 0011, P = 00010011

  // Convert A and B to signed numbers
  reg [4:0] A_signed = {1'b0, A};
  reg [4:0] B_signed = {1'b0, B};

  // Booth algorithm
  reg [7:0] partial_product = 8'b0;
  always @(*) begin
    case (B_signed[1:0])
      2'b00: partial_product = {4'b0, A_signed};
      2'b01: partial_product = {4'b0, A_signed} - A_signed;
      2'b10: partial_product = {4'b0, A_signed} + A_signed;
      2'b11: partial_product = {4'b0, A_signed};
    endcase
  end

  // 8-bit adder
  reg [7:0] sum = 8'b0;
  always @(*) begin
    sum = partial_product + {4'b0, B_signed};
  end

  // Output
  assign P = sum;

endmodule