module bubble_sort (
    input [15:0] arr_in, // 4 unsigned 4-bit numbers
    output reg [15:0] arr_out // sorted 4 unsigned 4-bit numbers
);
    integer i, j;
    reg [3:0] temp;
    reg [3:0] arr [0:3];

    always @* begin
        // Load input into array
        arr[0] = arr_in[15:12];
        arr[1] = arr_in[11:8];
        arr[2] = arr_in[7:4];
        arr[3] = arr_in[3:0];

        // Bubble Sort Algorithm
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 3 - i; j = j + 1) begin
                if (arr[j] > arr[j + 1]) begin
                    // Swap
                    temp = arr[j];
                    arr[j] = arr[j + 1];
                    arr[j + 1] = temp;
                end
            end
        end
        
        // Load sorted array into output
        arr_out = {arr[0], arr[1], arr[2], arr[3]};
    end
endmodule