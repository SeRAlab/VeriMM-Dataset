module top_module(

	 input [15:0] x,
    input clk,
    input clr,
    output reg [6:0] a_to_g,
    output reg [3:0] an,
    output wire dp 
	 );wire [1:0] s;	 
reg [3:0] digit;
wire [3:0] aen;
reg [19:0] clkdiv;

assign dp = 1;
assign s = clkdiv[19:18];
assign aen = 4'b1111; 




always @(posedge clk)
	
	case(s)
	0:digit = x[3:0]; 
	1:digit = x[7:4]; 
	2:digit = x[11:8]; 
	3:digit = x[15:12]; 
	
	default:digit = x[3:0];
	
	endcase
	
	
	always @(*)

case(digit)




0:a_to_g = 7'b1000000;
1:a_to_g = 7'b1111001;
2:a_to_g = 7'b0100100;

3:a_to_g = 7'b0110000;
4:a_to_g = 7'b0011001;
5:a_to_g = 7'b0010010;
6:a_to_g = 7'b0000010;
7:a_to_g = 7'b1111000;
8:a_to_g = 7'b0000000;
9:a_to_g = 7'b0010000;
'hA:a_to_g = 7'b0111111; 
'hB:a_to_g = 7'b1111111; 
'hC:a_to_g = 7'b1110111;

default: a_to_g = 7'b0000000; 

endcase


always @(*)begin
an=4'b1111;
if(aen[s] == 1)
an[s] = 0;
end




always @(posedge clk or posedge clr) begin
if ( clr == 1)
clkdiv <= 0;
else
clkdiv <= clkdiv+1;
end


endmodule