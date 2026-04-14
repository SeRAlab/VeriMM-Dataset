module bubble_sort (
    input [19:0] data_in, // 5 * 4-bit inputs
    output reg [19:0] data_out // 5 * 4-bit sorted outputs
);
    integer i, j;
    reg [3:0] temp;
    reg [4:0] arr [0:4];

    // Unpack input into array
    always @* begin
        arr[0] = data_in[3:0];
        arr[1] = data_in[7:4];
        arr[2] = data_in[11:8];
        arr[3] = data_in[15:12];
        arr[4] = data_in[19:16];

        // Bubble Sort algorithm
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

        // Pack sorted array into output
        data_out = {arr[4], arr[3], arr[2], arr[1], arr[0]};
    end
endmodule