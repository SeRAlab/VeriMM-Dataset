module morphological_dilation(  
    input [8:0] image,  // 3x3 image flattened (9 bits)  
    output reg dilated_output  // single bit output  
);  
    always @(*) begin  
        dilated_output = |image;  // logical OR of all bits in the image  
    end  
endmodule