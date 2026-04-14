module top_module(next_pc, cur_pc, rst, clk);// Output signals...
	// Incremented value of the program counter
	output reg [0:31] next_pc;
	
	// ===============================================================
	// Input signals
	// Current value of the program counter
	input [0:31] cur_pc;
	// Clock signal for the program counter
	input clk;
	// Reset signal for the program counter
	input rst;
	
	// ===============================================================
	// Declare "wire" signals:
	// None
	
	// ===============================================================
	// Declare "reg" signals: 
	// None
	
	// ===============================================================
	always @(posedge clk) begin
		// If the reset signal is set to HIGH
		if (rst) begin
			// Set the program counter to 0
			next_pc <= 32'd0;
		end
		else begin
			// Increment the program counter by 4
			next_pc <= cur_pc + 32'd4;
		end
	end
endmodule