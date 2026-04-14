module top_module(npm, d, pm1, bm1, pm2, bm2);output [3:0] npm;
	
	output d;
	
	
	
	
	input [3:0] pm1;
	
	input [1:0] bm1;
	
	input [3:0] pm2;
	
	input [1:0] bm2;
	
	
	reg [3:0] npm;
	reg d;
	
	
	reg [3:0] add1;
	
	reg [3:0] add2;
	
	reg [4:0] add_temp1;
	
	reg [4:0] add_temp2;



	
	
	
	
	parameter max_add = 4'd15;


	
	always @ (pm1 or bm1)
	begin
		
		add_temp1 = pm1 + bm1;
		
		if(add_temp1 > max_add)
		begin
			
			add1 = max_add;
		end
		else
		begin
			
			add1 = pm1 + bm1;
		end
	end
	
	
	always @ (pm2 or bm2)
	begin
		
		add_temp2 = pm2 + bm2;
		
		if(add_temp2 > max_add)
		begin
			
			add2 = max_add;
		end
		else
		begin
			
			add2 = pm2 + bm2;
		end
	end
	
	
	
	
	always @ (add1 or add2)
	begin
		if(add1 <= add2)
		begin
			
			d = 1'b0;
		end
		else
		begin
			
			d = 1'b1;
		end
	end
	
	
	
	
	always @ (d or add1 or add2)
	begin
		if(d)
		begin
			
			npm = add2;
		end
		else
		begin
			
			npm = add1;
		end
	end
	
	
	
endmodule