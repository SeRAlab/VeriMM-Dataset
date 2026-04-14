module top_module(A,Cin,Cout,Sum);input wire A; 
 input wire Cin; 
 output wire Cout; 
 output wire Sum; 
 assign Cout = A & Cin; 
 assign Sum = A ^ Cin; 
 endmodule