module top_module(Clk,RegWr, BusA, BusB, BusW, RA, RB, RW
    );output wire [31:0] BusA ,BusB ;
input wire [31:0] BusW;
input wire [4:0] RA, RB, RW ;
input wire Clk;
input wire RegWr ;

reg [31:0] Reg [0:31] ;
always@(negedge Clk)begin
	Reg[0] <= 32'b0;
	if(RegWr == 1'b1 )begin
		if(RW == 0)begin
			Reg[RW] <= 32'b0 ;
		end else begin
			Reg[RW] <= BusW ;
		end
	end
end

assign	BusA = (RA == 0 ? 0 : Reg[RA]);
assign	BusB = (RB == 0 ? 0 : Reg[RB]);


endmodule