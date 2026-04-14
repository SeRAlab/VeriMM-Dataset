module median_filter(  
    input [8:0] pixels,  
    output reg [8:0] median  
);  
    reg [8:0] sorted_pixels [0:8];  
    integer i, j;  
    
    always @(*) begin  
        // Store the pixels in an array for sorting  
        for (i = 0; i < 9; i = i + 1) begin  
            sorted_pixels[i] = pixels[i];  
        end  

        // Simple bubble sort to sort the pixel values  
        for (i = 0; i < 8; i = i + 1) begin  
            for (j = 0; j < 8 - i; j = j + 1) begin  
                if (sorted_pixels[j] > sorted_pixels[j + 1]) begin  
                    {sorted_pixels[j], sorted_pixels[j + 1]} = {sorted_pixels[j + 1], sorted_pixels[j]};  
                end  
            end  
        end  

        // The median is the middle value in the sorted array  
        median = sorted_pixels[4];  
    end  
endmodule