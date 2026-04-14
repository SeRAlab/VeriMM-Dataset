module top_module(input rst_n, input i_clk, output reg o_clk);parameter N=2_500_000;
	parameter M=1_249_999;

	reg [25:0]cnt;

	always @(posedge i_clk or negedge rst_n)
	begin
	 if(!rst_n)
		cnt<=26'b0;
	 else
		begin
		  if(cnt==N-1)
			 cnt<=26'b0;
		  else
			 cnt<=cnt+1'b1;
		end
	end
	always @(posedge i_clk or negedge rst_n)
	begin
	 if(!rst_n)
		o_clk<=0;
	 else
	 begin
		if(cnt<=M)
		o_clk<=1;
		else
		o_clk<=0;
	 end
	end
	  
endmodule