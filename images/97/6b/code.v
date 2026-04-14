module full_adder(
    input    a,
    input    b,
    input    cin,
    output   sum,
    output   cout
);

// Declare wires to connect internal modules
wire sum1, c1, c2;

// Instantiate first half adder
half_adder ha1 (
    .a(a),
    .b(b),
    .sum(sum1),
    .cout(c1)
);

// Instantiate second half adder
half_adder ha2 (
    .a(sum1),
    .b(cin),
    .sum(sum),
    .cout(c2)
);

// OR gate for final carry output
assign cout = c1 | c2;

endmodule

module half_adder(
    input    a,
    input    b,
    output   sum,
    output   cout
);

// Half adder logic
assign sum = a ^ b;
assign cout = a & b;

endmodule