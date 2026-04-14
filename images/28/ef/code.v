module merge_sort(
    input [19:0] data_in, // 5 numbers of 4 bits each
    output reg [19:0] data_out // sorted output
);
    reg [3:0] arr [0:4]; // Array to hold the 5 numbers
    integer i, j;

    // Convert input into array
    always @(*) begin
        for (i = 0; i < 5; i = i + 1) begin
            arr[i] = data_in[i*4 +: 4]; // Extracting each 4-bit number
        end
        
        // Merge sort implementation
        // First stage: split and merge
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4 - i; j = j + 1) begin
                if (arr[j] > arr[j + 1]) begin
                    // Swap
                    {arr[j], arr[j + 1]} = {arr[j + 1], arr[j]};
                end
            end
        end
        
        // Convert array back to output
        for (i = 0; i < 5; i = i + 1) begin
            data_out[i*4 +: 4] = arr[i]; // Packing back to output
        end
    end
endmodule