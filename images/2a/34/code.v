module phase_shifter(
    input [4:0] phase_in,
    output [4:0] phase_out
);
    assign phase_out = (phase_in + 5'd3) % 5'd32;
endmodule