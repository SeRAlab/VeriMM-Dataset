module morphological_dilation (  
    input [8:0] image, // 3x3 binary image represented as a 9-bit input  
    output reg dilated // Output indicating dilation result  
);  
    always @* begin  
        // Check if any bit in the 3x3 matrix is 1  
        if (image[0] || image[1] || image[2] ||  
            image[3] || image[4] || image[5] ||  
            image[6] || image[7] || image[8])  
            dilated = 1'b1;  
        else  
            dilated = 1'b0;  
    end  
endmodule