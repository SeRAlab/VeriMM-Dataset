module binary_adder_2bit(
    input  [1:0] a,
    input  [1:0] b,

    output [2:0] sum
);

assign sum = a + b;

endmodule