module fan_speed_control (
    input clk,
    input reset,
    input [7:0] temperature, // 0 to 255 representing degrees Celsius
    output reg [1:0] fan_speed // 00: off, 01: low, 10: medium, 11: high
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            fan_speed <= 2'b00; // Off
        end else begin
            if (temperature < 20) begin
                fan_speed <= 2'b01; // Low speed
            end else if (temperature >= 20 && temperature <= 30) begin
                fan_speed <= 2'b10; // Medium speed
            end else begin
                fan_speed <= 2'b11; // High speed
            end
        end
    end
endmodule