module top_module (
    input wire i,
    input wire j,
    input wire k,
    output wire o
);

    assign o = (i & j) | (i & k) | (j & k);

endmodule