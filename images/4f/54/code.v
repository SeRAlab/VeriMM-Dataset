module top_module(Clock, reset_n, En, BCD_sec, BCD_tsec, BCD_hsec, BCD_msec);input Clock, reset_n, En;
	output reg [3:0] BCD_sec, BCD_tsec, BCD_hsec, BCD_msec;
	
	always @ (posedge Clock, negedge reset_n)
	begin
		if (!reset_n) 
		begin
			BCD_sec  <= 0;
			BCD_tsec <= 0;
			BCD_hsec <= 0;
			BCD_msec <= 0;
		end
		else if (En)
			if (BCD_msec == 9)
				begin
				BCD_msec <= 0;
				if(BCD_hsec == 9) 
					begin
					BCD_hsec <= 0;
					if (BCD_tsec == 9) 
						begin
						BCD_tsec <= 0;
						if (BCD_sec == 9)
							BCD_sec <= 0;
						else
							BCD_sec <= BCD_sec + 1;
						end 
					else
						BCD_tsec <= BCD_tsec + 1;
					end 
				else
					BCD_hsec <= BCD_hsec + 1;
				end
			else
				BCD_msec <= BCD_msec + 1;
	end
endmodule