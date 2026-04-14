module top_module(o, e, t, clk, s);input [9:0] o;
	input [3:0] e;
	input t;
	input clk;
	output [9:0] s;
	
	reg [9:0] s;

	always@(posedge clk)
	begin
		s=o;
		if (t==1)
		begin
			case (e)
				4'b0000:
				begin
					s[0]=0;
					s[6]=0;
				end
				4'b0100:
				begin
					s[0]=0;
					s[6]=0;
				end
				4'b0001:
				begin
					s[1]=0;
					s[7]=0;
				end
				4'b0101:
				begin
					s[2]=0;
					s[7]=0;
				end
				4'b0010:
				begin
					s[3]=0;
					s[8]=0;
				end
				4'b0110:
				begin
					s[4]=0;
					s[8]=0;
				end
				4'b0011:
				begin
					s[5]=0;
					s[9]=0;
				end
				4'b0111:
				begin
					s[5]=0;
					s[9]=0;
				end
			endcase
		end
	end
endmodule