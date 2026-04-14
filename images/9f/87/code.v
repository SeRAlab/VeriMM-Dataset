module adder (
    input wire [3:0] a,
    input wire [3:0] b,
    output wire [3:0] sum,
    output wire cout
);

    assign {cout, sum} = a + b;

endmodule