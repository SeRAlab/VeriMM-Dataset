module PLL (
    input wire clk,                // Input clock
    input wire ref_freq,          // Reference frequency
    input wire control,            // Control signal
    output reg out_freq           // Output frequency
);
    reg [7:0] phase_error;         // Phase error
    reg [7:0] vco_output;          // VCO output

    always @(posedge clk) begin
        // Phase detector
        phase_error <= ref_freq - vco_output;

        // Low-pass filter simulation
        if (control) begin
            vco_output <= vco_output + phase_error; // Adjust VCO output based on phase error
        end else begin
            vco_output <= vco_output - phase_error; // Adjust VCO output based on phase error
        end

        // Assign output frequency
        out_freq <= vco_output;
    end
endmodule