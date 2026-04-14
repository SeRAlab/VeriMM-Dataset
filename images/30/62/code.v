module dynamic_range_compressor(
    input clk,
    input reset,
    input [7:0] signal_in,
    input [7:0] threshold,
    output reg [7:0] signal_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            signal_out <= 8'b0;
        end else begin
            if (signal_in > threshold) begin
                signal_out <= threshold;  // Compress the signal to the threshold
            end else begin
                signal_out <= signal_in;   // No change
            end
        end
    end
endmodule