module top_module(in1,in2, Cin, Sum,Cout);input [3:0] in1,in2;
input Cin;
output [3:0] Sum;
output Cout;
 
wire [3:0] Pr,Ge,Carry;
assign Ge=in1&in2; 

assign Pr=in1^in2;
 
   assign Carry[0] = Cin;
    assign Carry[1] = (Ge[0]) |(Pr[0] & Carry[0]);
    assign Carry[2] = (Ge[1]) | (Pr[1] & Ge[0]) | (Pr[1] & Pr[0] & Carry[0]);
    assign Carry[3] = (Ge[2]) | (Pr[2] & Ge[1]) | (Pr[2] & Pr[1] & Ge[0]) |(Pr[2] & Pr[1] & Pr[0] & Carry[0]);
    assign Cout = (Ge[3]) | (Pr[3] & Ge[2]) | (Pr[3] & Pr[2] & Ge[1]) | 
	 (Pr[3] & Pr[2] & Pr[1] & Ge[0]) |(Pr[3] & Pr[2] & Pr[1] & Pr[0] & Carry[0]);
    assign Sum = Pr ^ Carry;endmodule