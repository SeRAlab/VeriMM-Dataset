module top_module(clk, pay, pby, miso, mosi, cs, sck);parameter PADDLESIZE = 0;
parameter SCREENHEIGHT = 0;
input clk;
output reg[9:0] pay;
output reg[9:0] pby;
input miso;
output reg mosi;
output reg cs;
output sck;

parameter state0 = 0, state1 = 1, state2 = 2, state3 = 3;

reg [1:0] state;

reg [4:0] sckcount;
reg [11:0] datain;

reg ab;

assign sck = clk;

always @(posedge sck) begin
	case(state)
	state0:
		begin
			ab <= 1;
			state <= state1;
		end
	state1: 
		begin
			ab <= !ab;
			cs <= 0;
			mosi <= !ab;
			sckcount <= 15;
			state <= state2;
		end
	state2:
		begin
			if (sckcount != 0) 
				sckcount <= sckcount - 1'b1;
			else 
				state <= state3;
		end
	state3:
		begin
			cs <= 1;
			mosi <= 0;
			if (ab == 0) begin
				pay <= paddlelimiter(datain[7:0], PADDLESIZE, SCREENHEIGHT);
			end else begin
				pby <= paddlelimiter(datain[10:8], PADDLESIZE, SCREENHEIGHT);
			end
			state <= state1;
		end
	default:
		state <= state0;
	endcase
end

always @(negedge sck) begin
	if (state == state2)
		datain <= (datain << 1) | miso; 
	else if (state == state1)
		datain <= 0;
end


//
// Limit paddle position to stay within screen coordinates
//
function [9:0] paddlelimiter;
input [9:0] py;
input [3:0] paddlesize;
input [9:0] screenheight;
begin
	if (py < paddlesize/2) 
		paddlelimiter = paddlesize/2;
	else 
	if (py > screenheight-96/2)
		paddlelimiter = screenheight-paddlesize/2;
	else
		paddlelimiter = py;
end
endfunction


endmodule