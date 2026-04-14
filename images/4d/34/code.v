module top_module(readregA, readregB, writereg, writedata, writeflag, dataA, dataB, clk);input [4:0] readregA, readregB, writereg;
	input writeflag, clk;
	input [31:0] writedata;
	output [31:0] dataA, dataB;
	reg [31:0] REGS [31:0];
	
	always@(posedge clk)
	begin
		if(writeflag)
			REGS[writereg] = writedata;
		REGS[0] = 32'b0;
	end
	
	assign	dataA = REGS[readregA];
	assign	dataB = REGS[readregB];

endmodule