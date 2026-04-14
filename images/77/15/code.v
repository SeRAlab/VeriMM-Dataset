module top_module(
	
	a			,
	b			,
	
	
	led			
);input 	[1:0]	  a;
	input 	[1:0]	  b;
	
	
	
	
	output  [2:0]	led;
	
	wire			a_eq_b;
	wire			a_gt_b;
	wire			a_1t_b;
	 
	
	assign 	a_eq_b=~b[1]&~b[0]&~a[1]&~a[0]	
					|~b[1]&b[0]&~a[1]&a[0]
					|b[1]&~b[0]&a[1]&~a[0]
					|b[1]&b[0]&a[1]&a[0];
	
	assign  a_gt_b=~b[1]&a[1]
					|~b[1]&~b[0]&a[0]
					|~b[0]&a[1]&a[0];
	
	assign  a_1t_b=b[1]&~a[1]
					|b[1]&b[0]&~a[0]
					|b[0]&~a[1]&~a[0];
	
	assign	led[0]=~a_eq_b;        		
	assign	led[1]=~a_gt_b;
	assign	led[2]=~a_1t_b;
	
endmodule