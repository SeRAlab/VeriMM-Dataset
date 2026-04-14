module top_module(output reg [3:0] SUM, output reg C_OUT, input [3:0] A, input [3:0] B, input SUB);reg [3:0] temp;
	
	always @(*) begin
		if(SUB == 0) begin
			temp = A + B;
			SUM = temp;
			C_OUT = (temp[4] == 1) ? 1 : 0;
		end
		else begin
			temp = A - B;
			SUM = temp;
			C_OUT = (temp[4] == 1) ? 1 : 0;
		end
	end
	
endmodule