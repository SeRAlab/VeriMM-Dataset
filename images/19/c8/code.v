module thresholding (
    input [7:0] pixel_value,
    output reg binary_output
);
    always @(*) begin
        if(pixel_value >= 8'd128)
            binary_output = 1'b1; // White
        else
            binary_output = 1'b0; // Black
    end
endmodule