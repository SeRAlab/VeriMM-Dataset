module top_module(s, Cout, x, y, As_Sel);output Cout;
	output [3:0] s;
	input [3:0] x,y;
	input As_Sel;
	wire [3:0] g, p;
	wire [4:0] c;
	
	assign g[0] = x[0] * (y[0] ^ As_Sel);
	assign g[1] = x[1] * (y[1] ^ As_Sel);
	assign g[2] = x[2] * (y[2] ^ As_Sel);
	assign g[3] = x[3] * (y[3] ^ As_Sel);
	
	assign p[0] = x[0] + (y[0] ^ As_Sel);
	assign p[1] = x[1] + (y[1] ^ As_Sel);
	assign p[2] = x[2] + (y[2] ^ As_Sel);
	assign p[3] = x[3] + (y[3] ^ As_Sel);
	
	assign c[0] = As_Sel;
	assign c[1] = g[0] + (p[0] * c[0]);
	assign c[2] = g[1] + (p[1] * c[1]);
	assign c[3] = g[2] + (p[2] * c[2]);
	assign c[4] = g[3] + (p[3] * c[3]);
	
	assign Cout = c[4];
	
	assign s[0] = x[0] ^ (y[0] ^ As_Sel) ^ c[0];
	assign s[1] = x[1] ^ (y[1] ^ As_Sel) ^ c[1];
	assign s[2] = x[2] ^ (y[2] ^ As_Sel) ^ c[2];
	assign s[3] = x[3] ^ (y[3] ^ As_Sel) ^ c[3];
	
	
endmodule