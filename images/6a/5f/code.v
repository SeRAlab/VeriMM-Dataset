module top_module(
	input			[4:0]		ra,
	input			[4:0]		rb,
	input			[4:0]		wa,
	input	 		[31:0]  	wdata,
	input          		wen,
	input          		clk,
	input       	   	rst,
	output 		[31:0] 	radata,
	output 		[31:0] 	rbdata
	);parameter INIT_FILE = "reg_file.txt";
	parameter ADDR_SIZE = 5;
   parameter DATA_SIZE = 32;
	
	localparam ARRAY_DEPTH = 1 << ADDR_SIZE;
	
	reg [DATA_SIZE-1:0] 	regarray [0:ARRAY_DEPTH-1];
	
		
	always @ (posedge clk)
	begin
		if (rst)
			
			;
		else if (wen)
			regarray[wa] <= wdata;
	end
	
	assign	radata = (ra == 5'b00000) ? 32'b0 :
							(ra == wa) ? wdata :
							regarray[ra];	
						
	assign	rbdata = (rb == 5'b00000) ? 32'b0 : 
							(rb == wa) ? wdata :
							regarray[rb];		
endmodule