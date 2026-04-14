module top_module(rst, clk, ie, de, iaddr, daddr, drw, din, iout, dout);input rst;
        input clk;
        input ie,de;
        input [31:0] iaddr, daddr;
        input [1:0] drw;
        input [31:0] din;
        output [31:0] iout, dout;

        wire [31:0] idata, ddata;
        assign iout = idata;
        assign dout = ddata;

	
	always @(negedge clk) begin
		if (drw[0] && de && !rst) begin
			
		end else if (rst) begin
			
		end
	end
endmodule