module fixed_point_adder (
    input [3:0] a, // First 4-bit fixed-point number
    input [3:0] b, // Second 4-bit fixed-point number
    output [3:0] sum // Sum of the two numbers
);
    assign sum = a + b;
endmodule