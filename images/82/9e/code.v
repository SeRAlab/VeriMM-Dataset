module top_module( clk, ALUOp, Signal, SignaltoALU, SignaltoSHT, SignaltoMULT, SignaltoMUX );input clk ;
	input [1:0] ALUOp ;
	input [5:0] Signal ;
	output [5:0] SignaltoALU ;
	output [5:0] SignaltoSHT ;
	output [5:0] SignaltoMULT ;
	output [5:0] SignaltoMUX ;

	
	
	
	
	
	
	
	

	
	reg [5:0] temp ;
	reg [6:0] counter ;


	parameter AND = 6'b100100;
	parameter OR  = 6'b100101;
	parameter ADD = 6'b100000;
	parameter SUB = 6'b100010;
	parameter SLT = 6'b101010;

	parameter SLL = 6'b000000;
	parameter SRL = 6'b000010;

	parameter MULTU = 6'b011001;
	parameter DIVU  = 6'b011011;
	parameter MFHI  = 6'b010000;
	parameter MFLO  = 6'b010010;
	
	
	always@( Signal or ALUOp )
	begin
	  temp = Signal ;
	  if ( ALUOp == 2'b00 ) temp = ADD;
	  else if ( ALUOp == 2'b01 ) temp = SUB;
	end

	assign SignaltoALU = temp ; 
	assign SignaltoSHT = temp ; 
	assign SignaltoMULT = temp ; 
	assign SignaltoMUX = temp ; 
	
	

endmodule