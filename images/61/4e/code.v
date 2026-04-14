module top_module( A, B, out ) ;parameter width = 16;
parameter half  = width/2;
input  [width:1] A,B;
output [width:1] out;

assign out = (
    0
    + ( (B[ 1]) ? A >> (  1 - 1 - half ) : 0 )
    + ( (B[ 2]) ? A >> (  2 - 1 - half ) : 0 )
    + ( (B[ 3]) ? A >> (  3 - 1 - half ) : 0 )
    + ( (B[ 4]) ? A >> (  4 - 1 - half ) : 0 )
    + ( (B[ 5]) ? A >> (  5 - 1 - half ) : 0 )
    + ( (B[ 6]) ? A >> (  6 - 1 - half ) : 0 )
    + ( (B[ 7]) ? A >> (  7 - 1 - half ) : 0 )
    + ( (B[ 8]) ? A >> (  8 - 1 - half ) : 0 )
    + ( (B[ 9]) ? A >> (  9 - 1 - half ) : 0 )
    + ( (B[10]) ? A >> ( 10 - 1 - half ) : 0 )
    + ( (B[11]) ? A >> ( 11 - 1 - half ) : 0 )
    + ( (B[12]) ? A >> ( 12 - 1 - half ) : 0 )
    + ( (B[13]) ? A >> ( 13 - 1 - half ) : 0 )
    + ( (B[14]) ? A >> ( 14 - 1 - half ) : 0 )
    + ( (B[15]) ? A >> ( 15 - 1 - half ) : 0 )
    + ( (B[16]) ? A >> ( 16 - 1 - half ) : 0 )
);

endmodule