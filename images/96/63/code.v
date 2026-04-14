module top_module(
reset          ,
clock      		,
CS2				,
CS3				,
CS4				,
A_in				,
A					

);input   			clock;
input				reset;
input     [4:0]A_in;

 
output 			CS2;
output 			CS3;
output			CS4;
output	[4:0]	A;

wire   			clock;
wire				reset;


wire				CS2;
wire 				CS3;
wire				CS4;
wire 				WR;
reg		[4:0]	A;
wire				EN;


always @(A_in[4:0])
begin
	case(A_in[4:0])
		0:		A[4:0]=16;
		1:		A[4:0]=17;
		2:		A[4:0]=18;
		3:		A[4:0]=19;
		4:		A[4:0]=20;
		5:		A[4:0]=21;
		6:		A[4:0]=22;
		7:		A[4:0]=23;
		
		8:		A[4:0]=24;
		9:		A[4:0]=25;
		10:	A[4:0]=26;
		11:	A[4:0]=27;
		12:	A[4:0]=28;
		13:	A[4:0]=29;
		14:	A[4:0]=30;
		15:	A[4:0]=31;
		
		16:	A[4:0]=15;
		17:	A[4:0]=14;
		18:	A[4:0]=13;
		19:	A[4:0]=12;
		20:	A[4:0]=11;
		21:	A[4:0]=10;
		22:	A[4:0]=9;
		23:	A[4:0]=8;
			
		24:	A[4:0]=7;
		25:	A[4:0]=6;
		26:	A[4:0]=5;
		27:	A[4:0]=4;
		28:	A[4:0]=3;
		29:	A[4:0]=2;
		30:	A[4:0]=1;
		31:	A[4:0]=0;
		
		default: A[4:0]=0;
	endcase
	
end

assign CS2 = 0;
assign CS3 = 0;
assign CS4 = 0;

endmodule