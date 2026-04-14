module temperature_shutdown(  
    input [3:0] temperature,  
    output reg shutdown  
);  
    always @(*) begin  
        if (temperature > 4'd10)  
            shutdown = 1;  
        else  
            shutdown = 0;  
    end  
endmodule