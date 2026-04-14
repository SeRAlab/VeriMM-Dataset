module mux_2to1(
    input wire sel,
    input wire [3:0] data0,
    input wire [3:0] data1,
    output wire [3:0] data_out
);

assign data_out = (sel) ? data1 : data0;

endmodule