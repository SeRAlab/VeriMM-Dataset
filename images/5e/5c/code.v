module top_module(
	input CLK,
	input RESET,
	input [7:0] IN,
	output [7:0] OUT,
	output RDA,
	input ACK,
	input WR,
	output RDY
);reg [3:0] SELREG;

	assign OUT = 8'h41 + SELREG;
	assign RDA = 1'b1;
	assign RDY = 1'b1;
	
	always @ (posedge CLK)
	begin
		if(RESET)
			SELREG <= 8'h00;
		else
		begin
			if(WR)
				$write("%c", IN);
				
			if(ACK)
				SELREG <= SELREG + 1;
		end
	end
	
endmodule