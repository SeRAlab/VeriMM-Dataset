module top_module(nLoad, Clk, hour2, hour1, minute2, minute1, second2, second1, 
						chour2, chour1, cminute2, cminute1, csecond2, csecond1);input Clk, nLoad;
	input [3:0] hour2, hour1, minute2, minute1, second2, second1;
	output reg [3:0] chour2, chour1, cminute2, cminute1, csecond2, csecond1;
	
	always @ (posedge Clk, negedge nLoad)
	
	//load initial values of the clock
	//similar to a reset
	begin
	if (~nLoad)
	begin
		chour2 <= hour2; chour1 <= hour1; cminute2 <= minute2; cminute1 <= minute1; csecond2 <= second2; csecond1 <= second1;
	end
	
	//run the clock
	else
	begin
	csecond1 <= csecond1 + 1;
	//seconds
	if (csecond1 > 8)
		begin
		csecond2 <= csecond2 + 1;
		csecond1 <= 0;
		end
	if ((csecond2 == 5)&(csecond1 == 9))
		begin
		cminute1 <= cminute1 + 1;
		csecond2 <= 0;
		csecond1 <= 0;
		end
	//minutes
	if ((cminute2 < 5) & (cminute1 == 9) & (csecond2 == 5) & (csecond1 == 9))
		begin
		cminute2 <= cminute2 + 1;
		cminute1 <= 0;
		end
	if ((cminute2 == 5)&(cminute1 == 9)&(csecond2 == 5)&(csecond1 == 9))
		begin
		chour1 <= chour1 + 1;
		cminute2 <= 0;
		cminute1 <= 0;
		end
	//hours
	if ((chour2 < 2) & (chour1 == 9) & (cminute2 == 5) & (cminute1 == 9) & (csecond2 == 5) & (csecond1 == 9))
			begin
			chour2 <= chour2 + 1;
			chour1 <= 0;
			end
	if ((chour2 == 2)&(chour1 == 3)&(cminute2 == 5)&(cminute1 == 9)&(csecond2==5)&(csecond1==9))
		begin
		chour2 <= 0;
		chour1 <= 0;
		end
	end
	end
endmodule