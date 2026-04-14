module top_module(clk, wen, din, dout);parameter WIDTH = 4'b1000;

    input clk; 
    input wen; 
    input[WIDTH - 1:0] din; 
    output[WIDTH - 1:0] dout; 
    reg[WIDTH - 1:0] dout;

    reg[WIDTH-1:0]buff1; 
    reg[WIDTH-1:0]buff2; 

    always @(posedge clk)
    begin
		if (wen == 1'b1)
		begin
			buff1 <= din;
			buff2 <= buff1;
			dout <= buff2;
		end
	end
endmodule