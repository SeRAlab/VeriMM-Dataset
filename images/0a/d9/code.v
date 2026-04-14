module quick_sort(input [7:0] array_in, output [7:0] array_out);  
    reg [7:0] sorted_array;  
    integer i, j;  
    always @(*) begin  
        sorted_array = array_in;  
        // Simple Bubble Sort for demonstration purposes  
        for (i = 0; i < 8; i = i + 1) begin  
            for (j = 0; j < 8 - i - 1; j = j + 1) begin  
                if (sorted_array[j] > sorted_array[j + 1]) begin  
                    // Swap  
                    {sorted_array[j], sorted_array[j + 1]} = {sorted_array[j + 1], sorted_array[j]};  
                end  
            end  
        end  
    end  
    assign array_out = sorted_array;  
endmodule