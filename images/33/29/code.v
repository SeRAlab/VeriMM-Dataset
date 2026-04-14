module fixed_point_adder (
    input [15:0] a, // 16-bit fixed-point number
    input [15:0] b, // 16-bit fixed-point number
    output [15:0] sum // 16-bit fixed-point sum
);
    assign sum = a + b; // Perform fixed-point addition
endmodule