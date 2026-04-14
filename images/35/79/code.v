module butterworth_filter (
    input [4:0] signal_in,
    output reg [4:0] signal_out
);
    always @(*) begin
        // Simple Butterworth filter implementation (example using a basic averaging)
        signal_out = (signal_in + (signal_in >> 1) + (signal_in >> 2)) / 3; // Averaging for a low-pass effect
    end
endmodule