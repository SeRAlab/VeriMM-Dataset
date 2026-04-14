module pulse_generator (
    input wire clk,
    input wire reset,
    input wire trigger,
    input wire [3:0] pulse_width, // Configurable pulse width
    output reg pulse_out
);
    reg [3:0] count; // Counter to track pulse duration
    reg pulse_active; // Indicates if the pulse is currently active

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pulse_out <= 0;
            count <= 0;
            pulse_active <= 0;
        end else begin
            if (trigger && !pulse_active) begin
                pulse_active <= 1; // Start pulse
                count <= pulse_width; // Load pulse width
            end
            
            if (pulse_active) begin
                pulse_out <= 1; // Keep pulse high
                if (count > 0) begin
                    count <= count - 1; // Decrement counter
                end else begin
                    pulse_out <= 0; // End pulse
                    pulse_active <= 0; // Reset pulse state
                end
            end
        end
    end
endmodule