module aeMB2_mult (
   mul_mx,
   opa_of, opb_of, opc_of, gclk, grst, dena, gpha
   );      
   parameter AEMB_MUL = 1; 
   output [31:0] mul_mx;   
   input [31:0]  opa_of;
   input [31:0]  opb_of;
   input [5:0] 	 opc_of;   
   input 	 gclk,
		 grst,
		 dena,
		 gpha;      
   reg [31:0] 	 rOPA, rOPB;   
   reg [31:0] 	 rMUL0, 
		 rMUL1;
   always @(posedge gclk)
     if (grst) begin
	rMUL0 <= 32'h0;
	rMUL1 <= 32'h0;
	rOPA <= 32'h0;
	rOPB <= 32'h0;
     end else if (dena) begin
	rMUL1 <= #1 rMUL0; 
	rMUL0 <= #1 (opa_of * opb_of);
	rOPA <= #1 opa_of;
	rOPB <= #1 opb_of;	
     end
   assign 	 mul_mx = (AEMB_MUL[0]) ? rMUL1 : 32'hX;
endmodule