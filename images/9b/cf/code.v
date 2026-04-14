module top_module(
	input i_clk,    
	input i_rst_n,
	output o_pluse
);parameter plu = 32'b1000_1001_0000_0000_1111_0000_1000_0000;
	reg [31:0] temp;

	assign o_pluse = temp[31];

	always@(posedge i_clk, negedge i_rst_n)
	begin
		if(1'b0 == i_rst_n)
		begin
			temp <= plu;
		end
		else begin
			temp <= {temp[30:0], temp[31]};
		end
	end

	
	
	
	
	
	
	
	
	
	

	
endmodule