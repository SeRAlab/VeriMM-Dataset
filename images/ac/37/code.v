module top_module(clk_in, D_in, rst, D_out);input D_in, clk_in, rst;
	
	output D_out;
	
	wire D_out;
	
	reg q9, q8, q7, q6, q5, q4, q3, q2, q1, q0;



	assign D_out = !q9 & q8 & q7 & q6 & q5 & q4 & q3 & q2 & q1 & q0;

	always@(posedge clk_in or posedge rst)
		
		if (rst == 1'b1)
			{q9,q8, q7, q6,q5, q4, q3, q2, q1, q0} <= 10'b0;
		else begin
	
			q9 <= q8 ; q8 <= q7 ; q7 <= q6 ; q6 <= q5; q5 <= q4;
			q4 <= q3; q3 <= q2 ; q2 <= q1; q1 <= q0; q0 <= D_in;
   end
	
	assign D_out =!q9 & q8 & q7 & q6 & q5 & q4 & q3 & q2 & q1 & q0;
						
endmodule