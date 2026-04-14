module fan_speed_controller(
    input clk,
    input rst,
    input [3:0] temperature,
    output reg [1:0] fan_speed
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            fan_speed <= 2'b00; // Default to low speed on reset
        end else begin
            if (temperature < 4'b0101) begin
                fan_speed <= 2'b00; // Low speed
            end else if (temperature < 4'b1011) begin
                fan_speed <= 2'b01; // Medium speed
            end else begin
                fan_speed <= 2'b10; // High speed
            end
        end
    end
endmodule