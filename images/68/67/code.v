module top_module(
    clk,
    input_a,
    input_b,
    output_result
);input clk;
input [7:0] input_a;
input [7:0] input_b;
output [7:0] output_result;

wire [7:0] wire_and0;
wire [7:0] wire_and1;
wire [7:0] wire_and2;
wire [7:0] wire_and3;
wire [7:0] wire_and4;
wire [7:0] wire_and5;
wire [7:0] wire_and6;
wire [7:0] wire_and7;

assign wire_and0 = input_a[0] & input_b[0];
assign wire_and1 = input_a[1] & input_b[1];
assign wire_and2 = input_a[2] & input_b[2];
assign wire_and3 = input_a[3] & input_b[3];
assign wire_and4 = input_a[4] & input_b[4];
assign wire_and5 = input_a[5] & input_b[5];
assign wire_and6 = input_a[6] & input_b[6];
assign wire_and7 = input_a[7] & input_b[7];

assign output_result[0] = wire_and0;
assign output_result[1] = wire_and1;
assign output_result[2] = wire_and2;
assign output_result[3] = wire_and3;
assign output_result[4] = wire_and4;
assign output_result[5] = wire_and5;
assign output_result[6] = wire_and6;
assign output_result[7] = wire_and7;

endmodule