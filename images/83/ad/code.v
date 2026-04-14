module top_module(clk, rstn, ce, we, addr, din, dout);parameter DWIDTH = 32;
parameter AWIDTH = 10;
parameter DEPTH = (1<<AWIDTH);

input clk, rstn;
input ce, we;

input [AWIDTH-1:0] addr;
input [DWIDTH-1:0] din;
output [DWIDTH-1:0] dout;

reg [DWIDTH-1:0] do_r;

reg [DWIDTH-1:0] mem [0:DEPTH-1];

always @(posedge clk)
begin
	if(ce && we)
	begin
		mem[addr] <= din;
	end
end

always @(posedge clk)
begin
	if(ce && !we)
	begin
		do_r <= mem[addr];
	end
end

assign dout = do_r;

endmodule