module phase_shifter (
    input [2:0] phase_in,
    input [1:0] control,
    output reg [2:0] phase_out
);
    
    always @(phase_in or control) begin
        case (control)
            2'b00: phase_out = phase_in;                     // No shift
            2'b01: phase_out = (phase_in + 3'd2) % 8;       // Shift by 90 degrees (2)
            2'b10: phase_out = (phase_in + 3'd4) % 8;       // Shift by 180 degrees (4)
            2'b11: phase_out = (phase_in + 3'd6) % 8;       // Shift by 270 degrees (6)
            default: phase_out = phase_in;                    // Fallback
        endcase
    end
endmodule