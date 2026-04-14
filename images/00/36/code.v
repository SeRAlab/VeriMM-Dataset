module bubble_sort (
    input [15:0] data_in, // 4 elements of 4 bits each
    output reg [15:0] data_out // sorted 4 elements of 4 bits each
);
    integer i, j;
    reg [3:0] temp [0:3]; // temporary storage for sorting

    always @* begin
        // Load input data into temporary array
        for (i = 0; i < 4; i = i + 1) begin
            temp[i] = data_in[i*4 +: 4];
        end
        
        // Bubble sort algorithm
        for (i = 0; i < 3; i = i + 1) begin
            for (j = 0; j < 3 - i; j = j + 1) begin
                if (temp[j] > temp[j + 1]) begin
                    // Swap
                    temp[j] = temp[j] ^ temp[j + 1];
                    temp[j + 1] = temp[j] ^ temp[j + 1];
                    temp[j] = temp[j] ^ temp[j + 1];
                end
            end
        end

        // Load sorted data into output
        data_out = {temp[3], temp[2], temp[1], temp[0]};
    end
endmodule