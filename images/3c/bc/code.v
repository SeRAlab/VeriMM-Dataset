module fan_speed_controller (
    input wire clk,
    input wire rst,
    input wire [3:0] temperature,
    output reg [1:0] fan_speed
);

    reg [3:0] last_temperature;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            fan_speed <= 2'b00; // Off
            last_temperature <= 4'b0000;
        end else begin
            if (temperature != last_temperature) begin
                last_temperature <= temperature;
                case (temperature)
                    4'b0000, 4'b0001, 4'b0010, 4'b0011: fan_speed <= 2'b00; // Off
                    4'b0100, 4'b0101, 4'b0110, 4'b0111: fan_speed <= 2'b01; // Low
                    4'b1000, 4'b1001, 4'b1010, 4'b1011: fan_speed <= 2'b10; // Medium
                    4'b1100, 4'b1101, 4'b1110, 4'b1111: fan_speed <= 2'b11; // High
                    default: fan_speed <= fan_speed; // Retain last speed
                endcase
            end
        end
    end
endmodule