module top_module(
  input      [3:0] hex_i,
  output reg [6:0] hex_o
	);always @( * ) begin
	case ( hex_i )
	  4'h0:    hex_o = 7'b1000000;
	  4'h1:    hex_o = 7'b1111001;
	  4'h2:    hex_o = 7'b0100100;
	  4'h3:    hex_o = 7'b0110000;
	  4'h4:    hex_o = 7'b0011001;
	  4'h5:    hex_o = 7'b0010010;
	  4'h6:    hex_o = 7'b0000010;
	  4'h7:    hex_o = 7'b1111000;
	  4'h8:    hex_o = 7'b0000000;
	  4'h9:    hex_o = 7'b0010000;
	  4'ha:    hex_o = 7'b0001000;
	  4'hb:    hex_o = 7'b0000011;
	  4'hc:    hex_o = 7'b1000110;
	  4'hd:    hex_o = 7'b0100001;
	  4'he:    hex_o = 7'b0000110;
	  4'hf:    hex_o = 7'b0001110;
	  default: hex_o = 7'b1111111;
	endcase
  end

endmodule