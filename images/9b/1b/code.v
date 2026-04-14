module top_module(
	input clk,
	input  [7:0] p0,p1,p2,p3,p4,p5,p6,p7,p8,		
	output reg [7:0] median_out
    );reg [7:0] val [8:0];
	
	reg [7:0] temp[7:0];
	
	integer j;
	integer i;
	
	always @(posedge clk)
	begin
		val[0] = p0;
		val[1] = p1;
		val[2] = p2;
		val[3] = p3;
		val[4] = p4;
		val[5] = p5;
		val[6] = p6;
		val[7] = p7;
		val[8] = p8;
  
		 for (i = 0; i < 9; i = i+1)        
			for (j = 0; j < 8-i; j = j+1)  
			  if (val[j] > val[j+1]) begin 
					temp[j] = val[j];
					val[j] = val[j+1];
					val[j+1] = temp[j];
					end

		median_out = val[4];
	end

endmodule