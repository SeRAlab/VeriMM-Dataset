module top_module(
    input [bwidth-1:0] in0,
    input [bwidth-1:0] in1,
    input sel,
    output [bwidth-1:0] out
);parameter bwidth = 1;

    wire [bwidth-1:0] select_bus;

    assign select_bus = {bwidth{sel}};
    assign out = (in0 & (~select_bus)) | (in1 & (select_bus));endmodule