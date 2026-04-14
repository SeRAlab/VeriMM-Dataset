module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    output wire [15:0] sum
);

    wire [3:0] sum0, sum1, sum2, sum3;
    wire c1, c2, c3;

    adder4 adder4_inst0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(1'b0),
        .sum(sum0),
        .cout(c1)
    );

    adder4 adder4_inst1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(c1),
        .sum(sum1),
        .cout(c2)
    );

    adder4 adder4_inst2 (
        .a(a[11:8]),
        .b(b[11:8]),
        .cin(c2),
        .sum(sum2),
        .cout(c3)
    );

    adder4 adder4_inst3 (
        .a(a[15:12]),
        .b(b[15:12]),
        .cin(c3),
        .sum(sum3),
        .cout()
    );

    assign sum = {sum3, sum2, sum1, sum0};

endmodule

module adder4 (
    input wire [3:0] a,
    input wire [3:0] b,
    input wire cin,
    output wire [3:0] sum,
    output wire cout
);
    assign {cout, sum} = a + b + cin;
endmodule