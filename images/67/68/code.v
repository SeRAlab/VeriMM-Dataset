module top_module (
    input [15:0] x,
    input [15:0] y,
    output [15:0] diff,
    output borrow_out
);

    // Perform subtraction
    assign {borrow_out, diff} = x - y;

endmodule