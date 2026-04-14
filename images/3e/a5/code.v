module chebyshev_filter (
    input [3:0] signal_in,
    output reg [3:0] signal_out
);
    always @(*) begin
        // Simple Chebyshev-like behavior
        // For demonstration, let's just shift the input and add some constant value.
        signal_out = (signal_in << 1) + 4'b0010; // Shift left and add 2
    end
endmodule