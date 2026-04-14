module fan_speed_control(
    input wire clk,
    input wire reset,
    input wire [7:0] temperature, // Temperature input in degrees Celsius
    output reg [1:0] fan_speed // 00 - Low, 01 - Medium, 10 - High
);

    // State encoding
    parameter LOW = 2'b00, MEDIUM = 2'b01, HIGH = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            fan_speed <= LOW; // Default state
        end else begin
            if (temperature < 20) begin
                fan_speed <= LOW;
            end else if (temperature >= 20 && temperature <= 30) begin
                fan_speed <= MEDIUM;
            end else begin
                fan_speed <= HIGH;
            end
        end
    end
endmodule