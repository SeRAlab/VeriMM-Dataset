module top_module(d,c);output [14:0] c;
	
	
	
	input [10:0] d;
	
	
	
	

	
	
	
	
	


	
		
		



	
	



		
		
	
		
		assign c[2]=d[0];
		assign c[4]=d[1];
		assign c[5]=d[2];
		assign c[6]=d[3];
		assign c[8]=d[4];
		assign c[9]=d[5];
		assign c[10]=d[6];
		assign c[11]=d[7];
		assign c[12]=d[8];
		assign c[13]=d[9];
		assign c[14]=d[10];
		
	
		






        assign c[0]=d[0]^d[1]^d[3]^d[4]^d[6]^d[8]^d[10];
		assign c[1]=((d[0]^d[2])^(d[3]^d[5]))^((d[6]^d[9])^d[10]);
		assign c[3]=((d[1]^d[2])^(d[3]^d[7]))^((d[8]^d[9])^d[10]);
		assign c[7]=((d[4]^d[5])^(d[6]^d[7]))^((d[8]^d[9])^d[10]);

	
	
endmodule