module adder_64bit (
    input wire [63:0] a,
    input wire [63:0] b,
    output wire [63:0] sum
);

    wire [15:0] sum0, sum1, sum2, sum3;
    wire carry_out1, carry_out2, carry_out3;

    adder16 adder16_inst0 (
        .a(a[15:0]),
        .b(b[15:0]),
        .cin(1'b0),
        .sum(sum0),
        .cout(carry_out1)
    );

    adder16 adder16_inst1 (
        .a(a[31:16]),
        .b(b[31:16]),
        .cin(carry_out1),
        .sum(sum1),
        .cout(carry_out2)
    );

    adder16 adder16_inst2 (
        .a(a[47:32]),
        .b(b[47:32]),
        .cin(carry_out2),
        .sum(sum2),
        .cout(carry_out3)
    );

    adder16 adder16_inst3 (
        .a(a[63:48]),
        .b(b[63:48]),
        .cin(carry_out3),
        .sum(sum3),
        .cout()
    );

    assign sum = {sum3, sum2, sum1, sum0};

endmodule

module adder16 (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire cin,
    output wire [15:0] sum,
    output wire cout
);
    assign {cout, sum} = a + b + cin;
endmodule