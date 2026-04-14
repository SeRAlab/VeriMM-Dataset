module fan_speed_control(  
    input wire clk,  
    input wire reset,  
    input wire [7:0] temperature,  
    output reg [1:0] fan_speed  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            fan_speed <= 2'b00; // Fan off  
        end else begin  
            case (temperature)  
                8'b00000000: fan_speed <= 2'b00; // Off  
                8'b00010100: fan_speed <= 2'b01; // Low speed (20°C)  
                8'b00011100: fan_speed <= 2'b10; // Medium speed (30°C)  
                default:  
                    if (temperature > 8'b00101000) // > 40°C  
                        fan_speed <= 2'b11; // High speed  
                    else if (temperature > 8'b00011000) // > 30°C  
                        fan_speed <= 2'b10; // Medium speed  
                    else if (temperature > 8'b00010100) // > 20°C  
                        fan_speed <= 2'b01; // Low speed  
                    else  
                        fan_speed <= 2'b00; // Off  
            endcase  
        end  
    end  
endmodule