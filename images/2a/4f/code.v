module bubble_sort(
    input [19:0] data_in, // 5 x 4-bit unsigned numbers
    output reg [19:0] data_out // Sorted 5 x 4-bit unsigned numbers
);
    integer i, j;
    reg [3:0] temp;
    reg [3:0] arr [0:4];

    always @(*) begin
        // Load input to array
        for (i = 0; i < 5; i = i + 1) begin
            arr[i] = data_in[4*i +: 4];
        end
        
        // Bubble sort algorithm
        for (i = 0; i < 5; i = i + 1) begin
            for (j = 0; j < 4 - i; j = j + 1) begin
                if (arr[j] > arr[j + 1]) begin
                    // Swap
                    temp = arr[j];
                    arr[j] = arr[j + 1];
                    arr[j + 1] = temp;
                end
            end
        end
        
        // Load sorted array to output
        data_out = {arr[4], arr[3], arr[2], arr[1], arr[0]};
    end
endmodule