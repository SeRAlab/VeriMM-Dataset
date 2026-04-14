module otsu_threshold(
    input [7:0] pixel_value,
    output reg binary_output
);
    reg [7:0] threshold = 128; // Assuming a fixed threshold for simplicity

    always @(*) begin
        if (pixel_value > threshold)
            binary_output = 1;
        else
            binary_output = 0;
    end
endmodule