module otsu_threshold (
    input [7:0] pixel_intensity,
    input [7:0] threshold,
    output reg binary_output
);
    always @* begin
        if (pixel_intensity > threshold)
            binary_output = 1;
        else
            binary_output = 0;
    end
endmodule