module top_module( 
							clk,
							bin_bcd,
							rst,
							tho,
							hun,
							ten,
							one);input			[11:0]	bin_bcd;
	input					clk,rst;
	output		[3:0] tho, hun, ten, one;
							
	wire			[11:0]	bin_bcd;
	reg			[3:0] tho, hun, ten, one;
	
	integer 				i;
							
	always @ (posedge clk or negedge rst) begin
		if(!rst) begin
			tho	<= 4'd0;
			hun	<= 4'd0;
			ten	<= 4'd0;
			one	<= 4'd0;
		end
		
		else begin
			tho	= 4'd0;
			hun	= 4'd0;
			ten	= 4'd0;
			one	= 4'd0;
			for(i=11; i>=0; i=i-1) begin
				if(tho >= 5)
					tho = tho + 3;
				if(hun >= 5)
					hun = hun + 3;
				if(ten >= 5)
					ten = ten + 3;
				if(one >= 5)
					one = one + 3;
				
				tho = tho << 1;
				tho[0] = hun[3];
				hun = hun << 1;
				hun[0] = ten[3];
				ten = ten << 1;
				ten[0] = one[3];
				one = one << 1;
				one[0] = bin_bcd[i];
			end
			tho <= tho;
			hun <= hun;
			ten <= ten;
			one <= one;
		end
	end

endmodule