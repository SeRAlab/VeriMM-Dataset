module top_module( H, R, G, B, delta, max, locationMax, temp);input [1:0] locationMax;
	input [7:0] R, G, B, delta, max;
	
	output [8:0] H;
	
	output reg [13:0] temp;
	
	wire signed [9:0] tempH1, tempH2;
	
	always @(*) begin
		case (locationMax)
			2'b01: begin
				temp = (G-B)*100/delta;
			end
			2'b10: begin
			temp = (B-R)*100/delta+200;
			end
			default: begin
			temp = (R-G)*100/delta+400;
			end
		endcase
	end
	
	assign tempH1 = (temp/6)%100;
	assign tempH2 = (tempH1<0)?tempH1+100:tempH1;
	assign 		H = (tempH2*36/10);
	
endmodule