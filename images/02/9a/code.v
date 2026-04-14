module temperature_sensor(  
    input clk,  
    input reset,  
    input [7:0] temp_in,  
    output reg warning  
);  
    parameter THRESHOLD = 8'd75;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            warning <= 0;  
        end else begin  
            if (temp_in > THRESHOLD)  
                warning <= 1;  
            else  
                warning <= 0;  
        end  
    end  
endmodule