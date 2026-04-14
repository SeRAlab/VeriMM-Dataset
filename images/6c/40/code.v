module top_module (
    input [3:0] a,
    input [3:0] b,
    output [3:0] y
);

    // Perform bitwise XOR
    assign y = a ^ b;

endmodule