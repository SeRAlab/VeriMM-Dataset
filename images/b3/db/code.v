module top_module(
    input wire [15:0] data,
    output wire [15:0] and_result
);

    assign and_result = data & 16'hFF00;

endmodule