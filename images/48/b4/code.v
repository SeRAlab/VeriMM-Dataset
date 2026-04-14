module top_module(
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);wire [3:0] sum_wire;
wire cout_wire;

assign sum_wire = a + b + cin;
assign sum = sum_wire[3:0];
assign cout = sum_wire[4];

endmodule