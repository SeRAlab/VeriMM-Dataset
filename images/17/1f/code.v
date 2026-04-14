module multiplexer_2to1 (
    input [7:0] data0,
    input [7:0] data1,
    input select,
    output [7:0] out
);
    assign out = (select) ? data1 : data0;
endmodule