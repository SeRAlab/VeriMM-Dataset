module top_module (
    input wire i,
    input wire j,
    output wire k
);

    assign k = ~(i | j);

endmodule