module top_module(input [2:0] branch_in,
	 input zero_flag, sign_flag,
	 output reg pc_src);wire BEQ, BNQ, BLT, BGT;
	
	always@(branch_in, BEQ, BNQ, BLT, BGT) begin
		
		case (branch_in)
			3'b001: pc_src = BEQ; 
			3'b010: pc_src = BNQ; 
			3'b011: pc_src = BLT; 
			3'b100: pc_src = BGT; 
			3'b101: pc_src = 1'b1;	
			3'b110: pc_src= 1'b1;	
			default: pc_src = 1'b0;	
		endcase	
	end
	
	assign BEQ = zero_flag? 1'b1 : 1'b0;
	assign BNQ = zero_flag? 1'b0 : 1'b1;
	assign BLT = sign_flag? 1'b1 : 1'b0;
	assign BGT = sign_flag? 1'b0 : 1'b1;

endmodule