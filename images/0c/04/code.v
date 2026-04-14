module bubble_sort (
    input [19:0] data_in,
    output reg [19:0] data_out
);
    integer i, j;
    reg [3:0] arr [4:0];

    always @(*) begin
        // Load input into array
        for (i = 0; i < 5; i = i + 1) begin
            arr[i] = data_in[(i + 1) * 4 - 1 -: 4];
        end

        // Bubble sort algorithm
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4 - i; j = j + 1) begin
                if (arr[j] > arr[j + 1]) begin
                    // Swap arr[j] and arr[j + 1]
                    {arr[j], arr[j + 1]} = {arr[j + 1], arr[j]};
                end
            end
        end

        // Load sorted array into output
        data_out = {arr[4], arr[3], arr[2], arr[1], arr[0]};
    end
endmodule