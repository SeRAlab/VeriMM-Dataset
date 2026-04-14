module top_module (
    input [1:0] a,
    input [1:0] b,
    output [1:0] y
);

    // Perform bitwise NOR
    assign y = ~(a | b);

endmodule