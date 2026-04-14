module adder_4bit_carry (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);

  assign sum = a + b + cin; // 4-bit binary addition
  assign cout = (a[3] & b[3]) | (a[3] & cin) | (b[3] & cin); // carry-out calculation

endmodule