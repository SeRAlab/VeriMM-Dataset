module top_module (
    input wire g,
    input wire h,
    input wire i,
    output wire j
);

    assign j = g | h | i;

endmodule