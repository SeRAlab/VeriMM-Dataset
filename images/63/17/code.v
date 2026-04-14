module top_module (
    input [7:0] m,
    input [7:0] n,
    output [7:0] s
);

    // Perform bitwise NOR
    assign s = ~(m | n);

endmodule