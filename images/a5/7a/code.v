module top_module(
    input clk,
    input rst,
	input [1:0]PcSource,
	input [31:0]in0,
	input [31:0]in1,
	input [31:0]in2, 
	output wire[31:0]out
);assign out = PcSource[1] ? (PcSource[0] ? 0 : in2) : (PcSource[0] ? in1 : in0);endmodule