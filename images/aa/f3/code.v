module top_module(
    input  [3:0] i_hex,
    output reg [6:0] o_segment
    );always @(i_hex)
		begin
			case (i_hex)
				  4'b0000 : o_segment <= 7'h7E; 
				  4'b0001 : o_segment <= 7'h30; 
				  4'b0010 : o_segment <= 7'h6D; 
				  4'b0011 : o_segment <= 7'h79; 
				  4'b0100 : o_segment <= 7'h33; 
				  4'b0101 : o_segment <= 7'h5B; 
				  4'b0110 : o_segment <= 7'h5F; 
				  4'b0111 : o_segment <= 7'h70; 
				  4'b1000 : o_segment <= 7'h7F; 
				  4'b1001 : o_segment <= 7'h7B; 
				  4'b1010 : o_segment <= 7'h77; 
				  4'b1011 : o_segment <= 7'h1F; 
				  4'b1100 : o_segment <= 7'h4E; 
				  4'b1101 : o_segment <= 7'h3D; 
				  4'b1110 : o_segment <= 7'h4F; 
				  4'b1111 : o_segment <= 7'h47; 
			endcase
		end

endmodule