module median_filter (
    input [2:0] pixel0, pixel1, pixel2,
    input [2:0] pixel3, pixel4, pixel5,
    input [2:0] pixel6, pixel7, pixel8,
    output reg [2:0] median
);

reg [2:0] sorted [0:8];

integer i, j;

always @(*) begin
    // Store the pixels in an array
    sorted[0] = pixel0;
    sorted[1] = pixel1;
    sorted[2] = pixel2;
    sorted[3] = pixel3;
    sorted[4] = pixel4;
    sorted[5] = pixel5;
    sorted[6] = pixel6;
    sorted[7] = pixel7;
    sorted[8] = pixel8;

    // Sort the array using bubble sort
    for (i = 0; i < 9; i = i + 1) begin
        for (j = 0; j < 8 - i; j = j + 1) begin
            if (sorted[j] > sorted[j + 1]) begin
                // Swap
                {sorted[j], sorted[j + 1]} = {sorted[j + 1], sorted[j]};
            end
        end
    end

    // The median is the 5th element in the sorted list
    median = sorted[4];
end

endmodule