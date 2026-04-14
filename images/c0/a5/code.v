module qdiv #(
	parameter Q = 15,
	parameter N = 32
	)
	(
	input 	[N-1:0] i_dividend,
	input 	[N-1:0] i_divisor,
	input 	i_start,
	input 	i_clk,
	output 	[N-1:0] o_quotient_out,
	output 	o_complete,
	output	o_overflow
	);
	reg [2*N+Q-3:0]	reg_working_quotient;	
	reg [N-1:0] 		reg_quotient;				
	reg [N-2+Q:0] 		reg_working_dividend;	
	reg [2*N+Q-3:0]	reg_working_divisor;		
	reg [N-1:0] 			reg_count; 		
	reg					reg_done;			
	reg					reg_sign;			
	reg					reg_overflow;		
	initial reg_done = 1'b1;				
	initial reg_overflow = 1'b0;			
	initial reg_sign = 1'b0;				
	initial reg_working_quotient = 0;	
	initial reg_quotient = 0;				
	initial reg_working_dividend = 0;	
	initial reg_working_divisor = 0;		
 	initial reg_count = 0; 		
	assign o_quotient_out[N-2:0] = reg_quotient[N-2:0];	
	assign o_quotient_out[N-1] = reg_sign;						
	assign o_complete = reg_done;
	assign o_overflow = reg_overflow;
	always @( posedge i_clk ) begin
		if( reg_done && i_start ) begin										
			reg_done <= 1'b0;												
			reg_count <= N+Q-1;											
			reg_working_quotient <= 0;									
			reg_working_dividend <= 0;									
			reg_working_divisor <= 0;									
			reg_overflow <= 1'b0;										
			reg_working_dividend[N+Q-2:Q] <= i_dividend[N-2:0];				
			reg_working_divisor[2*N+Q-3:N+Q-1] <= i_divisor[N-2:0];		
			reg_sign <= i_dividend[N-1] ^ i_divisor[N-1];		
			end 
		else if(!reg_done) begin
			reg_working_divisor <= reg_working_divisor >> 1;	
			reg_count <= reg_count - 1;								
			if(reg_working_dividend >= reg_working_divisor) begin
				reg_working_quotient[reg_count] <= 1'b1;										
				reg_working_dividend <= reg_working_dividend - reg_working_divisor;	
				end
			if(reg_count == 0) begin
				reg_done <= 1'b1;										
				reg_quotient <= reg_working_quotient;			
				if (reg_working_quotient[2*N+Q-3:N]>0)
					reg_overflow <= 1'b1;
					end
			else
				reg_count <= reg_count - 1;	
			end
		end
endmodule