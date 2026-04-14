module top_module( write, addr, datain, dataout, clk, reset);input [31:0] datain;
	input [15:0] addr;
	input write, clk, reset;
	output reg[31:0] dataout;
	
	reg[31:0] mem[255 : 0];
	
	always @(posedge clk) begin
		if(reset) begin
			mem[0] <=32'b0000100001000010_0001000000000000;
			mem[1] <=32'b1000001000010100_0000000000000000;
			mem[2] <=32'b0100101111100001_0001100100000000;
			mem[3] <=32'b1000101000010100_0000000000000100;
			mem[4] <=32'b1000101000010100_0000000000000100;
			mem[5] <=32'b0010111111111100_0000000000010100;
		end
		else begin
			if(write==1)
				mem[addr]<=datain;
			dataout<= mem[addr];
		end

	end
endmodule