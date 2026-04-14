module top_module( SW, LEDG, LEDR, HEX0, CLK );input [3:0] SW;
	input CLK;
	output reg [1:0] LEDG, LEDR; // Changed to reg to allow assignment
	output reg [6:0] HEX0; // Changed to reg to allow assignment

	reg [1:0] led_counter;
	reg [6:0] hex_lookup [0:15];

	// Initialize the LED counter and hex lookup table
	initial begin
		led_counter = 2'b00;
		hex_lookup[0] = 7'b1111110;
		hex_lookup[1] = 7'b0110000;
		hex_lookup[2] = 7'b1101101;
		hex_lookup[3] = 7'b1111001;
		hex_lookup[4] = 7'b0110011;
		hex_lookup[5] = 7'b1011011;
		hex_lookup[6] = 7'b1011111;
		hex_lookup[7] = 7'b1110000;
		hex_lookup[8] = 7'b1111111;
		hex_lookup[9] = 7'b1111011;
		hex_lookup[10] = 7'b1110111;
		hex_lookup[11] = 7'b0011111;
		hex_lookup[12] = 7'b1001110;
		hex_lookup[13] = 7'b0111101;
		hex_lookup[14] = 7'b1001111;
		hex_lookup[15] = 7'b1000111;
	end

	// Convert the binary input to a hexadecimal output
	always @ (SW) begin
		HEX0 = hex_lookup[SW];
	end

	// Alternate the LEDG and LEDR outputs every time the input changes
	always @ (posedge CLK) begin
		if (SW != $past(SW)) begin
			led_counter <= led_counter + 1;
			if (led_counter == 2'b10) begin
				LEDG <= 2'b10;
				LEDR <= 2'b00;
			end else begin
				LEDG <= 2'b00;
				LEDR <= 2'b10;
			end
		end
	end

endmodule