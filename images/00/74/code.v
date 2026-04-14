module butterworth_filter (
    input wire [7:0] x,   // 8-bit input signal
    output wire [7:0] y   // 8-bit output signal
);
    // Coefficients for the 2nd order Butterworth filter
    parameter B0 = 8'b00011010; // 0.21875 in Q8.8 format
    parameter B1 = 8'b00011010; // 0.21875 in Q8.8 format
    parameter A1 = 8'b11100110; // -1.84375 in Q8.8 format
    parameter A2 = 8'b01111010; // 0.6875 in Q8.8 format

    reg [8:0] y_reg;
    reg [8:0] x_prev1, x_prev2;
    reg [8:0] y_prev1, y_prev2;

    always @(*) begin
        // Perform the filter calculation
        y_reg = B0 * x + B1 * x_prev1 + A1 * y_prev1 + A2 * y_prev2;
        
        // Update previous states
        x_prev2 = x_prev1;
        x_prev1 = x;
        y_prev2 = y_prev1;
        y_prev1 = y_reg[7:0];
    end

    assign y = y_reg[7:0];
endmodule