module pll_4x (
    input wire clk,           // Clock input
    input wire reset,         // Reset signal
    input wire ref_freq,      // Reference frequency input
    output reg vco_out        // VCO Output frequency
);
    reg [1:0] phase_counter;  // 2-bit phase counter to track phase

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            phase_counter <= 2'b00; // Reset phase counter
            vco_out <= 1'b0;         // Reset VCO output
        end else begin
            phase_counter <= phase_counter + 1; // Increment phase counter
            if (phase_counter == 2'b11) begin
                vco_out <= ~vco_out; // Toggle output every 4 clock cycles
            end
        end
    end
endmodule