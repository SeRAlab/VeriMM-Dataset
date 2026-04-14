module thresholding (  
    input [7:0] pixel_value,  
    input [2:0] threshold,  
    output reg result  
);  
    always @(*) begin  
        if (pixel_value >= threshold)  
            result = 1;  
        else  
            result = 0;  
    end  
endmodule