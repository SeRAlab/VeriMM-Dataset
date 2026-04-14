module fixed_point_adder (
    input signed [15:0] a,
    input signed [15:0] b,
    output signed [15:0] sum
);
    assign sum = a + b;
endmodule