module top_module(  
  input  signed	    [31:0]	alu_a,
  input  signed	    [31:0]	alu_b,
  input	             [4:0]	alu_op,
  output    	reg    [31:0]	alu_out
    );always@(*)
	 begin
	 case(alu_op)
		1: 	alu_out <= alu_a + alu_b;	
		2: 	alu_out <= alu_a - alu_b;		
		3: 	alu_out <= alu_a & alu_b;
		4:	 	alu_out <= alu_a | alu_b;
		5:		alu_out <= alu_a ^ alu_b;
		6:		alu_out <= ~(alu_a | alu_b);	
		default:alu_out <= alu_out;
		endcase
		end

endmodule