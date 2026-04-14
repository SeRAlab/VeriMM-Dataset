module mux_2to1_8bit(
    input sel,
    input [7:0] data_a,
    input [7:0] data_b,
    output [7:0] data_out
);

assign data_out = (sel) ? data_b : data_a;

endmodule