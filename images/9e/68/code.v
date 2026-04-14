module top_module(
	input ahref,
	input avsync,
	output acapture,
	output newframe
);reg [9:0] linecount;
reg [2:0] state;

parameter
	ABOVE_SKIP = 3'h0,
	HOTLINE = 3'h1,
	LINEOMIT = 3'h2;

assign acapture = ((state == HOTLINE) & ahref);

function [2:0] nextstate;
	input [2:0] state;
	input [9:0] linecount;
	begin
		case (state)
			ABOVE_SKIP:
			begin
				if (linecount == 10'h0f4) begin
					nextstate = HOTLINE;
				end else begin
					nextstate = state;
				end
			end
			HOTLINE:
				nextstate = LINEOMIT;
			LINEOMIT:
			begin
				if (linecount == 10'h00a) begin
					nextstate = HOTLINE;
				end else begin
					nextstate = state;
				end
			end
			default:
				nextstate = state;
		endcase
	end
endfunction

always @(posedge avsync or posedge ahref)
begin
	if (avsync) begin
		linecount <= 8'h00;
		state <= ABOVE_SKIP;
	end else begin
		linecount <= (state == ABOVE_SKIP || state == LINEOMIT)
									? linecount + 10'b1
									: 10'h000;
		state <= nextstate(state, linecount);
	end
end

endmodule