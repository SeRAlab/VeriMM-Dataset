module top_module(
	input clock,
	input reset_l,
	input [2:0] selectRoute,
	input [N-1:0] tx3_in, tx2_in, tx1_in, tx0_in,
	output reg [N-1:0] rx3_out, rx2_out, rx1_out, rx0_out
);parameter N = 1;

always @(posedge clock) begin
	
	if (reset_l == 1'b0)
	begin
		rx3_out <= {N{1'b0}};
		rx2_out <= {N{1'b0}};
		rx1_out <= {N{1'b0}};
		rx0_out <= {N{1'b0}};
		
	end
	else
	begin
		
		
		if (selectRoute == 3'bX11) 
			begin
				
			
			end
		if (selectRoute == 3'bX10) 
			begin
				
		
			end
		if (selectRoute == 3'bX01) 
			begin
				
				rx2_out <= tx1_in;
				rx1_out <= tx2_in;
			end
			else
			begin
				rx3_out <= {N{1'b0}};
				rx0_out <= {N{1'b0}};
			end
		if (selectRoute == 3'bX00) 
			begin
				
				rx1_out <= tx0_in;
				rx0_out <= tx1_in;
			end
			else
			begin
				
				rx3_out <= {N{1'b0}};
				rx2_out <= {N{1'b0}};
			end
		end
end
		
endmodule