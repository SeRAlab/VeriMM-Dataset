module thresholding (
    input [7:0] pixel_value,
    output reg binary_output
);
    // Define the threshold value
    parameter THRESHOLD = 128;

    always @(*) begin
        if (pixel_value >= THRESHOLD) 
            binary_output = 1'b1; // Above threshold
        else 
            binary_output = 1'b0; // Below threshold
    end
endmodule