module fan_speed_controller(
    input wire clk,
    input wire rst,
    input wire [6:0] temperature,
    output reg [1:0] fan_speed
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            fan_speed <= 2'b00; // Default to fan off
        end else begin
            if (temperature <= 7'd20) begin
                fan_speed <= 2'b00; // Fan off
            end else if (temperature <= 7'd30) begin
                fan_speed <= 2'b01; // Low speed
            end else if (temperature <= 7'd40) begin
                fan_speed <= 2'b10; // Medium speed
            end else begin
                fan_speed <= 2'b11; // High speed
            end
        end
    end
endmodule