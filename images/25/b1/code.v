module jpeg_scaler (
    input [3:0] pixel_in,
    output [7:0] pixel_out
);
    assign pixel_out = pixel_in * 17;
endmodule