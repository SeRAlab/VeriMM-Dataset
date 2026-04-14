module adder_5bit (
    input [4:0] a,
    input [4:0] b,
    output [4:0] sum
);
    assign sum = (a + b > 5'd31) ? 5'd31 : (a + b);
endmodule