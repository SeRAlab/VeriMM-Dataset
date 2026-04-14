module top_module(
	input clock,
	input clear,
	input [5:0] xin,
	input [5:0] yin,
	input xld,
	input yld,
	input gld,
	input xselect,
	input yselect,
	output eqflag,
	output ltflag,
	output onezeroflag,
	output [5:0] gcd
	);reg [5:0] x1, y1, xreg, yreg, greg;
	wire [5:0] xmy, ymx;
	always @(*)
	begin
		case (xselect)
			1'd0 : x1 = xmy;
			1'd1 : x1 = xin;
		endcase
		
		case (yselect)
			1'd0 : y1 = ymx;
			1'd1 : y1 = yin;
		endcase
	end
	
	always @(posedge clock)
	begin
		if (xld == 1)
			xreg = x1;
		else
			xreg = xreg;
		
		if (yld == 1)
			yreg = y1;
		else
			yreg = yreg;
		
		if (gld == 1)
		begin
			if (xreg == yreg)
				greg = xreg;
			else
				if (xreg == 0 || yreg == 0)
				greg = xreg + yreg;
		end
				
		else
			greg = greg;
			
	end
	
	
	assign xmy = xreg - yreg;
	assign ymx = yreg - xreg;
	assign eqflag = (xreg == yreg);
	assign ltflag = (xreg < yreg);
	assign gcd = greg;
	assign onezeroflag = ((xreg == 0) || (yreg == 0));
	
endmodule