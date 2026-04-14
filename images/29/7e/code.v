module fan_speed_control(clk, reset, temperature, fan_speed);  
    input clk;  
    input reset;  
    input [7:0] temperature;  
    output reg [1:0] fan_speed;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            fan_speed <= 2'b00; // Default to low speed  
        end else begin  
            if (temperature < 20)  
                fan_speed <= 2'b00; // Low speed  
            else if (temperature < 25)  
                fan_speed <= 2'b01; // Medium speed  
            else  
                fan_speed <= 2'b10; // High speed  
        end  
    end  
endmodule