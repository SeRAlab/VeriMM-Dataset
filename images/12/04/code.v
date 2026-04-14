module png_compression (
    input [7:0] pixel_in,
    output [3:0] pixel_out
);

assign pixel_out = (pixel_in[7:4] + pixel_in[3:0]) >> 1;

endmodule