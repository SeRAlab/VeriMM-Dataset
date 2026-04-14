module pitch_detection (
    input clk,
    input reset,
    input serial_data,
    output reg pitch_detected
);
    reg [3:0] counter;  // Sample counter
    reg [3:0] state;    // State machine for pattern matching

    // Define the pitch detection pattern (simplified)
    parameter PATTERN = 4'b1010; // Example pattern for pitch detection

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            state <= 0;
            pitch_detected <= 0;
        end else begin
            // Increment the counter
            counter <= counter + 1;

            // Check for pattern on the serial data
            if (serial_data == PATTERN[state]) begin
                if (state == 3) begin
                    pitch_detected <= 1; // Pattern matched
                    state <= 0;          // Reset state
                end else begin
                    state <= state + 1; // Move to next pattern state
                end
            end else begin
                state <= 0; // Reset state if pattern is broken
                pitch_detected <= 0; // Reset detected signal
            end
        end
    end
endmodule