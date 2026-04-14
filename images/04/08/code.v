module bubble_sort (
    input [19:0] in_data, // 5 numbers, each 4 bits
    output reg [19:0] out_data // 5 sorted numbers, each 4 bits
);
    integer i, j;
    reg [3:0] arr [0:4];

    always @(*) begin
        // Load inputs into array
        for (i = 0; i < 5; i = i + 1) begin
            arr[i] = in_data[(i + 1) * 4 - 1 -: 4];
        end

        // Bubble sort logic
        for (i = 0; i < 5; i = i + 1) begin
            for (j = 0; j < 4 - i; j = j + 1) begin
                if (arr[j] > arr[j + 1]) begin
                    // Swap
                    {arr[j], arr[j + 1]} = {arr[j + 1], arr[j]};
                end
            end
        end

        // Output sorted array
        for (i = 0; i < 5; i = i + 1) begin
            out_data[(i + 1) * 4 - 1 -: 4] = arr[i];
        end
    end
endmodule