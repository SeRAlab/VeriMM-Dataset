module butterworth_filter (
    input [4:0] x, // 5-bit input signal
    output reg [4:0] y // 5-bit output signal
);

reg [4:0] x1, x2; // Previous inputs
reg [4:0] y1, y2; // Previous outputs

always @(*) begin
    // Update filter states
    x2 = x1; 
    x1 = x;
    
    // Simple Butterworth filter equation: y[n] = 0.5*x[n] + 0.5*x[n-1] + 0.5*y[n-1]
    y = (x + x2 + y1) / 3; // Normalize by 3 to keep the output in range
    y2 = y1;
    y1 = y;
end

endmodule