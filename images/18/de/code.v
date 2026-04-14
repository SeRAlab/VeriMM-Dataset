module fan_speed_control(  
    input wire clk,  
    input wire [6:0] temperature,  
    output reg [1:0] fan_speed  
);  
    always @(posedge clk) begin  
        if (temperature > 30) begin  
            fan_speed <= 2'b10; // High speed  
        end else if (temperature >= 20 && temperature <= 30) begin  
            fan_speed <= 2'b01; // Medium speed  
        end else begin  
            fan_speed <= 2'b00; // Low speed  
        end  
    end  
endmodule