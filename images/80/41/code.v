module top_module(input clock, clear, count, load, enablen, input [3:0] highscore, output reg [3:0] BCD, output reg enableNext);parameter zeroize = 4'b0000, fullcount=4'b1001;
	always @(posedge clock)

	if(clear)
	begin
		BCD<=zeroize;
		enableNext<=0;
	end
		else	if(load)
		begin 
		BCD <= highscore;
		end 
	else if(count && enablen)
	begin
			if(BCD==fullcount)
			begin
				enableNext=0;
				BCD<=zeroize;
			end
			else
			begin
				BCD=BCD+1;
				if(BCD==fullcount)
					enableNext=1;
				else
				enableNext=0;
			end
		end
endmodule