module RAM1Kx1(input CLK1, input[9:0] AB1, input CS1, input READ,
					 output DO1, input DI1,
				    input CLK2, input[9:0] AB2, input CS2, output DO2);
	parameter FILL = 256'h33333333333333333333333333333333CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC;
	reg mem[0:'h3FF];
	integer i;
	initial
		for (i = 0; i < 'h400; i = i + 1) 
			mem[i] = (FILL&(256'b01<<(i&'hFF)))?1'b1:1'b0;
	assign DO1 = (CS1 && READ)? mem[AB1]: 1'bZ;
	assign DO2 = CS2? mem[AB2]: 1'bZ;
	always @(posedge CLK1) if (CS1 && !READ) mem[AB1] <= DI1;
endmodule