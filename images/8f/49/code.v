module top_module(input clock, wP, rP,
				input [31:0] target,
				input [31:0] writeData,
				output [31:0] readData);reg [31:0] dMem [0:127];
	always @(posedge clock)
	begin
		if(wP==1)
			dMem[target] = writeData;
	end
		assign readData = (rP==0) ? 0 : dMem[target];
endmodule