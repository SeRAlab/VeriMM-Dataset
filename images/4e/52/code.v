module top_module( A, B, CI, SUM, 
    CO );input  [13:0] A;
input  [13:0] B;
output [13:0] SUM;
input  CI;
output CO;
    wire \A[4] , \A[0] , \A[2] , \A[3] , \A[5] , \A[1] ;
    assign \A[5]  = A[5];
    assign \A[4]  = A[4];
    assign \A[3]  = A[3];
    assign \A[2]  = A[2];
    assign \A[1]  = A[1];
    assign \A[0]  = A[0];
    assign SUM[5] = \A[5] ;
    assign SUM[4] = \A[4] ;
    assign SUM[3] = \A[3] ;
    assign SUM[2] = \A[2] ;
    assign SUM[1] = \A[1] ;
    assign SUM[0] = \A[0] ;endmodule