module top_module(Y, A, B, C);output Y;
    input A;
    input B;
    input C;
reg Y;
always @ (A or B or C )
Y = ~(C | (B*A));endmodule