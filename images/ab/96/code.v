module top_module (
    input [7:0] x,
    input [7:0] z,
    output [7:0] w
);

    // Perform bitwise AND
    assign w = x & z;

endmodule