module phase_shifter (
    input [3:0] phase_in,
    input [1:0] shift_amount,
    output reg [3:0] phase_out
);

always @(phase_in, shift_amount) begin
    case (shift_amount)
        2'b00: phase_out = phase_in;           // No shift
        2'b01: phase_out = {phase_in[2:0], phase_in[3]}; // Shift left by 1
        2'b10: phase_out = {phase_in[1:0], phase_in[3:2]}; // Shift left by 2
        2'b11: phase_out = {phase_in[0], phase_in[3:1]}; // Shift left by 3
        default: phase_out = phase_in;         // Default case to handle unexpected values
    endcase
end

endmodule