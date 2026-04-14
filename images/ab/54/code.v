module top_module(
	input clk,
	input [6:0] rx_round,
	output reg [31:0] tx_k0 = 32'h0,
	output reg [31:0] tx_k1 = 32'h0
);always @ (posedge clk)
	begin
		
		
		if (rx_round < 15)
			{tx_k1, tx_k0} <= {32'h50A28BE6, 32'h00000000};
		else if (rx_round < 31)
			{tx_k1, tx_k0} <= {32'h5C4DD124, 32'h5A827999};
		else if (rx_round < 47)
			{tx_k1, tx_k0} <= {32'h6D703EF3, 32'h6ED9EBA1};
		else if (rx_round < 63)
			{tx_k1, tx_k0} <= {32'h7A6D76E9, 32'h8F1BBCDC};
		else
			{tx_k1, tx_k0} <= {32'h00000000, 32'hA953FD4E};
	end

endmodule