module thresholding (
    input [7:0] pixel_in,
    output reg [7:0] pixel_out
);
    always @(*) begin
        if (pixel_in > 8'd128)
            pixel_out = 8'd255; // White
        else
            pixel_out = 8'd0;   // Black
    end
endmodule