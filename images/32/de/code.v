module pitch_detector(
    input wire clk,
    input wire audio_signal,
    output reg [15:0] frequency
);
    reg [15:0] zero_crossing_count;
    reg [23:0] timer;

    always @(posedge clk) begin
        if (audio_signal == 1'b1 && timer == 24'd0) begin
            // Start timer
            timer <= 24'd1000000; // Assume we want to count over 1 second
        end else if (audio_signal == 1'b0 && timer > 0) begin
            // Count zero crossing
            zero_crossing_count <= zero_crossing_count + 1;
        end

        if (timer > 0) begin
            timer <= timer - 1;
        end else if (timer == 0) begin
            // Timer expired, calculate frequency
            frequency <= zero_crossing_count;
            zero_crossing_count <= 0; // Reset count for next period
            timer <= 24'd1000000; // Restart timer
        end
    end
endmodule