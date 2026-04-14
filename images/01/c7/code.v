module fixed_point_adder (
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum
);
    assign sum = a + b; // Perform fixed-point addition
endmodule