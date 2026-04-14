module top_module(unidades1, decenas1,unidades2, decenas2,salidas, an,clk);input [3:0]unidades2;
input [3:0]decenas2;
input [3:0]unidades1;
input [3:0]decenas1;
input  clk;
output reg [6:0]salidas;
output reg [3:0]an=4'b1110;
reg [3:0]display;
reg [16:0]temp=0;
reg clk2=0;

always @(posedge clk)begin
temp=temp+1;
clk2=temp[16];
end

always @(posedge clk2) begin
 
if(an==4'b1110) begin
	display=decenas1; 
	an=4'b1101;
end	
else if (an==4'b1101) begin 
	display=unidades2; 
	an=4'b1011; 
end
else if(an==4'b1011) begin
	display=decenas2; 
	an=4'b0111;
end	
else if (an==4'b0111) begin 
	display=unidades1;
	an=4'b1110; 
end
else begin 
display=display;
an=4'b0000;
end

end






always @(display)begin

case(display) 


0:salidas = 7'b1000000; 
1:salidas= 7'b1111001;
2:salidas= 7'b0100100;
3:salidas= 7'b0110000;
4:salidas=7'b0011001;
5:salidas= 7'b0010010;
6:salidas= 7'b0000010;
7:salidas=7'b1111000;
8:salidas=7'b0000000;
9:salidas= 7'b0010000;
default: salidas=7'b1111111;

endcase
end
endmodule