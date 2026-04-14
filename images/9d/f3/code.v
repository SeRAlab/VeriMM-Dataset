module top_module(
    input new_clk,
	 input rst,
    input east,
    input west,
	 input [4:0] choose_1,
	 input [4:0] choose_2,	 
    output reg [4:0] point
    );always @(posedge new_clk)begin
	if(rst) point <= 0;
	else if(east)begin
		if(point <15)begin
			if(point +1 == choose_1)begin 
				point <= point + 2;
			end
			else begin
				point <= point + 1;
			end
		end
		else begin
				if(choose_1 == 0)point <= 1;
				else point <= 0;
		end
	end
	else if(west)begin
		if(point >1)begin
			if(point -1 == choose_1)begin
				point <= point -2;
			end
			else begin
				point <= point -1;
			end
		end
		else if(point == 1)begin
			if(choose_1 == 0)begin
				point <= 15;
			end
			else begin
				point <= 0;
			end
		end
		else if(point == 0)begin
			if(choose_1 == 15)begin
				point <= 14;
			end
			else begin
				point <= 15;
			end
		end
	end
	else begin
		point <= point;
	end
	
	
end	
	
	
	
	



endmodule