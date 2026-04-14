module bubble_sort (
    input [19:0] unsorted, // 5 numbers, 4 bits each
    output reg [19:0] sorted,
    input start,
    output reg done
);

    reg [3:0] arr [0:4];
    integer i, j;
    initial begin
        sorted = 20'b0;
        done = 0;
    end

    always @(posedge start) begin
        // Load the input into the array
        for (i = 0; i < 5; i = i + 1) begin
            arr[i] = unsorted[4*i +: 4];
        end

        // Perform Bubble Sort
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4 - i; j = j + 1) begin
                if (arr[j] > arr[j + 1]) begin
                    // Swap
                    arr[j] = arr[j] ^ arr[j + 1];
                    arr[j + 1] = arr[j] ^ arr[j + 1];
                    arr[j] = arr[j] ^ arr[j + 1];
                end
            end
        end

        // Store sorted output
        for (i = 0; i < 5; i = i + 1) begin
            sorted[4*i +: 4] = arr[i];
        end
        done = 1;
    end
endmodule