module top_module(Y,A,B);output Y;
input A,B;


assign Y =((~A) & B) | (A & (~B));
endmodule