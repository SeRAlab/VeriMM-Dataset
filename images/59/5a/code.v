module top_module(rdata,clk,addr,rd,wr,wdata);output wire	[31:0]	rdata;
		input wire			clk;
		input wire	[31:0]	addr;
		input wire			rd, wr;
		input wire 	[31:0]	wdata;

	reg [31:0] mem [0:63];  

	always @(posedge clk) begin
		if (wr==1) mem[addr]=wdata;
	end
	assign rdata = rd ? wdata : mem[addr][31:0];

endmodule