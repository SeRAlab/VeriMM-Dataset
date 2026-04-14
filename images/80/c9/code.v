module top_module(
							
							Branch,
							Zero,
							
							PCSrc
						 );input Branch;
input Zero;
output PCSrc;

assign PCSrc = Branch & Zero;

endmodule