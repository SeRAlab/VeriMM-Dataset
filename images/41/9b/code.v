module top_module(
	input				clk,
	input				rst_n,
	output				clk_out
);parameter	N=	6;
	reg					clk_out1;
	reg		[9:0]		cnt1;
	
always	@(posedge	clk	or	negedge	rst_n)
	begin
		if(!rst_n)
			begin
				cnt1		<=	10'd0;
				clk_out1	<=	1'd0;
			end
		else
			begin
				if(N==2)
					clk_out1		<=		~clk_out1;
				else
					if(cnt1	<=	((N-1'd1)/2)- 1'd1)
						begin
							cnt1		<=	cnt1	+1'd1;
							clk_out1	<=	1'd1;
						end
					else
						if(cnt1	<=	(N-2'd2))
							begin
								cnt1		<=	cnt1	+1'd1;
								clk_out1	<=	1'd0;
							end
						else
							begin
								cnt1		<=	10'd0;
								clk_out1	<=	1'd0;
							end
			end
	end

	
	reg				clk_out2;
	reg		[9:0]	cnt2;
always	@(negedge	clk	or	negedge	rst_n)
	begin
		if(!rst_n)
			begin
				cnt2		<=	10'd0;
				clk_out2	<=	1'd0;
			end
		else
			begin
				if(N==2)
					clk_out2		<=		~clk_out2;
				else
					if(cnt2	<=	((N-1'd1)/2)- 1'd1)
						begin
							cnt2		<=	cnt2	+1'd1;
							clk_out2	<=	1'd1;
						end
					else
						if(cnt2	<=	(N-2'd2))
							begin
								cnt2		<=	cnt2	+1'd1;
								clk_out2	<=	1'd0;
							end
						else
							begin
								cnt2		<=	10'd0;
								clk_out2	<=	1'd0;
							end
			end
	end	

assign	clk_out	=	clk_out1	|	clk_out2;	

endmodule