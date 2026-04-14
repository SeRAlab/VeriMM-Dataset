module fan_speed_control (  
    input clk,  
    input [6:0] temperature,  
    output reg [1:0] fan_speed  
);  

    always @(posedge clk) begin  
        if (temperature <= 25)  
            fan_speed <= 2'b00; // Low speed  
        else if (temperature <= 50)  
            fan_speed <= 2'b01; // Medium speed  
        else if (temperature <= 75)  
            fan_speed <= 2'b10; // High speed  
        else  
            fan_speed <= 2'b11; // Invalid speed (can be used for error handling)  
    end  
endmodule