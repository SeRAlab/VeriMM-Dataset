module demux_1to2 (
	input en,
	input in,
	input sel,
	output reg [1:0] out);
always @(*) begin
	if (!en) begin
		case (sel)
			1'b0: out = {1'b0, in};
			1'b1: out = {in, 1'b0};
			default: out = 2'b00;
		endcase
	end else begin
		out = 2'b00;
	end
end
endmodule