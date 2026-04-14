module TemperatureSensor(  
    input clk,  
    input reset,  
    input [7:0] temperature,  
    input [7:0] threshold,  
    output reg alert  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            alert <= 0;  
        end else begin  
            if (temperature > threshold) begin  
                alert <= 1;  
            end else begin  
                alert <= 0;  
            end  
        end  
    end  
endmodule