module fixed_point_adder (
    input [15:0] a, // 16-bit fixed point input a
    input [15:0] b, // 16-bit fixed point input b
    output [15:0] sum // 16-bit fixed point output sum
);
    assign sum = a + b; // Perform fixed-point addition
endmodule