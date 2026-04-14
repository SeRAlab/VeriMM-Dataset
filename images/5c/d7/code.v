module top_module(
		input wire		[ 3 : 0]	digit,		
		input wire		[ 1 : 0]	sel,		
		output reg		[ 3 : 0]	anode,		
		output reg		[ 6 : 0]	cathode		
    );always @(sel) begin
		case(sel)
			2'b00:	anode = 4'b1110;
			2'b01:	anode = 4'b1101;
			2'b10:	anode = 4'b1011;
			2'b11:	anode = 4'b0111;
		endcase
	end
	
	
	always @(digit) begin
		case(digit)			
			4'h0:	cathode = 7'b0000001;
			4'h1:	cathode = 7'b1001111;
			4'h2:	cathode = 7'b0010010;
			4'h3:	cathode = 7'b0000110;
			4'h4:	cathode = 7'b1001100;
			4'h5:	cathode = 7'b0100100;
			4'h6:	cathode = 7'b0100000;
			4'h7:	cathode = 7'b0001111;
			4'h8:	cathode = 7'b0000000;
			4'h9:	cathode = 7'b0000100;
			4'ha:	cathode = 7'b0001000;
			4'hb:	cathode = 7'b1100000;
			4'hc:	cathode = 7'b0110001;
			4'hd:	cathode = 7'b1000010;
			4'he:	cathode = 7'b0110000;
			4'hf:	cathode = 7'b0111000;
		endcase
	end

endmodule