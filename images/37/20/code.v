module power_gating_controller (
    input [2:0] current_state,
    input power_enable,
    output reg [2:0] power_state
);
    always @(*) begin
        if (power_enable) begin
            power_state = current_state; // Fully powered with current state
        end else begin
            power_state = 3'b000; // Power down to minimum state
        end
    end
endmodule