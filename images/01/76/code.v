module median_filter (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    input [7:0] e,
    output reg [7:0] median
);

reg [7:0] sorted [0:4];

integer i, j;

always @(*) begin
    // Load inputs into sorted array
    sorted[0] = a;
    sorted[1] = b;
    sorted[2] = c;
    sorted[3] = d;
    sorted[4] = e;

    // Simple bubble sort to sort the array
    for (i = 0; i < 4; i = i + 1) begin
        for (j = 0; j < 4 - i; j = j + 1) begin
            if (sorted[j] > sorted[j + 1]) begin
                // Swap
                {sorted[j], sorted[j + 1]} = {sorted[j + 1], sorted[j]};
            end
        end
    end

    // Select the median (the middle element in the sorted array)
    median = sorted[2];
end

endmodule