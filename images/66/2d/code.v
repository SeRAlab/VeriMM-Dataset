module top_module(
		num_in,
		control,
		seg_out,
		display_sel
);input [3:0]  num_in;
			input [1:0]  control;
			output [6:0] seg_out;
			input        display_sel;
   
   



			wire [6:0]   seg_out_bcd;
			wire [6:0]   seg_out_hex;
			wire [6:0]   seg_out_buf;
   




			
			assign seg_out = (control == 2'b11 & display_sel == 1'b0) ? 7'b0001001 : seg_out_buf;
			
			
			assign seg_out_buf = (display_sel == 1'b1) ? seg_out_bcd : seg_out_hex;
			
			
			assign seg_out_bcd = (num_in == 4'b0000) ? 7'b1000000 : 		
										(num_in == 4'b0001) ? 7'b1111001 : 		
										(num_in == 4'b0010) ? 7'b0100100 : 		
										(num_in == 4'b0011) ? 7'b0110000 : 		
										(num_in == 4'b0100) ? 7'b0011001 : 		
										(num_in == 4'b0101) ? 7'b0010010 : 		
										(num_in == 4'b0110) ? 7'b0000010 : 		
										(num_in == 4'b0111) ? 7'b1111000 : 		
										(num_in == 4'b1000) ? 7'b0000000 : 		
										(num_in == 4'b1001) ? 7'b0010000 : 		
										(num_in == 4'b1010) ? 7'b1111111 : 		
										(num_in == 4'b1011) ? 7'b1000110 : 		
										7'b0111111;										

			
			assign seg_out_hex = (num_in == 4'b0000) ? 7'b1000000 : 		
										(num_in == 4'b0001) ? 7'b1111001 : 		
										(num_in == 4'b0010) ? 7'b0100100 : 		
										(num_in == 4'b0011) ? 7'b0110000 : 		
										(num_in == 4'b0100) ? 7'b0011001 : 		
										(num_in == 4'b0101) ? 7'b0010010 : 		
										(num_in == 4'b0110) ? 7'b0000010 : 		
										(num_in == 4'b0111) ? 7'b1111000 : 		
										(num_in == 4'b1000) ? 7'b0000000 : 		
										(num_in == 4'b1001) ? 7'b0010000 : 		
										(num_in == 4'b1010) ? 7'b0001000 : 		
										(num_in == 4'b1011) ? 7'b0000011 : 		
										(num_in == 4'b1100) ? 7'b1000110 : 		
										(num_in == 4'b1101) ? 7'b0100001 : 		
										(num_in == 4'b1110) ? 7'b0000110 : 		
										7'b0001110;										
   
endmodule