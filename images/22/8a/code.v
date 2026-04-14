module bubble_sort (
    input [15:0] unsorted, // 4 4-bit unsigned integers
    output [15:0] sorted   // Sorted output
);
    reg [15:0] temp;
    integer i, j;

    always @(*) begin
        // Copy input to temp for sorting
        temp = unsorted;

        // Bubble sort algorithm
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 3 - i; j = j + 1) begin
                if (temp[j*4 +: 4] > temp[(j+1)*4 +: 4]) begin
                    // Swap
                    temp[j*4 +: 4] = temp[(j+1)*4 +: 4];
                    temp[(j+1)*4 +: 4] = temp[j*4 +: 4];
                end
            end
        end
    end

    assign sorted = temp;
endmodule