module merge_sort (
    input  [31:0] data_in, // 8 numbers, 4 bits each
    output reg [31:0] data_out // Sorted output
);

// Define internal wires and registers
reg [3:0] arr [0:7]; // Array to hold the 8 inputs
reg [3:0] sorted [0:7]; // Array to hold the sorted output
integer i, j;

// Unroll the input data into the array
always @* begin
    for (i = 0; i < 8; i = i + 1) begin
        arr[i] = data_in[i*4 +: 4];
    end
end

// Merge sort logic
always @* begin
    // Initialize sorted array
    for (i = 0; i < 8; i = i + 1) begin
        sorted[i] = arr[i];
    end

    // Perform sorting (Bubble Sort implemented for simplicity)
    for (i = 0; i < 7; i = i + 1) begin
        for (j = 0; j < 7 - i; j = j + 1) begin
            if (sorted[j] > sorted[j + 1]) begin
                // Swap
                {sorted[j], sorted[j + 1]} = {sorted[j + 1], sorted[j]};
            end
        end
    end

    // Output the sorted array
    data_out = {sorted[7], sorted[6], sorted[5], sorted[4], sorted[3], sorted[2], sorted[1], sorted[0]};
end

endmodule