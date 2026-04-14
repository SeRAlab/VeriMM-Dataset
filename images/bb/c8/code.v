module top_module(
			input wire CAN_A_TX,
			output wire CAN_A_RX,
			input wire CAN_B_TX,
			output wire CAN_B_RX,
			input wire CAN_C_TX,
			output wire CAN_C_RX,
			input wire CAN_D_TX,
			output wire CAN_D_RX
		);assign CAN_A_RX = ((CAN_A_TX&CAN_B_TX&CAN_C_TX&CAN_D_TX) == 0)? 1'b0 : 1'b1;
	assign CAN_B_RX = CAN_A_RX;
	assign CAN_C_RX = CAN_A_RX;
	assign CAN_D_RX = CAN_A_RX;
	
endmodule