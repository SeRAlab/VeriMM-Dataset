module top_module(
						clk_i,
						rst_i,
						enable_i,
						uart_brr_i,
						baud_clk_o
);input clk_i,rst_i;

input [15:0] uart_brr_i;

input enable_i;
output baud_clk_o;
	
	
		reg [15:0] count;
		always@(posedge clk_i)
		begin
			if(rst_i | (!enable_i))
				count<=1;
			else
				if(count == uart_brr_i )
					count<=1;
				else	
					count<=count+16'b1;
		end
		
		assign baud_clk_o=(count==uart_brr_i);
endmodule