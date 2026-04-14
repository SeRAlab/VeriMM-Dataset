module top_module (
    input [7:0] data,
    output msb);

assign msb = data[7];

endmodule