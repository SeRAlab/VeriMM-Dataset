module otsu_threshold (
    input [7:0] pixel_value,
    input [7:0] threshold,
    output reg binary_output
);
    always @(*) begin
        if (pixel_value >= threshold)
            binary_output = 1'b1;
        else
            binary_output = 1'b0;
    end
endmodule