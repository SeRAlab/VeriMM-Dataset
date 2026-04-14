module top_module(
    input wire [7:0] h,
    output wire [7:0] sum
);

    assign sum = h + 8'd20;

endmodule