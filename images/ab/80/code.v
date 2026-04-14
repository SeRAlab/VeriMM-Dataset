module top_module(n,q,r);parameter K = 32 ;
    input [K-1:0] n ;
    output [K-1:0] q ;
    output [3:0] r ;

    assign q = n / 10;
    assign r = n % 10;endmodule