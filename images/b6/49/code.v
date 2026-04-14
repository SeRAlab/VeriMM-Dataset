module top_module(OrigULA, entrada1, entrada2, saida);input	OrigULA;
	input [31:0] entrada1;	
	input [31:0] entrada2;	
	
	output reg [31:0] saida;
	
	always @(*) begin
		if(OrigULA)
			saida = entrada2;
		else
			saida = entrada1;
	end

endmodule