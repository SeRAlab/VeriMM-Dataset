module quick_sort(input [15:0] data_in, output reg [15:0] data_out);  
    reg [7:0] arr [1:0];  
    integer i, j;  
    always @(*) begin  
        arr[0] = data_in[15:8];  
        arr[1] = data_in[7:0];  
        
        // Simple Bubble Sort for 2 elements  
        for (i = 0; i < 1; i = i + 1) begin  
            for (j = 0; j < 1 - i; j = j + 1) begin  
                if (arr[j] > arr[j + 1]) begin  
                    // Swap  
                    {arr[j], arr[j + 1]} = {arr[j + 1], arr[j]};  
                end  
            end  
        end  
        
        data_out = {arr[0], arr[1]};  
    end  
endmodule