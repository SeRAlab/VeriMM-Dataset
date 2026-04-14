module phase_shifter (
    input [4:0] angle_in,
    output [4:0] angle_out
);
    assign angle_out = (angle_in + 5'd3) % 5'd32;
endmodule