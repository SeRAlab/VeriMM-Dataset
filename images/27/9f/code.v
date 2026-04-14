module quick_sort(
    input [19:0] unsorted, // 5 numbers, each 4 bits (total 20 bits)
    output reg [19:0] sorted // 5 sorted numbers, each 4 bits
);
    integer i, j, temp;

    // Simple bubble sort implementation for demonstration
    always @(*) begin
        sorted = unsorted; // Initialize sorted with unsorted
        for (i = 0; i < 5; i = i + 1) begin
            for (j = 0; j < 4 - i; j = j + 1) begin
                if (sorted[j*4 +: 4] > sorted[(j+1)*4 +: 4]) begin
                    // Swap
                    temp = sorted[j*4 +: 4];
                    sorted[j*4 +: 4] = sorted[(j+1)*4 +: 4];
                    sorted[(j+1)*4 +: 4] = temp;
                end
            end
        end
    end
endmodule