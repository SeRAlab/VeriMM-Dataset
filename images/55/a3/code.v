module top_module(nLT, nRBI, A3, A2, A1, A0, nBI,
				nRBO, nA, nB, nC, nD, nE, nF, nG);input  nLT, nRBI, A3, A2, A1, A0, nBI;
	output nRBO, nA, nB, nC, nD, nE, nF, nG;

	
	wire  [3:0] SEGIN;
	
	
	reg   [6:0] nSEGOUT;

	
	assign   SEGIN[3] = A3;
	assign   SEGIN[2] = A2;
	assign   SEGIN[1] = A1;
	assign   SEGIN[0] = A0;

	assign   nA = nSEGOUT[6];
	assign   nB = nSEGOUT[5];
	assign   nC = nSEGOUT[4];
	assign   nD = nSEGOUT[3];
	assign   nE = nSEGOUT[2];
	assign   nF = nSEGOUT[1];
	assign   nG = nSEGOUT[0];

	
	assign nRBO = ~(~nBI || (~nRBI && (SEGIN == 4'd0) && nLT));
	
	
	always @ (nRBO or nLT or SEGIN) begin
		if (~nRBO) begin
			
			nSEGOUT = ~7'b0000000; 
		end else if (~nLT) begin
			
			nSEGOUT = ~7'b1111111; 
		end else begin 
			case (SEGIN)
				4'd0:     nSEGOUT = ~7'b1111110; 
				4'd1:     nSEGOUT = ~7'b0110000;
				4'd2:     nSEGOUT = ~7'b1101101;
				4'd3:     nSEGOUT = ~7'b1111001;
				4'd4:     nSEGOUT = ~7'b0110011;
				4'd5:     nSEGOUT = ~7'b1011011;
				4'd6:     nSEGOUT = ~7'b1011111;
				4'd7:     nSEGOUT = ~7'b1110000;
				4'd8:     nSEGOUT = ~7'b1111111;
				4'd9:     nSEGOUT = ~7'b1111011;
				4'hF:		 nSEGOUT = ~7'b1100111;	
				default:  nSEGOUT = ~7'b0000000;
			endcase
		end
	end

endmodule