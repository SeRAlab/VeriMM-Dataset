module top_module(input 		  clk, we,
						 input [9:0]  addr,
						 input [31:0] datain,
						 output reg [31:0] dataout);reg [31:0] mem [1023:0];
	
	always @(posedge clk) begin
		if(we) mem[addr] <= datain;
		dataout <= mem[addr];
	end
endmodule