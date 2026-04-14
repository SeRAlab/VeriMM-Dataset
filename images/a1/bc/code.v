module top_module(

input [3:0] A,
input [3:0] multiplier, 
input [4:0] multiplicand, 
output [3:0] A_left,
output [4:0] q_right

);reg [3:0] temp_left;
reg [4:0] temp_right;

wire [3:0] sum1 = A + multiplier;
wire [3:0] sub1 = A + ~multiplier + 1;


always@(A,multiplier,multiplicand,sum1,sub1)begin

	if(multiplicand[1:0]==2'b00)begin
		temp_left={A[3],A[3:1]};
		temp_right={A[0],multiplicand[4:1]};
	end
	if(multiplicand[1:0]==2'b11)begin
		temp_left={A[3],A[3:1]};
		temp_right={A[0],multiplicand[4:1]};
	end
	if(multiplicand[1:0]==2'b01)begin
		temp_left={sum1[3],sum1[3:1]};	
		temp_right={sum1[0],multiplicand[4:1]};
	end
	if(multiplicand[1:0]==2'b10)begin
		temp_left={sub1[3],sub1[3:1]};
		temp_right={sub1[0],multiplicand[4:1]};
	end
	
	
	
end



assign A_left = temp_left;
assign q_right = temp_right;


endmodule