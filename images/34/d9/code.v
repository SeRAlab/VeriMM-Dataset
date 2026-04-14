module phase_shifter(
    input [2:0] phase_in,
    output [2:0] phase_out
);
    assign phase_out = {phase_in[1:0], phase_in[2]};
endmodule