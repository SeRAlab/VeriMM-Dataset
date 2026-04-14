module top_module(clk, noisysignal, conditioned, positiveedge, negativeedge);output reg conditioned = 0;
output reg positiveedge = 0;
output reg negativeedge = 0;
input clk, noisysignal;

// variables
parameter counterwidth = 5;
parameter waittime = 10;
reg[counterwidth-1:0] counter = 0;
reg sync0 = 0;
reg sync1 = 0;

always @(posedge clk) begin
	// if last bit of buffer is the same as conditioned, 
	// no need to wait to see if change is consistent
	if (conditioned == sync1) begin
		counter <= 0;
		positiveedge <= 0;
		negativeedge <= 0;
	// otherwise we check the counter
	end else begin 
		// if the counter is at the end point, we approve this input
		if (counter == waittime) begin
			counter <= 0;
			conditioned <= sync1;
			// we know this is an edge--check if rising or falling
			if (sync1 == 1) begin
					positiveedge <= 1;
			end else begin
					negativeedge <= 1;
			end
		// otherwise we increment
		end else begin
			counter <= counter + 1;
		end
	end
	sync1 = sync0;
	sync0 = noisysignal;
	
end

endmodule