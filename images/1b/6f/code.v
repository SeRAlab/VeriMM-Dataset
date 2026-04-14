module phase_shifter (
    input [3:0] phase_in,
    input [1:0] control,
    output reg [3:0] phase_out
);

always @(phase_in, control) begin
    case (control)
        2'b00: phase_out = phase_in;                   // No shift
        2'b01: phase_out = (phase_in + 90) % 360;     // 90° shift
        2'b10: phase_out = (phase_in + 180) % 360;    // 180° shift
        2'b11: phase_out = (phase_in + 270) % 360;    // 270° shift
        default: phase_out = phase_in;                 // Default case
    endcase
end

endmodule