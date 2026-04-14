module top_module(
	input wire CLKARDCLK,
	input wire CLKBWRCLK,
	input wire [17:0] ADDRARDADDR,
	input wire [17:0] ADDRBWRADDR,
	input wire ENARDEN,
	input wire ENBWREN,
	input wire [17:0] DIADI,
	input wire [17:0] DIBDI,
	input wire WEA,
	input wire WEBWE,
	output wire [17:0] DOADO,
	output wire [17:0] DOBDO
);// Internal memory
	reg [17:0] mem [0:262143];

	// Read port A
	assign DOADO = (ENARDEN) ? mem[ADDRARDADDR] : 18'bz; // Change condition to ENARDEN for output enable

	// Read port B
	assign DOBDO = (ENBWREN) ? mem[ADDRBWRADDR] : 18'bz; // Change condition to ENBWREN for output enable

	// Write port A
	always @(posedge CLKARDCLK) begin
		if (WEA) begin
			if (1) begin // Change RAM_MODE to a constant for now; it should be a configurable parameter if needed
				mem[ADDRARDADDR] <= DIADI;
			end else begin
				// ROM mode
				$display("Error: Write attempted in ROM mode on write port A.");
			end
		end
	end

	// Write port B
	always @(posedge CLKBWRCLK) begin
		if (WEBWE) begin
			mem[ADDRBWRADDR] <= DIBDI; // Assuming WEBWE is used correctly for writing
		end
	end

endmodule