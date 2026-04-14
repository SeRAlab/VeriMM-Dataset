module fixed_point_adder(
    input [4:0] a,
    input [4:0] b,
    output [5:0] sum
);
    assign sum = a + b;
endmodule