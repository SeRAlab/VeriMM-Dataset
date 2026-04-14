module png_compress (
    input wire [2:0] pixel_in,
    input wire enable,
    output wire [2:0] pixel_out
);

assign pixel_out = enable ? ~pixel_in : pixel_in;

endmodule