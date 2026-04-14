module adder_2bit(
    input [1:0] a,
    input [1:0] b,
    input [1:0] c,
    output [1:0] sum
);

    assign sum = a + b + c;

endmodule