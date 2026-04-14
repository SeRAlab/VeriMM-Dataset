module power_gating_controller (
    input wire power_request,
    input wire sleep_mode,
    output reg power_gate
);

    always @(*) begin
        if (sleep_mode) begin
            power_gate = 0; // Turn off power gate in sleep mode
        end else if (power_request) begin
            power_gate = 1; // Turn on power gate when power requested
        end
        // if both are low, power_gate retains its previous state
    end

endmodule