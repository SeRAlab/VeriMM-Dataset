module zero_crossing_detector(
    input clk,
    input signed [7:0] in_signal,
    output reg zero_cross
);
    reg signed [7:0] prev_signal;

    always @(posedge clk) begin
        if (prev_signal < 0 && in_signal >= 0) 
            zero_cross <= 1; // rising zero crossing
        else 
            zero_cross <= 0; // otherwise
        prev_signal <= in_signal;
    end
endmodule