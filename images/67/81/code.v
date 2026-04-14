module top_module(Comp_Code, ZF, LT, Branch);input [1:0] 	Comp_Code;
	input 			ZF;
	input 			LT;
	
	output reg 		Branch;
	
	always @ (*) begin
		case(Comp_Code)
			2'h0: begin
				Branch = ZF ? 1'b1 : 1'b0;
			end
			
			2'h1: begin
				Branch = !ZF ? 1'b1 : 1'b0;
			end
			
			2'h2: begin
				Branch = LT ? 1'b1 : 1'b0;
			end
			
			2'h3: begin
				Branch = ZF ? 1'b1 : (!LT ? 1'b1 : 1'b0);
			end
		endcase
	end 

endmodule