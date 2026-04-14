module zero_crossing_detector (
    input wire clk,
    input wire signed [7:0] signal_in,
    output reg pos_cross,
    output reg neg_cross
);
    reg signed [7:0] last_signal;

    always @(posedge clk) begin
        pos_cross <= 0;
        neg_cross <= 0;
        if (last_signal > 0 && signal_in <= 0) begin
            neg_cross <= 1; // Detect negative crossing
        end else if (last_signal < 0 && signal_in >= 0) begin
            pos_cross <= 1; // Detect positive crossing
        end
        last_signal <= signal_in; // Update last signal
    end
endmodule