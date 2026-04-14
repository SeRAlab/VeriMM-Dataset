module median_filter (
    input [7:0] sample0,
    input [7:0] sample1,
    input [7:0] sample2,
    input [7:0] sample3,
    input [7:0] sample4,
    output reg [7:0] median
);
    reg [7:0] samples [0:4];
    integer i, j;

    always @(*) begin
        // Store the samples in an array
        samples[0] = sample0;
        samples[1] = sample1;
        samples[2] = sample2;
        samples[3] = sample3;
        samples[4] = sample4;

        // Simple bubble sort to sort the samples
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4 - i; j = j + 1) begin
                if (samples[j] > samples[j + 1]) begin
                    // Swap
                    {samples[j], samples[j + 1]} = {samples[j + 1], samples[j]};
                end
            end
        end

        // Median is the middle element (third one in sorted order)
        median = samples[2];
    end
endmodule