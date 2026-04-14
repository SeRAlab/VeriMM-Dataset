module png_compression (
    input [4:0] pixel_in,
    output [4:0] pixel_out
);
    assign pixel_out = (pixel_in + 5'd3) % 32;
endmodule