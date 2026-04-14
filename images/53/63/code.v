module full_adder_4bit(
    input wire [3:0] a,
    input wire [3:0] b,
    input wire cin,
    output wire [3:0] sum,
    output wire cout
);

    wire carry0, carry1, carry2;

    full_adder fa0(
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .cout(carry0)
    );

    full_adder fa1(
        .a(a[1]),
        .b(b[1]),
        .cin(carry0),
        .sum(sum[1]),
        .cout(carry1)
    );

    full_adder fa2(
        .a(a[2]),
        .b(b[2]),
        .cin(carry1),
        .sum(sum[2]),
        .cout(carry2)
    );

    full_adder fa3(
        .a(a[3]),
        .b(b[3]),
        .cin(carry2),
        .sum(sum[3]),
        .cout(cout)
    );

endmodule

module full_adder(
    input wire a,
    input wire b,
    input wire cin,
    output wire sum,
    output wire cout
);

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);

endmodule