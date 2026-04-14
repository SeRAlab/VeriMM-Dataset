module fan_speed_controller (
    input clk,
    input reset,
    input [7:0] temperature, // 0 to 255, assuming temperature in degrees Celsius
    output reg [1:0] fan_speed // 0: off, 1: low, 2: medium, 3: high
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            fan_speed <= 0;
        end else begin
            if (temperature < 20) begin
                fan_speed <= 0;
            end else if (temperature <= 25) begin
                fan_speed <= 1;
            end else if (temperature <= 30) begin
                fan_speed <= 2;
            end else begin
                fan_speed <= 3;
            end
        end
    end
endmodule