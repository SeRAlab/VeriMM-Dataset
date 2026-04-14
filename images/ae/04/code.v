module top_module(clock, AN, rst);input clock;
	input rst;
	output reg [3:0] AN; 
	
	reg [1:0] Bit_Sel;
	reg [17:0] count;
	always@(posedge clock or posedge rst)
	begin
		if(rst)
			begin
				Bit_Sel <= 2'b00;
				count <= 18'd0;
			end
		else
			begin
				if (count == 18'd260000)
					begin
						Bit_Sel <= Bit_Sel + 1'b1;
						count <=18'd0;
					end
				else
					begin
						count <= count + 1'b1;
						
					end
			end
	end
	
	always @(*)
	begin
		case (Bit_Sel)
			2'b00: AN <= 4'b0111;
			2'b01: AN <= 4'b1011;
			2'b10: AN <= 4'b1101;
			2'b11: AN <= 4'b1110;
			default: AN <= 4'b0000;
		endcase
	end

endmodule