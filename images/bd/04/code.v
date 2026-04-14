module top_module(SW,KEY,LEDR);input [9:0]SW;
	input [3:0]KEY;
	output [7:0]LEDR;
	
	wire Reset = SW[9];
	
	wire Clock = KEY[0];
	wire Loadn = KEY[1];
	wire rotateR = KEY[2];
	wire Wrapn = KEY[3];
	
	wire [7:0]D = SW[7:0];
	reg [7:0]Q = 0;	
	reg [7:0]regis;			
	reg temp = 0;
	assign LEDR = regis;
	
	
	always @(posedge Clock) begin
		if(Reset) Q = 0;
		else if(!Loadn) Q = D;
		else if (rotateR && Wrapn) Q = Q >> 1;															
		else if (!rotateR && Wrapn) Q = Q << 1;															
		else if (rotateR && !Wrapn) begin temp = Q[0]; Q = Q >> 1; Q[7] = temp; end	
		else if (!rotateR && !Wrapn) begin temp = Q[7]; Q = Q << 1; Q[0] = temp; end	
		regis = Q;
	end
	
endmodule