module median_filter(input [8:0] pixels, output reg [7:0] median);  
    integer i, j;  
    reg [7:0] sorted[0:8];  
    reg [7:0] temp;  

    always @(*) begin  
        // Copy input pixels to sorted array  
        for (i = 0; i < 9; i = i + 1)  
            sorted[i] = pixels[i];  

        // Simple bubble sort to sort the pixel values  
        for (i = 0; i < 8; i = i + 1) begin  
            for (j = 0; j < 8 - i; j = j + 1) begin  
                if (sorted[j] > sorted[j + 1]) begin  
                    temp = sorted[j];  
                    sorted[j] = sorted[j + 1];  
                    sorted[j + 1] = temp;  
                end  
            end  
        end  

        // The median is the middle value in the sorted array  
        median = sorted[4];  
    end  
endmodule