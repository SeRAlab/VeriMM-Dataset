module phase_detector(
    input clk,
    input phaseA,
    input phaseB,
    output reg output_state
);
    always @(posedge clk) begin
        if (phaseA && !phaseB) begin
            output_state <= 1'b1; // Phase A leads
        end else if (!phaseA && phaseB) begin
            output_state <= 1'b0; // Phase B leads
        end
        // If both are equal, output_state remains unchanged
    end
endmodule