module top_module(clock,operand1,operand2,mode,result,overflow);input        clock;
	 input  [2:0] operand1;
    input  [2:0] operand2;
    input        mode;
    output [2:0] result;
    output       overflow;
	 reg    [3:0] r_temp = 0;
	 reg    [2:0] r_two_bit_sum = 0; 
	 reg          r_overflow = 0;
	 
	 assign overflow = r_overflow;
	 assign result = r_temp[2:0];

	 
	 always @(posedge clock)
	 begin
	 
		if(~mode)
			begin
				r_temp = operand1 + operand2;
				if(r_temp[3])
					r_overflow = 1;
				else
					r_overflow = 0;
			end
	 
		else
			begin
				r_temp = operand1 + operand2;
				r_two_bit_sum = operand1[1:0] + operand2[1:0]; 
				
				if((r_temp[3]==0 && r_two_bit_sum[2]==1)||(r_temp[3]==1 && r_two_bit_sum[2]==0)) 
					r_overflow = 1;
				else
					r_overflow = 0;
			end				
	 end
		
endmodule