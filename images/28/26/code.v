module jpeg_compression (
    input [7:0] pixel_in,
    output reg [3:0] compressed_out
);

always @(*) begin
    if (pixel_in < 64)
        compressed_out = 0;
    else if (pixel_in < 128)
        compressed_out = 1;
    else if (pixel_in < 192)
        compressed_out = 2;
    else
        compressed_out = 3;
end

endmodule