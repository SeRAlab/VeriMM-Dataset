module Log2pipelined
(
	input [23:0]	DIN,
	input			clk,
	output	[7:0]	DOUT
);
reg	[3:0]	priencout1;
reg	[3:0]	priencout2;
reg	[3:0]	priencout3;
reg	[4:0]	barrelout;
reg	[19:0]	barrelin;
reg	[3:0]	LUTout; 
assign	DOUT	=	{priencout3, LUTout};	
always @(posedge clk) 					
begin
	priencout2	<=	priencout1;
	priencout3	<=	priencout2;
	barrelin	<=	DIN[22:3];
end
wire [19:0] tmp1 =	(barrelin << ~priencout1);	
always @(posedge clk)
begin
	barrelout	<=	tmp1[19:15];
end
wire	[15:0]	priencin = DIN[23:8];
always @(posedge clk)						
casex (priencin)
	16'b1xxxxxxxxxxxxxxx:	priencout1	<=	15;
	16'b01xxxxxxxxxxxxxx:	priencout1	<=	14;
	16'b001xxxxxxxxxxxxx:	priencout1	<=	13;	
	16'b0001xxxxxxxxxxxx:	priencout1	<=	12;	
	16'b00001xxxxxxxxxxx:	priencout1	<=	11;	
	16'b000001xxxxxxxxxx:	priencout1	<=	10;	
	16'b0000001xxxxxxxxx:	priencout1	<=	9;	
	16'b00000001xxxxxxxx:	priencout1	<=	8;	
	16'b000000001xxxxxxx:	priencout1	<=	7;	
	16'b0000000001xxxxxx:	priencout1	<=	6;	
	16'b00000000001xxxxx:	priencout1	<=	5;	
	16'b000000000001xxxx:	priencout1	<=	4;	
	16'b0000000000001xxx:	priencout1	<=	3;	
	16'b00000000000001xx:	priencout1	<=	2;	
	16'b000000000000001x:	priencout1	<=	1;	
	16'b000000000000000x:	priencout1	<=	0;
endcase
always @(posedge clk)
case (barrelout)
	0:	LUTout	<=	0;
	1:	LUTout	<=	1;
	2:	LUTout	<=	1;
	3:	LUTout	<=	2;
	4:	LUTout	<=	3;
	5:	LUTout	<=	3;
	6:	LUTout	<=	4;
	7:	LUTout	<=	5;
	8:	LUTout	<=	5;
	9:	LUTout	<=	6;
	10:	LUTout	<=	6;
	11:	LUTout	<=	7;
	12:	LUTout	<=	7;
	13:	LUTout	<=	8;
	14:	LUTout	<=	8;
	15:	LUTout	<=	9;
	16:	LUTout	<=	9;
	17:	LUTout	<=	10;
	18:	LUTout	<=	10;
	19:	LUTout	<=	11;
	20:	LUTout	<=	11;
	21:	LUTout	<=	12;
	22:	LUTout	<=	12;
	23:	LUTout	<=	13;
	24:	LUTout	<=	13;
	25:	LUTout	<=	13;
	26:	LUTout	<=	14;
	27:	LUTout	<=	14;
	28:	LUTout	<=	14;	
	29:	LUTout	<=	15;
	30:	LUTout	<=	15;
	31:	LUTout	<=	15;
endcase
endmodule