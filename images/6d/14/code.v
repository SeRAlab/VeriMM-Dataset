module top_module(FFlag3, clk,rst, PC, Ins, FFlag1);input clk;
input FFlag3;
input rst;
input [7:0]PC;
output reg[13:0]Ins;
output reg FFlag1;
reg [13:0] Mem [0:255];
 
always @(posedge clk)begin

	if(!rst)begin
	 Mem[0]=14'b00011110001000;
	 Mem[1]=14'b00011100001001;
	 Mem[2]=14'b00001010001010;
	 Mem[3]=14'b00001000001011;
	 Mem[4]=14'b00001000001100;
	 Mem[5]=14'b00001100001101;
	 Mem[6]=14'b00010110001000;
	 Mem[7]=14'b00101000001001;
	 Mem[8]=14'b00010010001010;
	 Mem[9]=14'b00100100001011;
	 Mem[10]=14'b00011010001100;
	
	 Mem[11]=14'b01001110001000;
	 Mem[12]=14'b01000110001001;
	 Mem[13]=14'b01010110001010;
	 Mem[14]=14'b01010100001011;
	
	 Mem[15]=14'b11111100001111;
	 Mem[16]=14'b11100100001000;
	 Mem[17]=14'b11100000000001;
	 Mem[18]=14'b11110100000010;
	 Mem[19]=14'b11101000000100;
	
	end
	else if(FFlag3) begin
		Ins<=Mem[PC%20];
		#20 FFlag1<=1;
	end
	
end
endmodule