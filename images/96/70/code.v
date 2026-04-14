module top_module(
	CK, 
	EN,
	RST,
	Q3, 
	Q2, 
	Q1, 
	Q0);input CK;
	input EN;
	input RST;
	output Q3; 
	output Q2; 
	output Q1; 
	output Q0;
	
	reg [3:0] Q;
	
	assign {Q3, Q2, Q1, Q0} = Q; // Drive the individual outputs from the 4-bit register Q
	
	always @(posedge CK) begin
		if (RST == 1) begin
			Q <= 4'b0000;
		end else if (EN == 1) begin
			Q <= Q + 1;
		end
	end
	
endmodule