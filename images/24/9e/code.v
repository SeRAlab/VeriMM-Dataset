module quick_sort(
    input [19:0] arr, // 5 numbers, each 4 bits
    output reg [19:0] sorted_arr
);
    integer i, j;
    reg [3:0] temp;

    always @(*) begin
        sorted_arr = arr; // Initialize sorted array as input
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4 - i; j = j + 1) begin
                if (sorted_arr[j*4 +: 4] > sorted_arr[(j+1)*4 +: 4]) begin
                    // Swap
                    temp = sorted_arr[j*4 +: 4];
                    sorted_arr[j*4 +: 4] = sorted_arr[(j+1)*4 +: 4];
                    sorted_arr[(j+1)*4 +: 4] = temp;
                end
            end
        end
    end
endmodule