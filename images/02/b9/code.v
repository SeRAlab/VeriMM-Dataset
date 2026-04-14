module median_filter(  
    input [71:0] matrix,  
    output reg [7:0] median  
);  
    reg [7:0] values [0:8];  
    integer i, j;  
    
    always @(*) begin  
        // Convert input to an array  
        for (i = 0; i < 9; i = i + 1) begin  
            values[i] = matrix[8*i +: 8];  
        end  
        
        // Simple bubble sort to find the median  
        for (i = 0; i < 8; i = i + 1) begin  
            for (j = i + 1; j < 9; j = j + 1) begin  
                if (values[i] > values[j]) begin  
                    // Swap  
                    {values[i], values[j]} = {values[j], values[i]};  
                end  
            end  
        end  
        
        // The median is the 5th element in the sorted array  
        median = values[4];  
    end  
endmodule