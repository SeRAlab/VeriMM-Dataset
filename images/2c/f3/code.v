module carrier_frequency_recovery(
    input wire clk,
    input wire baseband_signal,
    input wire local_oscillator,
    output reg recovered_signal
);
    reg phase_buffer;

    always @(posedge clk) begin
        phase_buffer <= baseband_signal ^ local_oscillator; // XOR for phase detection
        recovered_signal <= phase_buffer; // Output the phase detected signal
    end
endmodule