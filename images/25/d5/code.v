module zero_crossing_detector (
    input wire clk,
    input wire signed [7:0] signal_in,
    output reg crossing
);
    reg signed [7:0] previous_signal;

    always @(posedge clk) begin
        if (previous_signal < 0 && signal_in >= 0) begin
            crossing <= 1; // crossing from negative to positive
        end else if (previous_signal >= 0 && signal_in < 0) begin
            crossing <= 0; // crossing from positive to negative
        end
        previous_signal <= signal_in;
    end
endmodule