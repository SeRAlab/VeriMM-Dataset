module fixed_point_adder (
    input [7:0] a, // 8-bit fixed-point input a
    input [7:0] b, // 8-bit fixed-point input b
    output [8:0] sum // 9-bit fixed-point output sum
);
    assign sum = a + b; // Perform addition
endmodule