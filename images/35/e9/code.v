module dynamic_range_compressor(
    input clk,
    input reset,
    input signed [15:0] in_signal,
    output reg signed [15:0] out_signal
);
    reg signed [15:0] threshold;
    reg signed [15:0] gain;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out_signal <= 0;
            threshold <= 16'h4000; // Example threshold (0.5 in Q15)
            gain <= 16'h2000;      // Example gain (0.25 in Q15)
        end else begin
            if (in_signal > threshold) begin
                out_signal <= (in_signal - threshold) * gain >>> 15;
            end else begin
                out_signal <= in_signal;
            end
        end
    end
endmodule