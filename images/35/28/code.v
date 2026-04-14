module png_compressor (
    input [3:0] pixel_in,
    output [3:0] pixel_out
);
    assign pixel_out = (pixel_in >= 4'd8) ? (pixel_in - 4'd8) : pixel_in;
endmodule