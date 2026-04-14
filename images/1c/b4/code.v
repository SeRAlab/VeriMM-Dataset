module jpeg_compression (
    input [7:0] pixel_value,
    output reg [2:0] compressed_value
);
    always @(*) begin
        if (pixel_value < 64)
            compressed_value = 3'b000; // 0
        else if (pixel_value < 128)
            compressed_value = 3'b001; // 1
        else if (pixel_value < 192)
            compressed_value = 3'b010; // 2
        else
            compressed_value = 3'b011; // 3
    end
endmodule