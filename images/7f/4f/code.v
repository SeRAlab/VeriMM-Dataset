module top_module(PinCLK, PinA, PinOE, PinCCLR, PinSIN);input PinCLK;
input [7:0]PinA;
input PinOE;
input PinCCLR;

output [7:0]PinSIN;

wire PinCLK;

reg [16:0]ShiftReg = 17'h1FFFF;
wire [16:0]CmpVal;
wire [16:0]XorVal;

assign CmpVal = 17'h13596	^ (PinA[0] ? 17'h0000c : 0)
									^ (PinA[1] ? 17'h06000 : 0)
									^ (PinA[2] ? 17'h000c0 : 0)
									^ (PinA[3] ? 17'h00030 : 0)
									^ (PinA[4] ? 17'h18000 : 0)
									^ (PinA[5] ? 17'h00003 : 0)
									^ (PinA[6] ? 17'h00600 : 0)
									^ (PinA[7] ? 17'h01800 : 0);
assign XorVal = 17'h0C820	^ (PinA[0] ? 17'h00004 : 0)
									^ (PinA[1] ? 17'h06000 : 0)
									^ (PinA[2] ? 17'h00080 : 0)
									^ (PinA[3] ? 17'h00020 : 0)
									^ (PinA[4] ? 17'h08000 : 0)
									^ (PinA[5] ? 17'h00000 : 0)
									^ (PinA[6] ? 17'h00000 : 0)
									^ (PinA[7] ? 17'h00800 : 0);

always@(negedge PinCLK)
	begin

	if (PinCCLR) 
		begin
		if (!PinOE && ((ShiftReg | 17'h00100) == CmpVal))
			begin
			ShiftReg <= (ShiftReg ^ XorVal) >> 1;
			ShiftReg[16] <= ShiftReg[0] ^ ShiftReg[9] ^ ShiftReg[12] ^ ShiftReg[16] ^ XorVal[0];  
			end
		else
			begin
			ShiftReg <= ShiftReg >> 1;
			ShiftReg[16] <= ShiftReg[0] ^ ShiftReg[9] ^ ShiftReg[12] ^ ShiftReg[16];
			end
		end
	else
		begin
			ShiftReg <= 17'h1FFFF;
		end
	end


assign PinSIN = ShiftReg[7:0];



endmodule