module goertzel(
    input clk,
    input reset,
    input [15:0] sample,
    output reg detection_flag
);
    reg [15:0] s_prev, s_prev2;
    reg [15:0] target_frequency_cos;
    parameter N = 128; // Number of samples
    parameter TARGET_FREQ = 300; // Target frequency in Hz

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            s_prev <= 0;
            s_prev2 <= 0;
            detection_flag <= 0;
        end else begin
            // Update the Goertzel algorithm state
            s_prev2 <= s_prev;
            s_prev <= sample + target_frequency_cos * s_prev2 - s_prev2;

            // Detection condition (simple thresholding for example)
            if (s_prev > 10000) // Example threshold
                detection_flag <= 1;
            else
                detection_flag <= 0;
        end
    end
endmodule