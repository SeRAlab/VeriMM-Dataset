module top_module(clk, wen, din, dout);parameter WIDTH = 4'b1000;

    input clk; 
    input wen; 
    input[WIDTH - 1:0] din; 
    output[WIDTH - 1:0] dout; 
    reg[WIDTH - 1:0] dout;

    reg[WIDTH-1:0]buff1; 
    reg[WIDTH-1:0]buff2; 
    reg[WIDTH-1:0]buff3;
    reg[WIDTH-1:0]buff4;

    always @(posedge clk)
    begin
		if (wen == 1'b1)
		begin
			buff1 <= din;
			buff2 <= buff1;
			buff3 <= buff2;
			buff4 <= buff3;
		end
		dout <= buff4;
		buff1 <= buff2;
		buff2 <= buff3;
		buff3 <= buff4;
	end
endmodule