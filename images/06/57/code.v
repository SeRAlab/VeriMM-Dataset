module adder_5bit (
    input [4:0] a,
    input [4:0] b,
    output [5:0] sum,
    output overflow
);
    assign sum = a + b;
    assign overflow = (sum > 5'b11111); // Check for overflow
endmodule