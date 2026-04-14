module top_module( 
    input [3:0] a,
    input [3:0] b,
    input select,     // Select input to choose between different outputs
    output [3:0] out_xor_bitwise,
    output out_xor_logical,
    output [7:0] out_not
);// Generate the inverse of the input numbers
    wire [3:0] a_inv = ~a;
    wire [3:0] b_inv = ~b;

    // Generate the bitwise-XOR output
    wire [3:0] xor_bitwise = a ^ b;

    // Generate the logical-XOR output
    wire xor_logical = !(a & b) && (a | b);

    // Generate the output based on the select input
    assign out_xor_bitwise = select ? xor_bitwise : 4'b0;
    assign out_xor_logical = select ? xor_logical : 1'b0;
    assign out_not = select ? {b_inv, a_inv} : 8'b0;

endmodule