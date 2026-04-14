module heap_sort(
    input [3:0] arr,
    output reg [3:0] sorted_arr
);
    integer i, j;
    reg [3:0] temp;
    
    always @(*) begin
        // Initializing the output
        sorted_arr = arr;

        // Performing heap sort
        for (i = 0; i < 4; i = i + 1) begin
            for (j = i + 1; j < 4; j = j + 1) begin
                if (sorted_arr[i] > sorted_arr[j]) begin
                    temp = sorted_arr[i];
                    sorted_arr[i] = sorted_arr[j];
                    sorted_arr[j] = temp;
                end
            end
        end
    end
endmodule