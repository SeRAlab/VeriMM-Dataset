module butterworth_filter (
    input [4:0] signal_in,
    output reg [4:0] signal_out
);
    
    // Coefficients for a 2nd order Butterworth filter
    reg [4:0] a0, a1, a2;
    reg [4:0] b1, b2;
    reg [4:0] prev_signal_1, prev_signal_2;
    
    initial begin
        a0 = 5'b00001; // Coefficient for current input
        a1 = 5'b00010; // Coefficient for previous input 1
        a2 = 5'b00001; // Coefficient for previous input 2
        b1 = 5'b00001; // Feedback coefficient 1
        b2 = 5'b00000; // Feedback coefficient 2
        prev_signal_1 = 5'b00000;
        prev_signal_2 = 5'b00000;
    end
    
    always @(*) begin
        signal_out = (a0 * signal_in + a1 * prev_signal_1 + a2 * prev_signal_2) >> 2; // Shift for scaling
        prev_signal_2 = prev_signal_1;
        prev_signal_1 = signal_out;
    end
    
endmodule