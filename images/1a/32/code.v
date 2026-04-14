module phase_shifter (
    input [2:0] phase_in,
    output reg [2:0] phase_out
);

always @(*) begin
    case (phase_in)
        3'b000: phase_out = 3'b000; // No shift
        3'b001: phase_out = 3'b001; // 1 shift
        3'b010: phase_out = 3'b010; // 2 shifts
        3'b011: phase_out = 3'b011; // 3 shifts
        3'b100: phase_out = 3'b100; // 4 shifts
        3'b101: phase_out = 3'b101; // 5 shifts
        3'b110: phase_out = 3'b110; // 6 shifts
        3'b111: phase_out = 3'b111; // 7 shifts
        default: phase_out = 3'b000; // Default case
    endcase
end

endmodule