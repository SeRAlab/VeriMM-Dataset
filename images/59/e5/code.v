module top_module (
    input [7:0] a,
    output is_negative
);

    // Check if the input is negative
    assign is_negative = a[7];

endmodule