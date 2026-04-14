module top_module (
    input [7:0] v,
    output [7:0] w
);

    // Perform bitwise NOT
    assign w = ~v;

endmodule