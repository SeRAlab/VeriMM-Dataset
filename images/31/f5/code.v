module temperature_sensor(  
    input clk,  
    input rst,  
    input [3:0] temp,  
    output reg warning  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            warning <= 0;  
        else if (temp > 4'd10)  
            warning <= 1;  
        else  
            warning <= 0;  
    end  
endmodule