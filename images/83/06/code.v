module top_module(
    input wire [15:0] in,
    output wire [7:0] out_hi,
    output wire [7:0] out_lo
);wire select;
    wire [255:0] decoder_out;

    // Decoder - Creating a simple 16-to-256 decoder
    wire [15:0] dec_enable;
    assign dec_enable = 1 << in[15:12]; // Setting the corresponding enable line based on upper 4 bits of input

    assign decoder_out = {dec_enable[0], dec_enable[1], dec_enable[2], dec_enable[3], dec_enable[4], dec_enable[5], 
                          dec_enable[6], dec_enable[7], dec_enable[8], dec_enable[9], dec_enable[10], dec_enable[11], 
                          dec_enable[12], dec_enable[13], dec_enable[14], dec_enable[15]};

    // Multiplexer
    assign out_hi = decoder_out[{in[15], 1'b0} +: 8];
    assign out_lo = decoder_out[{~in[15], 1'b0} +: 8];

    // Select input for the multiplexer
    assign select = in[15];

endmodule