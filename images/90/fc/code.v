module top_module(
	input nRESET,
	input nCOUNTOUT,
	input [3:1] M68K_ADDR,
	input M68K_ADDR_7,
	output reg COUNTER1,
	output reg COUNTER2,
	output reg LOCKOUT1,
	output reg LOCKOUT2,
	input [15:0] PBUS,
	input PCK2B,
	output reg [15:0] G
);// Initialize all counters and lockouts to zero
	always @(negedge nRESET)
	begin
		COUNTER1 <= 1'b0;
		COUNTER2 <= 1'b0;
		LOCKOUT1 <= 1'b0;
		LOCKOUT2 <= 1'b0;
	end

	// Increment appropriate counter when a coin is inserted
	always @(negedge nCOUNTOUT)
	begin
		if (M68K_ADDR[2:0] == 3'b000)
			COUNTER1 <= COUNTER1 + 1'b1;
		else if (M68K_ADDR[2:0] == 3'b001)
			COUNTER2 <= COUNTER2 + 1'b1;
	end

	// Set appropriate lockout or counter based on address and M68K_ADDR_7
	always @(posedge PCK2B)
	begin
		if (M68K_ADDR_7 == 1'b0)
		begin
			if (M68K_ADDR[2:0] == 3'b010)
				LOCKOUT1 <= PBUS[15];
			else if (M68K_ADDR[2:0] == 3'b011)
				LOCKOUT2 <= PBUS[15];
			else if (M68K_ADDR[2:0] == 3'b100)
				COUNTER1 <= PBUS[15:0];
			else if (M68K_ADDR[2:0] == 3'b101)
				COUNTER2 <= PBUS[15:0];
		end
	end

	// Output debug message when a coin counter or lockout is reset or set
	always @(posedge PCK2B)
	begin
		if (!nRESET && nCOUNTOUT)
		begin
			if (M68K_ADDR_7 == 1'b0)
			begin
				if (M68K_ADDR[2:0] == 3'b000)
					$display("COIN COUNTER 1 RESET");
				else if (M68K_ADDR[2:0] == 3'b001)
					$display("COIN COUNTER 2 RESET");
				else if (M68K_ADDR[2:0] == 3'b010)
					$display("COIN LOCKOUT 1 RESET");
				else if (M68K_ADDR[2:0] == 3'b011)
					$display("COIN LOCKOUT 2 RESET");
			end
			else
			begin
				if (M68K_ADDR[2:0] == 3'b100)
					$display("COIN COUNTER 1 SET");
				else if (M68K_ADDR[2:0] == 3'b101)
					$display("COIN COUNTER 2 SET");
				else if (M68K_ADDR[2:0] == 3'b110)
					$display("COIN LOCKOUT 1 SET");
				else if (M68K_ADDR[2:0] == 3'b111)
					$display("COIN LOCKOUT 2 SET");
			end
		end
	end

	// Transfer data to main processor
	always @(posedge PCK2B)
		G <= {PBUS[11:0], PBUS[15:12]};

endmodule