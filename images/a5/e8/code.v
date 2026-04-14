module top_module(NPC,clk,Reset,PC,PCWr);input   [31:2]  NPC ;
  input           clk ;
  input           Reset ;
  input           PCWr ;
  output  [31:2]  PC ;
  reg	  [31:2]  PC ;

  always @ ( posedge clk )
	if( Reset == 0 )
		PC = {28'h0000300,2'b00} ;
	else
		PC = PCWr ? NPC : PC ;
endmodule