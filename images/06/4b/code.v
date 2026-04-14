module chebyshev_filter (
    input [4:0] in_signal,
    output reg [4:0] out_signal
);
    // Predefined coefficients for 5th-order Chebyshev filter
    parameter [4:0] b0 = 5'b00001;
    parameter [4:0] b1 = 5'b00010;
    parameter [4:0] b2 = 5'b00011;
    parameter [4:0] b3 = 5'b00100;
    parameter [4:0] b4 = 5'b00101;

    always @(*) begin
        // Simple filter implementation
        out_signal = (in_signal * b0 + in_signal * b1 + in_signal * b2 + in_signal * b3 + in_signal * b4) >> 2; // Right shift for scaling
    end
endmodule