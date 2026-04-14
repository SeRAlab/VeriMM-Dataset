module png_compressor (
    input [23:0] rgb_in,
    output reg [7:0] compressed_out
);
    
    always @(*) begin
        // Simple compression by averaging R, G, and B
        compressed_out = (rgb_in[23:16] + rgb_in[15:8] + rgb_in[7:0]) / 3;
    end

endmodule