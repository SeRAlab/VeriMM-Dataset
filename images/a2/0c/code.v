module top_module(
	 output [6:0] S,
	 input [3:0] D
    );reg [6:0] S2;
	 always @(D) begin
			
		 S2 = 7'b0000000;
		 case(D)
			4'h0: S2 = 7'b1111110;	
			4'h1: S2 = 7'b0110000;	
			4'h2: S2 = 7'b1101101;	
			4'h3: S2 = 7'b1111001;	
			4'h4: S2 = 7'b0110011;	
			4'h5: S2 = 7'b1011011;	
			4'h6: S2 = 7'b1011111;	
			4'h7: S2 = 7'b1110000;	
			4'h8: S2 = 7'b1111111;	
			4'h9: S2 = 7'b1111011;	
			4'hA: S2 = 7'b1110111;	
			4'hB: S2 = 7'b0011111;	
			4'hC: S2 = 7'b1001110;	
			4'hD: S2 = 7'b0111101;	
			4'hE: S2 = 7'b1001111;	
			4'hF: S2 = 7'b1000111;	
			
			default: S2 = 7'b0000000;
		 endcase
	 end
	 
	 assign S = ~S2;

endmodule