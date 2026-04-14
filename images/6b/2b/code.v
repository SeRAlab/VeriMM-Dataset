module top_module(bcd_in, segments_out, invert);output reg	[6:0] segments_out;
    input		[3:0] bcd_in;
	input		invert;












	reg [6:0] seg_reg;

	always @*
      case (bcd_in)
		
          4'b0001 : seg_reg = 7'b1111001;   
          4'b0010 : seg_reg = 7'b0100100;   
          4'b0011 : seg_reg = 7'b0110000;   
          4'b0100 : seg_reg = 7'b0011001;   
          4'b0101 : seg_reg = 7'b0010010;   
          4'b0110 : seg_reg = 7'b0000010;   
          4'b0111 : seg_reg = 7'b1111000;   
          4'b1000 : seg_reg = 7'b0000000;   
          4'b1001 : seg_reg = 7'b0010000;   
          4'b1010 : seg_reg = 7'b0001000;   
          4'b1011 : seg_reg = 7'b0000011;   
          4'b1100 : seg_reg = 7'b1000110;   
          4'b1101 : seg_reg = 7'b0100001;   
          4'b1110 : seg_reg = 7'b0000110;   
          4'b1111 : seg_reg = 7'b0001110;   
          default : seg_reg = 7'b1000000;   
      endcase

	always @*
		case (invert)
			1'b1 : segments_out = seg_reg; 
			1'b0 : segments_out = ~seg_reg; 
		endcase
	
endmodule