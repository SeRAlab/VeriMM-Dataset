module median_filter(
    input [71:0] pixels, // 3x3 matrix flattened (9 pixels, 8 bits each)
    output reg [7:0] median // output median value
);
    integer i, j;
    reg [7:0] sorted_pixels [0:8];

    always @(*) begin
        // Unpack the pixels into an array
        for (i = 0; i < 9; i = i + 1) begin
            sorted_pixels[i] = pixels[i*8 +: 8];
        end

        // Simple bubble sort to sort the pixels
        for (i = 0; i < 9; i = i + 1) begin
            for (j = 0; j < 8 - i; j = j + 1) begin
                if (sorted_pixels[j] > sorted_pixels[j + 1]) begin
                    // Swap
                    {sorted_pixels[j], sorted_pixels[j + 1]} = {sorted_pixels[j + 1], sorted_pixels[j]};
                end
            end
        end

        // The median is the 5th element in the sorted array
        median = sorted_pixels[4];
    end
endmodule