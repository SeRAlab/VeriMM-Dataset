module top_module (
    input [7:0] a,
    output [7:0] y
);

    // Perform arithmetic right shift
    assign y = $signed(a) >>> 1;

endmodule