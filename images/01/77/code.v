module fan_speed_control(  
    input wire clk,  
    input wire [1:0] temperature,  
    output reg [1:0] fan_speed  
);  
    always @(posedge clk) begin  
        case (temperature)  
            2'b00: fan_speed <= 2'b00; // Off  
            2'b01: fan_speed <= 2'b01; // Low  
            2'b10: fan_speed <= 2'b10; // Medium  
            2'b11: fan_speed <= 2'b11; // High  
            default: fan_speed <= 2'b00; // Default to Off  
        endcase  
    end  
endmodule