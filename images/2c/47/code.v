module fractional_n_pll (
    input wire clk,                // Input clock
    input wire reset,              // Reset signal
    input wire [7:0] ref_freq,     // Reference frequency
    input wire [7:0] frac_div,     // Fractional divider
    output reg [7:0] vco_freq      // VCO output frequency
);
    reg [15:0] counter = 0;         // Counter for division
    reg [7:0] target_freq;          // Target frequency after division
    reg [7:0] fractional_part;       // Store the fractional part

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            vco_freq <= 0;
            fractional_part <= 0;
        end else begin
            // Calculate target frequency based on reference and fractional division
            fractional_part <= frac_div; // Update fractional part
            target_freq <= ref_freq / (fractional_part + 1);
            counter <= counter + 1;

            if (counter >= target_freq) begin
                vco_freq <= target_freq; // Update VCO frequency
                counter <= 0;             // Reset counter
            end
        end
    end
endmodule