module top_module(
    input wire [7:0] a,
    output wire [7:0] sum
);

    assign sum = a + 8'd42;

endmodule