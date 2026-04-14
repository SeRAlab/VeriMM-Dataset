module fan_speed_control (
    input clk,
    input reset,
    input [1:0] control_signal,
    output reg [2:0] speed
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        speed <= 3'b000; // Off state
    end else begin
        case (control_signal)
            2'b00: speed <= 3'b000; // Off
            2'b01: speed <= 3'b001; // Low
            2'b10: speed <= 3'b010; // Medium
            2'b11: speed <= 3'b011; // High
            default: speed <= 3'b000; // Default case
        endcase
    end
end

endmodule