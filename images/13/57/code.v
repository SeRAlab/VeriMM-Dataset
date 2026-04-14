module bubble_sort(
    input [39:0] data_in,
    output reg [39:0] data_out
);
    reg [7:0] arr [0:4];
    integer i, j;
    
    always @* begin
        // Unpack input data into array
        arr[0] = data_in[7:0];
        arr[1] = data_in[15:8];
        arr[2] = data_in[23:16];
        arr[3] = data_in[31:24];
        arr[4] = data_in[39:32];

        // Bubble sort algorithm
        for (i = 0; i < 5; i = i + 1) begin
            for (j = 0; j < 4 - i; j = j + 1) begin
                if (arr[j] > arr[j + 1]) begin
                    // Swap
                    {arr[j], arr[j + 1]} = {arr[j + 1], arr[j]};
                end
            end
        end

        // Pack sorted array back into output
        data_out = {arr[4], arr[3], arr[2], arr[1], arr[0]};
    end
endmodule