module top_module(ALU_result, Zero, ALU_in0, ALU_in1, ALU_Control) ;output reg signed [31:0]ALU_result ;
	output Zero ;
	input signed [31:0]ALU_in0, ALU_in1 ;
	input [3:0]ALU_Control ;

	always @(*) begin
		if(ALU_Control==4'b0000) 
			ALU_result = ALU_in0 & ALU_in1 ;
		else if(ALU_Control==4'b0001)
			ALU_result = ALU_in0 | ALU_in1 ;
		else if(ALU_Control==4'b0010)
			ALU_result = ALU_in0 + ALU_in1 ;
		else if(ALU_Control==4'b0110)
			ALU_result = ALU_in0 - ALU_in1 ;
		else if(ALU_Control==4'b0111)
			ALU_result = ( ALU_in0 < ALU_in1 ) ? 1 : 0 ;
		else if(ALU_Control==4'b1100)
			ALU_result = ~(ALU_in0 | ALU_in1) ; 
		else
			ALU_result = 32'd0 ; 
	end

	assign Zero = ( ALU_result == 0 ) ; 

endmodule