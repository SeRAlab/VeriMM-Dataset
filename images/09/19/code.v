module erosion_3x3(  
    input [8:0] img, // 3x3 binary image  
    output reg result // erosion result  
);  
    always @(*) begin  
        if (img == 9'b111111111)  
            result = 1'b1;  
        else  
            result = 1'b0;  
    end  
endmodule