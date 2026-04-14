module phase_shifter(
    input [2:0] phase_in,
    input control_signal,
    output reg [2:0] phase_out
);
    
    always @(phase_in or control_signal) begin
        if (control_signal == 0) begin
            phase_out = (phase_in + 1) % 8;  // shift right
        end else begin
            phase_out = (phase_in - 1 + 8) % 8;  // shift left with wrap around
        end
    end
endmodule