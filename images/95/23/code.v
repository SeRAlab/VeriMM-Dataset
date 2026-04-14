module top_module(

	input 				 clk_i, 
	input 		[31:0] a_i  , 
	input 		[31:0] wd_i , 
	input 				 we_i ,
	output wire	[31:0] rd_o 
	);reg [31:0] MEM [0:63]; 

assign rd_o = (24'h710000 == a_i[31:8]) ?  MEM[a_i[7:2]] : 32'd0;





always @ (posedge clk_i) 
	begin
		if (we_i) 
			begin
				MEM[a_i[7:2]] <= wd_i;
			end
	end
	
endmodule