module jpeg_compressor (
    input [7:0] pixel_in,
    output [3:0] compressed_out
);
assign compressed_out = (pixel_in >= 128) ? 4'b0001 : 4'b0000;
endmodule