module top_module(result,Dataout,memtoreg,busW);input wire memtoreg;
	input wire[31:0] result,Dataout;
	output wire[31:0] busW;

	assign busW=(memtoreg==0)?result:Dataout;
endmodule