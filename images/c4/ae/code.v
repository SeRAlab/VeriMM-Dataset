module adder (
    input  [7:0] A,
    input  [7:0] B,
    output [7:0] C,
    output       CARRY
);

  wire [7:0] sum;
  wire       carry;

  assign {carry, sum} = A + B;

  assign CARRY = carry;
  assign C    = sum;

endmodule