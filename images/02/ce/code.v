module butterworth_filter (
    input [3:0] signal_in,
    output reg [3:0] signal_out
);
    reg [3:0] a0 = 4'b0001; // Example coefficient a0
    reg [3:0] a1 = 4'b0010; // Example coefficient a1
    reg [3:0] a2 = 4'b0001; // Example coefficient a2
    
    reg [3:0] prev_out1;
    reg [3:0] prev_out2;

    always @(*) begin
        signal_out = (a0 * signal_in + a1 * prev_out1 + a2 * prev_out2) >> 2; // Simple filter equation
        prev_out2 = prev_out1; // Shift registers for output
        prev_out1 = signal_out;
    end
endmodule