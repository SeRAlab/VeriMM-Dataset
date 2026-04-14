module butterworth_filter (
    input wire [15:0] x,      // input signal
    output wire [15:0] y      // output signal
);
    reg [15:0] y_reg;
    reg [15:0] x1, x2;
    
    always @* begin
        // Simple implementation of a 2nd order Butterworth filter
        // y[n] = 0.5 * x[n] + 0.5 * x[n-1] + 0.5 * x[n-2]
        y_reg = (x + x1 + x2) / 3;
        x2 = x1; // Shift x1 to x2
        x1 = x;  // Update x1 to current x
    end
    
    assign y = y_reg;
endmodule