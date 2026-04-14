module top_module(
	clk,
	start,
	RWB,
	Address,
	Data
);input clk;
	input	start;
	output RWB;
	output reg[5:0] Address;
	output reg[7:0] Data;
	reg Addreg;
	
	always@(posedge clk)
	begin
	
		Data[0] <= start ? 1'b0 : Data[7]^ Data[6];
		Data[6:1] <= start ? 5'b0: Data[5:0];
		Data[7] <= start ? 1'b1 : Data[6];
		Address[0] <= start ? 1'b0 : Address[5]^ Addreg;
		{Addreg,Address[3:1]} <= start ? 4'b0: Address[3:0];
		Address[4] <= 0;
		Address[5] <= start ? 1'b1 : Addreg;
	
	end


	assign RWB = Data[5];


endmodule