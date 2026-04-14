module top_module(rst, clk, ie, de, iaddr, daddr, drw, din, iout, dout, switches);input rst;
        input clk;
        input ie,de;
        input [31:0] iaddr, daddr;
        input [1:0] drw;
        input [31:0] din;
        output [31:0] iout, dout;
	input [7:0] switches;

        
        wire [31:0] idata, ddata;
        assign iout = idata;
        assign dout = ddata;

	assign idata = 32'h00000000;
	assign ddata = {24'h000000,switches};
endmodule