module morphological_dilation(  
    input [8:0] img,  // 3x3 input image (9 bits)  
    input [8:0] se,   // 3x3 structuring element (9 bits)  
    output reg [8:0] out // 3x3 output image (9 bits)  
);  
    integer i, j;  
    always @(*) begin  
        out = 0;  
        for (i = 0; i < 3; i = i + 1) begin  
            for (j = 0; j < 3; j = j + 1) begin  
                if (se[i*3 + j] == 1'b1) begin  
                    out = out | (img >> (i*3 + j));  
                end  
            end  
        end  
    end  
endmodule