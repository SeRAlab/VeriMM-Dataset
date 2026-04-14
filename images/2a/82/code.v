module mux_8bit (
    input [7:0] data0,
    input [7:0] data1,
    input sel,
    output [7:0] out
);
    assign out = (sel) ? data1 : data0;
endmodule