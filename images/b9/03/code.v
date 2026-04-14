module top_module(
	input wire clk,		
	input wire clr,		
	output wire dclk,		
	output wire segclk,	
	output reg clk_player,
	output reg clk_moving_obs
	);reg [31:0] a;  
reg [31:0] b;


reg [16:0] q;




always @(posedge clk or posedge clr)
begin
	
	if (clr == 1)
		q <= 0;
	
	else
		q <= q + 1;
end


always @(posedge clk or posedge clr)
begin
	if(clr == 1)
	begin
		clk_player <= 0;
		a <= 0;
	end

	else if( a == 'd50000000 -1)
	begin
		clk_player <= 1;
		a <= 0;
	end

	else
	begin
		clk_player <= 0;
		a <= a + 1;
	end

end


always @(posedge clk or posedge clr)
begin
	if(clr == 1)
	begin
		clk_moving_obs <= 0;
		b <= 0;
	end

	else if( b == 'd250000000 -1)
	begin
		clk_moving_obs <= 1;
		b <= 0;
	end

	else
	begin
		clk_moving_obs <= 0;
		b <= b + 1;
	end

end


assign segclk = q[16];


assign dclk = q[1];

endmodule