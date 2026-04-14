module top_module(A_in,B_in,Cin,Zero,Carry,Overflow,Negative,Output);input [31:0] A_in,B_in;
output [31:0] Output;
input Cin;
output Zero,Carry,Overflow,Negative;

assign {Carry,Output} = A_in + B_in + Cin;
assign Zero = (Output == 32'b0)? 1'b1 : 1'b0;
assign Overflow = (!(A_in[31]^B_in[31])&(B_in[31]^Output[31]));
assign Negative = Output[31];

endmodule