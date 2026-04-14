module merge_sort (
    input clk,
    input [31:0] unsorted, // 4 unsigned 8-bit integers
    output reg [31:0] sorted // 4 unsigned 8-bit integers
);
    reg [7:0] array [0:3];
    integer i, j;
    
    always @(posedge clk) begin
        // Load inputs into array
        for (i = 0; i < 4; i = i + 1) begin
            array[i] = unsorted[8*i +: 8];
        end
        
        // Merge sort implementation
        // Simple implementation for 4 elements
        for (i = 0; i < 4; i = i + 1) begin
            for (j = i + 1; j < 4; j = j + 1) begin
                if (array[i] > array[j]) begin
                    // Swap
                    {array[i], array[j]} = {array[j], array[i]};
                end
            end
        end
        
        // Load sorted results to output
        sorted = {array[3], array[2], array[1], array[0]};
    end
endmodule