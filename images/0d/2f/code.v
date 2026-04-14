module current_sensor(  
    input [3:0] current,  
    output reg exceed_threshold  
);  
    always @(*) begin  
        if (current > 4'b1010)  
            exceed_threshold = 1'b1;  
        else  
            exceed_threshold = 1'b0;  
    end  
endmodule