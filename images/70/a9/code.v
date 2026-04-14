module top_module(entrada,saida16);input [15:0] entrada;
output reg [31:0] saida16;

always @(*) begin

	if(entrada[15] == 1'b1) 
		saida16= {{16{1'b1}}, entrada};
	else 
		saida16 = {{16{1'b0}}, entrada};
end

endmodule