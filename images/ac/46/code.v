module half_adder_1bit(
    input wire a,
    input wire b,
    output wire sum,
    output wire cout
    );

assign sum = a ^ b;
assign cout = a & b;

endmodule

module or_gate(
    input wire a,
    input wire b,
    output wire y
    );

assign y = a | b;

endmodule

module full_adder_1bit(
    input wire a,
    input wire b,
    input wire cin,
    output wire sum,
    output wire cout
    );

wire sum1, c1, c2;

half_adder_1bit ha1 (
    .a(a),
    .b(b),
    .sum(sum1),
    .cout(c1)
);

half_adder_1bit ha2 (
    .a(sum1),
    .b(cin),
    .sum(sum),
    .cout(c2)
);

or_gate or1 (
    .a(c1),
    .b(c2),
    .y(cout)
);

endmodule