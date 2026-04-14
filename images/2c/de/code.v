module fan_speed_control(
    input clk,
    input reset,
    input [7:0] temperature, // Assume temperature is in degrees Celsius.
    output reg [1:0] fan_speed // 00: Off, 01: Low, 10: Medium, 11: High
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            fan_speed <= 2'b00; // Fan is off
        end else begin
            if (temperature < 20) begin
                fan_speed <= 2'b00; // Off
            end else if (temperature < 30) begin
                fan_speed <= 2'b01; // Low
            end else if (temperature < 40) begin
                fan_speed <= 2'b10; // Medium
            end else begin
                fan_speed <= 2'b11; // High
            end
        end
    end
endmodule