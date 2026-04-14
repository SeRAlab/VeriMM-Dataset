module top_module(clk,r,s,c,d,e);input clk;
assign a=7'b1111111; 
output [6:0]c;
input [6:0]r;  
output reg [6:0]e;   
output reg [3:0]d;   
output reg [2:0]s; 
always@(posedge clk) 
	begin
		s[2]=r[6]^r[2]^r[3]^r[4]; 
		s[1]=r[6]^r[1]^r[3]^r[5]; 
		s[0]=r[0]^r[4]^r[5]^r[6]; 
end
always@(posedge clk)
	begin
		case(s)                   
			0 : e= 7'b0000000;        
			1 : e= 7'b0000001;          
			2 : e= 7'b0000010;
			3 : e= 7'b0100000;
			4 : e= 7'b0000100;      
			5 : e= 7'b0010000;
			6 : e= 7'b0001000;
			7 : e= 7'b1000000;
			default: e=7'bzzzzzzz; 
endcase
end
xor a1(c[0],e[0],r[0]); 
xor a2(c[1],e[1],r[1]);
xor a3(c[2],e[2],r[2]);
xor a4(c[3],e[3],r[3]);
xor a5(c[4],e[4],r[4]);
xor a6(c[5],e[5],r[5]);
xor a7(c[6],e[6],r[6]);
always@(c)
begin
	d[0]=c[3];
	d[1]=c[4];  
	d[2]=c[5];
	d[3]=c[6];
end
endmodule