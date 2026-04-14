module gray_counter (
  input clk,
  input reset,
  output reg [2:0] q
);always @(posedge clk) begin
	if (reset) begin
		q <= 3'b000;
	end else begin
		case (q)
			3'b000: q <= 3'b001;
			3'b001: q <= 3'b011;
			3'b011: q <= 3'b010;
			3'b010: q <= 3'b110;
			3'b110: q <= 3'b111;
			3'b111: q <= 3'b101;
			3'b101: q <= 3'b100;
			3'b100: q <= 3'b000;
			default: q <= 3'b000;
		endcase
	end
end

endmodule