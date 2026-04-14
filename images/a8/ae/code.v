module top_module( A, B, out ) ;parameter width = 16;
input  [width:1] A,B;
output [width:1] out ;
genvar i;

parameter half      = width/2;
parameter half_mask = ((1<<(half+1))-1);
parameter top_mask  = half_mask << (half);

wire [width:1] A2,B2;
wire [2*width:1] temp;
wire [1:1] flag;

assign flag = A[width] ^ B[width];

assign A2 = A[width] ? -A : A;
assign B2 = B[width] ? -B : B;

assign temp = (
    0
    + ( (B2[ 1]) ? A2 << (  1 - 1 ) : 0 )
    + ( (B2[ 2]) ? A2 << (  2 - 1 ) : 0 )
    + ( (B2[ 3]) ? A2 << (  3 - 1 ) : 0 )
    + ( (B2[ 4]) ? A2 << (  4 - 1 ) : 0 )
    + ( (B2[ 5]) ? A2 << (  5 - 1 ) : 0 )
    + ( (B2[ 6]) ? A2 << (  6 - 1 ) : 0 )
    + ( (B2[ 7]) ? A2 << (  7 - 1 ) : 0 )
    + ( (B2[ 8]) ? A2 << (  8 - 1 ) : 0 )
    + ( (B2[ 9]) ? A2 << (  9 - 1 ) : 0 )
    + ( (B2[10]) ? A2 << ( 10 - 1 ) : 0 )
    + ( (B2[11]) ? A2 << ( 11 - 1 ) : 0 )
    + ( (B2[12]) ? A2 << ( 12 - 1 ) : 0 )
    + ( (B2[13]) ? A2 << ( 13 - 1 ) : 0 )
    + ( (B2[14]) ? A2 << ( 14 - 1 ) : 0 )
    + ( (B2[15]) ? A2 << ( 15 - 1 ) : 0 )
    + ( (B2[16]) ? A2 << ( 16 - 1 ) : 0 )
);

assign out = flag[1] ? -temp[width+half+1:half+1] : temp[width+half+1:half+1];

endmodule