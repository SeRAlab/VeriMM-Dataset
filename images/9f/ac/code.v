module top_module(Q, CLK, MAC, RST, A, B);output [7:0] Q;
input CLK, MAC, RST;
input [3:0] A, B;
reg [7:0] Q;


wire [7:0]  multiply_output = A * B;

wire [7:0] adder_output = MAC ?   multiply_output + Q : multiply_output;


always @(posedge CLK  or posedge RST)
begin
	if (RST)
		Q = 0;
	else
		Q = adder_output;
end
 
endmodule