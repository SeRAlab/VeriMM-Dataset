module top_module(
    input [3:0] number,
    output [6:0] cathode
    );reg [6:0] sseg_temp;
	always @(number) begin
		case (number)

			4'h0 : sseg_temp = 7'b0000001;
			4'h1 : sseg_temp = 7'b1001111;
			4'h2 : sseg_temp = 7'b0010010;
			4'h3 : sseg_temp = 7'b0000110;
			4'h4 : sseg_temp = 7'b1001100;
			4'h5 : sseg_temp = 7'b0100100;
			4'h6 : sseg_temp = 7'b0100000;
			4'h7 : sseg_temp = 7'b0001111;
			4'h8 : sseg_temp = 7'b0000000;
			4'h9 : sseg_temp = 7'b0000100;
			4'ha : sseg_temp = 7'b0001000;
			4'hb : sseg_temp = 7'b1100000;
			4'hc : sseg_temp = 7'b0110001;
			4'hd : sseg_temp = 7'b1000010;
			4'he : sseg_temp = 7'b0110000;
			4'hf : sseg_temp = 7'b0111000;
			default : sseg_temp = 7'b1111110;
			
		endcase
	end
	
	assign cathode = ~sseg_temp;

endmodule