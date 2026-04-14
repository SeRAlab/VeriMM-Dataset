module fixed_point_adder(
    input [7:0] a, // 8-bit input a
    input [7:0] b, // 8-bit input b
    output [8:0] sum // 9-bit output sum
);
    assign sum = a + b; // Perform addition
endmodule