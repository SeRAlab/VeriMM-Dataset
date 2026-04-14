module top_module(clk,rst_n,x,y,btn1,btn2);input clk,rst_n,btn1,btn2;
output x,y;
reg x,y;


always@(posedge clk or negedge rst_n)begin
	if(!rst_n) begin 
		x <= 0;
		y <= 0;
	end else begin 
		if(btn1 == 1)begin
			x<=1;
			y<=0;
		end else if(btn2 == 1)begin
			x<=0;
			y<=1;
		end else if( btn1==0 && btn2==0 )
		begin 
		x<=0;
		y<=0;
		end
	end
end


endmodule