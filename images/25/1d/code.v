module phase_shifter (
    input [2:0] phase_in,
    output [2:0] phase_out
);
    assign phase_out = (phase_in + 3'b010) % 8; // Shift by 2 positions (modulo 8)
endmodule