module top_module(inSh, out);input [10:0] inSh;
	
	 output reg [31:0] out;
	 reg [31:0] temp;

	always@(inSh)begin
		temp <= {{21{inSh[10]}}, inSh[10:0]};		
	end
	
	always@(temp)begin
		out <= temp << 2;
	end

endmodule