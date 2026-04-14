module quicksort(input [15:0] arr, output reg [15:0] sorted_arr);
    reg [3:0] temp [0:3]; // Array to hold the elements
    integer i, j;

    always @(*) begin
        // Unpack the input array into regular array
        temp[0] = arr[15:12];
        temp[1] = arr[11:8];
        temp[2] = arr[7:4];
        temp[3] = arr[3:0];

        // Perform quick sort
        for (i = 0; i < 4; i = i + 1) begin
            for (j = i + 1; j < 4; j = j + 1) begin
                if (temp[i] > temp[j]) begin
                    // Swap
                    temp[i] = temp[i] ^ temp[j];
                    temp[j] = temp[i] ^ temp[j];
                    temp[i] = temp[i] ^ temp[j];
                end
            end
        end

        // Pack sorted array back into output
        sorted_arr = {temp[0], temp[1], temp[2], temp[3]};
    end
endmodule