module otsu_threshold(
    input [7:0] pixel_value,
    input [7:0] threshold,
    output reg binary_output
);
    always @(*) begin
        if (pixel_value > threshold) begin
            binary_output = 1;
        end else begin
            binary_output = 0;
        end
    end
endmodule