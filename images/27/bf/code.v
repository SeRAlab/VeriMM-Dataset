module pitch_detector (
    input clk,
    input reset,
    input [15:0] frequency, // 16-bit frequency input
    output reg valid         // Output signal indicating if frequency is valid
);

// Define the frequency limits in parameters
parameter MIN_FREQ = 16'd1000; // Minimum frequency (e.g., 1000 Hz)
parameter MAX_FREQ = 16'd2000; // Maximum frequency (e.g., 2000 Hz)

always @(posedge clk or posedge reset) begin
    if (reset) begin
        valid <= 0; // On reset, invalid by default
    end else begin
        if (frequency >= MIN_FREQ && frequency <= MAX_FREQ) begin
            valid <= 1; // Frequency is valid
        end else begin
            valid <= 0; // Frequency is not valid
        end
    end
end

endmodule