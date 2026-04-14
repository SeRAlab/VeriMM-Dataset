module top_module(Start, EndofScore, StartAddress, KeyOutput, CurrentAddress, EndofNote, Clock, Reset);input Clock, Reset, Start;
output EndofScore;
parameter DataLength=4;
input [DataLength-1:0] KeyOutput;
parameter AddressBits=5;
input [AddressBits-1:0] StartAddress;
output reg [AddressBits-1:0] CurrentAddress;
input EndofNote;
reg State;

assign EndofScore = ~State;

always@(posedge Clock or posedge Reset)
	if (Reset==1) begin State<=0;end
	else if(Start==1 && KeyOutput!=0) begin State<=1;end 
	else if(KeyOutput==0) begin State<=0;end	
	else begin State<=State;end
	
always@(posedge Clock or posedge Reset) 
	if(Reset==1) begin CurrentAddress<=0;end
	else if (State==0) begin CurrentAddress<=StartAddress;end
	else if (EndofNote==1 && KeyOutput!=0) 
		begin CurrentAddress<=CurrentAddress+1'b1; end
	else begin CurrentAddress<=CurrentAddress;end



endmodule