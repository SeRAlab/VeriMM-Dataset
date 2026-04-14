module temperature_comparator(  
    input [4:0] temp_input,  
    input [4:0] threshold,  
    output reg exceed  
);  
    always @(*) begin  
        if (temp_input > threshold)  
            exceed = 1;  
        else  
            exceed = 0;  
    end  
endmodule