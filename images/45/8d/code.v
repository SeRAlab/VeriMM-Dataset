module top_module(
	input clk,
	input reset,
	input [9:0] data,
	output reg [3:0] pos);always @(posedge clk or negedge reset) begin
		if (!reset)
			pos <= 4'b0000;
		else begin
			casez (data)
				10'b1?????????: pos <= 4'd9;
				10'b01????????: pos <= 4'd8;
				10'b001???????: pos <= 4'd7;
				10'b0001??????: pos <= 4'd6;
				10'b00001?????: pos <= 4'd5;
				10'b000001????: pos <= 4'd4;
				10'b0000001???: pos <= 4'd3;
				10'b00000001??: pos <= 4'd2;
				10'b000000001?: pos <= 4'd1;
				10'b0000000001: pos <= 4'd0;
				default: pos <= 4'b0000;
			endcase
		end
	end
endmodule