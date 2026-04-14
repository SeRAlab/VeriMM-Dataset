module top_module(Rout,Gout,DINout,DIN,G,Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7,BUSWIRE);input [7:0] Rout;
	input Gout;
	input DINout;
	input G,DIN;
	input [15:0] Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7;
	output reg [15:0] BUSWIRE;
	reg [9:0] sel;
	
	
	
	
	

	always@(DINout or Rout or Gout or sel)
	begin
	sel[9:2] = Rout;
   sel[1] = Gout;
   sel[0] = DINout;
		case(sel)
			10'b1000000000:BUSWIRE=Q7;
			10'b0100000000:BUSWIRE=Q6;
			10'b0010000000:BUSWIRE=Q5;
			10'b0001000000:BUSWIRE=Q4;
			10'b0000100000:BUSWIRE=Q3;
			10'b0000010000:BUSWIRE=Q2;
			10'b0000001000:BUSWIRE=Q1;
			10'b0000000100:BUSWIRE=Q0;
			10'b0000000010:BUSWIRE=G;
			10'b0000000001:BUSWIRE=DIN;
		endcase
	end
		
endmodule