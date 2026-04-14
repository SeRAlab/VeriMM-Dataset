module power_gating_controller (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire power_gating,
    output reg power_state
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            power_state <= 1'b0; // Power is off on reset
        end else if (enable) begin
            power_state <= power_gating; // Follow the power_gating input
        end
        // If enable is low, power_state holds its value
    end
endmodule