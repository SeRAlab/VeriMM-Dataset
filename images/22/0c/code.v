module thresholding(input [2:0] value,  
                    output reg result);  

parameter THRESHOLD = 3;  

always @(*) begin  
    if (value >= THRESHOLD)  
        result = 1;  
    else  
        result = 0;  
end  
endmodule