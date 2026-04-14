module temperature_sensor_controller (  
    input clk,  
    input reset,  
    input [7:0] temperature,  
    input [7:0] threshold,  
    output reg alert  
);  
    reg [7:0] last_temperature;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            last_temperature <= 8'b0;  
            alert <= 1'b0;  
        end else begin  
            last_temperature <= temperature;  
            if (temperature > threshold)  
                alert <= 1'b1;  
            else  
                alert <= 1'b0;  
        end  
    end  
endmodule