module top_module(
	input clk,
	input [6:0] rx_round,
	output reg [3:0] tx_s0,
	output reg [3:0] tx_s1
);localparam [319:0] first_sequence = {4'd6,4'd5,4'd8,4'd11,4'd14,4'd13,4'd12,4'd5,4'd12,4'd13,4'd8,4'd6,4'd11,4'd5,4'd15,4'd9,4'd12,4'd5,4'd6,4'd8,4'd6,4'd5,4'd14,4'd9,4'd8,4'd9,4'd15,4'd14,4'd15,4'd14,4'd12,4'd11,4'd5,4'd7,4'd12,4'd5,4'd6,4'd13,4'd8,4'd14,4'd15,4'd13,4'd9,4'd14,4'd7,4'd6,4'd13,4'd11,4'd12,4'd13,4'd7,4'd11,4'd9,4'd15,4'd12,4'd7,4'd15,4'd7,4'd9,4'd11,4'd13,4'd8,4'd6,4'd7,4'd8,4'd9,4'd7,4'd6,4'd15,4'd14,4'd13,4'd11,4'd9,4'd7,4'd8,4'd5,4'd12,4'd15,4'd14,4'd11};
	localparam [319:0] second_sequence = {4'd11,4'd11,4'd13,4'd15,4'd5,4'd6,4'd13,4'd8,4'd6,4'd14,4'd5,4'd12,4'd9,4'd12,4'd5,4'd8,4'd8,4'd15,4'd5,4'd12,4'd9,4'd12,4'd9,4'd6,4'd14,4'd6,4'd14,4'd14,4'd11,4'd8,4'd5,4'd15,4'd5,4'd7,4'd13,4'd13,4'd14,4'd5,4'd13,4'd12,4'd14,4'd6,4'd6,4'd8,4'd11,4'd15,4'd7,4'd9,4'd11,4'd13,4'd15,4'd6,4'd7,4'd12,4'd7,4'd7,4'd11,4'd9,4'd8,4'd12,4'd7,4'd15,4'd13,4'd9,4'd6,4'd12,4'd14,4'd14,4'd11,4'd8,4'd7,4'd7,4'd5,4'd15,4'd15,4'd13,4'd11,4'd9,4'd9,4'd8};


	always @ (posedge clk)
	begin
		tx_s0 <= first_sequence >> {rx_round, 2'b00};
		tx_s1 <= second_sequence >> {rx_round, 2'b00};
	end

endmodule