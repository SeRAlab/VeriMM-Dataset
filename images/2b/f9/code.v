module morphological_dilation(  
    input [8:0] binary_image, // 3x3 image flattened  
    output reg output_pixel  
);  
    always @(*) begin  
        output_pixel = |binary_image; // Logical OR of all pixels  
    end  
endmodule