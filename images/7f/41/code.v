module top_module(
    input [31:0] data1,
    input [31:0] data2,
    input select,
    output [31:0] out
    );assign out = select == 0 ? data1:data2;
endmodule