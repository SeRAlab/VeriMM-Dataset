module phase_shifter(
    input [2:0] phase_in,
    input [1:0] shift_amount,
    output reg [2:0] phase_out
);

always @(phase_in or shift_amount) begin
    case (shift_amount)
        2'b00: phase_out = phase_in; // No shift
        2'b01: phase_out = (phase_in + 1) % 8; // Shift by 1
        2'b10: phase_out = (phase_in + 2) % 8; // Shift by 2
        2'b11: phase_out = (phase_in + 3) % 8; // Shift by 3
        default: phase_out = phase_in; // Default case
    endcase
end

endmodule