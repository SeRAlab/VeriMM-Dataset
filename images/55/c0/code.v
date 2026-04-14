module top_module(input [2:0] color, output reg [8:0] char1,char2,char3,char4,char5,char6);always@(color)begin
		if(color==3'b001) begin
									char1=9'h152;
									char2=9'h145;
									char3=9'h144;
									char4=9'h120;
									char5=9'h120;
									char6=9'h120;
								end
		else if(color==3'b010) begin
										char1=9'h159;
										char2=9'h145;
										char3=9'h14C;
										char4=9'h14C;
										char5=9'h14F;
										char6=9'h157;
									end
		else if(color==3'b100) begin
											char1=9'h147;
											char2=9'h152;
											char3=9'h145;
											char4=9'h145;
											char5=9'h14E;
											char6=9'h120;
										end
										
		else begin
					char1=9'h152;
					char2=9'h145;
				   char3=9'h144;
					char4=9'h120;
					char5=9'h120;
					char6=9'h120;
				end
	end
	

endmodule