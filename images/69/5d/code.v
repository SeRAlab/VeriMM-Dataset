module top_module(
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [1:0] sel,
    output [3:0] result
);wire [3:0] sel_0, sel_1, sel_2, sel_3;

assign sel_0 = (sel == 2'b00) ? data0 : 4'b0000;
assign sel_1 = (sel == 2'b01) ? data1 : 4'b0000;
assign sel_2 = (sel == 2'b10) ? data2 : 4'b0000;
assign sel_3 = (sel == 2'b11) ? data3 : 4'b0000;

assign result = sel_0 | sel_1 | sel_2 | sel_3;

endmodule