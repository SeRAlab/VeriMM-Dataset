module mux_2to1_8bit (
    input sel,
    input [7:0] data0,
    input [7:0] data1,
    output [7:0] out
);

assign out = sel ? data1 : data0;

endmodule