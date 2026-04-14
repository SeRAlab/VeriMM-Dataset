module temperature_sensor(  
    input [4:0] temp_in,  
    output reg [2:0] status_out  
);  
    always @(*) begin  
        if (temp_in < 5'd10)  
            status_out = 3'b000; // Low  
        else if (temp_in >= 5'd10 && temp_in <= 5'd25)  
            status_out = 3'b001; // Normal  
        else  
            status_out = 3'b010; // High  
    end  
endmodule