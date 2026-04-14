module median_filter (
    input [8:0] pixels, // 3x3 matrix represented as a 9-bit vector
    output reg [4:0] median // 5-bit output for the median value
);
    integer i, j;
    reg [4:0] sorted [0:8]; // Array to hold sorted values

    always @(*) begin
        // Copy input pixels to sorted array
        for (i = 0; i < 9; i = i + 1) begin
            sorted[i] = pixels[i];
        end

        // Simple bubble sort to sort the values
        for (i = 0; i < 9; i = i + 1) begin
            for (j = 0; j < 8 - i; j = j + 1) begin
                if (sorted[j] > sorted[j + 1]) begin
                    // Swap
                    {sorted[j], sorted[j + 1]} = {sorted[j + 1], sorted[j]};
                end
            end
        end

        // The median is the 5th element after sorting
        median = sorted[4];
    end
endmodule