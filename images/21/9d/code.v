module power_gating_controller(
    input [1:0] ctrl,
    input enable_prev,
    output reg power_gated
);
    always @(*) begin
        case (ctrl)
            2'b00: power_gated = 0; // Power gated off
            2'b01: power_gated = 1; // Power gated on
            2'b10: power_gated = 1; // Power gated on
            2'b11: power_gated = enable_prev; // Hold previous state
            default: power_gated = enable_prev; // Default hold state
        endcase
    end
endmodule