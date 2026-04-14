module phase_shifter(
    input [2:0] phase_in,
    output reg [4:0] phase_out
);
    always @(*) begin
        case (phase_in)
            3'b000: phase_out = 5'b00000; // Phase 0
            3'b001: phase_out = 5'b00001; // Phase 1
            3'b010: phase_out = 5'b00010; // Phase 2
            3'b011: phase_out = 5'b00011; // Phase 3
            3'b100: phase_out = 5'b00100; // Phase 4
            3'b101: phase_out = 5'b00101; // Phase 5
            3'b110: phase_out = 5'b00110; // Phase 6
            3'b111: phase_out = 5'b00111; // Phase 7
            default: phase_out = 5'b00000; // Default case
        endcase
    end
endmodule