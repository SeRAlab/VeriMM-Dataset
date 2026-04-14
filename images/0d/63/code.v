module bubble_sort (
    input [15:0] unsorted, // 4 numbers of 4 bits each
    output reg [15:0] sorted // 4 numbers of 4 bits each
);
    integer i, j;
    reg [3:0] temp [0:3];
    
    always @(*) begin
        // Load input into temp array
        for (i = 0; i < 4; i = i + 1) begin
            temp[i] = unsorted[i*4 +: 4];
        end
        
        // Bubble sort implementation
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 3 - i; j = j + 1) begin
                if (temp[j] > temp[j + 1]) begin
                    // Swap
                    temp[j] = temp[j] ^ temp[j + 1];
                    temp[j + 1] = temp[j] ^ temp[j + 1];
                    temp[j] = temp[j] ^ temp[j + 1];
                end
            end
        end
        
        // Load sorted result into output
        sorted = {temp[3], temp[2], temp[1], temp[0]};
    end
endmodule