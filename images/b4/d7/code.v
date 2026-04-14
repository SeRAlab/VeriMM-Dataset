module mux8x1 (
    input wire [7:0] data_in,
    input wire [2:0] sel,
    output wire data_out
);

    assign data_out = data_in[sel];

endmodule