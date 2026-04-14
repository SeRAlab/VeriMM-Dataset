module top_module(Init, creaenhe, D, rst, RS, RW, Out_display, MsbOD, clk, scrinit);input Init;
  input creaenhe;
	input clk;
	input [2:0] scrinit;
  input [6:0] D;
  input rst;
	output reg MsbOD;
	output reg [6:0] Out_display;
  output reg RS;
	output reg RW;

always @(negedge clk) begin
	if(rst) begin
		MsbOD=0;
		Out_display=7'b0;
	end
	else begin
		case (scrinit)
			3'b001: begin
				Out_display={7'b0111000};
				MsbOD=0;
				RW=0;
				RS=0;
			end
			3'b010: begin
				Out_display={7'b0000100};
				MsbOD=0;
				RW=0;
				RS=0;
			end
			3'b011: begin
				Out_display={7'b0001100};
				MsbOD=0;
				RW=0;
				RS=0;
			end
			3'b100: begin
				Out_display={7'b0000001};
				MsbOD=0;
				RW=0;
				RS=0;
			end
			3'b101: begin
				Out_display={7'b0110000};
				MsbOD=0;
				RW=0;
				RS=0;
			end
			default begin
				if (creaenhe) begin
					Out_display={7'b1101110};
					MsbOD=1;
					RW=0;
					RS=1;
				end
				else begin
					if(Init) begin
						Out_display={7'b0000001};
						MsbOD=0;
						RS=0;
						RW=0;
					end 
					else begin
						Out_display=D;
						MsbOD=0;
						RW=0;
						RS=1;
					end
				end
			end
		endcase
	end
end
endmodule