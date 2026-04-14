module median_filter(  
    input [71:0] matrix, // 3x3 matrix flattened (9x8 bits)  
    output reg [7:0] median  
);  
    integer i, j;  
    reg [7:0] sorted [0:8];  
  
    always @(*) begin  
        // Unpacking the flattened input into an array  
        for (i = 0; i < 9; i = i + 1)  
            sorted[i] = matrix[i*8 +: 8];  
  
        // Sorting the array using a simple bubble sort  
        for (i = 0; i < 9; i = i + 1)  
            for (j = 0; j < 8 - i; j = j + 1)  
                if (sorted[j] > sorted[j + 1]) begin  
                    // Swap  
                    sorted[j] = sorted[j] ^ sorted[j + 1];  
                    sorted[j + 1] = sorted[j] ^ sorted[j + 1];  
                    sorted[j] = sorted[j] ^ sorted[j + 1];  
                end  
  
        // The median is the 5th element in the sorted array  
        median = sorted[4];  
    end  
endmodule