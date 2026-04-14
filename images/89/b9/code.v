module top_module (
    input [7:0] m,
    input [7:0] n,
    output [7:0] o
);

    // Perform bitwise OR
    assign o = m | n;

endmodule