module fan_speed_control(
    input wire clk,
    input wire reset,
    input wire [7:0] temperature,
    output reg [1:0] fan_speed // 00: Low, 01: Medium, 10: High
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            fan_speed <= 2'b00; // Default to Low speed
        end else begin
            if (temperature < 20) begin
                fan_speed <= 2'b00; // Low speed
            end else if (temperature < 30) begin
                fan_speed <= 2'b01; // Medium speed
            end else begin
                fan_speed <= 2'b10; // High speed
            end
        end
    end
endmodule