module top_module(input wire q0, start, clk, output wire CargaQ, DesplazaQ, ResetA, CargaA, Fin);reg [2:0] state,nextstate;

  parameter S0 = 3'b000;
  parameter S1 = 3'b001;
  parameter S2 = 3'b010;
  parameter S3 = 3'b011;
  parameter S4 = 3'b100;
  parameter S5 = 3'b101;
  parameter S6 = 3'b110;

  always @ (posedge clk, posedge start)
	  if (start)
		  state <= S0;
	  else
		  state <= nextstate;

  
  always @(*)

	  case (state)
		  S0: nextstate = S1;
		  S1: nextstate = S2;
		  S2: nextstate = S3;
		  S3: nextstate = S4;
		  S4: nextstate = S5;
		  S5: nextstate = S6;
		  S6: nextstate = S6;
		  default: nextstate = S0;
	  endcase

  
  assign CargaQ = (state == S0)? 1:0; 
  assign DesplazaQ = ((state == S2)|(state == S4))? 1:0;
  assign ResetA = (state == S0)? 1:0;
  assign CargaA = (q0 & ((state == S1)|(state == S3)|(state == S5)))? 1:0;
  assign Fin = (state == S6)? 1:0;

endmodule