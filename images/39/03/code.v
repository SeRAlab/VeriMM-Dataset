module noise_suppression (
    input wire clk,
    input wire enable,
    input wire [7:0] in_signal,
    output reg [7:0] out_signal
);
    reg [7:0] prev_signal;

    always @(posedge clk) begin
        if (enable) begin
            out_signal <= (in_signal + prev_signal) >> 1; // Average current and previous
            prev_signal <= in_signal; // Update previous signal
        end else begin
            out_signal <= in_signal; // Bypass noise suppression
        end
    end
endmodule