module top_module(input clk,rst,in_en,input[7:0] a,b,output [15:0] prdct ,output reg out_en);localparam s0=4'b0001,
	            s1=4'b0010,
					s2=4'b0100,
					s3=4'b1000;

	reg [3:0] stat_reg,next_reg;
	reg [2:0] count_reg,count_nxt;
	reg [15:0] b_reg,b_next;
	reg shift_rt ;
	
	always @(posedge clk, posedge rst)
	if(rst)begin
	stat_reg <= s0;
	count_reg<= 3'b0;
	b_reg    <= 16'h0000; end
	else begin
	stat_reg <= next_reg;
	count_reg<= count_nxt;
	if(shift_rt)
	b_reg    <= {b_next[15],b_next[15:1]};
	else 
	 b_reg    <=  b_next;
  end
	always @(*) begin
	out_en = 0;
	b_next = b_reg;
	shift_rt = 0;
	count_nxt = count_reg;
	case(stat_reg)
	s0: begin
           
				
								
				count_nxt = 0;
				if(in_en)begin
				b_next[7:0] = b;
				b_next[15:8]=8'h00;
		      next_reg  = s1 ; end
				else 
				next_reg  = s0 ; end
	 s1: begin
	        if(b_reg[0]) 
			       if(count_reg==3'b111)
			           b_next[15:8] = b_reg[15:8]-a;
					  else 
					  b_next[15:8] = b_reg[15:8]+a;
			   else
			           b_next[15:8] = b_reg[15:8]+0; 
				if(count_reg<3'b111)
				    next_reg  = s1 ;
				else
				    next_reg  = s3 ;
					 shift_rt  = 1;
				    count_nxt = count_reg+1;
				end
		
		s3: begin
		      out_en = 1;
				b_next = b_reg;				
			   next_reg  = s0;
            				end
		default: next_reg  = s0;
			endcase      end
assign prdct=b_reg;
	endmodule