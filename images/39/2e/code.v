module fan_speed_controller (
    input clk,
    input reset,
    input [2:0] speed_input,
    output reg fan_speed // 0 for low speed, 1 for high speed
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        fan_speed <= 0; // Default to low speed
    end else begin
        if (speed_input >= 3) begin
            fan_speed <= 1; // Set to high speed
        end else begin
            fan_speed <= 0; // Set to low speed
        end
    end
end

endmodule