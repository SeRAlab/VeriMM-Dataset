module zero_cross_detector (
    input wire clk,
    input wire signal_in,
    output reg zero_cross
);
    reg signal_prev;

    always @(posedge clk) begin
        // Detect zero crossing
        if (signal_prev < 0 && signal_in >= 0) begin
            zero_cross <= 1; // Set zero_cross high on crossing
        end else begin
            zero_cross <= 0; // Reset zero_cross low otherwise
        end
        signal_prev <= signal_in; // Update previous signal
    end
endmodule