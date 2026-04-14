module FanSpeedController(
    input clk,
    input rst,
    input [7:0] temperature, // 0 to 255 degrees Celsius
    output reg [1:0] fan_speed // 00: OFF, 01: LOW, 10: MEDIUM, 11: HIGH
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            fan_speed <= 2'b00; // OFF
        end else begin
            case (temperature)
                8'b00000000: fan_speed <= 2'b00; // 0 degrees
                8'b00010100: fan_speed <= 2'b01; // 20 degrees
                8'b00111010: fan_speed <= 2'b10; // 30 degrees
                8'b00111011: fan_speed <= 2'b11; // 40 degrees
                8'b11111111: fan_speed <= 2'b11; // 255 degrees
                default: begin
                    if (temperature < 20) begin
                        fan_speed <= 2'b00; // OFF
                    end else if (temperature < 30) begin
                        fan_speed <= 2'b01; // LOW
                    end else if (temperature < 40) begin
                        fan_speed <= 2'b10; // MEDIUM
                    end else begin
                        fan_speed <= 2'b11; // HIGH
                    end
                end
            endcase
        end
    end
endmodule