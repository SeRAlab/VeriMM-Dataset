module full_adder_1bit(
    input wire A,
    input wire B,
    input wire carry_in,
    output wire sum,
    output wire carry_out
    );

wire sum1, carry1, carry2;

// Half adder for A and B
half_adder HA1 (
    .A(A),
    .B(B),
    .sum(sum1),
    .carry(carry1)
);

// Half adder for sum1 and carry_in
half_adder HA2 (
    .A(sum1),
    .B(carry_in),
    .sum(sum),
    .carry(carry2)
);

// OR gate for carry outputs
assign carry_out = carry1 | carry2;

endmodule

module half_adder(
    input wire A,
    input wire B,
    output wire sum,
    output wire carry
    );

assign sum = A ^ B;
assign carry = A & B;

endmodule