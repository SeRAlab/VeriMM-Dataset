module top_module(
input WrEn,
input [1:0] sel,
output r0,
output r1,
output r2,
output r3
);assign r0 = (~sel[1]&~sel[0]) ? WrEn : 0;
assign r1 = ~sel[1]&sel[0] ? WrEn : 0;
assign r2 = sel[1]&~sel[0] ? WrEn : 0;
assign r3 = sel[1]&sel[0] ? WrEn : 0;

endmodule