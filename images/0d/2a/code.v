module temperature_sensor_controller(  
    input clk,  
    input reset,  
    input [3:0] temperature,  
    output reg above_threshold  
);  

    parameter THRESHOLD = 4'd25;  
    reg [3:0] last_temperature;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            last_temperature <= 4'd0;  
            above_threshold <= 1'b0;  
        end else begin  
            last_temperature <= temperature;  
            if (temperature > THRESHOLD)  
                above_threshold <= 1'b1;  
            else  
                above_threshold <= 1'b0;  
        end  
    end  
endmodule