module full_adder(
    input  a,
    input  b,
    input  carry_in,
    output sum,
    output carry_out
);

wire sum1, carry1, carry2;

half_adder ha1 (
    .a(a),
    .b(b),
    .sum(sum1),
    .carry(carry1)
);

half_adder ha2 (
    .a(sum1),
    .b(carry_in),
    .sum(sum),
    .carry(carry2)
);

assign carry_out = carry1 | carry2;

endmodule

module half_adder(
    input  a,
    input  b,
    output sum,
    output carry
);

assign sum = a ^ b;
assign carry = a & b;

endmodule