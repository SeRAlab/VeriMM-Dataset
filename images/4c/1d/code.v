module top_module(
    input wire [9:0] f,
    output wire [9:0] or_result
);

    assign or_result = f | 10'h2A2;

endmodule