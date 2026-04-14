module top_module(
    input wire [13:0] e,
    output wire [13:0] and_result
);

    assign and_result = e & 14'h3FFF;

endmodule