module top_module(SUM, COUT, I0, I1, I3, CIN);input I0;
input I1;
input I3;
(* abc9_carry *) input CIN;
output SUM;
(* abc9_carry *) output COUT;

localparam ADD = 0;
localparam SUB = 1;
localparam ADDSUB = 2;
localparam NE = 3;
localparam GE = 4;
localparam LE = 5;
localparam CUP = 6;
localparam CDN = 7;
localparam CUPCDN = 8;
localparam MULT = 9;

parameter ALU_MODE = 0;

reg S, C;

specify
	(I0 => SUM) = (1043, 1432);
	(I1 => SUM) = (775, 1049);
	(I3 => SUM) = (751, 1010);
	(CIN => SUM) = (694, 811);
	(I0  => COUT) = (1010, 1380);
	(I1  => COUT) = (1021, 1505);
	(I3  => COUT) = (483, 792);
	(CIN => COUT) = (49, 82);
endspecify

assign SUM = S ^ CIN;
assign COUT = S? CIN : C;

always @* begin
	case (ALU_MODE)
		ADD: begin
			S = I0 ^ I1;
			C = I0;
		end
		SUB: begin
			S = I0 ^ ~I1;
			C = I0;
		end
		ADDSUB: begin
			S = I3? I0 ^ I1 : I0 ^ ~I1;
			C = I0;
		end
		NE: begin
			S = I0 ^ ~I1;
			C = 1'b1;
		end
		GE: begin
			S = I0 ^ ~I1;
			C = I0;
		end
		LE: begin
			S = ~I0 ^ I1;
			C = I1;
		end
		CUP: begin
			S = I0;
			C = 1'b0;
		end
		CDN: begin
			S = ~I0;
			C = 1'b1;
		end
		CUPCDN: begin
			S = I3? I0 : ~I0;
			C = I0;
		end
		MULT: begin
			S = I0 & I1;
			C = I0 & I1;
		end
	endcase
end

endmodule