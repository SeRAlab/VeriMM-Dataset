module dilation_3x3 (  
    input [7:0] img,  // 3x3 binary image input, packed into 1 byte  
    output reg out     // Output binary value  
);  
    always @(*) begin  
        out = |img;  // Dilation: output is 1 if any bit in img is 1  
    end  
endmodule