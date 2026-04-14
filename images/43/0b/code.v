module top_module(
		input wire iClock,
		input wire iReset,
		output wire oOut131k,
		output wire oOut262k
	);reg [18:0] rCounter; // 2^18 = 262144


	always @ (posedge iClock) begin
		if (iReset) begin
			rCounter <= 0;
		end
		else begin
			rCounter <= rCounter+1;
		end
	end

	assign oOut131k = rCounter[0];
	assign oOut262k = rCounter[1];

endmodule