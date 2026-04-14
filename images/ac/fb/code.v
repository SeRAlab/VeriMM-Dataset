module top_module(clock, reset,
	pixCellIx, cellData1, cellData2,
	busAddr, busData, busOE, busWR, busHold);input clock;
input reset;

input[13:0] pixCellIx;
output[31:0] cellData1;
output[31:0] cellData2;

input[39:0] busAddr;
inout[31:0] busData;
input busOE;
input busWR;
output busHold;

reg			tBusHold;			
reg[31:0] 	tBusData;			
wire		tBusCSel;			

assign	busHold = (busOE && tBusCSel) ? tBusHold : 1'bZ;
assign	busData = (busOE && tBusCSel) ? tBusData : 32'hZZZZ_ZZZZ;


assign  tBusCSel = (busAddr[39:16]==24'hA0_A000) ||
	(busAddr[39:16]==24'h00_ACA0) ||
	(busAddr[39:16]==24'h00_ACA1);





reg[13:0]	tPixCellIx;			














(* ram_style="block" *) reg[31:0]	scrCell1A[0:511];
(* ram_style="block" *) reg[31:0]	scrCell1B[0:511];

reg[31:0]	scrRegCtrl[7:0];	
reg			scrIs320;			

reg			scrCellNoRead;

reg[31:0]	tCell1;
reg[31:0]	tCell2;
reg[31:0]	tNextCell1;
reg[31:0]	tNextCell2;

assign cellData1 = tCell1;
assign cellData2 = tCell2;

always @ (clock)
begin

	tBusHold = 1;
	tBusData = 0;
	if(busOE && tBusCSel)
	begin
		if(busAddr[15:8]==255)
		begin

			tBusHold=0;
			case(busAddr[6:2])
			0: tBusData = scrRegCtrl[0];
			1: tBusData = scrRegCtrl[1];
			2: tBusData = scrRegCtrl[2];
			3: tBusData = scrRegCtrl[3];

			8: tBusData = {18'h0, pixCellIx};

			endcase
		end
		else
		begin


			tBusHold = tPixCellIx != busAddr[15:2];
			tBusData = busAddr[2] ? tCell2 : tCell1;
		end
	end
end

always @ (posedge clock)
begin


	tCell1			<= tNextCell1;
	tCell2			<= tNextCell2;
	tPixCellIx		<= pixCellIx;

	if(tBusCSel && busWR && !busOE)
	begin

		scrCellNoRead <= 0;

		if(busAddr[15:8]==255)
		begin
			scrRegCtrl[busAddr[4:2]] <= busData;
		end
		else
		begin

		
			if(busAddr[2])
				scrCell1B[busAddr[11:3]] <= busData;
			else
				scrCell1A[busAddr[11:3]] <= busData;
		end
	end
end

always @ (posedge clock)
begin







	tNextCell1 <= scrCell1A[pixCellIx[9:1]];
	tNextCell2 <= scrCell1B[pixCellIx[9:1]];
end


endmodule