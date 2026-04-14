module quick_sort(input [15:0] data_in, output reg [15:0] data_out);  
    integer i, j;  
    reg [3:0] arr [3:0];  

    always @(*) begin  
        // Load the input data into an array  
        arr[0] = data_in[3:0];  
        arr[1] = data_in[7:4];  
        arr[2] = data_in[11:8];  
        arr[3] = data_in[15:12];  

        // Simple implementation of Quick Sort  
        for (i = 0; i < 4; i = i + 1) begin  
            for (j = i + 1; j < 4; j = j + 1) begin  
                if (arr[i] > arr[j]) begin  
                    // swap  
                    {arr[i], arr[j]} = {arr[j], arr[i]};  
                end  
            end  
        end  

        // Output the sorted array  
        data_out = {arr[3], arr[2], arr[1], arr[0]};  
    end  
endmodule