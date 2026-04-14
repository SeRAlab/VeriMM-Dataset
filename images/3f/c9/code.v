module erosion_3x3(  
    input [8:0] img, // 3x3 input binary image  
    output reg eroded // output after erosion operation  
);  
    always @(*) begin  
        if (img == 9'b111111111)  
            eroded = 1'b1;  
        else  
            eroded = 1'b0;  
    end  
endmodule