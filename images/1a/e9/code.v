module thresholding_otsu(  
    input [7:0] pixel,  
    output reg binary_output  
);  
    // Threshold value, for this example we set it to a constant  
    // In practice, the threshold would be calculated using Otsu's method  
    parameter THRESHOLD = 128;  

    always @(*) begin  
        if (pixel >= THRESHOLD)  
            binary_output = 1;  
        else  
            binary_output = 0;  
    end  
endmodule