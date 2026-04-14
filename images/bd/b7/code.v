module top_module(
    input wire aumentar,
    input wire disminuir,
    input wire seleccion,
	 input wire clk,
	 input reset,
    output reg au,
    output reg dis,
    output reg sel
    );reg [2:0]pas1;
reg [2:0]pas2;
reg [2:0]pas3;
reg [2:0]pas4;

always @(posedge clk)
if (reset)
	begin
	pas1<=3'b0;
	pas2<=3'b0;
	pas3<=3'b0;
	pas4<=3'b0;
	sel<=1'b0;
	au<=1'b0;
	dis<=1'b0;
	end
else
	begin
	pas1[0]<=aumentar;
	pas1[1]<=disminuir;
	pas1[2]<=seleccion;
	pas2[0]<=pas1[0];
	pas2[1]<=pas1[1];
	pas2[2]<=pas1[2];
	pas3[0]<=pas2[0];
	pas3[1]<=pas2[1];
	pas3[2]<=pas2[2];
	pas4[0]<=pas3[0];
	pas4[1]<=pas3[1];
	pas4[2]<=pas3[2];
	if (pas1[0]==pas2[0]&&pas1[0]==pas3[0]&&pas1[0]==pas4[0])
		au<=pas4[0];
	if (pas1[1]==pas2[1]&&pas1[1]==pas3[1]&&pas1[1]==pas4[1])
		dis<=pas4[1];
	if (pas1[2]==pas2[2]&&pas1[2]==pas3[2]&&pas1[2]==pas4[2])
		sel<=pas4[2];
	end
endmodule